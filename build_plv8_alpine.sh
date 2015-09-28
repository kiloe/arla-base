#!/bin/sh

set -e
set -x

apk add --update bash python g++ perl alpine-sdk tar postgresql-dev

cd plv8 && make clean && make static
