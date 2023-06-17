<h1 align="center">
  <br>
  <img src=".github/assets/CTS-Logo.png" alt="DISecT" width="425"></a>
  <br>Containerized Security Toolkit (CST)<br>
</h1>

<p align="center">
    <a href="https://github.com/Tanq16/containerized-security-toolkit/wiki"><b>Wiki</b></a>  &bull;  
    <a href="https://github.com/Tanq16/containerized-security-toolkit/wiki/2.-Example-Workflow"><b>Example Workflow</b></a>  &bull;  
    <a href="https://hub.docker.com/r/tanq16/sec_docker"><b>Docker Hub</b></a>  &bull;  
    <a href="https://github.com/Tanq16/containerized-security-toolkit/wiki/5.-Tools-List"><b>Tools List</b></a>  &bull;  
    <a href="https://github.com/tanq16/dockers_tool_builder"><b>Executable Builder</b></a>
</p>

<br>

This project contains several Dockerfiles for ARM (Apple Silicon) and x86_64 variants of security focussed docker images. The main resources here are as follows &rarr;

- **Security Image** &rarr; An image that contains many security focussed tools
- **Threat Hunt Image** &rarr; An image that contains tools and for threat hunting

The security image is built manually by me on AWS EC2 (not via GitHub Actions due to free runner limits and long ARM build times) and pushed to Docker Hub for both x86-64 and ARM architectures.

The image is called `sec_docker` and multiple versions of it are uploaded as different tags, such as &rarr;

| | x86\_64 Image | ARM Image |
| --- | --- | --- |
| Security | `main` | `main_apple` |
| Security Minimal | `minimal` | `minimal_apple` |
| Threat Hunt | `thmain` | `thmain_apple` |

It has the [cli-productivity-suite](https://github.com/tanq16/cli-productivity-suite) preinstalled within the image. Executables, primarily Go-lang executables, are built and copied over from another image which is built once a month at the [tool_builder](https://github.com/tanq16/dockers_tool_builder).

The [wiki](https://github.com/Tanq16/containerized-security-toolkit/wiki) goes over using the pre-built images, building it with modifications, conventions considered when creating the Dockerfiles, and different ways it can be used.

---

A rundown of the [Quickstart](https://github.com/Tanq16/containerized-security-toolkit/wiki/1.-Quickstart) is as follows &rarr; 

There are several other nuances related to running the container, specifically around setting up single command functions to start and stop containers. Read the [wiki](https://github.com/Tanq16/containerized-security-toolkit/wiki), especially the [Example Workflow](https://github.com/Tanq16/containerized-security-toolkit/wiki/2.-Example-Workflow) for a better setup.

However, for a quick and dirty run, copy and paste the following commands in order &rarr;

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

---

Containerized workloads for the win!
