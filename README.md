<h1 align="center">
  <br>
  <img src="docs/assets/CST-Logo.png" alt="CST" width="280">
  <br>
  Containerized Security Toolkit (CST)
  <br>
</h1>

<p align="center">
  <a href="https://hub.docker.com/r/tanq16/sec_docker"><img src="https://img.shields.io/docker/pulls/tanq16/sec_docker?style=flat"></a><a href="https://hub.docker.com/r/tanq16/cst-rice"><img src="https://img.shields.io/docker/pulls/tanq16/cst-rice?style=flat"></a><a href="https://hub.docker.com/r/tanq16/cst-cloud"><img src="https://img.shields.io/docker/pulls/tanq16/cst-cloud?style=flat"></a><a href="https://hub.docker.com/r/tanq16/cst-general"><img src="https://img.shields.io/docker/pulls/tanq16/cst-general?style=flat"></a>
  <br>
  <a href="https://tanishq.page/containerized-security-toolkit"><img alt="Static Badge" src="https://img.shields.io/badge/Documentation"></a> • <a href="https://hub.docker.com/r/tanq16/"><img alt="Static Badge" src="https://img.shields.io/badge/DockerHub%20(User)"></a>
  <br>
  <a href="https://github.com/tanq16/containerized-security-toolkit/releases"><img src="https://img.shields.io/github/v/release/tanq16/containerized-security-toolkit?include_prereleases&style=flat"></a><a href="https://github.com/tanq16/containerized-security-toolkit/blob/main/LICENSE"><img src="https://img.shields.io/github/license/tanq16/containerized-security-toolkit?style=flat"></a><a href=""><img src="https://img.shields.io/github/stars/tanq16/containerized-security-toolkit?style=flat"></a>
</p>

<h3 align="center">A comprehensive suite of containerized security toolkits for various security operations</h3>

<p align="center">
  <b>Build Status:</b><br>
  <a href="https://github.com/tanq16/containerized-security-toolkit/actions/workflows/general-build.yml"><img src="https://github.com/tanq16/containerized-security-toolkit/actions/workflows/general-build.yml/badge.svg" alt="General Build"></a><a href="https://github.com/tanq16/containerized-security-toolkit/actions/workflows/cloud-build.yml"><img src="https://github.com/tanq16/containerized-security-toolkit/actions/workflows/cloud-build.yml/badge.svg" alt="Cloud Build"></a><a href="https://github.com/tanq16/containerized-security-toolkit/actions/workflows/rice-build.yml"><img src="https://github.com/tanq16/containerized-security-toolkit/actions/workflows/rice-build.yml/badge.svg" alt="Rice Build"></a>
  <br>
  <a href="https://dl.circleci.com/status-badge/redirect/circleci/YPqXqLMjjXxLwPP9TvpyFc/W1CQsWfrfu4rKFiytoHbs9/tree/main"><img src="https://dl.circleci.com/status-badge/img/circleci/YPqXqLMjjXxLwPP9TvpyFc/W1CQsWfrfu4rKFiytoHbs9/tree/main.svg?style=svg"></a><br>
  (All ARM images build through CCI until ARM GHA runners are available)
</p>

## Overview

The Containerized Security Toolkit (CST) provides a comprehensive suite of Docker images tailored for various security operations. Each variant is designed for specific use cases while maintaining consistency in basic functionality:

- **General** (`tanq16/cst-general:*`): Core security tools and utilities for general security operations
- **Cloud** (`tanq16/cst-cloud:*`): Specialized for cloud security assessments and operations
- **Dev** (`tanq16/cst-dev:*`): Development environment with security tools (Python, Go, Node.js) - ***`WIP`***
- **Netsec** (`tanq16/cst-netsec:*`): Network security assessment and monitoring tools - ***`WIP`***
- **Rice** (`tanq16/cst-rice:*`): Enhanced version of General with [CLI Productivity Suite](https://github.com/Tanq16/cli-productivity-suite)

Each variant is available for both x86_64 and ARM64 architectures:

```
tanq16/cst-<variant>:amd  # For x86_64 systems
tanq16/cst-<variant>:arm  # For ARM64 systems (Apple Silicon, etc.)
```

## Quickstart

Get started with the General variant in seconds:

```bash
# Create persistence directory
mkdir -p $HOME/docker_work/

# Run container (use general-arm for ARM64 systems)
docker run --name="cst_general" \
  -v $HOME/docker_work/:/persist \
  --rm -it tanq16/cst-general:amd \
  /bin/bash
```

For advanced usage patterns, variant-specific guides, and comprehensive documentation:
- 📚 [Full Documentation](https://tanishq.page/containerized-security-toolkit)
- 🚀 [Shell Shortcuts](https://tanishq.page/containerized-security-toolkit/advanced/shortcuts/)
- 🚀 [Advanced Workflow](https://tanishq.page/containerized-security-toolkit/advanced/workflow/)
- 🔧 [Tool Lists](https://tanishq.page/containerized-security-toolkit/tools/general-tools)

## Key Features

- 🔄 **Persistent Storage**: Mount local directories for data persistence
- 🔒 **Secure Design**: Regular security updates and best practices
- 🎯 **Purpose-Built**: Each variant optimized for specific security tasks
- 🔧 **Rich Tooling**: Comprehensive set of pre-installed security tools
- 📦 **Consistent Environment**: Reproducible setup across systems
- 🖥️ **Cross-Platform**: Full support for both x86_64 and ARM64

## Contributing

Check out [contribution guidelines](https://tanishq.page/containerized-security-toolkit/contributing/) for details on how to submit changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
