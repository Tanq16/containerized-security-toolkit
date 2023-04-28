<h1 align="center">
  <br>
  <img src=".github/assets/CTS-Logo.png" alt="DISecT" width="500"></a>
  <br>Containerized Security Toolkit (CST)<br>
</h1>

<p align="center">
    <a href="#quickstart"><b>Quickstart</b></a>  &bull;  
    <a href="#example-workflow"><b>Workflow</b></a>  &bull;  
    <a href="#conventions"><b>Conventions</b></a>  &bull;  
    <a href="#image-builds"><b>Image Builds</b></a>  &bull;    
    <a href="#tools-list"><b>Tools List</b></a>  &bull;  
    <a href="#bonus"><b>Bonus</b></a>
</p>

<br>

<div align="center">

    ![main](https://github.com/tanq16/containerized-security-toolkit/actions/workflows/sec-build.yml/badge.svg)
    ![mainarm](https://github.com/tanq16/containerized-security-toolkit/actions/workflows/sec-apple-silicon.yml/badge.svg)
    ![min](https://github.com/tanq16/containerized-security-toolkit/actions/workflows/sec-build-minimal.yml/badge.svg)
    ![minarm](https://github.com/tanq16/containerized-security-toolkit/actions/workflows/sec-apple-silicon-minimal.yml/badge.svg)
    
</div>

<br>

This repository contains Dockerfiles for ARM (Apple Silicon) and x86_64 variants of a security focussed docker image. The main resources here are as follows &rarr;

* An image that contains many security focussed tools
* The minimal folder contains a security image with most tools and a lower image size

The images are built via GitHub Actions and pushed to Docker Hub for both x86-64 and ARM ((built using [Buildx](https://docs.docker.com/buildx/working-with-buildx/))) architectures.

The image is called `sec_docker` and it has the [cli-productivity-suite](https://github.com/tanq16/cli-productivity-suite) preinstalled within the image. Executables are built and copied over from another image which is built once a month at the [tool_builder](https://github.com/tanq16/dockers_tool_builder).

<br>
<br>

## Quickstart

For a better setup, check out the [Example Workflow](#example-workflow) section. For a quick and dirty run, copy and paste the following commands in order to get into a working image &rarr;

```bash
mkdir -p $HOME/docker_work/persist
```

```bash
docker run --name="security_docker" \
-v $HOME/docker_work/persist/:/persist \
-p 50022:22 --rm -d -it tanq16/sec_docker:main \
zsh -c "service ssh start; tail -f /dev/null"
```

```bash
docker exec -e newpp="docker" security_docker zsh -c 'echo "root:$(printenv newpp)" | chpasswd'
```

```bash
ssh root@localhost -p 50022
```

Finally, stop the container with the following &rarr;

```bash
docker stop security_docker -t 0
```

*Note:* Use `tanq16/sec_docker:main_apple` for the ARM variant. Change the password if needed, otherwise there is a better method for it in the [Example Workflow](#example-workflow) section. We'll also revisit SSH vs. exec-ing into the container in the same section.

<br>
<br>

## Example Workflow

Use the following command to make the necessary directory structure &rarr;

```bash
mkdir -p $HOME/docker_work/persist
```

With this in place, the following functions should be added to the host profile or the respective shell rc file &rarr;

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

The workflow can be used as follows:

```bash
start_work # prints the password to SSH into the container

ssh root@localhost -p 50022 -D 65500 # ssh into the container with dynamic port forwarding

stop_work # stop the container
```

Now, the start function can be executed with the `start_work` command to start the container in a detached state which can be SSH-ed into using the password that is printed on the screen after the container ID. 

*Note:* Start `vim` to trigger auto plugin install, which takes ~5-10 seconds, then exit so that `vim` is fully configured for the entirety the same session.

Calling `stop_work` after exiting the container will stop the running container and store the history on the host to copy it back when the image is launched the next time.

<br>
<br>

## Conventions

The images are mainly meant to be used as a linux system for work. The idea is to have a container with a mount of a persistent storage directory that stays intact even across container spin down and spin up cycles. The shell history or any required configuration file can be shared with the docker for persistence as well. The structure of the `docker_work` directory is something like the follows &rarr;

```
$ tree docker_work -a -L 1
docker_work
├── persist
├── run.sh
└── .zsh_history
```

The optional `run.sh` script can be customized to contain any custom script instructions needed to get a container ready for work. This can be directly run from the home directory as it's copied automatically in the start image function described in the previous section. The `.zsh_history` files are also automatically copied in and out within the start and stop functions.

The images are built with the intention of SSH-ing into it and making use of `tmux` to work. While they can be exec-ed into as well, using SSH has the following advantages &rarr;

* the container can be deployed on separate machines (like cloud VMs) and then SSH-ed into via non-standard ports
* using SSH allows dynamic port forwarding allowing easy access to web-based services within the container through browsers with the appropriate proxy setup
* it fixes certain visual discrepancies that appear when exec-ing into the image

The password is randomly generated and stored in the `current_docker_password` file in the current directory as well as printed out when the container is built and run.

The `start_work` function also includes a `$@`, mainly to add other port publish arguments or volume mounts arguments if necessary. Example &rarr; if a Golang based directory structure is to be shared, then use the argument of `-v /path/to/host/go_programs/:/root/go/src` with the `start_work` command.

The general conventions followed for building/running the images are &rarr;

* port mapping follows convention &rarr; `shared port` = `port + 50000`
* port for dynamic port forwarding when SSH-ing into the container = `65500`
* volume mount to `/persist` (helps with persistence across runs or sessions)
* general tool installations should be under `/opt` while executables under `/opt/executables` (has already been added to path within the dockerfiles)
* optionally maintain a `run.sh` file for common stuff to run when the container starts (also helps with persistence of custom script instructions)

<br>
<br>

## Image Builds

To pull a pre-built image, use the following &rarr;

```bash
docker pull tanq16/sec_docker:<tag>
```

Here, the `<tag>` can be one of the following &rarr;

* `main` &rarr; x86-64 image security image
* `main_apple` &rarr; ARM image security image
* `minimal` &rarr; x86-64 image minimal security image
* `minimal_apple` &rarr; ARM image minimal security image

The security image builds are pretty large in size due to some of the tools like `msfconsole` and `az-cli`. So the images are around 7 GB in size. The minimal security image builds are relatively much smaller around 2GB in size.

The containers can be built by cloning and using `docker build` command.

<details>
<summary>Example build command (expand this)</summary>

To build, use the following &rarr;

```bash
git clone https://github.com/tanq16/dockers
cd dockers/security_docker
docker build -t <your_tag> .
```

The directory also contains a Dockerfile for ARM images, which can be specified using the `--file Dockerfile.AppleSilicon` flag for the `docker build` command.

</details>

<br>
<br>

## Tools List

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

## Bonus

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

To remove dangling images when refreshing with new builds, use the `docker rm` command or the following alias from the CLI-Productivity Suite &rarr;

```bash
alias dockernonerm='for i in $(docker images -f dangling=true -q); do docker image rm $i; done'
```

It is also useful to have buildkit enabled when building the images locally. This can be done by using the following command or adding it to the shell rc file &rarr;

```bash
export DOCKER_BUILDKIT=1
```

Docker buildkit can be disabled by making the above 0.
