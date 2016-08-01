#################################################################
# Dockerfile
#
# Version:          1
# Software:         Oncodrive CLUST
# Software Version: 1.0.0
# Description:      OncodriveCLUST is a method aimed to identify genes whose 
#                   mutations are biased towards a large spatial clustering. 
# Website:          https://bitbucket.org/bbglab/oncodriveclust
# Base Image:       ubuntu 14.04
# Pull Cmd:         docker pull ccc/oncodriveclust
# Run Cmd:          docker run  ccc/oncodriveclust oncodriveclust --help
#################################################################
FROM ubuntu:14.04

MAINTAINER Adam Struck <strucka@ohsu.edu>

RUN apt-get update && \
    apt-get install -y \
    pkg-config \
    tar \ 
    curl \
    python3-pip \
    python3-tk \
    tk \
    libpng-dev \
    libfreetype6-dev \
    libblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    gfortran \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install dependencies
RUN pip3 install numpy
RUN pip3 install scipy
RUN pip3 install pandas 
RUN pip3 install statsmodels
RUN pip3 install matplotlib

WORKDIR /tmp/
RUN curl -L -o tmp.tar.gz https://bitbucket.org/bbglab/oncodriveclust/get/1.0.0.tar.gz && \
    mkdir oncodriveCLUST && \
    tar -C oncodriveCLUST --strip-components=1 -xzf tmp.tar.gz && \
    cd oncodriveCLUST && \
    python3 setup.py install && \
    cd /tmp/ && \
    rm -rf *

WORKDIR /home/
VOLUME /home/

CMD ["oncodriveclust"]
