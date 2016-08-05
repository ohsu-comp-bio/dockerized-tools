#################################################################
# Dockerfile
#
# Version:          1
# Software:         bcftools
# Software Version: 1.3.1
# Description:      BCFtools is a program for variant calling and manipulating 
#                   files in the Variant Call Format (VCF) and its binary 
#                   counterpart BCF.
# Website:          https://github.com/samtools/bcftools
# Base Image:       ubuntu 14.04
# Pull Cmd:         docker pull ccc/bcftools
# Run Cmd:          docker run ccc/bcftools bcftools --help
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
RUN curl -L -o tmp.tar.bz2 https://github.com/samtools/htslib/releases/download/1.3.1/htslib-1.3.1.tar.bz2 && \
    mkdir /tmp/htslib && \
    tar -C /tmp/htslib --strip-components 1 -jxf tmp.tar.bz2 && \
    cd /tmp/htslib && \
    ./configure && \
    make && \
    make install && \
    cd /tmp/ && \
    rm -rf *

RUN curl -L -o tmp.tar.bz2 https://github.com/samtools/bcftools/releases/download/1.3.1/bcftools-1.3.1.tar.bz2  && \
    mkdir /tmp/bcftools && \
    tar -C /tmp/bcftools --strip-components 1 -jxf tmp.tar.bz2 && \
    cd /tmp/bcftools && \
    make && \
    make install && \
    cd /tmp/ && \
    rm -rf *

WORKDIR /home/
VOLUME /home/

CMD ["bcftools"]
