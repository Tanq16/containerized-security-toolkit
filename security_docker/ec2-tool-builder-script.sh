#!/bin/bash

# init
apt update -y && apt install docker.io -y
git clone https://github.com/tanq16/containerized-security-toolkit --depth 1
cd containerized-security-toolkit/security_docker
docker login --username $1 --password $2

# x86-64 version
DOCKER_BUILDKIT=1 docker build -f builder.Dockerfile -t tanq16/sec_docker_tools:main .
docker push tanq16/sec_docker_tools:main

# aarch64 version
# DOCKER_BUILDKIT=1 docker build -f builder.Dockerfile -t tanq16/sec_docker_tools:main_apple .
# docker push tanq16/sec_docker_tools:main_apple

# cleanup
docker builder prune -f
cd ../.. && rm -rf ./containerized-security-toolkit
