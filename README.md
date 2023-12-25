<h1 align="center">
  <br>
  <img src=".github/assets/CTS-Logo.png" alt="DISecT" width="425"></a>
  <br>Containerized Security Toolkit (CST)<br>
</h1>

<p align="center">
    <a href="https://github.com/Tanq16/containerized-security-toolkit/wiki"><b>Wiki</b></a>  &bull;  
    <a href="https://github.com/Tanq16/containerized-security-toolkit/wiki/2.-Example-Workflow"><b>Example Workflow</b></a>  &bull;  
    <a href="https://hub.docker.com/r/tanq16/sec_docker"><b>Docker Hub</b></a>
</p>

<br>

This project contains several Dockerfiles for ARM (Apple Silicon) and x86_64 variants of security focussed docker images. The two main resources here are as follows &rarr;

- **Security Image for x86_64**
- **Security Image for ARM64**

The x86_64 security image is built automatically on GH CI and the ARM is built by me on AWS EC2 (not via GitHub Actions due to free runner limits, ARM limits, and long ARM build times). Both images are pushed to Docker Hub.

The image is called `sec_docker` and multiple versions of it are uploaded as different tags, such as &rarr;

| | x86\_64 | ARM |
| --- | --- | --- |
| tag | `main` | `main_apple` |
| image ref | `tanq16/sec_docker:main` | `tanq16/sec_docker:main_apple` |

It has the [cli-productivity-suite](https://github.com/tanq16/cli-productivity-suite) preinstalled within the image. The [wiki](https://github.com/Tanq16/containerized-security-toolkit/wiki) goes over using the pre-built images, building it with modifications, conventions considered when creating the Dockerfiles, and different ways it can be used.

---

A quick look into the container and its capabilities, built from this image, is as follows &rarr; 

```bash
docker run --name="sec_docker_quickstart" --rm -it tanq16/sec_docker:main /bin/zsh
```

If you exit the shell, the container will be destroyed along with the information in the ephemeral filesystem.

There are several other nuances related to running the container, such as setting up a persistence diretcory across container restarts, using one-word shell functions to start and stop containers with customized settings. Read the [wiki](https://github.com/Tanq16/containerized-security-toolkit/wiki), especially the [Example Workflow](https://github.com/Tanq16/containerized-security-toolkit/wiki/2.-Example-Workflow) for a comprehensive and convenient setup process.
