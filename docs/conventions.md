# CST Conventions

This document outlines the standard conventions used across all CST variants.

## Directory Structure

```
/
├── opt/
│   ├── executables/    # Binary tools and utilities
│   └── pyenv/          # Python virtual environment
├── persist/            # Mount point for persistent storage
└── root/               # User home directory
```

## Port Mapping Conventions

When exposing ports from the container, follow these conventions:

- SSH: `50022` (host) → `22` (container)
- HTTP: `50080` (host) → `80` (container)
- HTTPS: `50443` (host) → `443` (container)
- Dynamic Ports: Start at `50000` + original port
- Dynamic Port Forward: always use `65500`

These conventions are generally only needed if you're adding new port publish arguments using the `-p` flag to the start command. Otherwise, it's easiest to use SSH dynamic port forwarding. Refer to the [example workflow](advanced/workflow.md) for more details.

## Environment Variables

Standard environment details used across variants:

- `TERM=xterm-256color` (set this manually if not the case on launch)
- Python environment at `/opt/pyenv/`
- `PATH` includes `/opt/executables`

## Tool Installation Locations

- Binary tools: `/opt/executables/`
- Python packages: `/opt/pyenv/`
- Binaries: `/usr/bin/` & `/usr/local/bin/`

## Persistent Storage

- Mount point: `/persist/`
- Recommended host location: `$HOME/docker_work/`
- Used for:
      - Project files
      - Configuration files
      - Shell history
      - Tool configurations

## SSH Configuration

- Root login enabled for convenience
- Password authentication enabled
- Dynamic port forwarding supported
- Custom port (`50022`) to avoid conflicts

## Best Practices

- **Data Persistence**
      - Store important data in `/persist/`
      - Use version control for project files
      - Back up configurations regularly

- **Resource Management**
      - Clean up unused containers
      - Prune Docker images periodically
      - Monitor disk space usage

- **Security**
      - Change SSH password for every run
      - Use SSH keys when possible
      - Keep host directory permissions restrictive

- **Workflow**
      - Use shell functions for container management
      - Maintain separate instances for different projects
      - Document custom configurations

## Version Control

- Image versions only represent build time
- Tools are always installed to their latest versions, unless necessary for error fixes
- Base image: Ubuntu Jammy (22.04 LTS)
- Updates follow semantic versioning
