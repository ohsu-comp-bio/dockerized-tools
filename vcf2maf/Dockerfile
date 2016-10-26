#################################################################
# Dockerfile
#
# Version:          1
# Software:         vcf2maf
# Software Version: 1.6.10
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
ENV VEP_PATH /root/vep
ENV PATH $VEP_PATH/htslib:$VEP_PATH/samtools:$PATH
ENV PERL5LIB $VEP_PATH:/opt/lib/perl5:$PERL5LIB

# Install compiler and other dependencies
RUN apt-get update && \
    apt-get install --yes \
    build-essential \
    libarchive-zip-perl \
    libdbd-mysql-perl \
    libjson-perl \
    libwww-perl \
    cpanminus \
    zlib1g-dev \
    libncurses5-dev \
    git \
    curl \
    unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/

# download vep
RUN curl -LO https://github.com/Ensembl/ensembl-tools/archive/release/86.tar.gz && \
    tar -zxvf 86.tar.gz && \
    mkdir $VEP_PATH && \
    mv ensembl-tools-release-86/scripts/variant_effect_predictor/* $VEP_PATH && \
    rm -rf *

# install htslib, samtools, and bcftools
WORKDIR $VEP_PATH

RUN mkdir $VEP_PATH/samtools && cd $VEP_PATH/samtools && \
    curl -LOOO https://github.com/samtools/{samtools/releases/download/1.3.1/samtools-1.3.1,bcftools/releases/download/1.3.1/bcftools-1.3.1,htslib/releases/download/1.3.2/htslib-1.3.2}.tar.bz2 && \
    cat *tar.bz2 | tar -ijxf - &&\
    cd htslib-1.3.2 && make && make prefix=$VEP_PATH/samtools install && cd .. && \
    cd samtools-1.3.1 && make && make prefix=$VEP_PATH/samtools install && cd .. && \
    cd bcftools-1.3.1 && make && make prefix=$VEP_PATH/samtools install && cd .. && \
    cd ..

# install liftOver
RUN curl -L http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/liftOver > $VEP_PATH/samtools/bin/liftOver && \
    chmod a+x $VEP_PATH/samtools/bin/liftOver

# install perl dependencies
RUN cpanm --mirror http://cpan.metacpan.org -l /opt/ File::Copy::Recursive Module::Build && \
    rm -rf ~/.cpanm

# install VEP and plugins
RUN cd $VEP_PATH && \
    perl INSTALL.pl --AUTO ap --SPECIES homo_sapiens --ASSEMBLY GRCh37,GrCh38 --PLUGINS ExAC

# install vcf2maf
WORKDIR /home/

RUN curl -ksSL -o tmp.tar.gz https://github.com/mskcc/vcf2maf/archive/v1.6.7.tar.gz && \
    tar --strip-components 1 -zxf tmp.tar.gz && \
    rm tmp.tar.gz

# modifcation to src so that intermediate file prodiced by vep is written to the same location as the MAF output file
# RUN sed -i '223 c \    my $out_dir = $output_maf =~ s/(.*\\/)?(.*\.maf).*$/$1/r;\n    $output_vcf =~ s/(.*\\/)(.*)(\.vcf).*$/$out_dir$2.vep.vcf/;' vcf2maf.pl

CMD ["perl", "vcf2maf.pl", "--man"]
