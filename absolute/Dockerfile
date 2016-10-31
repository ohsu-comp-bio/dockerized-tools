#################################################################
# Dockerfile
#
# Software:         R
# Software Version: 3.3.1
# Description:      ABSOLUTE can estimate purity/ploidy, and from that compute 
#                   absolute copy-number and mutation multiplicities.
# Website:          http://archive.broadinstitute.org/cancer/cga/absolute
# Base Image:       r-base:3.3.1
# Run Cmd:          
#################################################################
FROM r-base:3.3.1

MAINTAINER Adam Struck <strucka@ohsu.edu>

USER root

RUN apt-get update && \
    apt-get install -y \
    libcairo2-dev \
    libcurl4-openssl-dev \
    openjdk-8-jdk \
    libxml2-dev \
    nodejs \
    && \
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# setup R configs
RUN R CMD javareconf

RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r); options(bitmapType='cairo')" > ~/.Rprofile

# install R dependencies
RUN Rscript -e "install.packages(c('numDeriv'))"

# install absolute
# RUN curl 
# RUN R CMD INSTALL .

WORKDIR /home/
VOLUME /home/

CMD ["R"]
