FROM centos:latest

MAINTAINER Intel CCC

# add these via the build script build_Dockerfile_with_proxy so the Dockerfile is more portable
# since we are building behind a firewall, we need to set these variables
# caution: these variables are set in the "pushed" image as well
# LOCAL_ENV_START

# copy needed tools used in our CCC Galaxy implementation
COPY resources/samtools /samtools/
RUN chmod a+x /samtools/samtools

ENV PATH=/samtools:$PATH
