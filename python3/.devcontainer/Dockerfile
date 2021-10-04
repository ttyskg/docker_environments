FROM python:3.9.7

# specify user
ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} docker
RUN useradd -u ${UID} -g ${GID} -s /bin/bash -m docker

RUN apt-get update\
    && apt-get install -y\
	git \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/work

COPY requirements.txt ${PWD}

RUN python -m pip install --upgrade pip \
    && pip install -r requirements.txt

# set non root user
USER ${UID}
