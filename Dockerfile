FROM alpine:edge

ENV LANG en_GB.utf8

RUN apk add --update \
		nodejs \
		postgresql \
		postgresql-contrib \
	&& npm install -g browserify babelify

COPY *.so /usr/lib/postgresql/
COPY *.control /usr/share/postgresql/extension/
COPY *.sql /usr/share/postgresql/extension/

ENV PGDATA /var/lib/postgresql/data
ENV PGUSER postgres
ENV PGDATABASE arla
RUN mkdir -p $PGDATA && chown -R postgres $PGDATA



