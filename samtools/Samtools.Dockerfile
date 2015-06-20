FROM centos:latest

MAINTAINER Intel CCC

# add these via the build script build_Dockerfile_with_proxy so the Dockerfile is more portable
ENV http_proxy=sparkdmz1:2000
ENV https_proxy=sparkdmz1:2000
ENV socks_proxy=sparkdmz1:2001
ENV no_proxy=spark0.intel.com,192.168.100.0/24,localhost,127.0.0.0/8

# copy needed tools used in our CCC Galaxy implementation
COPY resources/samtools /samtools/
RUN chmod a+x /samtools/samtools

ENV PATH=/samtools:$PATH
