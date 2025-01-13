# Example Workflow

This document details the workflow I use on a daily basis, which can be seen as a general example.

First, the initial functions are similar to the ones mentioned in the [shortcuts](./shortcuts.md); however, includes more arbitrary arguments:

```bash
start_cst() {
    arch=$(uname -m | grep -q "aarch64" && echo "arm" || echo "amd")

    docker run --name="cst" --rm -d \
    -v $HOME/docker_work/:/persist \
    -p 50022:22 $@ \
    -it tanq16/cst-rice:${arch} \
    zsh -c "service ssh start; cp /persist/.bash_history /root/.bash_history 2>/dev/null; tail -f /dev/null"

    new_pass=$(cat /dev/random | head -c 20 | base64 | tr -d '=+/')
    echo "Password: $new_pass"
    echo $new_pass > $HOME/.cst-pw
    docker exec -e newpp="$new_pass" cst bash -c 'echo "root:$(printenv newpp)" | chpasswd'
}

stop_cst() {
    variant=${1:-general}
    docker cp cst:/root/.bash_history $HOME/docker_work/.bash_history 2>/dev/null
    docker stop cst -t 0
}
```

- Additional parameters are possible due to `$@`
- Additional arguments can basically be things like new port mappings or volume mounts, etc.

Example execution:

```bash
start_cst -v "/Users/tanq16/Repositories/WORKREPO":/work -p 6767:6767
sshide -D 65500 root@localhost -p 50022
# Execute inside the container
export TERM=xterm-256color && \
echo "America/Chicago" > /etc/timezone && rm -rf /etc/localtime && \
ln -s "/usr/share/zoneinfo/$(cat /etc/timezone)" /etc/localtime
```
