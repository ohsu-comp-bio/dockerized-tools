#################################################################
# Dockerfile
#
# Version:          1
# Software:         bedtools
# Software Version: 2.26.0
# Description:      The bedtools utilities are a swiss-army knife of tools for 
#                   a wide-range of genomics analysis tasks. The most widely-used
#                   tools enable genome arithmetic: that is, set theory on the genome.
# Website:          https://github.com/arq5x/bedtools
# Base Image:       ubuntu 14.04
# Pull Cmd:         docker pull ccc/bedtools
# Run Cmd:          docker run ccc/bedtools bedtools --help
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
    python \
    && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


WORKDIR /tmp/
RUN curl -L -o tmp.tar.gz https://github.com/arq5x/bedtools2/releases/download/v2.26.0/bedtools-2.26.0.tar.gz && \
    mkdir /tmp/bedtools && \
    tar -C /tmp/bedtools --strip-components 1 -zxf tmp.tar.gz && \
    cd /tmp/bedtools && \
    make && \
    make install && \
    cd /tmp/ && \
    rm -rf *

WORKDIR /home/
VOLUME /home/

CMD ["bedtools"]
