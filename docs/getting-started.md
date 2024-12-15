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

Create the persistence directory as shown above. Then, add these functions and alias to your shell's RC file (`.bashrc`, `.zshrc`, etc.) to start and stop the containers more efficiently:

```bash
# Start Container
start_cst() {
    # First argument is the variant name, defaulting to 'general'
    variant=${1:-general}
    arch=$(uname -m | grep -q "aarch64" && echo "arm" || echo "amd")
    
    # Run container with SSH enabled and history persistence
    docker run --name="cst_${variant}" --rm -d \
    -v $HOME/docker_work/:/persist \
    -p 50022:22 ${@:2} \
    -it tanq16/cst-${variant}:${arch} \
    bash -c "service ssh start; cp /persist/.bash_history /root/.bash_history 2>/dev/null; tail -f /dev/null"
    
    # Generate and set SSH password
    new_pass=$(cat /dev/random | head -c 20 | base64 | tr -d '=+/')
    echo "Password: $new_pass"
    echo $new_pass > $HOME/.cst-pw
    docker exec -e newpp="$new_pass" cst_${variant} bash -c 'echo "root:$(printenv newpp)" | chpasswd'
}

# Stop Container
stop_cst(){
    variant=${1:-general}
    docker cp cst-${variant}:/root/.bash_history $HOME/docker_work/.bash_history 2>/dev/null
    docker stop cst-${variant} -t 0
}

# SSH alias without known host file write
alias sshide='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
```

Restart or respawn your shell after saving to ensure the new commands are available.

!!! tip "Disk Space Consideration" Remember the `--rm` flag is necessary to delete the container after stopping it. This is very important because usual work can cause the container's ephemeral filesystem to become as large as 1GB or more. If the containers aren't automatically removed, it can eat up disk space rapidly.

### Using SSH for Access

With the above functions in place, the images can be launched with an SSH server already started. This allows SSH-ing into the running container as many number of times as needed. It emulates a virtual machine in this case.

1. Start container:
    ```bash
    start_cst cloud
    ```

2. SSH into container:
    ```bash
    sshide root@localhost -p 50022
    ```
    Use the password that was printed in the `start_cst` command. It's also stored at `$HOME/.cst-pw`

3. When done, stop container:
    ```bash
    stop_cst cloud
    ```

To understand why SSH and shell functions exist as a workflow, refer to [Advanced Usage](advanced/shortcuts.md).

## Persistence

The `/persist` directory in the container maps to `$HOME/docker_work/` on your host system. Use this directory for:

- Project files
- Configuration files
- Data that needs to persist between container restarts
- Shell history files
- Local setup file (if you have a specific set of instructions you want to run at container start, you can easily store that as `run.sh` in the persistence directory)

## Next Steps

- Check out the [Variant-Specific Guides](variants/index.md) for your chosen variant
- Review [Conventions](conventions.md) for best practices
- Explore [Advanced Usage](advanced/shortcuts.md) for more features
- Read [Example Workflow](advanced/workflow.md) to see an example of how I use the `cst-rice` image for my day to day
