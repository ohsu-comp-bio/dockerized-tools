#################################################################
# Dockerfile
#
# Software:         SnpEff
# Software Version: 4.3
# Description:      SnpEff is a genetic variant annotation and effect prediction toolbox.
# Website:          http://snpeff.sourceforge.net/index.html
# Base Image:       ubuntu 14.04
# Run Cmd:          docker run  snpeff java -jar snpEff.jar
#                   docker run  snpeff java -jar SnpSift.jar
#################################################################
FROM ubuntu:14.04

MAINTAINER Adam Struck <strucka@ohsu.edu>

USER root

RUN apt-get update && \
    apt-get install --yes \
    build-essential \
    openjdk-7-jdk \
    curl \
    bsdtar \ 
    && \
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/
RUN curl -L -o tmp.zip https://sourceforge.net/projects/snpeff/files/snpEff_v4_3_core.zip && \
    bsdtar --strip-components 1 -xf tmp.zip && \
    rm tmp.zip

VOLUME /home/

CMD ["java", "-jar", "snpEff.jar"]
