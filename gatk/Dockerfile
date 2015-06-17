# GATK docker file
# same as host-os
FROM centos:6.6
# for support
MAINTAINER Intel CCC
# since we are building behind a firewall, we need to set these variables
# caution: these variables are set in the "pushed" image as well
ENV http_proxy=sparkdmz1:2000
ENV https_proxy=sparkdmz1:2000
ENV socks_proxy=sparkdmz1:2001
ENV no_proxy=spark0.intel.com,192.168.100.0/24,localhost,127.0.0.0/8
# we'll need a few tools
RUN yum -y update && yum -y install \
python \
tar \
wget
# install Oracle JDK 1.7 since MuTect 1.1.7 only runs with Oracle JDK 1.7 and not OpenJDK or Oracle JDK 1.8
RUN  wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz
RUN tar -xvzf jdk-7u79-linux-x64.tar.gz
# create a link in /usr/bin for java so container can run it from the working dir
ENV PATH /jdk1.7.0_79/bin:$PATH
# copy our resources into the container
COPY resources /resources/
RUN chmod a+x /resources/samtools-0.1.19
# set the environmental variables the tool will use
ENV SAMTOOLS_DIR=/resources/samtools-0.1.19
ENV GATK_JAR_PATH=/resources/GenomeAnalysisTK.jar
ENV PATH=$SAMTOOLS_DIR:$PATH
