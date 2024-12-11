# Shell Shortcuts and Functions

The CST environment can be enhanced with shell functions that streamline container management and daily operations. These functions provide a seamless workflow for starting, accessing, and managing CST containers.

## Core Container Management

The following shell functions handle container lifecycle management. Add these to your shell's RC file (`.bashrc`, `.zshrc`, etc.):

```bash
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
    echo $new_pass > current_docker_password
    docker exec -e newpp="$new_pass" cst_${variant} bash -c 'echo "root:$(printenv newpp)" | chpasswd'
}

stop_cst() {
    # Gracefully stop container and preserve history
    variant=${1:-general}
    docker cp cst_${variant}:/root/.bash_history $HOME/docker_work/.bash_history 2>/dev/null
    docker stop cst_${variant} -t 0
}
```

These functions provide:
- Automatic architecture detection (ARM/AMD)
- Command history persistence
- SSH access with random password generation
- Flexible port mapping
- Volume mounting for persistence

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

port_cst() {
    # Add port mapping to running container
    variant=${1:-general}
    host_port=$2
    container_port=$3
    docker exec cst_${variant} \
    iptables -t nat -A DOCKER -p tcp --dport $container_port -j DNAT --to-destination :$host_port
}
```

## Usage Examples

Starting a Cloud variant container with extra port mapping:

```bash
start_cst cloud -p 50080:80 -p 50443:443
```

Accessing the container via SSH with dynamic port forwarding:

```bash
ssh_cst cloud
```

Adding port mapping to a running container:

```bash
port_cst general 8080 80
```

## Advanced Configuration Tips

### Persistent Configurations

Create a `.cst_config` file in your home directory:

```bash
# ~/.cst_config
CST_PERSIST_DIR="$HOME/docker_work"
CST_DEFAULT_PORTS="-p 50080:80 -p 50443:443"
CST_EXTRA_MOUNTS="-v $HOME/.aws:/root/.aws"

# Source this in your shell RC file
if [ -f ~/.cst_config ]; then
    source ~/.cst_config
fi
```

### Shell Function Enhancements

Extended start function with configurations:

```bash
start_cst_enhanced() {
    variant=${1:-general}
    docker run --name="cst_${variant}" --rm -d \
    -v "${CST_PERSIST_DIR:-$HOME/docker_work}":/persist \
    -p 50022:22 \
    ${CST_DEFAULT_PORTS} \
    ${CST_EXTRA_MOUNTS} \
    ${@:2} \
    -it tanq16/cst-${variant}:${arch} \
    bash -c "service ssh start && tail -f /dev/null"
}
```

## Best Practices

1. **Resource Management**
   Create cleanup functions for maintenance:
   ```bash
   cleanup_cst() {
       docker ps -a | grep 'cst_' | awk '{print $1}' | xargs docker stop
       docker container prune -f
   }
   ```

2. **Development Workflow**
   Mount development directories:
   ```bash
   start_cst dev \
   -v ~/projects:/persist/projects \
   -v ~/.gitconfig:/root/.gitconfig
   ```

3. **Network Security**
   Use SSH dynamic port forwarding for securely accessing container-internal services:
   ```bash
   ssh -D 65500 root@localhost -p 50022
   ```

4. **Data Persistence**
   Structure your persistent storage:
   ```
   docker_work/
   ├── projects/
   ├── .aws/
   ├── .bash_history
   └── configs/
   ```
