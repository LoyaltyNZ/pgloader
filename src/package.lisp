;;;; package.lisp
;;;
;;; To avoid circular files dependencies, define all the packages here
;;;
(defpackage #:pgloader.transforms
  (:use #:cl)
  (:export #:precision
           #:scale
           #:intern-symbol
           #:typemod-expr-to-function))

(defpackage #:pgloader.logs
  (:use #:cl #:pgloader.params)
  (:import-from #:cl-log
		#:defcategory
		#:log-manager
		#:start-messenger
		#:ring-messenger
		#:text-file-messenger
		#:text-stream-messenger
		#:formatted-message)
  (:export #:*log-messengers*
           #:start-logger
           #:stop-logger))

(defpackage #:pgloader.quoting
  (:use #:cl #:pgloader.params)
  (:export #:apply-identifier-case))

(defpackage #:pgloader.schema
  (:use #:cl #:pgloader.params #:pgloader.quoting)
  (:export #:catalog
           #:schema
           #:table
           #:column
           #:index
           #:index
           #:fkey

           #:cast                       ; generic function for sources

           #:apply-identifier-case

           #:make-catalog
           #:make-schema
           #:make-table
           #:create-table
           #:make-view
           #:make-column
           #:make-index
           #:make-index
           #:make-fkey

           #:catalog-name
           #:catalog-schema-list
           #:schema-name
           #:schema-table-list
           #:schema-view-list
           #:table-name
           #:table-source-name
           #:table-schema
           #:table-oid
           #:table-comment
           #:table-field-list
           #:table-column-list
           #:table-index-list
           #:table-fkey-list
           #:column-name
           #:column-type-name
           #:column-type-mod
           #:column-nullable
           #:column-default
           #:column-comment
           #:column-transform

           #:table-list
           #:view-list
           #:add-schema
           #:find-schema
           #:maybe-add-schema
           #:add-table
           #:find-table
           #:maybe-add-table
           #:add-view
           #:find-view
           #:maybe-add-view
           #:add-field
           #:add-column
           #:add-index
           #:add-fkey
           #:find-fkey
           #:maybe-add-fkey
           #:count-tables
           #:count-views
           #:count-indexes
           #:count-fkeys
           #:max-indexes-per-table

           #:push-to-end
           #:with-schema

           #:format-table-name))

(defpackage #:pgloader.state
  (:use #:cl #:pgloader.params #:pgloader.schema)
  (:export #:make-pgstate
           #:pgstate-tabnames
           #:pgstate-tables
           #:pgstate-read
           #:pgstate-rows
           #:pgstate-errs
           #:pgstate-secs

           #:pgstate-get-label
           #:pgstate-new-label
           #:pgstate-setf
           #:pgstate-incf
           #:pgstate-decf

           #:pgtable-initialize-reject-files
           #:pgtable-reject-data
           #:pgtable-reject-logs
           #:report-pgtable-stats
           #:report-pgstate-stats

           ;; report
           #:report-header
	   #:report-table-name
	   #:report-results
	   #:report-footer
	   #:report-summary
	   #:report-full-summary))

(defpackage #:pgloader.monitor
  (:use #:cl #:pgloader.params #:pgloader.state)
  (:export #:with-monitor
           #:*monitoring-queue*
           #:log-message
           #:new-label
           #:update-stats
           #:process-bad-row
           #:with-stats-collection
           #:send-event
           #:start-monitor
           #:stop-monitor
           #:elapsed-time-since
           #:timing))

(defpackage #:pgloader.utils
  (:use #:cl
        #:pgloader.params #:pgloader.schema
        #:pgloader.monitor #:pgloader.state)
  (:import-from #:alexandria
                #:appendf
                #:read-file-into-string)

  (:export #:with-monitor               ; monitor
           #:*monitoring-queue*
           #:with-stats-collection
           #:elapsed-time-since
	   #:timing

           ;; bits from alexandria
           #:appendf
           #:read-file-into-string

           ;; state
           #:make-pgstate
           #:pgstate-tabnames

           ;; events
           #:log-message
           #:new-label
           #:update-stats
           #:process-bad-row

           ;; utils
	   #:format-interval
	   #:camelCase-to-colname
           #:unquote
           #:expand-user-homedir-pathname

           ;; threads
           #:make-kernel

           ;; charsets
           #:list-encodings-and-aliases
           #:show-encodings
           #:make-external-format

           ;; quoting
           #:apply-identifier-case

           ;; schema
           #:catalog
           #:schema
           #:table
           #:column
           #:index
           #:index
           #:fkey

           #:cast                       ; generic function for sources

           #:make-catalog
           #:make-schema
           #:make-table
           #:create-table
           #:make-view
           #:make-column
           #:make-index
           #:make-index
           #:make-fkey

           #:catalog-name
           #:catalog-schema-list
           #:schema-name
           #:schema-table-list
           #:schema-view-list
           #:table-name
           #:table-source-name
           #:table-schema
           #:table-oid
           #:table-comment
           #:table-field-list
           #:table-column-list
           #:table-index-list
           #:table-fkey-list
           #:column-name
           #:column-type-name
           #:column-type-mod
           #:column-type-nullable
           #:column-default
           #:column-comment
           #:column-transform

           #:table-list
           #:view-list
           #:add-schema
           #:find-schema
           #:maybe-add-schema
           #:add-table
           #:find-table
           #:maybe-add-table
           #:add-view
           #:find-view
           #:maybe-add-view
           #:add-field
           #:add-column
           #:add-index
           #:add-fkey
           #:find-fkey
           #:maybe-add-fkey
           #:count-tables
           #:count-views
           #:count-indexes
           #:count-fkeys
           #:max-indexes-per-table

           #:push-to-end
           #:with-schema

           #:format-table-name
           #:format-default-value
           #:format-column))

(defpackage #:pgloader.batch
  (:use #:cl #:pgloader.params #:pgloader.monitor)
  (:export #:make-batch
           #:batch-row
           #:finish-batch
           #:push-end-of-data-message))


;;
;; Not really a source, more a util package to deal with http and zip
;;
(defpackage #:pgloader.archive
  (:use #:cl #:pgloader.params)
  (:import-from #:pgloader.monitor
                #:log-message)
  (:export #:*supporter-archive-types*
           #:archivep
           #:http-fetch-file
	   #:expand-archive
	   #:get-matching-filenames))


;;;
;;; PostgreSQL COPY support, and generic sources API.
;;;
(defpackage #:pgloader.parse-date
  (:use #:cl #:esrap)
  (:export #:parse-date-string
           #:parse-date-format))

(defpackage #:pgloader.connection
  (:use #:cl #:pgloader.archive)
  (:import-from #:pgloader.monitor
                #:log-message)
  (:export #:connection
           #:open-connection
           #:close-connection
           #:clone-connection
           #:fd-connection
           #:db-connection
           #:connection-error
           #:fd-connection-error
           #:db-connection-error
           #:with-connection
           #:query
           #:check-connection

           ;; also export slot names
           #:type
           #:handle
           #:uri
           #:arch
           #:path

           ;; file based connections API for HTTP and Archives support
           #:fetch-file
           #:expand

           ;; connection classes accessors
           #:conn-type
           #:conn-handle
           #:db-conn
           #:fd-path
           #:db-name
           #:db-host
           #:db-port
           #:db-user
           #:db-pass))

(defpackage #:pgloader.pgsql
  (:use #:cl
        #:pgloader.params #:pgloader.utils #:pgloader.connection
        #:pgloader.schema)
  (:export #:pgsql-connection
           #:pgconn-use-ssl
           #:pgconn-table-name
           #:with-pgsql-transaction
	   #:with-pgsql-connection
	   #:pgsql-execute
	   #:pgsql-execute-with-timing
	   #:pgsql-connect-and-execute-with-timing

           ;; PostgreSQL schema facilities
	   #:truncate-tables
	   #:copy-from-file
	   #:copy-from-queue
	   #:reset-all-sequences
	   #:create-tables
	   #:create-views
	   #:format-pgsql-column
	   #:format-extra-type
	   #:make-pgsql-fkey
	   #:format-pgsql-create-fkey
	   #:format-pgsql-drop-fkey
           #:drop-pgsql-fkeys
           #:create-pgsql-fkeys
	   #:make-pgsql-index
	   #:index-table-name
	   #:format-pgsql-create-index
	   #:create-indexes-in-kernel
           #:set-table-oids
           #:drop-indexes
           #:maybe-drop-indexes
           #:create-indexes-again
           #:reset-sequences
           #:comment-on-tables-and-columns

           ;; PostgreSQL introspection queries
	   #:list-databases
	   #:list-tables
	   #:list-columns-query
	   #:list-columns
	   #:list-indexes
	   #:list-tables-cols
	   #:list-tables-and-fkeys
	   #:list-table-oids

           ;; PostgreSQL Identifiers
	   #:list-reserved-keywords

           ;; PostgreSQL user provided GUCs
           #:sanitize-user-gucs

           ;; PostgreSQL data format
	   #:get-date-columns
           #:format-vector-row))

(defpackage #:pgloader.sources
  (:use #:cl
        #:pgloader.params #:pgloader.utils #:pgloader.connection
        #:pgloader.pgsql #:pgloader.batch)
  (:import-from #:pgloader.transforms
                #:precision
                #:scale
                #:intern-symbol
                #:typemod-expr-to-function)
  (:import-from #:pgloader.parse-date
                #:parse-date-string
                #:parse-date-format)
  (:export #:copy
           #:md-copy
           #:db-copy

           ;; Accessors
	   #:source-db
	   #:target-db
	   #:source
	   #:target
	   #:fields
	   #:columns
	   #:transforms
           #:encoding
           #:skip-lines
           #:header

           ;; Main protocol/API
	   #:map-rows
           #:copy-column-list
           #:queue-raw-data
           #:format-data-to-copy
	   #:copy-from
	   #:copy-to
	   #:copy-database

           ;; md-copy protocol/API
           #:parse-header
           #:process-rows

           ;; the md-connection facilities
           #:md-connection
           #:md-spec
           #:md-strm
           #:expand-spec
           #:clone-copy-for

           ;; the db-methods
           #:fetch-metadata
           #:prepare-pgsql-database
           #:cleanup
           #:instanciate-table-copy-object
           #:complete-pgsql-database
           #:end-kernels

           ;; file based utils for CSV, fixed etc
           #:with-open-file-or-stream
	   #:get-pathname
	   #:project-fields
	   #:reformat-then-process

           ;; database cast machinery
           #:*default-cast-rules*
           #:*cast-rules*
           #:apply-casting-rules
           #:format-pgsql-type))


;;;
;;; Other utilities
;;;
(defpackage #:pgloader.ini
  (:use #:cl #:pgloader.params #:pgloader.utils #:pgloader.connection)
  (:import-from #:alexandria #:read-file-into-string)
  (:import-from #:pgloader.pgsql
		#:list-columns
		#:with-pgsql-transaction
		#:pgsql-execute)
  (:export #:read-ini-file
	   #:parse-ini-file
	   #:write-command-to-string
	   #:convert-ini-into-commands
	   #:convert-ini-into-files))

(defpackage #:pgloader.sql
  (:use #:cl)
  (:export #:read-queries))


;;
;; Specific source handling
;;
(defpackage #:pgloader.csv
  (:use #:cl
        #:pgloader.params #:pgloader.utils #:pgloader.connection
        #:pgloader.sources)
  (:import-from #:pgloader.pgsql
                #:maybe-drop-indexes
                #:create-indexes-again)
  (:export #:csv-connection
           #:specs
           #:csv-specs
	   #:get-pathname
	   #:copy-csv
	   #:copy-from
	   #:import-database
	   #:guess-csv-params
	   #:guess-all-csv-params))

(defpackage #:pgloader.fixed
  (:use #:cl
        #:pgloader.params #:pgloader.utils #:pgloader.connection
        #:pgloader.sources)
  (:import-from #:pgloader.csv
                #:csv-connection
                #:specs
                #:csv-specs)
  (:import-from #:pgloader.pgsql
                #:maybe-drop-indexes
                #:create-indexes-again)
  (:export #:fixed-connection
           #:copy-fixed
	   #:copy-from))

(defpackage #:pgloader.copy
  (:use #:cl
        #:pgloader.params #:pgloader.utils #:pgloader.connection
        #:pgloader.sources)
  (:import-from #:pgloader.csv
                #:csv-connection
                #:specs
                #:csv-specs)
  (:import-from #:pgloader.pgsql
                #:maybe-drop-indexes
                #:create-indexes-again)
  (:export #:copy-connection
           #:copy-copy
	   #:copy-from))

(defpackage #:pgloader.ixf
  (:use #:cl
        #:pgloader.params #:pgloader.utils #:pgloader.connection
        #:pgloader.sources)
  (:import-from #:pgloader.pgsql
		#:with-pgsql-transaction
		#:pgsql-execute
		#:pgsql-execute-with-timing
		#:create-tables
		#:format-pgsql-column
                #:format-vector-row)
  (:export #:ixf-connection
           #:copy-ixf
	   #:map-rows
	   #:copy-from))

(defpackage #:pgloader.db3
  (:use #:cl
        #:pgloader.params #:pgloader.utils #:pgloader.connection
        #:pgloader.sources)
  (:import-from #:pgloader.pgsql
		#:with-pgsql-transaction
		#:pgsql-execute
		#:pgsql-execute-with-timing
		#:create-tables
		#:format-pgsql-column
                #:format-vector-row)
  (:export #:dbf-connection
           #:copy-db3
	   #:map-rows
	   #:copy-to
	   #:copy-from))

(defpackage #:pgloader.mysql
  (:use #:cl
        #:pgloader.params #:pgloader.utils #:pgloader.connection
        #:pgloader.sources)
  (:import-from #:pgloader.transforms #:precision #:scale)
  (:import-from #:pgloader.pgsql
		#:with-pgsql-connection
		#:with-pgsql-transaction
		#:pgsql-execute
		#:pgsql-execute-with-timing
		#:list-tables-and-fkeys
		#:list-table-oids
		#:create-tables
		#:create-views
                #:truncate-tables
		#:format-pgsql-column
		#:format-extra-type
		#:make-pgsql-fkey
		#:format-pgsql-create-fkey
		#:format-pgsql-drop-fkey
                #:drop-pgsql-fkeys
                #:create-pgsql-fkeys
		#:make-pgsql-index
		#:format-pgsql-create-index
		#:create-indexes-in-kernel
                #:set-table-oids
                #:format-vector-row
                #:reset-sequences
                #:comment-on-tables-and-columns)
  (:export #:mysql-connection
           #:copy-mysql
           #:*decoding-as*
	   #:*mysql-default-cast-rules*
           #:with-mysql-connection
	   #:map-rows
	   #:copy-to
	   #:copy-from
	   #:copy-database
	   #:list-databases
	   #:list-tables
	   #:export-database
	   #:export-import-database))

(defpackage #:pgloader.sqlite
  (:use #:cl
        #:pgloader.params #:pgloader.utils #:pgloader.connection
        #:pgloader.sources)
  (:import-from #:pgloader.transforms #:precision #:scale)
  (:import-from #:pgloader.pgsql
		#:with-pgsql-transaction
		#:pgsql-execute
		#:pgsql-execute-with-timing
		#:create-tables
                #:truncate-tables
		#:format-pgsql-column
		#:make-pgsql-index
		#:index-table-name
		#:format-pgsql-create-index
		#:create-indexes-in-kernel
                #:set-table-oids
                #:reset-sequences
                #:comment-on-tables-and-columns)
  (:export #:sqlite-connection
           #:copy-sqlite
           #:*sqlite-default-cast-rules*
	   #:map-rows
	   #:copy-to
	   #:copy-from
	   #:copy-database
	   #:list-tables))

(defpackage #:pgloader.mssql
  (:use #:cl
        #:pgloader.params #:pgloader.utils #:pgloader.connection
        #:pgloader.sources)
  (:import-from #:pgloader.transforms #:precision #:scale)
  (:import-from #:pgloader.pgsql
		#:with-pgsql-connection
		#:with-pgsql-transaction
		#:pgsql-execute
		#:pgsql-execute-with-timing
		#:pgsql-connect-and-execute-with-timing
		#:list-tables-and-fkeys
		#:list-table-oids
		#:create-tables
		#:create-views
                #:truncate-tables
		#:format-pgsql-column
		#:format-extra-type
		#:make-pgsql-fkey
		#:format-pgsql-create-fkey
		#:format-pgsql-drop-fkey
                #:drop-pgsql-fkeys
                #:create-pgsql-fkeys
		#:make-pgsql-index
		#:format-pgsql-create-index
		#:create-indexes-in-kernel
                #:set-table-oids
                #:format-vector-row
                #:reset-sequences)
  (:export #:mssql-connection
           #:copy-mssql
           #:*mssql-default-cast-rules*
	   #:map-rows
	   #:copy-to
	   #:copy-from
	   #:copy-database
	   #:list-tables))

(defpackage #:pgloader.syslog
  (:use #:cl #:pgloader.params #:pgloader.utils)
  (:import-from #:pgloader.pgsql
		#:with-pgsql-transaction
		#:pgsql-execute)
  (:export #:stream-messages
	   #:start-syslog-server
	   #:send-message))


;;;
;;; The Command Parser
;;;
(defpackage #:pgloader.parser
  (:use #:cl #:esrap #:metabang.bind
        #:pgloader.params #:pgloader.utils #:pgloader.sql #:pgloader.connection)
  (:import-from #:alexandria #:read-file-into-string)
  (:import-from #:pgloader.sources
                #:md-connection
                #:md-spec)
  (:import-from #:pgloader.pgsql
                #:pgsql-connection
		#:with-pgsql-transaction
		#:pgsql-execute
                #:pgconn-use-ssl
                #:pgconn-table-name
                #:make-table)
  (:import-from #:pgloader.csv
                #:csv-connection
                #:specs
                #:csv-specs)
  (:import-from #:pgloader.fixed
                #:fixed-connection)
  (:import-from #:pgloader.copy
                #:copy-connection)
  (:import-from #:pgloader.sources
                #:*default-cast-rules*
                #:*cast-rules*)
  (:import-from #:pgloader.mysql
                #:mysql-connection
                #:*decoding-as*
                #:*mysql-default-cast-rules*)
  (:import-from #:pgloader.mssql
                #:mssql-connection
                #:*mssql-default-cast-rules*)
  (:import-from #:pgloader.sqlite
                #:sqlite-connection
                #:*sqlite-default-cast-rules*)
  (:import-from #:pgloader.db3 #:dbf-connection)
  (:import-from #:pgloader.ixf #:ixf-connection)
  (:export #:parse-commands
           #:parse-commands-from-file

           ;; tools to enable complete CLI parsing in main.lisp
           #:process-relative-pathnames
	   #:parse-source-string
	   #:parse-source-string-for-type
           #:parse-target-string
           #:parse-cli-options
           #:parse-cli-gucs
           #:parse-cli-type
           #:parse-cli-encoding
           #:parse-cli-fields
           #:parse-cli-casts
           #:parse-sql-file
           #:parse-target-pg-db-uri

           ;; connection types / classes symbols for use in main
           #:connection
           #:conn-type
           #:csv-connection
           #:fixed-connection
           #:copy-connection
           #:dbf-connection
           #:ixf-connection
           #:sqlite-connection
           #:mysql-connection
           #:mssql-connection

           ;; functions to generate lisp code from parameters
           #:lisp-code-for-loading-from-mysql
           #:lisp-code-for-loading-from-csv
           #:lisp-code-for-loading-from-fixed
           #:lisp-code-for-loading-from-copy
           #:lisp-code-for-loading-from-dbf
           #:lisp-code-for-loading-from-ixf
           #:lisp-code-for-loading-from-sqlite
           #:lisp-code-for-loading-from-mssql))


;;
;; Main package
;;
(defpackage #:pgloader
  (:use #:cl
        #:pgloader.params #:pgloader.utils #:pgloader.parser
        #:pgloader.connection #:metabang.bind)
  (:import-from #:pgloader.pgsql
                #:pgconn-table-name
                #:pgsql-connection
		#:copy-from-file
		#:list-databases
		#:list-tables
		#:list-columns-query)
  (:import-from #:pgloader.pgsql
                #:with-pgsql-connection
                #:with-schema
                #:list-reserved-keywords)
  (:export #:*version-string*
	   #:*state*
	   #:*fd-path-root*
	   #:*root-dir*
	   #:*pg-settings*

           #:load-data
           #:parse-source-string
           #:parse-source-string-for-type
           #:parse-target-string

	   #:run-commands
	   #:parse-commands
	   #:with-database-uri
	   #:slurp-file-into-string
	   #:copy-from-file
	   #:list-databases
	   #:list-tables))

(in-package #:pgloader)

;;;
;;; Some package names are a little too long to my taste and don't ship with
;;; nicknames, so use `rename-package' here to give them some new nicknames.
;;;
(loop
   for (package . nicknames)
   in '((lparallel lp)
	(lparallel.queue lq)
	(simple-date date)
	(split-sequence sq)
	(py-configparser ini))
   do (rename-package package package nicknames))
