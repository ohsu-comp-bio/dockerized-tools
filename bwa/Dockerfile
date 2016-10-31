#################################################################
# Dockerfile
#
# Software:         BWA
# Software Version: 0.7.15
# Description:      Burrow-Wheeler Aligner for pairwise alignment between DNA sequences
# Website:          https://github.com/lh3/bwa
# Base Image:       ubuntu 14.04
# Run Cmd:          docker run bwa bwa mem [options...]
#################################################################
FROM ubuntu:14.04

MAINTAINER Adam Struck <strucka@ohsu.edu>

USER root

# Install compiler and other dependencies
RUN apt-get update && \
    apt-get install --yes \
    build-essential \
    zlib1g-dev \
    curl \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tmp/
# install bwa
RUN curl -ksSL -o tmp.tar.gz --retry 10 https://github.com/lh3/bwa/archive/v0.7.15.tar.gz && \
    tar --strip-components 1 -zxf tmp.tar.gz && \
    make  && \
    mv bwa /usr/local/bin/ && \
    rm -rf *

WORKDIR /home/
VOLUME /home/

CMD ["bwa"]
