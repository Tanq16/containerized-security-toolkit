# Docker Container for Everyday Work

* [Introduction](#introduction)
* [Conventions](#conventions)
* [Pre-Built](#pre-built)
* [Self-Built](#self-built)
* [Example Workflow](#example-workflow)
* [Tools in the Security Image](#tools-in-the-security-image)
* [Bonus Information](#bonus-information)

## Introduction

This repository contains Dockerfiles for ARM (Apple Silicon) and x86_64 variants of a security focussed docker image. The 2 main resources here are as follows &rarr;

* An image that contains many security focussed tools
* Base Dockerfiles to be used for building other images from the same awesome experience of the container

The security focussed image is also available to be directly pulled from docker hub. A GitHub CI Action builds and pushes the images to docker hub monthly and on every commit. The Apple Silicon images are built using [Buildx](https://docs.docker.com/buildx/working-with-buildx/).

The image is called `sec_docker` and it has the [cli-productivity-suite](https://github.com/tanq16/cli-productivity-suite) preinstalled i.e., a funky shell along with customized `vim` and `tmux`. The base Dockerfiles also have the same experience to build off it.

Make sure to read the conventions and example workflow. They are what work for me, but feel free to define your own.

---

## Conventions

The images are built with the intention of ssh-ing into it and making use of `tmux` to work. Further, the conventions followed for building the images are &rarr;

* ports mapping follows convention &rarr; `shared port` = `port + 50000`
* port for dynamic port forwarding when ssh-ing into the container = `65500`
* volume mount to `/work` or `/persist` (helps with persistence across runs or sessions)
* general installations made using Dockerfile should be placed under `/opt` while executables under `/opt/executables` so that can be added to path
* maintain a `run.sh` file for common stuff to run when the container starts (also helps with persistence)

<details>
<summary>Example docker run command</summary>

```bash
docker run --name="amazing_docker" \
-v /path/to/host/go_programs/:/root/go/src \
-v /path/to/host/work:/work \
-p 50022:22 \
--rm -it image_tag \
zsh -c "service ssh start; tail -f /dev/null"
```

This will start the container which can be ssh-ed into. The `tail -f /dev/null` keeps the the container running. `docker stop amazing_docker -t 0` can be used to stop the container. The run command can also be made into a function with a `$@` within the command somewhere to allow for more arguments to be passed (see Example Workflow section).

</details>

---

## Pre-Built

To pull a prebuilt image, use `docker pull tanq16/sec_docker:main`. For the Apple Silicon version, use the tag `tanq16/sec_docker:main_apple`.

Then follow the workflow outlined in the Example Workflow section to use the image. The security image is actually huge ins size due to cloud tools installed within which require python virtual environments which can be 1 GB large. So the images are around 5-6 GB in size.

To remove dangling images when refreshing with new builds, use the `docker rm` command or the following alias from the CLI-Productivity Suite &rarr;

```bash
alias dockernonerm='for i in $(docker images -f dangling=true -q); do docker image rm $i; done'
```

---

## Self-Built

The containers can be built by cloning and using `docker build`. The `base_docker` directory contains starter Dockerfiles with basic tools and the CLI-Productivity Suite preinstalled. The ssh workflow is also installed, and there is space to add further RUN statements.

<details>
<summary>Example build command</summary>

To build, use the following &rarr;

```bash
git clone https://github.com/tanq16/dockers
cd dockers/security_docker
docker build -t <your_tag> .
```

</details>

The `security_docker` directory also contains a Dockerfile for Apple Silicon Macs, which can be specified using the `--file Dockerfile.AppleSilicon` flag for the `docker build` command.

The `init.toml` file must be inside the same directory as the Dockerfile, as the build process copies it and prevents the configuration wizard for `SpaceVim`, though the plugins still need to be installed during the first run.

---

## Example Workflow

The images are mainly meant to be used as a linux system for work. The example here will follow an example workflow using the security image.

The idea is to have a container with a mount of a persistent storage directory. The shell history or any required configuration file can be shared with the docker for persistence as well. To do this, create a directory in the host home directory `docker_work`. The structure of the directory can be as follows &rarr;

```
$ tree docker_work -a -L 1
docker_work
├── persist
├── run.sh
└── .zsh_history
```

Use the following command to set this structure up in the home directory &rarr;

```bash
sh -c "$(curl -s https://raw.githubusercontent.com/Tanq16/dockers/main/workflow_structure_create.sh)"
```

With this in place, 2 functions can be added to the host profile or the respective rc file.

<details>
<summary>Start Image Function</summary>

```bash
start_work(){
    # run the container
    docker run --name="sec_docker" --rm -d \
    -v $HOME/docker_work/persist/:/persist -p 50022:22 $@ -it tanq16/sec_docker:main \
    zsh -c "service ssh start; tail -f /dev/null"
    # copy back prior history if it exists
    if [ -f $HOME/docker_work/.zsh_history ]
        then docker cp $HOME/docker_work/.zsh_history sec_docker:/root/.zsh_history
    fi
    # copy the run.sh file to act as kind of a bootstrap script
    docker cp $HOME/docker_work/run.sh sec_docker:/root/run.sh
    # create a new password for ssh-ing into the docker image
    new_pass=$(cat /dev/random | head -c 20 | base64 | tr -d '=+/')
    # print the new password and store in a file in the current directory
    echo "Password: $new_pass"
    echo $new_pass > current_docker_password
    # set the new password
    docker exec -e newpp="$new_pass" work_docker zsh -c 'echo "root:$(printenv newpp)" | chpasswd'
}
```

</details>

<details>
<summary>Stop Image Function</summary>

```bash
stop_work(){
    # copy (save) the command history
    docker cp sec_docker:/root/.zsh_history $HOME/docker_work/.zsh_history
    docker stop sec_docker -t 0
}
```

</details>

Now, the start function can be executed to start the docker container in a detached state which can be ssh-ed into using the password that is printed on the screen after the container ID. 

Following the CLI-Productivity Suite, it's best to dp the following &rarr;

1. Execute `run.sh` using &rarr; `sh run.sh` from the home directory within the directory
2. Start `vim` to have the auto plugin install kick in, which takes 8-10 seconds, then exit to have `vim` configured fully the next time it's invoked
3. Start a `tmux` session using the alias `tt` and press `Ctrl+b` followed by `Shift+i`, which will take 2 seconds to update the theme and add tmux plugins and custom configuration

At this point the container is fully ready and usable. The `run.sh` script can be customized to contain any instructions needed to get a container ready for work. This can be directly run from the home directory as it's copied in the start image function. The script above contains commands to fix slow paste in `oh-my-zsh`.

Calling `stop_work` after exiting the container will stop the running container.

---

## Tools in the Security Image

The following is a non-exhaustive list of tools installed on the security docker image, grouped by their categories. Expand on each to get the list in that section.

<details>
<summary>General Security-Focussed Tools</summary>

* GDB with PWNdbg and Binwalk
* Nmap and Ncat
* GoBuster & Nikto
* Hydra and John The Ripper
* Selective wordlists at `/opt/lists`
* MetaSploit and SearchSploit
* SemGrep
* ProjectDiscovery Tools &rarr; 
    * subfinder
    * naabu
    * httpx
    * dnsx
    * mapcidr
    * proxify
    * nuclei
    * cloudlist
    * uncover
* DalFox
* Insider
* SMAP
* WPScan
* TestSSL
* SQLMap

</details>

<details>
<summary> Cloud Security Tools</summary>

* AWS and GCloud CLI
* Terraform
* KubeAudit
* Trivy
* ScoutSuite
* Checkov
* KubeCTL
* PMapper
* CloudSploit

</details>

<details>
<summary>Development Oriented Tools</summary>

* PHP
* Python and iPython
* Golang
* NodeJS, NPM and YarnPKG
* Ruby
* Perl
* NASM
* NginX
* GCC
* Make

</details>

<details>
<summary>QoL Tools</summary>

* ZSH shell with Oh-My-Zsh, auto-completion, FZF, LSD, RipGrep, Fd-Find SpaceShip Prompt
* VIM with SpaceVim and Nord theme
* TMUX with Nord theme, custom config file with mouse support plugins and custom shortcuts + tmux_sensible plugin
* Custom aliases within `.zshrc`
* JSON Tools &rarr; JQ and Gron
* Diagrams Python library for creating cloud diagrams
* Python Rich library and Rich-CLI tool
* OpenSSL, OpenSSH, Tree, Git, WGET, Curl and some INET tools
* Shell functions for file encryption/decryption - `fencrypt` and `fdecrypt` to encrypt using AES 256 ECB mode on a file

</details>

---

## Bonus Information

To ssh into the docker without adding it to the hosts file, use the following command &rarr;

```bash
ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" root@localhost -p 50232
```

or add the following alias to the rc file for your default shell &rarr;

```bash
alias sshide='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
```
    
This is automatically installed when setting up CLI-Productivity Suite on the host machine.

It is also useful to have buildkit enabled when building the images. This can be done by using the following command or adding it to the shell rc file &rarr;

```bash
export DOCKER_BUILDKIT=1
```

Docker buildkit can be disabled by making the above 0.
    
The best way to continuously build images every X number of days is by using GitHub Actions. Check out the workflow files in this repo to get an idea of how to configure that to build and push to Docker Hub.

---
