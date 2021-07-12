FROM python:3.9.5

RUN apt-get update\
    && apt-get install -y\
    git \
    r-base \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/work

COPY requirements.txt ${PWD}
COPY requirements.r ${PWD}

RUN python -m pip install --upgrade pip\
    && pip install -r requirements.txt \
    && R -e "source('./requirements.r')"
