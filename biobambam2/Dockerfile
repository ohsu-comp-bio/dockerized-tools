#################################################################
# Dockerfile
#
# Software:         biobambam2
# Software Version: 2.0.50
# Description:      This package contains some tools for processing BAM files
# Website:          https://github.com/gt1/biobambam2
# Base Image:       ubuntu 14.04
# Run Cmd:          docker run biobambam2 [biobambam2 cmd] [options...]
#################################################################
FROM ubuntu:14.04

MAINTAINER Adam Struck <strucka@ohsu.edu>

USER root

RUN apt-get update && apt-get install -y \
    build-essential \
    tar \
    gzip \
    curl \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install biobambam2 - 2.0.50
WORKDIR /tmp/
RUN curl -ksSL -o tmp.tar.gz --retry 10 https://github.com/gt1/biobambam2/releases/download/2.0.50-release-20160705161609/biobambam2-2.0.50-release-20160705161609-x86_64-etch-linux-gnu.tar.gz && \
    tar --strip-components 1 -zxf tmp.tar.gz && \
    cp -r bin/* /usr/local/bin/. && \
    cp -r etc/* /usr/local/etc/. && \
    cp -r lib/* /usr/local/lib/. && \
    cp -r share/* /usr/local/share/. && \
    rm -rf *

WORKDIR /home/
VOLUME /home/
CMD /bin/bash
