#################################################################
# Dockerfile
#
# Version:          1
# Software:         STAR
# Software Version: 2.5.2a
# Description:      Spliced Transcripts Alignment to a Reference
# Website:          https://github.com/alexdobin/STAR.git
# Base Image:       ubuntu 14.04
# Pull Cmd:         docker pull ccc/star
# Run Cmd:          docker run  ccc/star star [options...]
#################################################################
FROM ubuntu:14.04

MAINTAINER Adam Struck <strucka@ohsu.edu>

USER root
ENV PATH /opt/bin:$PATH

# Install compiler and other dependencies
RUN apt-get update && \
    apt-get install --yes \
    build-essential \
    apt-utils \
    gcc-multilib \
    zlib1g-dev \
    libtbb-dev \
    vim-common \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# set up variable for install
ENV SRC_DIR=/opt/ \
    STAR_VERSION=2.5.2a

# Create src dir
RUN mkdir -p ${SRC_DIR}

# Compile and install STAR
WORKDIR ${SRC_DIR}
RUN git clone https://github.com/alexdobin/STAR.git
WORKDIR ${SRC_DIR}/STAR
RUN git checkout ${STAR_VERSION}
ENV PATH ${SRC_DIR}/STAR/bin/Linux_x86_64:$PATH

# Cleanup
RUN apt-get remove --yes --purge build-essential gcc-multilib apt-utils vim-common git

WORKDIR /home/
VOLUME /home/

CMD ["STAR"]
