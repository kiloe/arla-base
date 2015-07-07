FROM ubuntu:15.04

# Reduce warnings
ENV DEBIAN_FRONTEND noninteractive

# set locale
# install postgres plus work around for AUFS bug
# as per https://github.com/docker/docker/issues/783#issuecomment-56013588
# install nodejs and globally install some modules to speed up rebuilds
RUN echo 'LANG="en_GB.UTF-8"' > /etc/default/locale && locale-gen en_GB.UTF-8 \
  && dpkg-reconfigure locales \
  && apt-get install software-properties-common -y \
  && add-apt-repository ppa:evarlast/golang1.4 \
  && apt-get update \
  && apt-get install -y \
    make \
    golang \
    postgresql-9.4 \
    postgresql-contrib-9.4 \
    postgresql-9.4-plv8 \
    postgresql-9.4-postgis-2.1 \
    nodejs npm \
  && echo "working around AUFS bug...." \
  && mkdir /etc/ssl/private-copy \
  && mv /etc/ssl/private/* /etc/ssl/private-copy/ \
  && rm -r /etc/ssl/private \
  && mv /etc/ssl/private-copy /etc/ssl/private \
  && chmod -R 0700 /etc/ssl/private \
  && chown -R postgres /etc/ssl/private \
  && ln -s /usr/bin/nodejs /usr/bin/node \
  && npm install -g \
    browserify \
    babelify \
    mocha \
    chai \
    supertest \
    tmp \
    pegjs \

