# Using This Repository

This repository contains several directories, each of which has a Dockerfile and other requirements needed to build the respective docker images. The 4 images here are as follows &rarr;
<!-- start bullet list -->
* Image for Python and Go development
* Image for security focussed tools
* Image for general cli work
* Image to generate a PDF from a markdown file
<!-- end bullet list -->

These images are also available to be directly pulled from docker hub repositories. A GitHub CI Action builds and pushes the images to docker hub monthly and on every commit. The Apple Silicon images are built using [Buildx](https://docs.docker.com/buildx/working-with-buildx/).

Each of the following sections provides a brief on both pulling or building these images.

All images except for the `markdown_to_pdf` image have the [cli-productivity-suite](https://github.com/tanq16/cli-productivity-suite) preinstalled in them i.e., a funky shell along with customized vim and tmux.

## Conventions and Running Containers

All the work related images are built with the intention of ssh-ing into them and making use of tmux to work in them. Further, the conventions followed for building the images (also useful if edits are needed) are &rarr;
<!-- start bullet list -->
* ports mapping follows convention &rarr; shared port = port + 50000
* volume mount to `/work`
* general installations made using Dockerfile should be placed under `/opt`
* run the images with `--rm` option and start ssh as a command (shown below)
<!-- end bullet list -->

The images are meant to be run using the following docker run command syntax &rarr;
```bash
docker run --name="amazing_docker" \
-v /path/to/host/go_programs/:/root/go/src \
-v /path/to/host/work:/work \
-p 50022:22 -p 50080:80 \
--rm -it image_tag \
zsh -c "service ssh start; zsh"
```

This will spawn the container's shell on a terminal which can be left as a master window to exit and stop the image using `Ctrl+d` on the spawned shell when done. Another terminal window can be used to ssh into the machine and work.

Another possible workflow is to replace the last `zsh` command by `tail -f /dev/null` and adding the `-d` (detached) flag. This will keep the container running in the background. `docker stop amazing_docker -t 0` can be used to stop the container.

## Building the Images

To build, use the following &rarr;
```bash
git clone https://github.com/tanq16/dockers
cd dockers/dev_docker # or any other directory (work_docker or security_docker)
docker build -t <you_tag> .
```

Each directory also contains a dockerfile for Apple Silicon macs, which can be specified using the `--file Dockerfile.AppleSilicon` flag for the `docker build` command.

The `p10k.zsh` file for each directory must be inside the same directory as the Dockerfile of the respective docker image, as the build process copies it and prevents the configuration wizard of oh-my-zsh from running when accessing the shell of the docker image. If the wizard is still needed for customization, then run `p10k configure` inside the docker and replace the contents of the `p10k.zsh` file in the image with those of the `~/.p10k.zsh` file inside the directory for the required docker image.

---

# Python and Go Development Docker

This image is useful for Python and Go development and has both of them preinstalled.This image is meant to be sshed into by VS Code's remote ssh plugin for a well balanced development experience.

On connecting the VS code via the remote ssh extension to the docker image, the python package and the go package should be installed everytime the docker is run. This is not a cumbersome process for doing manually but is cumbersome doing it in an automated fashion.

Notably, the image has python3, jupyterlab and go installed.

To pull a prebuilt image, use `docker pull tanq16/sec_docker:dev`. For the Apple Silicon version, use the tag `tanq16/sec_docker:dev_apple`.

It can be run using the command discussed in the first section.

## Golang environment for development docker

Given the unique file structure for the go root directory, it is best to map the `src/` directory or a code store directory of the host to that of the `src` directory in the actual go structure inside the image. This avoids writing the built binaries and added packages into the code directory saved on the host, thereby allowing a clean sync of the code directory on the host to a version control system.

---

# Security Focussed Docker

The security docker is effectively a combination of many of the good tools required for basic pentesting. It has the development image's packages installed as well. The following are the notable installations in the image &rarr;
<!-- start bullet list -->
* nmap, ncat & ncrack
* ltrace & strace
* gobuster, nikto & dirb
* netdiscover & wireshark (tshark mainly, because its cli)
* hydra, fcrackzip & john the ripper
* gdb with pwndbg
* metasploit-framework & searchsploit (with exploit-database)
* jupyter-lab & golang
* seclists & rockyou.txt
<!-- end bullet list -->

To pull a prebuilt image, use `docker pull tanq16/sec_docker:main`. For the Apple Silicon version, use the tag `tanq16/sec_docker:main_apple`.

It can be built and run in the same way as discussed in the previous sections.

---

# Work Docker

This image is mainly meant to be used as a linux system for general work. It's a lightweight image and has all the tools from `cli-productivity-suite` and `python3`. It's meant for the most basic workflows and can be used as a starting point to customize for a specific workflow. The building and running instructions are the same as in the previous sections.

To pull a prebuilt image, use `docker pull tanq16/sec_docker:work`. For the Apple Silicon version, use the tag `tanq16/sec_docker:work_apple`.

This can also be used as a working dock from any machine. An example workflow is as follows &rarr;
Use a normal distribution to launch activities via the work docker by mounting a persistent storage directory. The zsh history or any required conf file can also be shared with the docker. To do this, create a directory in the host home directory `docker_work`. The structure of the directory can be as follows &rarr;
```
$ tree docker_work -a -L 1
docker_work
├── persist
├── run.sh
├── sshkeys
└── .zsh_history
```

With this in place, 2 functions can be added to the host profile or rc file. These are &rarr;
```bash
start_work(){
    docker run --name="sec_docker" --rm -d \
    -v $HOME/docker_work/persist/:/persist -p 50022:22 -it tanq16/sec_docker:main \
    zsh -c "service ssh start; tail -f /dev/null"
    if [ -f $HOME/docker_work/.zsh_history ]
        then docker cp $HOME/docker_work/.zsh_history sec_docker:/root/.zsh_history
    fi
    docker cp $HOME/docker_work/sshkeys/ sec_docker:/root/.ssh/
    docker cp $HOME/docker_work/run.sh sec_docker:/root/run.sh
}

stop_work(){
    docker cp sec_docker:/root/.zsh_history $HOME/docker_work/.zsh_history
    docker cp sec_docker:/root/.ssh/known_hosts $HOME/docker_work/sshkeys/known_hosts
    docker stop sec_docker -t 0
}
```

The `run.sh` script can be customized to contain any instructions needed to get a container ready for work. This can be directly run from the home directory as per the copy operation. An example for the script can be the following -

```bash
#!/bin/zsh
sed -i "s/autoload -Uz bracketed-paste-magic/#autoload -Uz bracketed-paste-magic/" ~/.oh-my-zsh/lib/misc.zsh
sed -i "s/zle -N bracketed-paste bracketed-paste-magic/#zle -N bracketed-paste bracketed-paste-magic/" ~/.oh-my-zsh/lib/misc.zsh
sed -i "s/autoload -Uz url-quote-magic/#autoload -Uz url-quote-magic/" ~/.oh-my-zsh/lib/misc.zsh
sed -i "s/zle -N self-insert url-quote-magic/#zle -N self-insert url-quote-magic/" ~/.oh-my-zsh/lib/misc.zsh
```

This is a script to fix so pastes on Oh-My-Zsh shells, which are caused due to magic-* functions. The scripts can be run as the first thing after sshing into the docker.

Now, just calling `start_work` runs the docker in a detached state and calling `stop_work` will stop the running container. After the container is started in detached state, it can be easily sshed into for work.

A bonus idea is to share other keys apart from ssh keys such as for remote servers such as aws consoles, gcp compute engines or github with the work docker.

---

# Markdown to PDF (HTML) Docker

This image can be used to render a webpage from a markdown file. The intent is to use a great looking template and produce high quality webpages. The html template used for this is at [html5up - editorial](https://html5up.net/editorial).

The best way to use this is to build the image like mentioned under the first section. It can then be run as follows &rarr;
```bash
docker run --name "render_md" \
-p 8000:8000 \
-e HS1="page header strong 1" -e HN="page header normal" -e HS2="page header strong 2" \
-v <md file and images directory>:/root/md_files/ \
--rm -it <image_tag> bash /root/run.sh <name of file>.md
```

The page has a header on top which follows the a bold-normal-bold format. These are controlled using the env variables of HS1, HN and HS2 passed in the run command above. They can be left as empty strings as well if a header is not needed.

This command will serve the rendered output on port 8000 and can be accessible at `http://localhost:8000/`. From here, the browser print option can be used to print the PDF version of the rendered file.

The markdown rendering script is a naive one and required the following hard requirements to be followed &rarr;
<!-- start bullet list -->
* Any kind of headings (`# heading` to `### heading`) are supported and `#### heading` produces normal text
* Tables should be preceded by an html comment `<!-- start table -->` and ended by `<!-- end table -->`
* Only single level bulleted lists using `*` are supprted and lists must be enclose between the `<!-- start bullet list -->` and `<!-- end bullet list -->` lines
* Only single level numbered lists are supported and they must be enclosed between `<!-- start number list -->` and `<!-- end number list -->`
* Blockquotes are not supported yet
* Images and links follow normal format
* Horizontal lines are supported as `---`
<!-- end bullet list -->

An example markdown file is present inside the directory.

---

# Bonus information

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
