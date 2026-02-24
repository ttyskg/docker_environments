# Troubleshooting: Running Scripts in Conda Virtual Environments within Docker Containers

## Problem

When running scripts inside a Docker container from outside (using `docker-compose exec`), conda virtual environments may not be activated, causing "command not found" errors even though the commands work when accessing the container interactively.

## Root Cause

The issue stems from the difference between **interactive** and **non-interactive** shells:

### Interactive Shell
```bash
docker-compose exec <container> bash
# This starts an INTERACTIVE shell that sources ~/.bashrc
# Result: Conda environment is activated ✅
```

### Non-Interactive Shell
```bash
docker-compose exec <container> bash ./script.sh
# This starts a NON-INTERACTIVE shell that does NOT source ~/.bashrc
# Result: Conda environment is NOT activated ❌
```

## Shell Initialization Behavior

| File | Interactive Shell | Non-Interactive Shell | Scope |
|------|------------------|----------------------|-------|
| `~/.bashrc` | ✅ Sourced | ❌ NOT sourced | User-specific |
| `/etc/bash.bashrc` | ✅ Sourced (but has early return for non-interactive) | ⚠️ Partially sourced | System-wide |
| `/etc/profile.d/*.sh` | ✅ Sourced (login shells only) | ❌ NOT sourced | System-wide |

**Key insight**: Even `/etc/bash.bashrc` contains this guard at the top:
```bash
# If not running interactively, don't do anything
[ -z "${PS1-}" ] && return
```
This prevents any subsequent commands from running in non-interactive shells.

## Solutions

### Solution 1: Self-Activating Scripts (Recommended)

Add environment activation logic directly in your shell scripts:

```bash
#!/usr/bin/bash

# Activate conda environment if not already activated
if [ "$CONDA_DEFAULT_ENV" != "your_env_name" ]; then
    source /opt/conda/etc/profile.d/conda.sh
    conda activate your_env_name
fi

# Rest of your script...
```

**Advantages:**
- ✅ Scripts are self-contained and portable
- ✅ Works from anywhere (Docker, local machine, CI/CD)
- ✅ Explicit dependencies
- ✅ No conflicts with already-activated environments

**Implementation in Dockerfile:**
```dockerfile
# Keep activation for interactive shells (good UX)
RUN echo "source /opt/conda/etc/profile.d/conda.sh && conda activate your_env" >> ~/.bashrc
```

### Solution 2: Use `conda run` Wrapper

Execute scripts through conda's built-in wrapper:

```bash
docker-compose exec <container> bash -c "conda run -n your_env bash ./script.sh"
```

**Advantages:**
- ✅ No script modification needed
- ✅ Clean and explicit

**Disadvantages:**
- ❌ Verbose command
- ❌ Requires remembering the wrapper syntax

### Solution 3: Source Conda Activation in Command

Activate the environment inline:

```bash
docker-compose exec <container> bash -c "source /opt/conda/etc/profile.d/conda.sh && conda activate your_env && bash ./script.sh"
```

**Advantages:**
- ✅ No script modification needed

**Disadvantages:**
- ❌ Very verbose
- ❌ Error-prone

### Solution 4: Use `BASH_ENV` Environment Variable

Set `BASH_ENV` to a script that activates the environment:

```dockerfile
ENV BASH_ENV=/etc/profile.d/conda-activate.sh
RUN echo "source /opt/conda/etc/profile.d/conda.sh && conda activate your_env" > /etc/profile.d/conda-activate.sh && \
    chmod +x /etc/profile.d/conda-activate.sh
```

**Advantages:**
- ✅ Automatic activation for non-interactive shells
- ✅ No script modification needed

**Disadvantages:**
- ❌ Applies globally to all bash invocations
- ❌ May cause unexpected behavior in some scenarios

## Recommended Approach

**Combine Solution 1 with interactive shell activation:**

1. **In Dockerfile**: Activate conda for interactive shells (good UX)
```dockerfile
RUN echo "source /opt/conda/etc/profile.d/conda.sh && conda activate your_env" >> ~/.bashrc
```

2. **In scripts**: Add self-activation logic
```bash
if [ "$CONDA_DEFAULT_ENV" != "your_env_name" ]; then
    source /opt/conda/etc/profile.d/conda.sh
    conda activate your_env_name
fi
```

This provides the **best of both worlds**:
- Interactive users get the environment automatically
- Scripts are self-contained and portable
- No conflicts (script checks before activating)

## Verification Commands

```bash
# Check current user and PATH from outside container
docker-compose exec <container> bash -c "whoami && echo \$PATH"

# Check if conda environment is activated
docker-compose exec <container> bash -c "echo \$CONDA_DEFAULT_ENV"

# Check available conda environments
docker-compose exec <container> bash -c "conda info --envs"

# Test interactive shell
docker-compose exec <container> bash
# Inside: echo $CONDA_DEFAULT_ENV
```

## Common Mistakes to Avoid

1. ❌ **Adding activation to `/etc/bash.bashrc`**: Won't work due to the early return for non-interactive shells
2. ❌ **Adding activation to `/etc/profile.d/` without `BASH_ENV`**: Only works for login shells
3. ❌ **Assuming `~/.bashrc` is always sourced**: Only works for interactive shells
4. ❌ **Not making activation scripts executable**: Will fail silently

## Summary

When working with conda environments in Docker containers:
- Understand the difference between interactive and non-interactive shell execution
- Use self-activating scripts for maximum portability and reliability
- Keep interactive shell activation in Dockerfile for better user experience
- Always test both interactive and non-interactive execution modes

## Related Issues

- Shell startup file execution order
- Docker `exec` vs `run` behavior
- Conda initialization in different shell contexts
- Environment variable inheritance in Docker
