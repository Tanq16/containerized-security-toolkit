<p align="center">
  <img src="assets/CST-Logo.png" alt="CST" width="250">
</p>

# Containerized Security Toolkit

The Containerized Security Toolkit (CST) provides a comprehensive suite of Docker images tailored for various security operations. Each variant is designed for specific use cases while maintaining consistency in basic functionality.

For getting started quickly, visit the [Getting Started Guide](getting-started.md).

## Available Variants

- **General**: Core security tools and utilities for general security operations
- **Cloud**: Specialized for cloud security assessments and operations
- **Dev**: Development environment with security tools (Python, Go, Node.js) - `Still a WIP`
- **Netsec**: Network security assessment and monitoring tools - `Still a WIP`
- **Rice**: Enhanced version of General with [CLI Productivity Suite](https://github.com/tanq16/cli-productivity-suite)

Each variant is available for both x86_64 and ARM64 architectures:

```
tanq16/cst-<variant>:amd  # For x86_64 systems
tanq16/cst-<variant>:arm  # For ARM64 systems (Apple Silicon, etc.)
```

## Quick Start

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

## Key Features

- **Persistent Storage**: Mount local directories for data persistence
- **Secure Design**: Regular security updates and best practices
- **Purpose-Built**: Each variant optimized for specific security tasks
- **Rich Tooling**: Comprehensive set of pre-installed security tools
- **Consistent Environment**: Reproducible setup across systems
- **Cross-Platform**: Full support for both x86_64 and ARM64

## Quick Reference

- **[Documentation](https://tanishq.page/containerized-security-toolkit)**
- **[Docker Hub - CST General](https://hub.docker.com/r/tanq16/cst-general)**
- **[Docker Hub - CST Cloud](https://hub.docker.com/r/tanq16/cst-cloud)**
- **[Docker Hub - CST Rice](https://hub.docker.com/r/tanq16/cst-rice)**
- **[Docker Hub - Legacy CST](https://hub.docker.com/r/tanq16/sec_docker)**
- **[Source Code](https://github.com/tanq16/containerized-security-toolkit)**
