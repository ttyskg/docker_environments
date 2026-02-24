# AutoDock Vina Docker Environment

This Docker environment provides a complete setup for running AutoDock Vina flexible docking experiments using Jupyter Lab with Python 3.11.

## What's Included

- **Python 3.11** (for optimal cctbx-base compatibility)
- **Jupyter Lab** with widgets support and bash terminals
- **AutoDock Vina** and AutoGrid tools
- **RDKit** for cheminformatics
- **ProDy** for protein structure analysis
- **py3Dmol** for molecular visualization
- **Meeko** for molecular preparation
- **Molscrub** for molecular cleanup
- **All necessary scientific computing libraries** (numpy, scipy, pandas, etc.)

## Prerequisites

Ensure you have Docker and Docker Compose installed:

```bash
# Check installations
docker --version
docker-compose --version
```

## Quick Start Commands

### 🏗️ Build the Environment

```bash
docker-compose build
```

### 🚀 Start the Environment

```bash
# Build and start in one command
docker-compose up --build -d

# Or start existing environment
docker-compose up -d
```

### 📖 Access Jupyter Lab

1. **Open your browser:** `http://localhost:8888`
2. **No token required** (configured for Docker development)

### 🔍 View Logs

```bash
# View all logs
docker-compose logs autodock-vina

# Follow logs in real-time
docker-compose logs -f autodock-vina
```

### 🐚 Access Container Shell

```bash
# Interactive bash shell (recommended)
docker-compose exec autodock-vina bash

# Alternative: docker exec
docker exec -it autodock-vina-jupyter bash

# Activate conda environment inside container
conda activate vina
```

### 🛑 Stop the Environment

```bash
# Stop containers
docker-compose stop

# Stop and remove containers
docker-compose down
```

### 🔄 Restart the Environment

```bash
docker-compose restart
```

### 🧹 Clean Up Everything

```bash
# Remove containers, images, and volumes
docker-compose down --rmi all --volumes --remove-orphans

# Clean up Docker system (be careful!)
docker system prune -a --volumes
```

## Container Management

### Check Container Status

```bash
# List running containers
docker ps

# List all containers
docker ps -a

# Check container resource usage
docker stats autodock-vina-jupyter
```

### Multiple Shell Sessions

```bash
# Terminal 1
docker-compose exec autodock-vina bash

# Terminal 2 (separate session)
docker-compose exec autodock-vina bash
```

## Directory Structure

```
Autodock_vina/
├── Dockerfile                            # Docker image definition
├── docker-compose.yml                    # Docker Compose configuration
├── environment.yml                       # Conda environment specification
├── start-jupyter.sh                      # Jupyter startup script
├── jupyter_server_config.py              # Jupyter configuration
├── Vina_RTD_02_Flexible_Docking.ipynb    # Main notebook
├── Template_Flexible_Docking.ipynb       # Template notebook
├── data/                                 # Input data directory
├── results/                              # Output results directory
└── README.md                             # This file
```

## Environment Details

### Software Versions

- **Base:** Python 3.11-slim
- **Package Manager:** Mamba (faster than conda)
- **AutoDock Vina:** Latest from conda-forge
- **RDKit:** Latest from conda-forge
- **Meeko:** 0.6.1 (pinned for stability)
- **cctbx-base:** 2024.8 (pinned for stability)
- **ProDy:** Latest from GitHub (numpy 2 compatibility)

### Pre-configured Environment Variables

- **`MMTBX_CCP4_MONOMER_LIB`:** `/workspace/geostd` (for reduce2 compatibility)
- **`SHELL`:** `/bin/bash` (bash terminals in Jupyter)

### Volume Mounts

- `./data` → `/workspace/data` (input files)
- `./results` → `/workspace/results` (output files)
- `./src` → `/workspace/src` (script files)
- `.` → `/workspace/host` (access to all project files)

## Non-Root User Setup

The Docker container runs as a **non-root user** (`docker`) for improved security and proper file ownership handling.

### How It Works

- **Inside container:** The `docker` user (UID 1000) executes scripts and creates files
- **On host system:** Output files appear to be owned by your host user (e.g., `ttyskg`)
- **Why?** Both the container's `docker` user and your host user share the same UID (1000)

This means:
- ✅ **No more root-owned files** created by container processes
- ✅ **Automatic ownership mapping** - files created by the container are readable/writable by your host user
- ✅ **Better security** - container processes don't run as root

### Verification

Check file ownership with numeric UIDs to confirm non-root ownership:

```bash
# Shows UID:GID instead of user names
ls -in results/2026-02-19_hHRH3/data/ligands/

# Output: files owned by 1000:1000 (the docker user inside container)
# Displayed as your username on host (same UID)
```

### Configuration Details

**Modified files:**
- `Dockerfile` - Creates `docker` user, changes `/workspace` ownership, adds `USER docker` directive
- `docker-compose.yml` - Specifies `user: "docker"` for container execution
- `start-jupyter.sh` - Removed `--allow-root` flag (not needed with non-root user)

## Using the Notebook

### 1. Start Environment

```bash
docker-compose up --build -d
```

### 2. Open Jupyter Lab

Navigate to: `http://localhost:8888`

### 3. Notebook Usage

- **Skip cells 1-2:** (condacolab setup - not needed in Docker)
- **Start from imports:** All dependencies are pre-installed
- **Use added helper cells:** Script location and CRYST1 handling

## Troubleshooting

### Jupyter Access Issues

```bash
# Check if container is running
docker ps

# View Jupyter logs
docker-compose logs autodock-vina

# Restart if needed
docker-compose restart
```

### Permission Issues

```bash
# Fix file permissions (if needed)
sudo chown -R $USER:$USER ./data ./results
```

### Port Conflicts

```bash
# Check what's using port 8888
sudo lsof -i :8888

# Use different port in docker-compose.yml
# ports: ["8889:8888"]  # Access via localhost:8889
```

### Memory/Performance Issues

```bash
# Check container resource usage
docker stats autodock-vina-jupyter

# Increase Docker memory limit in Docker Desktop settings
```

## Development Workflow

### Making Changes to Environment

1. **Edit `environment.yml`** for package changes
2. **Edit `Dockerfile`** for system-level changes
3. **Rebuild:** `docker-compose build`
4. **Restart:** `docker-compose up -d`

### Adding Custom Scripts

1. **Add script to project directory**
2. **Copy in Dockerfile:** `COPY script.sh /workspace/`
3. **Rebuild container**

### Debugging

```bash
# Interactive debugging session
docker-compose exec autodock-vina bash
conda activate vina
python -c "import rdkit; print(rdkit.__version__)"

# Check installed packages
conda list

# Test specific functionality
python -c "import py3Dmol; print('py3Dmol works!')"
```

## Common Commands Reference

| Action | Command |
|--------|---------|
| **Build** | `docker-compose build` |
| **Start** | `docker-compose up -d` |
| **Stop** | `docker-compose down` |
| **Logs** | `docker-compose logs -f autodock-vina` |
| **Shell** | `docker-compose exec autodock-vina bash` |
| **Restart** | `docker-compose restart` |
| **Clean** | `docker-compose down --rmi all --volumes` |

## License

This Docker environment setup is provided as-is for educational and research purposes. Please refer to individual software licenses for their respective terms.
