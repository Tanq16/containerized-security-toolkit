#!/bin/bash

# init
apt update -y && apt install docker.io -y
git clone https://github.com/tanq16/containerized-security-toolkit --depth 1
cd containerized-security-toolkit/security_docker
docker login --username $1 --password $2

# x86-64 version
docker run -v $PWD:/shared --rm -it gobuilder sh -c 'mv executables/ /shared/'
docker run -v $PWD:/shared --rm -it otherbuilder sh -c 'mv executables/noseyparker /shared/executables/ && mv neovim-linux64.deb /shared/'
DOCKER_BUILDKIT=1 docker build -f Dockerfile -t tanq16/sec_docker:main .
docker push tanq16/sec_docker:main

# aarch64 version
# docker run -v $PWD:/shared --rm -it gobuilder sh -c 'mv executables/ /shared/'
# docker run -v $PWD:/shared --rm -it otherbuilder sh -c 'mv executables/noseyparker /shared/executables/ && mv neovim-linux64.deb /shared/'
# DOCKER_BUILDKIT=1 docker build -f Dockerfile.AppleSilicon -t tanq16/sec_docker:main_apple .
# docker push tanq16/sec_docker:main_apple

# cleanup
cd ../.. && rm -rf ./containerized-security-toolkit
