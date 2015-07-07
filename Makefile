#
# Makefile for building the base image
#
default: build

SHELL := /bin/bash
PWD := $(shell pwd)

build:
	docker build -t arla/base .

release: build
	docker push arla/base

.PHONY: default build test release clean enter
