# DIY Build Guide

This guide details how to build custom images for specific purposes. The main idea is to use the `cst-general` image Dockerfiles as base and add tool and services onto it for custom operations.

## Basic Build Process

CST uses a multi-stage build process for efficient image creation:

1. **Builder Stage**: This stage builds or downloads tools. It is primarily meant for tools that are installed as executables, such as `go` installs or executable downloads. Often it would require multiple images being used in a multi-stage build to store executables inside an alpine image to copy to the main stage later. Example:
   ```dockerfile
   FROM ubuntu:jammy AS executable_builder
   # Tool compilation and binary creation

   FROM golang as go_builder
   # Go installs

   FROM alpine
   COPY --from=go_builder /executables/* /executables/
   COPY --from=executable_builder /executables/* /executables/
   ```

2. **Final Stage**: This uses the resulting image from the builder stage to copy artifacts into the main Dockerfile to produce the final image. This also includes non-binary installs (such as Tmux or `apt` installs). Example:
   ```dockerfile
   FROM intermediate_builder as intermediate_builder

   FROM ubuntu:jammy
   # System setup and tool installation

   COPY --from=intermediate_builder /executables /opt/executables
   RUN chown -R root:root /opt/executables && chmod 755 /opt/executables/*
   ```

Now, to build a custom image, create a new variant directory as follows:

```bash
cp -r images/general images/myvariant && \
cd images/myvariant
```

Then modify the two Dockerfiles, based on the details mentioned earlier. After that, you can build as follows:

```bash
# Build intermediate layer
docker build -f builder.Dockerfile -t intermediate_builder .

# Build final image
docker build -t cst-<variant>:local .

# Clean up
docker builder prune -f
```

!!! tip "Cleanup"
    Don't forget to cleanup otherwise the builder cache will pile up and really eat up disk space slowly.

## Advanced Building

### Cross-Platform Builds

Building for multiple architectures:

```bash
# Setup buildx
docker buildx create --use

# Build multi-platform image
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    -t username/cst-custom:latest .
```

### Optimization Techniques

- A multi-stage build itself reduces size significantly
- When cloning repositories with `git`, use `--depth=1` to save `.git` space
- Use `DEBIAN_FRONTEND="noninteractive"` as the environment variable for `apt` to prevent failures
- Use `--no-install-recommends` with `apt` to ensure only required packages are installed

!!! danger "Base Image"
    The base image being used is the `ubuntu:jammy` image. While a method of reducing size can be to use `alpine` images for the final image, in reality it does not make much of a difference with tools installed; essentially 250+ MB vs 15+ MB doesn't matter when the final images are sized in giga bytes. This is because there are tools like Azure CLI, which take up 2GB alone. Also, the `jammy` variant is being used for better overall stability. This may change in the future as needed. Also, using `ubuntu` helps with debugging and maintaining a common environment that most people use and have the best online support for.
