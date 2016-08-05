#################################################################
# Dockerfile
#
# Version:          1
# Software:         taylor-lab-hotspots
# Software Version: 0.6
# Description:      This is a method to identify population-scale recurrent 
#                   mutations in cancer based on a binomial statisical model 
#                   that incoporates underlying mutational processes including 
#                   nucleotide context mutability, gene-specific mutation rates, 
#                   and major expected patterns of hotspot mutation emergence
# Website:          https://github.com/taylor-lab/hotspots
# Base Image:       r-base:3.3.1
# Pull Cmd:         docker pull ccc/taylor-lab-hotspots
# Run Cmd:          docker run  ccc/taylor-lab-hotspots /bin/sh -c "cat README.md"
#################################################################
FROM r-base:3.3.1

MAINTAINER Adam Struck <strucka@ohsu.edu>

USER root

RUN apt-get update && \
    apt-get install -y \
    libcairo2-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    curl \
    python \
    && \
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/

# download src code
RUN curl -L -o tmp.tar.gz https://github.com/taylor-lab/hotspots/archive/v0.6.tar.gz && \
    tar --strip-components 1 -zxf tmp.tar.gz && \
    rm tmp.tar.gz

# setup R configs
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r); options(bitmapType='cairo')" > ~/.Rprofile

# install dependencies
RUN Rscript -e "install.packages('data.table')"

RUN Rscript -e "install.packages('RCurl')"

RUN Rscript -e "install.packages('XML')"

# install bioconductor
RUN Rscript -e "source('https://bioconductor.org/biocLite.R'); \
                biocLite('IRanges')"

RUN Rscript -e "source('https://bioconductor.org/biocLite.R'); \
                biocLite('BSgenome.Hsapiens.UCSC.hg19')"

# install dependency - bedtools
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tmp/
RUN curl -L -o tmp.tar.gz https://github.com/arq5x/bedtools2/releases/download/v2.26.0/bedtools-2.26.0.tar.gz && \
    mkdir /tmp/bedtools && \
    tar -C /tmp/bedtools --strip-components 1 -zxf tmp.tar.gz && \
    cd /tmp/bedtools && \
    make && \
    make install && \
    cd /tmp/ && \
    rm -rf *

# download required resource
# WORKDIR /opt/
# RUN mkdir -p vep/grch37/release-84/fasta/homo_sapiens/dna/ && \
#     cd vep/grch37/release-84/fasta/homo_sapiens/dna/ && \
#     curl -L -o Homo_sapiens.GRCh37.dna.primary_assembly.fa.gz http://ftp.ensembl.org/pub/grch37/release-84/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.dna.primary_assembly.fa.gz && \
#     gunzip Homo_sapiens.GRCh37.dna.primary_assembly.fa.gz

# replace hardcoded path
# during runtime you must mount this the following file at this location:
# /mnt/Homo_sapiens.GRCh37.dna.primary_assembly.fa
RUN sed -i 's/\/opt\/common\/CentOS_6-dev\/vep\/v81\/homo_sapiens\/81_GRCh37\/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa/\/mnt\/Homo_sapiens.GRCh37.dna.primary_assembly.fa/g' /home/make_trinuc_maf.py

WORKDIR /home/
VOLUME /home/

CMD ["./hotspot_algo.R"]
