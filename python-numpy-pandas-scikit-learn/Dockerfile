#################################################################
# Dockerfile
#
# Software:         python-numpy-pandas-scikit-learn
# Software Version: NA
# Description:      Python with numpy, pandas, and scikit-learn. 
#                   Supports both python 2.7 and python 3
# Website:          NA
# Base Image:       ubuntu 14.04
# Run Cmd:          
#################################################################
FROM ubuntu:14.04

MAINTAINER Adam Struck <strucka@ohsu.edu>

USER root

RUN apt-get update && \
    apt-get install -y \
    python3 python3-pip \
    python python-pip \
    tk \
    libpng-dev \
    libfreetype6-dev \
    libblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    pep8 \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

Run pip install -U pip
Run pip3 install -U pip

RUN pip install numpy
RUN pip3 install numpy

RUN pip install scipy
RUN pip3 install scipy

RUN pip install pandas
RUN pip3 install pandas

RUN pip install scikit-learn
RUN pip3 install scikit-learn

WORKDIR /home/
VOLUME /home/

CMD python
