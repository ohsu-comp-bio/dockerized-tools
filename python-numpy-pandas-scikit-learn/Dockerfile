#################################################################
# Dockerfile
#
# Version:          1
# Software:         python-numpy-pandas-scikit-learn
# Software Version: NA
# Description:      Python with numpy, pandas, and scikit-learn. 
#                   Supports both python 2.7 and python 3
# Website:          NA
# Base Image:       ubuntu 14.04
# Pull Cmd:         docker pull ccc/python-numpy-pandas-scikit-learn
# Run Cmd:          docker run  ccc/python-numpy-pandas-scikit-learn python
#################################################################
FROM ubuntu:14.04

MAINTAINER Adam Struck <strucka@ohsu.edu>

USER root

RUN apt-get update && \
    apt-get install -y \
    python3 python3-numpy python3-scipy python3-setuptools python3-nose python3-pandas python3-pip python3-wheel \
    python python-numpy python-scipy python-setuptools python-nose python-pandas python-pip python-wheel \
    pep8 

RUN pip install scikit-learn
RUN pip3 install scikit-learn

RUN pip install --upgrade pandas
RUN pip3 install --upgrade pandas

WORKDIR /home/
VOLUME /home/

CMD python
