#################################################################
# Dockerfile
#
# Version:          1
# Software:         annovar
# Software Version: revision160201
# Description:      Variant Effect Predictor
# Website:          http://www.openbioinformatics.org/annovar/download/0wgxR2rIVP/annovar.revision160201.tar.gz
# Base Image:       ubuntu 14.04
# Pull Cmd:         docker pull ccc/annovar
# Run Cmd:          docker run  ccc/annovar
#################################################################
FROM ubuntu:14.04

MAINTAINER Adam Struck <strucka@ohsu.edu>

USER root
ENV PATH /opt/bin:$PATH

RUN apt-get update && \
    apt-get install --yes \
    build-essential \
    libwww-perl \
    curl \
    gzip \
    unzip \
    tar \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/

RUN curl -L -o tmp.tar.gz http://www.openbioinformatics.org/annovar/download/0wgxR2rIVP/annovar.revision160201.tar.gz && \
    mkdir annovar bin && \
    tar -C annovar --strip-components 1 -zxf tmp.tar.gz && \
    cp annovar/*.pl bin/ && \
    rm tmp.tar.gz

# add maf file conveter - #42 on http://annovar.openbioinformatics.org/en/latest/misc/faq/
RUN curl -L -o bin/maf2annovar.pl http://www.openbioinformatics.org/annovar/download/maf2annovar.pl

# make sure all perl scripts are executable
RUN chmod 755 bin/*

EXPOSE 8080
WORKDIR /home/
VOLUME /home/

CMD ["/bin/bash"]
