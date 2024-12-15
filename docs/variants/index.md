# CST Variants Overview

The Containerized Security Toolkit provides purpose-built variants for different security operations. Each variant is available as `cst-<variant>:amd` for x86_64 systems and `cst-<variant>:arm` for ARM64 systems.

## Variant Selection Guide

Choose your variant based on primary use case:

- **General**: Basic security operations or as a base for building custom images
- **Cloud**: Cloud security assessments and operations
- **Dev**: Security tools and application development (`WIP`)
- **Netsec**: Network security testing and monitoring (`WIP`)
- **Rice**: All round security operations with [CLI Productivity Suite](https://github.com/tanq16/cli-productivity-suite) for shell interface

Each variant follows CST's core conventions while providing specialized capabilities for its target use case.
