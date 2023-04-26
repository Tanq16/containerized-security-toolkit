<h1 align="center">
  <br>
  <img src=".github/assets/CTS-Logo.png" alt="DISecT" width="500"></a>
  <br>Containerized Security Toolkit (CST)<br>
</h1>

<p align="center">
    <a href="#introduction"><b>Introduction</b></a>  &bull;  
    <a href="#conventions"><b>Conventions</b></a>  &bull;  
    <a href="#pre-built"><b>Pre-Built</b></a>  &bull;  
    <a href="#self-built"><b>Self-Built</b></a>  &bull;  
    <a href="#example-workflow"><b>Workflow</b></a>  &bull;  
    <a href="#tools-used"><b>Tools Used</b></a>  &bull;  
    <a href="#bonus-information"><b>Bonus</b></a>
</p>

<br>
<br>

## Introduction

This repository contains Dockerfiles for ARM (Apple Silicon) and x86_64 variants of a security focussed docker image. The main resources here are as follows &rarr;

* An image that contains many security focussed tools
* Base Dockerfiles to be used for building other images from the same awesome user experience of the container
* The minimal folder contains a security image with most tools and a lower image size

The security focussed image is available to be directly pulled from docker hub. A GitHub CI Action builds and pushes the images to docker hub multple times a month and on every commit. The Apple Silicon images are built using [Buildx](https://docs.docker.com/buildx/working-with-buildx/).

The image is called `sec_docker` and it has the [cli-productivity-suite](https://github.com/tanq16/cli-productivity-suite) preinstalled within the image i.e., a funky shell along with customized `vim` and `tmux`. The base Dockerfiles also have the same experience to build off it. The *golang* executables are built and copied over from another docker container which is built once a month over at the [tool_builder](https://github.com/tanq16/dockers_tool_builder) repo.

Read the conventions and example workflow below. They work for me, but feel free to define your own.

<br>
<br>

## Conventions

The images are built with the intention of SSH-ing into it and making use of `tmux` to work. Further, the conventions followed for building the images are &rarr;

* port mapping follows convention &rarr; `shared port` = `port + 50000`
* port for dynamic port forwarding when SSH-ing into the container = `65500`
* volume mount to `/work` or `/persist` (helps with persistence across runs or sessions)
* general tool installations should be under `/opt` while executables under `/opt/executables` (added to path)
* maintain a `run.sh` file for common stuff to run when the container starts (also helps with persistence)

<details>
<summary>Example docker run command (expand this)</summary>

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

<br>
<br>

## Pre-Built

To pull a pre-built image, use `docker pull tanq16/sec_docker:main`. For the Apple Silicon version, use the tag `main_apple`. The minimal images have the tags `minimal` and `minimal_apple`.

The images with thw *"main"* tags are pretty large in size due to some of the tools like msfconsole and az-cli. So the images are around 7 GB in size.

To remove dangling images when refreshing with new builds, use the `docker rm` command or the following alias from the CLI-Productivity Suite &rarr;

```bash
alias dockernonerm='for i in $(docker images -f dangling=true -q); do docker image rm $i; done'
```

<br>
<br>

## Self-Built

The containers can be built by cloning and using `docker build`. The `base_docker` directory contains starter Dockerfiles with basic tools and the CLI-Productivity Suite preinstalled.

<details>
<summary>Example build command (expand this)</summary>

To build, use the following &rarr;

```bash
git clone https://github.com/tanq16/dockers
cd dockers/security_docker
docker build -t <your_tag> .
```

The `security_docker` directory also contains a Dockerfile for Apple Silicon Macs, which can be specified using the `--file Dockerfile.AppleSilicon` flag for the `docker build` command.

</details>

<br>
<br>

## Example Workflow

The images are mainly meant to be used as a linux system for work. The example here is for the security image.

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

With this in place, the following functions can be added to the host profile or the respective rc file &rarr;

<details>
<summary>Start Image Function (expand this)</summary>

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
    # create a new password for SSH-ing into the docker image
    new_pass=$(cat /dev/random | head -c 20 | base64 | tr -d '=+/')
    # print the new password and store in a file in the current directory
    echo "Password: $new_pass"
    echo $new_pass > current_docker_password
    # set the new password
    docker exec -e newpp="$new_pass" sec_docker zsh -c 'echo "root:$(printenv newpp)" | chpasswd'
}
```

</details>

<details>
<summary>Stop Image Function (expand this)</summary>

```bash
stop_work(){
    # copy (save) the command history
    docker cp sec_docker:/root/.zsh_history $HOME/docker_work/.zsh_history
    docker stop sec_docker -t 0
}
```

</details>

Similar functions without the SSH requirements (instead only using `docker exec`) can be done with the following functions &rarr;

<details>
<summary>Functions for Start, Stop and Shell into the Container (expand this)</summary>

```bash
shell_work(){
    docker exec -it sec_docker_direct zsh
}
begin_work(){
    docker run --name="sec_docker_direct" --rm -v $HOME/docker_work/persist/:/persist -d -it tanq16/sec_docker:main
    # copy back prior history if it exists
    if [ -f $HOME/docker_work/.zsh_history ]
        then docker cp $HOME/docker_work/.zsh_history sec_docker_direct:/root/.zsh_history
    fi
    # copy the run.sh file to act as kind of a bootstrap script
    docker cp $HOME/docker_work/run.sh sec_docker_direct:/root/run.sh

}
end_work(){
    # copy (save) the command history
    docker cp sec_docker_direct:/root/.zsh_history $HOME/docker_work/.zsh_history
    docker stop sec_docker_direct -t 0
}
```

</details>

Now, the start function can be executed to start the docker container in a detached state which can be ssh-ed into using the password that is printed on the screen after the container ID. 

Following the CLI-Productivity Suite, it's best to do the following after SSH-ing &rarr;

1. SSH into the running container and optionally use dynamic port forwarding on port 65500 to connect to ports via the SSH tunnel
2. Execute `run.sh` using &rarr; `sh run.sh` right after SSH-ing
3. Start `vim` to trigger auto plugin install, which takes ~5-10 seconds, then exit so that `vim` is fully configured for the next launch in the same session
4. Start a `tmux` default session using the alias `tt` and press `Ctrl+b` followed by `Shift+i`, which takes ~3 seconds to trigger auto plugin and configuration install

Thats it! At this point the container is fully ready and usable. The `run.sh` script can be customized to contain any instructions needed to get a container ready for work. This can be directly run from the home directory as it's copied in the start image function. This script also contains commands to fix slow paste in `oh-my-zsh`.

Calling `stop_work` after exiting the container will stop the running container and store the history on the host to copy it back when the image is launched the next time.

<br>
<br>

## Tools Used

The following is a non-exhaustive list of tools installed on the security docker image, grouped by their categories. Expand on each to get the list in that section.

<details>
<summary>General Security-Focussed Tools (expand this)</summary>

* GDB with PWNdbg and Binwalk
* Nmap and Ncat
* GoBuster & Nikto
* Hydra and John The Ripper
* Selective SecLists wordlists at `/opt/lists`
* MetaSploit and SearchSploit (ExploitDB)
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
* Hakrawler (by HakLuke)
* Hakrevdns (by HakLuke)
* Haktldextract (by HakLuke)
* Assetfinder (by Tomnomnom)
* HTTProbe (by Tomnomnom)
* GAU - get all urls
* DalFox
* Insider
* Amass
* SMAP
* Metabigor
* TestSSL
* SQLMap

</details>

<details>
<summary> Cloud Security Tools (expand this)</summary>

* AWS, Azure and GCloud CLI
* Terraform
* KubeAudit
* Trivy
* ScoutSuite
* KubeCTL
* CloudSploit

</details>

<details>
<summary>Development Oriented Tools (expand this)</summary>

* PHP
* Python and iPython
* Golang
* NodeJS, NPM and YarnPKG
* Ruby
* Perl
* NginX
* GCC
* Make

</details>

<details>
<summary>QoL Tools (expand this)</summary>

* ZSH shell with Oh-My-Zsh, auto-completion, FZF, LSD, RipGrep, Ugrep, Fd-Find and the SpaceShip Prompt
* VIM with SpaceVim and Nord theme
* TMUX with Nord theme, custom config file with mouse support plugins and custom shortcuts + tmux_sensible plugin
* Custom aliases within `.zshrc`
* JSON Tools &rarr; JQ, JC and Gron
* Python Rich library and Rich-CLI tool
* OpenSSL, OpenSSH, Tree, Git, WGET, Curl and some INET tools
* Shell functions for file encryption/decryption - `fencrypt` and `fdecrypt` to encrypt using AES 256 ECB mode on a file

</details>

`Note` &rarr; The minimal image is available with the tags `minimal` and `minimal_apple`. It basically contains a minimal subset of tools from the full image (6.9 GB), and is therefore smaller in size (2.06 GB).

<br>
<br>

## Bonus Information

To run any python based tools from the container, usually an appropriately named python venv directory will be already placed in the tool directory. Activate that and install requirements to use the tool. This is kind of a forced habit to always use venvs so that the base python library structure doesn't get messed up. Although, even if it does, the image can be restarted from fresh pretty quickly without any real loss of data.

To ssh into the docker without adding it to the hosts file, use the following command &rarr;

```bash
ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" root@localhost -p 50232
```

or add the following alias to the rc file for your default shell &rarr;

```bash
alias sshide='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
```
    
This is automatically installed when setting up CLI-Productivity Suite on the host machine.

Also, using a `-D 65500` with the ssh command is helpful such that a fixed browser (maybe a firefox one) is always configured with this dynamic proxy. So, even if this image is being run on a cloud VM, sshing into the container with the port forwarding proxy can allow serving stuff in the container on the cloud and view on local.

It is also useful to have buildkit enabled when building the images locally. This can be done by using the following command or adding it to the shell rc file &rarr;

```bash
export DOCKER_BUILDKIT=1
```

Docker buildkit can be disabled by making the above 0.
    
The best way to continuously build images every X number of days is by using GitHub Actions. Check out the workflow files in this repo to get an idea of how to configure that to build and push to Docker Hub.

<br>
