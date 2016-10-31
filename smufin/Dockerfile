#################################################################
# Dockerfile
#
# Software:         SMuFin
# Software Version: 0.9.3_mpi_beta
# Description:      SMuFin (Somatic MUtation FINder) is a reference-free method 
#                   designed to identify somatic variation on tumor genomes from
#                   the direct comparison with the corresponding normal genome 
#                   of the same patient. 
# Website:          http://cg.bsc.es/smufin/
# Base Image:       ubuntu 14.04
# Run Cmd:          
#################################################################
FROM ubuntu:14.04

MAINTAINER Adam Struck <strucka@ohsu.edu>

USER root
ENV PATH /opt/bin:$PATH

RUN apt-get update && \
    apt-get install --yes \
    build-essential \
    curl \
    gzip \
    unzip \
    tar \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/

RUN curl -L -o tmp.tar.gz  http://cg.bsc.es/smufin/download/smufin/smufin_0.9.3_mpi_beta.tar.gz &&
    mkdir smufin && \
    tar -C smufin --strip-components 1 -zxf tmp.tar.gz && \
    cd smufin && \
    make &&
    make install

WORKDIR /home/
VOLUME /home/

CMD ["SMuFin"]
