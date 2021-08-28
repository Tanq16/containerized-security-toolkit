# Docker Images

The two docker images in this repository are intended to be used for cybersecurity related operations and for python/go development. The security docker is effectively a combination of all the good tools required for basic pentesting. Both the images include the command line enhancements listed above. The intended way to use it is to run the docker and then ssh into the instance via VS code and a terminal application, use tmux and work.

This is specific to x86 machines and the best way to get access is to pull the image by using -
```bash
docker pull tanq16/sec_docker:main # For the security docker image
docker pull tanq16/sec_docker:dev # For the development docker image
```
Then, it can be run by using -
```bash
# The dev docker image - mount the programming folders from host and map the ssh port
docker run --name="sec_docker" -v ~/go_programs/:/root/go/src -v ~/python_programs/:/root/python/ --rm -p 50022:22 -it tanq16/sec_docker:dev zsh -c "service ssh start; zsh"

# The security docker image - map the ssh port and the jupyterlab port
docker run --name="sec_docker" --rm -p 58080:8080 -p 50022:22 -it tanq16/sec_docker:main zsh -c "service ssh start; zsh"
```

The security image also has the development instructions in its `Dockerfile`, so the volumes can be mounted there as well. On connecting the VS code via the remote ssh extension to the docker image, the python package and the go package should be installed everytime the docker is run. This is not a cumbersome process for doing manually but is cumbersome doing it in an automated fashion. The advantage of using the development image over the security image, despite the security image containing both the development environments, is that the development image is only ``1.45 GB`` in size compared to ``6.5 GB`` for the security image.

The `service ssh start` section of the command to be executed is needed to enable ssh access. Direct loading of the shell interferes with the oh-my-zsh themes and not all things are loaded. Therefore, the docker image should be run either in background or as stated above to signify a control shell and then use ssh and tmux to simulate work environment. After this, it is possible to ssh into the docker with the `root` user and password `docker`.

The general norm for mapping ports for these images is 50000+port for consistency and interoperability.

## Golang environment for development docker

Given the unique file structure for the go root directory, it is best to map the ``src/`` directory or a code store directory of the host to that of the `src` directory in the actual go structure inside the image. This avoids writing the built binaries and added packages into the code saved on the host, thereby allowing a clean sync of the code directory on the host to a version control system.

## Notable installations in the security docker

* nmap, ncat & ncrack
* ltrace & strace
* gobuster, nikto & dirb
* netdiscover & wireshark (tshark mainly, because its cli)
* hydra, fcrackzip & john the ripper
* gdb with pwndbg
* metasploit-framework & searchsploit (with exploit-database)
* jupyter-lab & golang
* seclists & rockyou.txt

## Build on your own

The repository includes the required files to build both the images. If the existing tools are not required or extra tools must be installed or replaced, the given `Dockerfile`s in the respective directories should be edited. 

The `p10k.zsh` file for each directory must be inside the same directory as the `Dockerfile` of the respective docker image, as the vuild process copies it and prevents the configuration wizard of oh-my-zsh from running when accessing the shell of the docker image. If the wizard is still needed for customization, then run `p10k configure` inside the docker and replace the contents of the `p10k.zsh` file in the host with those of the `~/.p10k.zsh` file inside the directory for the required docker image.

To build the docker use this command in the required folder that contains the files -
```bash
docker build -t dev_docker .
```
Thereafter, run the following command to execute the shell within the image -
```bash
docker run --name="aio_docker_instance" --rm -p 50022:22 -it aio_docker zsh -c "service ssh start; zsh"
```

## Bonus information

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
Disabling can be done by making the above 0.
