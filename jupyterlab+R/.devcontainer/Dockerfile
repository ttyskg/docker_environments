FROM python:3.9.5

# Add R repository
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key '0xE19F5F87128899B192B1A2C2AD5F960A256A04AF'\
    && echo "deb http://cloud.r-project.org/bin/linux/debian buster-cran40/" > /etc/apt/sources.list.d/r.list

RUN apt-get update\
    && apt-get install -y\
    git \
    r-base \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/work

COPY requirements.txt ${PWD}
COPY requirements.r ${PWD}

RUN python -m pip install --upgrade pip \
    && pip install -r requirements.txt \
    && R -e "source('./requirements.r')"
