<p align="center">
  <img src="../assets/CST-Logo.png" alt="CST" width="250">
</p>

# Containerized Security Toolkit

The Containerized Security Toolkit (CST) provides a comprehensive suite of Docker images tailored for various security operations. Each variant is designed for specific use cases while maintaining consistency in basic functionality.

For getting started quickly, visit the [Getting Started Guide](getting-started.md).

## Available Variants

- **General**: Core security tools and utilities for general security operations
- **Cloud**: Specialized for cloud security assessments and operations
- **Dev**: Development environment with security tools (Python, Go, Node.js) - WIP
- **Netsec**: Network security assessment and monitoring tools - WIP
- **Rice**: Enhanced version of General with CLI Productivity Suite

Each variant is available for both x86_64 and ARM64 architectures:

```
tanq16/cst-<variant>:amd  # For x86_64 systems
tanq16/cst-<variant>:arm  # For ARM64 systems (Apple Silicon, etc.)
```

## Key Features

- **Persistent Storage**: Mount local directories for data persistence
- **Secure Design**: Regular security updates and best practices
- **Purpose-Built**: Each variant optimized for specific security tasks
- **Rich Tooling**: Comprehensive set of pre-installed security tools
- **Consistent Environment**: Reproducible setup across systems
- **Cross-Platform**: Full support for both x86_64 and ARM64

## Quick Reference

- **Documentation**: [https://tanishq.page/containerized-security-toolkit](https://tanishq.page/containerized-security-toolkit)
- **Docker Hub**: [https://hub.docker.com/r/tanq16/cst](https://hub.docker.com/r/tanq16/cst)
- **Source Code**: [https://github.com/tanq16/containerized-security-toolkit](https://github.com/tanq16/containerized-security-toolkit)
