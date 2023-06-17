#!/bin/bash

apt update -y && apt install docker.io -y
git clone https://github.com/tanq16/containerized-security-toolkit --depth 1
cd containerized-security-toolkit/security_docker
DOCKER_BUILDKIT=1 docker build -f builder.Dockerfile -t builder .
docker builder prune -f
docker run -v $PWD:/shared --rm -it builder 'mv /executables /neovim-linux64.deb /shared/'
DOCKER_BUILDKIT=1 docker build -f Dockerfile -t tanq16/sec_docker:main .
# DOCKER_BUILDKIT=1 docker build -f Dockerfile.AppleSilicon -t tanq16/sec_docker:main_apple .
docker login --username $1
docker push tanq16/sec_docker:main
