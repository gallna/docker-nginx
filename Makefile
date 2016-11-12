SHELL = /bin/bash
NS = gallna
NAME = nginx.cache
VERSION ?= latest
GIT_TAG=$(shell git describe --tags)

.PHONY : build push
.DEFAULT_GOAL := build

### docker ###
build:
	docker build -t $(NS)/$(NAME):$(VERSION) .
	@[ -z "$(GIT_TAG)" ]; docker tag $(NS)/$(NAME):$(VERSION) $(NS)/$(NAME):$(GIT_TAG); echo "$(NS)/$(NAME):$(GIT_TAG)";

push:
	docker push $(NS)/$(NAME):$(VERSION)
	@[ -z "$(GIT_TAG)" ] || docker push $(NS)/$(NAME):$(GIT_TAG)
