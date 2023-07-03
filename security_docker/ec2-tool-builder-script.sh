#!/bin/bash

# init
apt update -y && apt install docker.io -y
git clone https://github.com/tanq16/containerized-security-toolkit --depth 1
cd containerized-security-toolkit/security_docker
docker login --username $1 --password $2

DOCKER_BUILDKIT=1 docker build -f builder-goexecs.Dockerfile -t gobuilder .
docker builder prune -f
DOCKER_BUILDKIT=1 docker build -f builder-others.Dockerfile -t otherbuilder .
docker builder prune -f

# cleanup
cd ../.. && rm -rf ./containerized-security-toolkit
