FROM python:3.11.4

# create non-root user
RUN groupadd -r docker \
    && useradd -r -g docker -s /bin/bash -m docker

# Add R repository
RUN gpg --keyserver keyserver.ubuntu.com \
    --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' \
    && gpg --armor --export '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' | \
    tee /etc/apt/trusted.gpg.d/cran_debian_key.asc

RUN apt-get update\
    && apt-get install -y --no-install-recommends \
    git \
    make \
    r-base \
    r-base-dev \
    && rm -rf /var/lib/apt/lists/*

# Setup working directory
WORKDIR /tmp/work

COPY requirements.txt ${PWD}
COPY requirements.r ${PWD}

RUN python -m pip install --upgrade pip \
    && pip install -r requirements.txt
    # && R -e "source('./requirements.r')"

# add Python path of my library
ENV PYTHONPATH "${PYTHONPATH}:/tmp/work/mylib"

# set non root user
USER docker
