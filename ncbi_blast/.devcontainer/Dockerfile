FROM python:3.9.6

RUN apt-get update\
    && apt-get install -y\
    git \
    && rm -rf /var/lib/apt/lists/*

# Install NCBI BLAST+
ENV BLAST_VERSION 2.12.0

WORKDIR /tmp/bin

RUN wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${BLAST_VERSION}/ncbi-blast-${BLAST_VERSION}+-x64-linux.tar.gz \
 && tar -zxvf ncbi-blast-${BLAST_VERSION}+-x64-linux.tar.gz \
 && rm ncbi-blast-${BLAST_VERSION}+-x64-linux.tar.gz

ENV PATH $PATH:/tmp/bin/ncbi-blast-${BLAST_VERSION}+/bin

# Setup working directory
WORKDIR /tmp/work

COPY requirements.txt ${PWD}

RUN python -m pip install --upgrade pip \
    && pip install -r requirements.txt
