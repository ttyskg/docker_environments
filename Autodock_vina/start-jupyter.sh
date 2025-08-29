#!/bin/bash

# AutoDock Vina Jupyter Lab startup script
# Activates conda environment and starts Jupyter Lab

# Source conda
source /opt/conda/etc/profile.d/conda.sh

# Activate the vina environment
conda activate vina

# Set bash as the default shell for Jupyter terminals
export SHELL=/bin/bash

# Start Jupyter Lab
exec jupyter lab \
    --ip=0.0.0.0 \
    --port=8888 \
    --no-browser \
    --allow-root \
    --notebook-dir=/workspace \
    --ServerApp.token='' \
    --ServerApp.password='' \
    --ServerApp.allow_origin='*' \
    --ServerApp.disable_check_xsrf=True
