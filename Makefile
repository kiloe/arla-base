#
# Makefile for building the base image
#
default: build

SHELL := /bin/bash
PWD := $(shell pwd)
PLV8LIB := plv8/plv8.so

plv8/libv8.a:
	cd plv8 && $(MAKE) -f Makefile.v8 libv8.a

plv8/plv8.so: plv8/libv8.a
	docker run --rm -v $(PWD):/host -w /host --entrypoint=/host/build_plv8_alpine.sh alpine:3.2

context/plv8.control: plv8/plv8.so
	mkdir -p context
	cp plv8/plv8.control $@

context/plv8--1.5.0-dev1.sql: plv8/plv8.so
	mkdir -p context
	cp plv8/plv8--1.5.0-dev1.sql $@

context/plv8.so: plv8/plv8.so context/plv8--1.5.0-dev1.sql context/plv8.control
	mkdir -p context
	cp $< $@

context/Dockerfile: Dockerfile context/plv8.so
	mkdir -p context
	cp $< $@

build: context/Dockerfile
	docker build -t arla/base ./context/

release: build
	docker push arla/base

clean:
	rm -rf context
	cd plv8 && make clean

distclean: clean
	cd plv8 && make distclean

.PHONY: default build release clean distclean
