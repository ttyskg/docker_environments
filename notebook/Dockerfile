FROM jupyter/scipy-notebook

LABEL maintainer "ttyskg"

USER root

# Install all OS dependencies
RUN apt-get update && apt-get install -yq --no-install-recommends \
    vim \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Setting dotfiles
RUN git clone --recursive https://github.com/ttyskg/dotfiles /home/$NB_USER/dotfiles && \
    /home/$NB_USER/dotfiles/setup.sh

# Install Cloud Storage FUSE
RUN export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s` && \
    echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
    sudo apt-get update && \
    sudo apt-get install gcsfuse

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
