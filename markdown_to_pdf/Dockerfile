FROM ubuntu

RUN apt update && apt upgrade -y
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends python3 php

COPY . /root/

