# SSH and TMUX Advanced Usage

SSH and TMUX integration in CST provides a powerful environment for remote work and session management. This guide covers advanced usage patterns and configurations.

## SSH Configuration

### Dynamic Port Forwarding

SSH dynamic port forwarding creates a SOCKS proxy for flexible access to container services:

```bash
ssh -D 65500 root@localhost -p 50022
```

This enables:
- Browser proxy configuration
- Tool traffic routing
- Service access through proxy

### Advanced SSH Configuration

Create a dedicated SSH config for CST connections:

```bash
# ~/.ssh/config
Host cst-*
    User root
    Port 50022
    HostName localhost
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    DynamicForward 65500
```

Usage becomes as simple as:

```bash
ssh cst-general
```

## TMUX Advanced Usage

### Session Management

CST's TMUX configuration provides enhanced session management:

1. **Named Sessions**
   ```bash
   # Create new named session
   tmux new -s security
   
   # Attach to existing session
   tmux attach -t security
   ```

2. **Workspace Organization**
   ```bash
   # Create development workspace
   tmux new -s dev -n 'code' \; \
       send-keys 'cd /persist/projects' C-m \; \
       split-window -h \; \
       send-keys 'htop' C-m \; \
       new-window -n 'logs' \; \
       send-keys 'tail -f /var/log/auth.log' C-m
   ```

### Custom Configurations

The Rice variant includes an enhanced TMUX configuration. Create custom layouts:

```bash
# ~/.tmux.conf
# Security assessment layout
bind S source-file ~/.tmux/layouts/security

# ~/.tmux/layouts/security
split-window -v
select-pane -t 1
split-window -h
select-pane -t 0
send-keys 'nmap -v' C-m
select-pane -t 1
send-keys 'tail -f /var/log/auth.log' C-m
select-pane -t 2
send-keys 'htop' C-m
```

## Integration Patterns

### SSH + TMUX Workflow

1. **Persistent Sessions**
   ```bash
   # Start container
   start_cst rice
   
   # Connect and create session
   ssh cst-rice -t tmux new -s work
   ```

2. **Session Sharing**
   ```bash
   # Allow multiple clients
   tmux set-option -g allow-clients
   
   # Connect additional shell
   ssh cst-rice -t tmux attach -t work
   ```

### Advanced Use Cases

1. **Development Environment**
   ```bash
   tmux new-session -s dev \; \
       send-keys 'cd /persist/projects' C-m \; \
       split-window -h \; \
       send-keys 'docker stats' C-m \; \
       split-window -v \; \
       send-keys 'tail -f logs/*.log' C-m
   ```

2. **Monitoring Setup**
   ```bash
   tmux new-session -s monitor \; \
       send-keys 'htop' C-m \; \
       split-window -h \; \
       send-keys 'watch docker ps' C-m \; \
       split-window -v \; \
       send-keys 'tail -f /var/log/*' C-m
   ```

## Best Practices

- **Session Naming:** Use consistent naming conventions
   - `dev-*` for development sessions
   - `sec-*` for security assessment
   - `mon-*` for monitoring

- **Window Management:** Organize windows by function
   - Main workspace window
   - Monitoring window
   - Log window
   - Tool-specific windows

- **Pane Layout:** Design efficient layouts
   - Command input at top
   - Logs at bottom
   - Monitoring on side
   - Status in corner

- **Key Bindings:** Configure task-specific bindings
   ```bash
   # ~/.tmux.conf
   bind-key M-s source-file ~/.tmux/layouts/security
   bind-key M-d source-file ~/.tmux/layouts/development
   bind-key M-m source-file ~/.tmux/layouts/monitoring
   ```
