CSS_FILES += ${IHP}/static/vendor/bootstrap.min.css
CSS_FILES += ${IHP}/static/vendor/flatpickr.min.css
CSS_FILES += static/app.css

JS_FILES += ${IHP}/static/vendor/jquery-3.6.0.slim.min.js
JS_FILES += ${IHP}/static/vendor/timeago.js
JS_FILES += ${IHP}/static/vendor/popper.min.js
JS_FILES += ${IHP}/static/vendor/bootstrap.min.js
JS_FILES += ${IHP}/static/vendor/flatpickr.js
JS_FILES += ${IHP}/static/helpers.js
JS_FILES += ${IHP}/static/vendor/morphdom-umd.min.js
JS_FILES += ${IHP}/static/vendor/turbolinks.js
JS_FILES += ${IHP}/static/vendor/turbolinksInstantClick.js
JS_FILES += ${IHP}/static/vendor/turbolinksMorphdom.js

# pg_dump -v -O --disable-triggers -h $PWD/build/db -d app -f Dump.sql
db.dump:
	pg_dump -v -O --disable-triggers -h $$PWD/build/db -d app -Fc -f db.dump

include ${IHP}/Makefile.dist

db:
	(echo "drop schema public cascade; create schema public;" | psql -h ${PWD}/build/db -d app) && \
	psql -v ON_ERROR_STOP=1 -h ${PWD}/build/db -d app < "${IHP_LIB}/IHPSchema.sql" && \
	psql -v ON_ERROR_STOP=1 -h ${PWD}/build/db -d app < Application/Schema.sql && \
	psql -v ON_ERROR_STOP=1 -h ${PWD}/build/db -d app < Application/Constraints.sql && \
	psql -v ON_ERROR_STOP=1 -h ${PWD}/build/db -d app < Application/Fixtures.sql