FROM jupyter/scipy-notebook

LABEL maintainer "ttyskg"

USER root

# Install all OS dependencies
RUN apt-get update && apt-get install -yq --no-install-recommends \
    vim \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Setting dotfiles
RUN git clone --recursive https://github.com/ttyskg/dotfiles && \
    ~/dotfiles/setup.sh && \
    source .bashrc

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
