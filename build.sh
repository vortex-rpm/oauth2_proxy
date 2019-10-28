#!/bin/bash -e

ARTIFACTS="_ARTIFACTS"
NAME="oauth2_proxy"
VERSION="4.0.0"
ITERATION="1.vortex.el7.centos"
DOCKER_REGISTRY="nonexistant.vortex-rpm.org"
tag="${DOCKER_REGISTRY}/build-${NAME}:latest"

if [ ! -d $ARTIFACTS ] ; then
	mkdir -p $ARTIFACTS
fi

docker build --pull -t ${tag} .

docker cp $(docker create ${tag}):/pkg/${NAME}-${VERSION}-${ITERATION}.x86_64.rpm ${ARTIFACTS}/
