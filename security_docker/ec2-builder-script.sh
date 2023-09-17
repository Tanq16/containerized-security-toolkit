#!/bin/bash

# init
# apt update -y 2>/dev/null 1>/dev/null && apt install docker.io -y 2>/dev/null 1>/dev/null
apt install ca-certificates curl gnupg -y 2>/dev/null && install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg && echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update -y && apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

git clone https://github.com/tanq16/containerized-security-toolkit --depth 1 2>/dev/null 1>/dev/null
cd containerized-security-toolkit/security_docker

# tool build
DOCKER_BUILDKIT=1 docker build -f builder-goexecs.Dockerfile -t gobuilder .
docker builder prune -f
DOCKER_BUILDKIT=1 docker build -f builder-others.Dockerfile -t otherbuilder .
docker builder prune -f

docker login --username $1 --password $2

# build
docker run -v $PWD:/shared --rm -it gobuilder sh -c 'mv executables/ /shared/'
docker run -v $PWD:/shared --rm -it otherbuilder sh -c 'mv executables/noseyparker /shared/executables/ && mv neovim-linux64.deb /shared/'

if [ $(uname -p) != "x86_64" ]
then
  DOCKER_BUILDKIT=1 docker build -f Dockerfile.AppleSilicon -t tanq16/sec_docker:main_apple .
  docker push tanq16/sec_docker:main_apple
else
  DOCKER_BUILDKIT=1 docker build -f Dockerfile -t tanq16/sec_docker:main .
  docker push tanq16/sec_docker:main
fi

# cleanup
cd ../.. && rm -rf ./containerized-security-toolkit