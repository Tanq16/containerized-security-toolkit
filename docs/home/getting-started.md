# Getting Started with CST

This guide will help you get up and running with the Containerized Security Toolkit.

## Prerequisites

- Docker installed and running on your system
- Basic familiarity with Docker commands
- At least 10GB of free disk space (varies by variant)

## Basic Setup

1. Create a persistence directory:

```bash
mkdir -p $HOME/docker_work/
```

2. Choose your variant and architecture:

```bash
# For x86_64 systems
docker pull tanq16/cst-general:amd

# For ARM64 systems (Apple Silicon, etc.)
docker pull tanq16/cst-general:arm
```

3. Run the container:

```bash
docker run --name="cst-general" \
  -v $HOME/docker_work/:/persist \
  --rm -it tanq16/cst-general:amd \
  /bin/bash
```

## Advanced Setup

### Shell Functions for Convenience

Add these functions to your shell's RC file (`.bashrc`, `.zshrc`, etc.):

```bash
# Start Container
start_cst(){
    variant=${1:-general}
    docker run --name="cst-${variant}" --rm -d \
    -v $HOME/docker_work/:/persist \
    -p 50022:22 ${@:2} \
    -it tanq16/cst-${variant}:amd \
    bash -c "service ssh start; cp /persist/.bash_history /root/.bash_history 2>/dev/null; tail -f /dev/null"
    
    new_pass=$(cat /dev/random | head -c 20 | base64 | tr -d '=+/')
    echo "Password: $new_pass"
    echo $new_pass > current_docker_password
    docker exec -e newpp="$new_pass" cst-${variant} bash -c 'echo "root:$(printenv newpp)" | chpasswd'
}

# Stop Container
stop_cst(){
    variant=${1:-general}
    docker cp cst-${variant}:/root/.bash_history $HOME/docker_work/.bash_history 2>/dev/null
    docker stop cst-${variant} -t 0
}
```

### Using SSH for Access

With the above functions in place:

1. Start container:

```bash
start_cst general
```

2. SSH into container:

```bash
ssh -o "StrictHostKeyChecking=no" \
    -o "UserKnownHostsFile=/dev/null" \
    root@localhost -p 50022
```

3. When done, stop container:

```bash
stop_cst general
```

## Persistence

The `/persist` directory in the container maps to `$HOME/docker_work/` on your host system. Use this directory for:

- Project files
- Configuration files
- Data that needs to persist between container restarts
- Shell history files

## Next Steps

- Check the [Variant-Specific Guides](../variants/index.md) for your chosen variant
- Review [Conventions](conventions.md) for best practices
- Explore [Advanced Usage](../advanced/shortcuts.md) for more features
