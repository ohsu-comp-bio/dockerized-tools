#################################################################
# Dockerfile
#
# Version:          1
# Software:         samtools
# Software Version: 1.3.1
# Description:      Tools (written in C using htslib) for manipulating next-generation sequencing data
# Website:          https://github.com/samtools/samtools
# Base Image:       ubuntu 14.04
# Pull Cmd:         docker pull ccc/samtools
# Run Cmd:          docker run ccc/samtools samtools --help
#################################################################
FROM ubuntu:14.04

MAINTAINER Adam Struck <strucka@ohsu.edu>

USER root

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \ 
    curl \
    && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


WORKDIR /tmp/
RUN curl -L -o tmp.tar.gz https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2 && \
    mkdir /tmp/samtools && \
    tar -C /tmp/samtools --strip-components 1 -jxf tmp.tar.gz && \
    cd /tmp/samtools && \
    ./configure && \
    make && \
    make install && \
    cd /tmp/ && \
    rm -rf *

WORKDIR /home/
VOLUME /home/

CMD ["samtools"]
