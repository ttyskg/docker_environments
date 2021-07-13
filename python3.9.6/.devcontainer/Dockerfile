FROM python:3.9.6

RUN apt-get update\
    && apt-get install -y\
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/work

COPY requirements.txt ${PWD}

RUN python -m pip install --upgrade pip \
    && pip install -r requirements.txt
