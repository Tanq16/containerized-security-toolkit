#!/bin/bash

# apt update -y 2>/dev/null 1>/dev/null && apt install docker.io -y 2>/dev/null 1>/dev/null
apt install ca-certificates curl gnupg -y 2>/dev/null && install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg && echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update -y && apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# tool build
DOCKER_BUILDKIT=1 docker build -f builder.Dockerfile -t gobuilder .
docker builder prune -f

docker login --username $1 --password $2

# docker run -v $PWD:/shared --rm -it gobuilder sh -c 'mv executables/ /shared/'
# docker run -v $PWD:/shared --rm -it otherbuilder sh -c 'mv executables/noseyparker /shared/executables/ && mv neovim-linux64.deb /shared/'

DOCKER_BUILDKIT=1 docker build -f Dockerfile -t tanq16/sec_docker:main .
docker push tanq16/sec_docker:main

# rm -rf ./executables && rm neovim-linux64.deb
