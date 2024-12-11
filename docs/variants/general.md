# General Variant

The General variant serves as both a standalone security operations environment and a base for building custom security-focused images. It provides a carefully selected set of core security tools and utilities while maintaining a clean, extensible structure.

### Key Features

- Core security assessment tools
- Network analysis utilities
- Common penetration testing tools
- Web application security tools
- Base for custom security images

This variant is ideal for:
- Security professionals needing a reliable base environment
- Teams building custom security toolkits
- General security assessment work
- Quick security analysis tasks

### Base Image Extension

The General variant is designed to be extended. Create custom security-focused images by using it as a base:

```dockerfile
FROM tanq16/cst-general:amd

# Add custom tools and configurations
RUN apt-get update && apt-get install -y \
    your-additional-packages

# Add custom scripts or tools
COPY ./custom-tools /opt/custom-tools
```
