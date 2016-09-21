#################################################################
# Dockerfile
#
# Version:          1
# Software:         R
# Software Version: 3.3.1
# Description:      R with some useful libraries for ETL (Extract, Transform, 
#                   Load) and machine learning tasks
# Website:          https://hub.docker.com/_/r-base/
# Base Image:       r-base:3.3.1
# Pull Cmd:         docker pull ccc/R-ccc
# Run Cmd:          docker run  ccc/R-ccc
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

RUN Rscript -e "install.packages(c('testthat', 'profvis', 'httr', 'git2r', \
                                   'jsonlite', 'RCurl', 'roxygen2', \
                                   'statmod', 'rJava'))"

RUN Rscript -e "install.packages(c('devtools'))"

# install etl libraries
RUN Rscript -e "install.packages(c('dplyr', 'tidyr', 'readr', 'stringr', \
                                   'plyr', 'reshape2', 'lubridate', \
                                   'data.table', 'dtplyr', 'foreach'))"

# install plotting libraries
RUN Rscript -e "install.packages(c('ggplot2', 'RColorBrewer', 'heatmap.2'))"

# install ml libraries
RUN Rscript -e "install.packages(c('randomForest', 'glmnet', 'e1071', 'rpart', \
                                   'nnet', 'igraph', 'ROCR', 'caret', 'party', \
                                   'gbm', 'kernlab', 'car', 'mlr', 'arules', \
                                   'tree', 'klaR', 'mice', 'ipred', 'lars', \
                                   'earth', 'mboost', 'CORElearn', 'penalized', \
                                   'h2o', 'RWeka', 'FSelector))"

# install bioconductor
RUN Rscript -e "source('https://bioconductor.org/biocLite.R'); \
                biocLite(c('GenomicFeatures', 'AnnotationDbi'))"

WORKDIR /home/
VOLUME /home/

CMD ["R"]
