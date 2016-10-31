#################################################################
# Dockerfile
#
# Software:         oncotator
# Software Version: 1.9.0.0
# Description:      Oncotator is an application for annotating human 
#                   genomic point mutations and indels with data relevant 
#                   to cancer researchers.
# Website:          https://github.com/broadinstitute/oncotator
# Base Image:       python:2.7.9
# Run Cmd:          docker run oncotator oncotator -h
#################################################################
FROM python:2.7.9

MAINTAINER Adam Struck <strucka@ohsu.edu>

RUN apt-get update && \
    apt-get install -y \
    unzip \ 
    curl \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install -U pip setuptools

WORKDIR /tmp/
RUN curl -L -o tmp.tar.gz https://github.com/broadinstitute/oncotator/archive/v1.9.0.0.tar.gz && \
    mkdir oncotator && \
    tar -C oncotator --strip-components=1 -xzf tmp.tar.gz && \
    cd oncotator && \
    python setup.py install && \
    cd /tmp/ && \
    rm -rf *

RUN pip install --no-binary :all: ngslib==1.1.18

WORKDIR /home/
VOLUME /home/

CMD ["oncotator"]
