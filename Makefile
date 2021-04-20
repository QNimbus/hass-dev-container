#Dockerfile vars
python_version=3.9

#vars
IMAGENAME=hass-dev-container
REPO=qnimbus
IMAGEFULLNAME=${REPO}/${IMAGENAME}

.PHONY: help build push all

help:
	@echo "Makefile arguments:"
	@echo ""
	@echo "python_version - Python version"
	@echo ""
	@echo "Makefile commands:"
	@echo "build"
	@echo "push"
	@echo "all"

.DEFAULT_GOAL := all

build:
	@docker build \
	--build-arg VARIANT="${python_version}" \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	-t ${IMAGEFULLNAME} .

push:
	@docker push ${IMAGEFULLNAME}

all: build push
