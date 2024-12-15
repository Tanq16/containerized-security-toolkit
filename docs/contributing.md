# Contributing to CST

Thank you for your interest in contributing to the Containerized Security Toolkit! This document provides guidelines for contributing to the project.

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR-USERNAME/containerized-security-toolkit
   ```
3. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Environment

1. Install prerequisites: Docker & Docker Buildx (if working cross-platform)
2. Install documentation dependencies:
   ```bash
   pip install mkdocs-material
   ```

## Building Images

To build images locally:

```bash
# For x86_64 or ARM64 systems
cd images/$VARIANT
docker build -f builder.Dockerfile -t intermediate_builder .
docker build -t cst-<variant>:local .
```

To build ARM64 on x86_64 systems, use:

```bash
# For ARM64 on x86_64 systems
docker buildx build --platform linux/arm64 -f builder.Dockerfile -t intermediate_builder .
docker buildx build --platform linux/arm64 -t cst-<variant>:local .
```

## Project Structure

```
.
├── docs/              # Documentation
├── images/            # Dockerfile for each variant
│   ├── general/
│   ├── cloud/
│   ├── dev/
│   ├── netsec/
│   └── rice/
└── scripts/           # Build and utility scripts
```

## Coding Guidelines

- **Dockerfiles**
      - Use multi-stage builds
      - `builder.Dockerfile` should contain `go` installs and release downloads
      - Document non-obvious commands
      - Follow best practices for size optimization

- **Documentation**
      - Use clear, concise language
      - Prefer short and bulleted information
      - Keep formatting consistent
      - Update relevant sections only

- **Scripts**
      - Add usage comments where applicable
      - Name them `<variant>-<action>.sh`

## Pull Request Process

1. Update documentation for new features
2. Create succint PR description
3. Link relevant issues (if any)

Before submitting the PR:

1. Build images locally
2. Test basic functionality
3. Verify installed tools work
4. Add examples to documentation if appropriate
5. Explicitly state any breaking changes in PR

## Questions?

- Open an issue
- Check documentation

## License

Your contributions will be licensed under the MIT License.
