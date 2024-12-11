# DIY Build Guide

The CST images can be customized and built locally. This guide explains the build process and customization options.

## Basic Build Process

CST uses a multi-stage build process for efficient image creation:

1. **Builder Stage**
   ```dockerfile
   FROM ubuntu:jammy AS executable_builder
   # Tool compilation and binary creation
   ```

2. **Final Stage**
   ```dockerfile
   FROM ubuntu:jammy
   # System setup and tool installation
   ```

### Building Images

Basic build commands:

```bash
# Change to variant directory
cd images/<variant>

# Build intermediate layer
docker build -f builder.Dockerfile -t intermediate_builder .

# Build final image
docker build -t cst-<variant>:local .

# Clean up
docker builder prune -f
```

## Customization Options

### Adding New Tools

1. **Builder Stage Modifications**
   ```dockerfile
   # In builder.Dockerfile
   RUN go install github.com/your/tool@latest && \
       mv /go/bin/tool /executables/
   ```

2. **Final Stage Additions**
   ```dockerfile
   # In Dockerfile
   RUN apt-get update && apt-get install -y \
       your-additional-package

   # Add custom scripts
   COPY ./scripts/custom.sh /opt/scripts/
   ```

### Creating New Variants

1. Create new variant directory:
   ```bash
   mkdir -p images/custom
   cp images/general/* images/custom/
   ```

2. Modify Dockerfiles for specific needs:
   ```dockerfile
   # Add specialized tools
   RUN apt-get update && apt-get install -y \
       specialized-package

   # Add custom configurations
   COPY configs/ /etc/custom/
   ```

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

1. **Layer Optimization**
   ```dockerfile
   # Combine related operations
   RUN apt-get update && \
       apt-get install -y \
       package1 \
       package2 && \
       apt-get clean && \
       rm -rf /var/lib/apt/lists/*
   ```

2. **Size Reduction**
   ```dockerfile
   # Use multi-stage builds
   FROM build-image AS builder
   # Build tools
   
   FROM runtime-image
   # Copy only necessary files
   COPY --from=builder /app/binary /usr/local/bin/
   ```

## Testing Builds

1. **Basic Testing**
   ```bash
   # Build test image
   docker build -t cst-test .
   
   # Run basic tests
   docker run --rm cst-test which tool1 tool2 tool3
   ```

2. **Feature Testing**
   ```bash
   # Test specific features
   docker run --rm cst-test \
       bash -c "tool --version && tool --help"
   ```

## Best Practices

- **Version Control**
   - Tag images with version numbers
   - Document changes in changelog
   - Use semantic versioning

- **Documentation**
   - Update tool lists
   - Document new features
   - Include usage examples

- **Security**
   - Scan images for vulnerabilities
   - Update base images regularly
   - Follow security best practices

- **Maintenance**
   - Regular dependency updates
   - Version compatibility checks
   - Performance optimization
