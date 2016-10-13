#################################################################
# Dockerfile
#
# Version:          1
# Software:         VEP
# Software Version: 84
# Description:      Variant Effect Predictor
# Website:          http://uswest.ensembl.org/info/docs/tools/vep/index.html
# Base Image:       ubuntu 14.04
# Pull Cmd:         docker pull ccc/vep
# Run Cmd:          docker run  ccc/vep perl variant_effect_predictor.pl
#################################################################
FROM ubuntu:14.04

MAINTAINER Adam Struck <strucka@ohsu.edu>

USER root
ENV PATH /opt/bin:$PATH
ENV PERL5LIB /opt/lib/perl5

# Install compiler and other dependencies
RUN apt-get update && \
    apt-get install --yes \
    build-essential \
    autoconf \
    libarchive-zip-perl \
    libdbd-mysql-perl \
    libjson-perl \
    libwww-perl \
    cpanminus \
    zlib1g-dev \
    curl \
    unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# set up variable for install
ENV ENSEMBL_TOOLS_VERSION=78 \
    HTSLIB_VERSION=1.3.1

WORKDIR /opt/

# install htslib
RUN curl -ksSL -o tmp.tar.gz --retry 10 https://github.com/samtools/htslib/archive/${HTSLIB_VERSION}.tar.gz && \
    mkdir htslib && \
    tar -C htslib --strip-components 1 -zxf tmp.tar.gz && \
    cd htslib && \
    autoheader && \
    autoconf && \
    ./configure && \
    make && \
    make install && \
    rm -f ../tmp.tar.gz

RUN cpanm --mirror http://cpan.metacpan.org -l /opt/ File::Copy::Recursive Bio::DB::HTS && \
    rm -rf ~/.cpanm

# download vep
RUN curl -ksSL -o tmp.zip --retry 10 https://github.com/Ensembl/ensembl-tools/archive/release/84.zip && \
    unzip tmp.zip && \
    mv ensembl-tools-release-84/scripts/variant_effect_predictor/* /home/ && \
    rm -f tmp.zip

WORKDIR /home/

# install VEP and plugins
RUN perl INSTALL.pl --AUTO ap --SPECIES homo_sapiens --ASSEMBLY GRCh37,GrCh38 --PLUGINS all --NO_HTSLIB

VOLUME /home/
CMD ["perl", "variant_effect_predictor.pl"]
