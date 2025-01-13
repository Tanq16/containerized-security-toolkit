# Shell Shortcuts and Functions

The CST environment can be enhanced with shell functions that streamline container management and daily operations. These functions provide a seamless workflow for starting, accessing, and managing CST containers.

## Core Container Management

As mentioned in [Getting Started](../getting-started.md), the following shell functions handle container lifecycle management. Add these to your shell's RC file (`.bashrc`, `.zshrc`, etc.):

```bash
start_cst() {
    # First argument is the variant name, defaulting to 'general'
    variant=${1:-general}
    arch=$(uname -m | grep -q "aarch64" && echo "arm" || echo "amd")
    
    # Run container with SSH enabled and history persistence
    docker run --name="cst_${variant}" --rm -d \
    -v $HOME/docker_work/:/persist \
    -p 50022:22 \
    -it tanq16/cst-${variant}:${arch} \
    bash -c "service ssh start; cp /persist/.bash_history /root/.bash_history 2>/dev/null; tail -f /dev/null"
    
    # Generate and set SSH password
    new_pass=$(cat /dev/random | head -c 20 | base64 | tr -d '=+/')
    echo "Password: $new_pass"
    echo $new_pass > $HOME/.cst-pw
    docker exec -e newpp="$new_pass" cst_${variant} bash -c 'echo "root:$(printenv newpp)" | chpasswd'
}

stop_cst() {
    # Gracefully stop container and preserve history
    variant=${1:-general}
    docker cp cst_${variant}:/root/.bash_history $HOME/docker_work/.bash_history 2>/dev/null
    docker stop cst_${variant} -t 0
}

# SSH alias without known host file write
alias sshide='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
```

These functions provide:

- Automatic architecture detection (ARM/AMD)
- The first argument to the `start_cst` function will be the variant name
- Command history is automatically copied on container start and stop to ensure persistence
- SSH server is enabled with access to a random password stored in `$HOME/.cst-pw`
- A default volume in `$HOME/docker_work` is already mounted for persistence

## Enhanced Access Functions

Additional functions can improve container access and management:

```bash
connect_cst() {
    # Direct shell access to running container
    variant=${1:-general}
    docker exec -it cst_${variant} /bin/bash
}

ssh_cst() {
    # SSH into container with dynamic port forwarding
    variant=${1:-general}
    ssh -o "StrictHostKeyChecking=no" \
        -o "UserKnownHostsFile=/dev/null" \
        -D 65500 \
        root@localhost -p 50022
}
```

## Usage Examples

Starting a Cloud variant container with extra port mapping:

```bash
start_cst cloud
```

Accessing the container via SSH with dynamic port forwarding:

```bash
ssh_cst cloud
```

Adding port mapping to a running container:

```bash
connect_cst general
```

## Best Practices

1. **Resource Management**: Create cleanup functions for maintenance
   ```bash
   cleanup_cst() {
       docker ps -a | grep 'cst_' | awk '{print $1}' | xargs docker stop
       docker container prune -f
   }
   ```
2. **Network Security**: Use SSH dynamic port forwarding for securely accessing container-internal services
   ```bash
   sshide -D 65500 root@localhost -p 50022
   ```

3. **Data Persistence**: Structure your persistent storage
   ```
   docker_work/
   ├── projects/
   ├── .bash_history
   ├── configs/
   └── run.sh
   ```
