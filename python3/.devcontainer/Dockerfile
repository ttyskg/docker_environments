FROM python:3.12.4

# create non-root user
RUN groupadd -r docker \
    && useradd -r -g docker -s /bin/bash -m docker

# Install required packages
RUN apt-get update\
    && apt-get install -y --no-install-recommends \
    git \
    make \
    msmtp \
    msmtp-mta \
    && rm -rf /var/lib/apt/lists/*

# Setup working directory
WORKDIR /tmp/work

COPY requirements.txt ${PWD}

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Add Python path of my library
ENV PYTHONPATH "${PYTHONPATH}:/tmp/work/mylib"

# Setup matplotlibrc
ENV MPLCONFIGDIR=/tmp/work/.devcontainer

# set non root user
USER docker
