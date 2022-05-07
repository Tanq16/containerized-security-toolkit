# About this repo

This repository contains Dockerfiles for ARM (Apple Silicon) and x86_64 variants of a security focussed docker image. The 2 main resources here are as follows &rarr;
* An image that contains many security focussed tools
* Dockerfile to be used as a base for building other images

The security focussed image is also available to be directly pulled from docker hub. A GitHub CI Action builds and pushes the images to docker hub monthly and on every commit. The Apple Silicon images are built using [Buildx](https://docs.docker.com/buildx/working-with-buildx/).

The image is called `sec_docker` and it has the [cli-productivity-suite](https://github.com/tanq16/cli-productivity-suite) preinstalled i.e., a funky shell along with customized vim and tmux.

## Information on Conventions and the Container

The security image is built with the intention of ssh-ing into it and making use of tmux to work. Further, the conventions followed for building the images (also useful if edits are needed) are &rarr;
* ports mapping follows convention &rarr; `shared port = port + 50000`
* port for dynamic port forwarding when ssh-ing into the container = `65500`
* volume mount to `/work` or `/persist` &rarr; helps with persistence
* general installations made using Dockerfile should be placed under `/opt`
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

This will start the container which can be ssh-ed into. The `tail -f /dev/null` keeps the the container running in the background. `docker stop amazing_docker -t 0` can be used to stop the container. The run command can also be made into a function with a `$@` within the command somewhere to allow for more arguments to be passed.
</details>

<details>
<summary>Example build command</summary>

To build, use the following &rarr;
```bash
git clone https://github.com/tanq16/dockers
cd dockers/security_docker
docker build -t <your_tag> .
```

The `security_docker` directory also contains a dockerfile for Apple Silicon Macs, which can be specified using the `--file Dockerfile.AppleSilicon` flag for the `docker build` command.
</details>

The `p10k.zsh` file must be inside the same directory as the Dockerfile, as the build process copies it and prevents the configuration wizard of `oh-my-zsh` from running when accessing the shell of the docker image via SSH. If the wizard is still needed for customization, then run `p10k configure` inside the docker and replace the contents of the `~/p10k.zsh` file in the image with those of the `p10k.zsh` file inside the directory for the docker image. `docker cp` can be used for this to copy out of a running container.

The security docker image is effectively a combination of many of the good tools required for basic pentesting. It has the some development tools like golang and nodejs installed as well. Cloud tools are also installed within the image such as ScoutSuite, CloudSploit, Trivy and PMapper. Kubectl and Terraform are also installed in the image.

To pull a prebuilt image, use `docker pull tanq16/sec_docker:main`. For the Apple Silicon version, use the tag `tanq16/sec_docker:main_apple`.

---

# Example Workflow

The image is mainly meant to be used as a linux system for security work. It is a lightweight image and has all the tools from `cli-productivity-suite`. They're meant for security testing workflows and can be used as a starting point to customize for specific workflows.

Launch the container and mount a persistent storage directory. The shell history or any required configuration file can also be shared with the docker. To do this, create a directory in the host home directory `docker_work`. The structure of the directory can be as follows &rarr;
```
$ tree docker_work -a -L 1
docker_work
├── persist
├── run.sh
├── keys
└── .zsh_history
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

The `run.sh` script can be customized to contain any instructions needed to get a container ready for work. This can be directly run from the home directory as per the copy operation. An example for the script can be to solve slow paste in oh-my-zsh.

<details>
<summary>Solve Oh-My-Zsh slow paste</summary>

```bash
#!/bin/zsh
sed -i "s/autoload -Uz bracketed-paste-magic/#autoload -Uz bracketed-paste-magic/" ~/.oh-my-zsh/lib/misc.zsh
sed -i "s/zle -N bracketed-paste bracketed-paste-magic/#zle -N bracketed-paste bracketed-paste-magic/" ~/.oh-my-zsh/lib/misc.zsh
sed -i "s/autoload -Uz url-quote-magic/#autoload -Uz url-quote-magic/" ~/.oh-my-zsh/lib/misc.zsh
sed -i "s/zle -N self-insert url-quote-magic/#zle -N self-insert url-quote-magic/" ~/.oh-my-zsh/lib/misc.zsh
```

This is a script to fix so pastes on `oh-my-zsh` shells, which are caused due to `magic-*` functions. The scripts can be run as the first thing after ssh-ing into the docker.
</details>

Just calling `start_work` runs the docker in a detached state and calling `stop_work` will stop the running container. After the container is started in detached state, it can be easily ssh-ed into for work.

**Note** &rarr; After ssh-ing into the container, if there is a need to use tmux, then use `tt` to launch a default session. Then, use `Ctrl+b` followed by `Shift+i` to install all the plugins. This takes approximately 2 seconds after which the plugins will stay installed until the container is stopped.

---

# Bonus Info

To ssh into the docker without adding it to the hosts file, use the following command -
```bash
ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" root@localhost -p 50232
```
or add the following alias to the rc file for your default shell -
```bash
alias sshide='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
```

It is also useful to have buildkit enabled. This can be done by using the following command or adding it to the shell rc file -
```bash
export DOCKER_BUILDKIT=1
```
Docker buildkit can be disabled by making the above 0.

---
