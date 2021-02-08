FROM debian:stable-20210111-slim

# Install sra-tools
RUN apt-get update && apt-get install -y \
    curl \
    # requred for samtools
    autoconf \
    automake \
    make \
    gcc \
    perl \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-gnutls-dev \
    libssl-dev \
    libncurses5-dev \
    wget \
    # required for sra-tools
    libxml-libxml-perl \
    # required for Bowtie2
    python3 \
    unzip \
    # required for TopHat
    python \
 && rm -rf /var/lib/apt/lists/*

# Locale setting
ENV LANG C.UTF-8

# Install SRA-Tools
WORKDIR /tmp
RUN curl https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.10.9/sratoolkit.2.10.9-centos_linux64-cloud.tar.gz | tar xz -C / 
ENV PATH $PATH:/usr/local/ncbi/sra-tools/bin

# Install samtools
ENV SAMTOOLS_VERSION 1.11
ENV SAMTOOLS_INSTALL_DIR=/usr/local/samtools

WORKDIR /tmp
RUN wget https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2 \
 && tar --bzip2 -xf samtools-${SAMTOOLS_VERSION}.tar.bz2 \
 && rm samtools-${SAMTOOLS_VERSION}.tar.bz2

WORKDIR /tmp/samtools-${SAMTOOLS_VERSION}
RUN ./configure --prefix=${SAMTOOLS_INSTALL_DIR} \
 && make \
 && make install \
 && cd .. \
 && rm -rf /tmp/samtools-${SAMTOOLS_VERSION}

ENV PATH $PATH:/usr/local/samtools/bin

# Install Bowtie2
ENV BOWTIE2_VERSION 2.4.2

WORKDIR /usr/local
RUN wget https://github.com/BenLangmead/bowtie2/releases/download/v${BOWTIE2_VERSION}/bowtie2-${BOWTIE2_VERSION}-linux-x86_64.zip \
 && unzip bowtie2-${BOWTIE2_VERSION}-linux-x86_64.zip \
 && rm bowtie2-${BOWTIE2_VERSION}-linux-x86_64.zip
ENV PATH $PATH:/usr/local/bowtie2-${BOWTIE2_VERSION}-linux-x86_64

# Install TopHat
ENV TOPHAT_VERSION 2.1.1

WORKDIR /usr/local
RUN wget https://ccb.jhu.edu/software/tophat/downloads/tophat-${TOPHAT_VERSION}.Linux_x86_64.tar.gz \
 && tar -zxvf tophat-${TOPHAT_VERSION}.Linux_x86_64.tar.gz \
 && rm tophat-${TOPHAT_VERSION}.Linux_x86_64.tar.gz \
 && ln -s /usr/local/tophat-${TOPHAT_VERSION}.Linux_x86_64/tophat2 /usr/bin/

WORKDIR /tmp/work
