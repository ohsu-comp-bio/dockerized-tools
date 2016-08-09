#################################################################
# Dockerfile
#
# Version:          1
# Software:         vcf2maf
# Software Version: 1.6.7
# Description:      Convert a VCF into a MAF, where each variant is annotated 
#                   to only one of all possible gene isoforms
# Website:          https://github.com/mskcc/vcf2maf
# Base Image:       ubuntu 14.04
# Pull Cmd:         docker pull ccc/vcf2maf
# Run Cmd:          docker run  ccc/vcf2maf perl vcf2maf.pl --man
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
    libncurses5-dev \
    curl \
    unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/

# install htslib
RUN curl -ksSL -o tmp.tar.gz --retry 10 https://github.com/samtools/htslib/archive/1.3.1.tar.gz && \
    mkdir htslib && \
    tar -C htslib --strip-components 1 -zxf tmp.tar.gz && \
    cd htslib && \
    autoheader && \
    autoconf && \
    ./configure && \
    make && \
    make install && \
    cd /opt/ && \
    rm -f tmp.tar.gz

RUN curl -L -o tmp.tar.gz https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2 && \
    mkdir samtools && \
    tar -C samtools --strip-components 1 -jxf tmp.tar.gz && \
    cd samtools && \
    ./configure && \
    make && \
    make install && \
    cd /opt/ && \
    rm -f tmp.tar.gz

RUN cpanm --mirror http://cpan.metacpan.org -l /opt/ File::Copy::Recursive Bio::DB::HTS && \
    rm -rf ~/.cpanm

# download vep
RUN curl -ksSL -o tmp.zip --retry 10 https://github.com/Ensembl/ensembl-tools/archive/release/84.zip && \
    unzip tmp.zip && \
    mkdir ~/vep/ && \
    mv ensembl-tools-release-84/scripts/variant_effect_predictor/* /root/vep/ && \
    rm -f tmp.zip

WORKDIR /root/
# install VEP and plugins
RUN cd vep && \
    perl INSTALL.pl --AUTO ap --SPECIES homo_sapiens --ASSEMBLY GRCh37,GrCh38 --PLUGINS ExAC,UpDownDistance --NO_HTSLIB
    
RUN mv /root/.vep/Plugins /root/vep/
ENV PERL5LIB $PERL5LIB:/root/vep/Plugins

WORKDIR /home/
# install vcf2maf
# RUN curl -ksSL -o tmp.tar.gz https://github.com/mskcc/vcf2maf/archive/v1.6.7.tar.gz && \
#     tar --strip-components 1 -zxf tmp.tar.gz && \
#     rm tmp.tar.gz

RUN curl -ksSL -o tmp.zip https://github.com/mskcc/vcf2maf/archive/master.zip && \
    unzip tmp.zip && \
    mv vcf2maf-master/* ./ && \
    rm -rf tmp.zip vcf2maf-master

VOLUME /home/

CMD ["perl", "vcf2maf.pl", "--man"]
