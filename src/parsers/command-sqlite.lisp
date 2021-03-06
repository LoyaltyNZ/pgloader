;;;
;;; LOAD DATABASE FROM SQLite
;;;

(in-package #:pgloader.parser)

#|
load database
     from sqlite:///Users/dim/Downloads/lastfm_tags.db
     into postgresql:///tags

 with drop tables, create tables, create indexes, reset sequences

  set work_mem to '16MB', maintenance_work_mem to '512 MB';
|#
(defrule sqlite-option (or option-workers
                           option-concurrency
                           option-batch-rows
                           option-batch-size
                           option-batch-concurrency
                           option-truncate
                           option-disable-triggers
			   option-data-only
			   option-schema-only
			   option-include-drop
			   option-create-tables
			   option-create-indexes
			   option-reset-sequences
                           option-encoding))

(defrule sqlite-options (and kw-with
                             (and sqlite-option (* (and comma sqlite-option))))
  (:function flatten-option-list))

(defrule including-like
    (and kw-including kw-only kw-table kw-names kw-like filter-list-like)
  (:lambda (source)
    (bind (((_ _ _ _ _ filter-list) source))
      (cons :including filter-list))))

(defrule excluding-like
    (and kw-excluding kw-table kw-names kw-like filter-list-like)
  (:lambda (source)
    (bind (((_ _ _ _ filter-list) source))
      (cons :excluding filter-list))))

(defrule sqlite-db-uri (and "sqlite://" filename)
  (:lambda (source)
    (bind (((_ filename) source)) filename)))

(defrule sqlite-uri (or sqlite-db-uri http-uri maybe-quoted-filename)
  (:lambda (source)
    (destructuring-bind (kind url) source
      (case kind
        (:http     (make-instance 'sqlite-connection :uri url))
        (:filename (make-instance 'sqlite-connection :path url))))))

(defrule get-sqlite-uri-from-environment-variable (and kw-getenv name)
  (:lambda (p-e-v)
    (bind (((_ varname) p-e-v)
           (connstring  (getenv-default varname)))
      (unless connstring
          (error "Environment variable ~s is unset." varname))
        (parse 'sqlite-uri connstring))))

(defrule sqlite-source (and kw-load kw-database kw-from
                            (or get-sqlite-uri-from-environment-variable
                                sqlite-uri))
  (:lambda (source)
    (bind (((_ _ _ uri) source)) uri)))

(defrule load-sqlite-optional-clauses (* (or sqlite-options
                                             gucs
                                             casts
                                             including-like
                                             excluding-like
                                             before-load
                                             after-load))
  (:lambda (clauses-list)
    (alexandria:alist-plist clauses-list)))

(defrule load-sqlite-command (and sqlite-source target
                                  load-sqlite-optional-clauses)
  (:lambda (command)
    (destructuring-bind (source target clauses) command
      `(,source ,target ,@clauses))))

(defun lisp-code-for-sqlite-dry-run (sqlite-db-conn pg-db-conn)
  `(lambda ()
     (log-message :log "DRY RUN, only checking connections.")
     (check-connection ,sqlite-db-conn)
     (check-connection ,pg-db-conn)))

(defun lisp-code-for-loading-from-sqlite (sqlite-db-conn pg-db-conn
                                          &key
                                            gucs casts before after options
                                            ((:including incl))
                                            ((:excluding excl)))
  `(lambda ()
     (let* ((*default-cast-rules* ',*sqlite-default-cast-rules*)
            (*cast-rules*         ',casts)
            ,@(pgsql-connection-bindings pg-db-conn gucs)
            ,@(batch-control-bindings options)
            (source-db      (with-stats-collection ("fetch" :section :pre)
                                (expand (fetch-file ,sqlite-db-conn))))
            (source
             (make-instance 'pgloader.sqlite::copy-sqlite
                            :target-db ,pg-db-conn
                            :source-db source-db)))

       ,(sql-code-block pg-db-conn :pre before "before load")

       (pgloader.sqlite:copy-database source
                                      :including ',incl
                                      :excluding ',excl
                                      ,@(remove-batch-control-option options))

       ,(sql-code-block pg-db-conn :post after "after load"))))

(defrule load-sqlite-database load-sqlite-command
  (:lambda (source)
    (destructuring-bind (sqlite-uri
                         pg-db-uri
                         &key
                         gucs casts before after options including excluding)
        source
      (cond (*dry-run*
             (lisp-code-for-sqlite-dry-run sqlite-uri pg-db-uri))
            (t
             (lisp-code-for-loading-from-sqlite sqlite-uri pg-db-uri
                                                :gucs gucs
                                                :casts casts
                                                :before before
                                                :after after
                                                :options options
                                                :including including
                                                :excluding excluding))))))

