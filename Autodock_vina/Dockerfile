# Dockerfile for AutoDock Vina Flexible Docking Jupyter Notebook
# Based on Python 3.10 for better cctbx-base compatibility

FROM python:3.11-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Set working directory
WORKDIR /workspace

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    build-essential \
    gcc \
    g++ \
    gfortran \
    libopenblas-dev \
    liblapack-dev \
    libhdf5-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Miniforge (includes mamba and conda with conda-forge as default)
RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O /tmp/miniforge.sh && \
    bash /tmp/miniforge.sh -b -p /opt/conda && \
    rm /tmp/miniforge.sh

# Add conda to path
ENV PATH=/opt/conda/bin:$PATH

# Update conda and mamba
RUN conda update -n base conda mamba -y

# Copy environment.yml file
COPY environment.yml /tmp/environment.yml

# Create conda environment using the environment.yml file
RUN mamba env create -n vina -f /tmp/environment.yml

# Install ProDy from source for numpy 2 compatibility (as per original setup)
RUN cd /tmp && \
    git clone https://github.com/prody/ProDy.git && \
    cd ProDy && \
    /opt/conda/envs/vina/bin/pip install .

# Download AutoDock tools and setup geostd repository
RUN cd /workspace && \
    git clone https://github.com/phenix-project/geostd.git

# Download hydrated docking scripts from AutoDock-Vina repository
RUN cd /tmp && \
    wget https://raw.githubusercontent.com/ccsb-scripps/AutoDock-Vina/develop/example/autodock_scripts/mapwater.py && \
    wget https://raw.githubusercontent.com/ccsb-scripps/AutoDock-Vina/develop/example/autodock_scripts/dry.py && \
    chmod +x mapwater.py dry.py && \
    mv mapwater.py dry.py /opt/conda/envs/vina/bin/

# Copy and setup startup script
COPY start-jupyter.sh /usr/local/bin/start-jupyter.sh
RUN chmod +x /usr/local/bin/start-jupyter.sh

# Copy Jupyter configuration
RUN mkdir -p /root/.jupyter
COPY jupyter_server_config.py /root/.jupyter/jupyter_server_config.py

# Copy the notebook to the workspace
COPY Template_Flexible_Docking.ipynb /workspace/

# Create a directory for data and results
RUN mkdir -p /workspace/data /workspace/results

# Set up the conda environment to be activated by default
RUN echo "source /opt/conda/etc/profile.d/conda.sh && conda activate vina" >> ~/.bashrc

# Expose port for Jupyter
EXPOSE 8888

# Default command
CMD ["/usr/local/bin/start-jupyter.sh"]
