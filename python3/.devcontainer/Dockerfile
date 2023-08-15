FROM python:3.11.4

# create non-root user
RUN groupadd -r docker \
    && useradd -r -g docker -s /bin/bash -m docker

# Install requried packages
RUN apt-get update\
    && apt-get install -y --no-install-recommends \
	git \
    make \
	&& rm -rf /var/lib/apt/lists/*

# Setup working directory
WORKDIR /tmp/work

COPY requirements.txt ${PWD}

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# add Python path of my library
ENV PYTHONPATH "${PYTHONPATH}:/tmp/work/mylib"

# set non root user
USER docker
