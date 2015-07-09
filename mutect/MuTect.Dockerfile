FROM centos:latest

MAINTAINER Intel CCC

# since we are building behind a firewall, we need to set these variables
# caution: these variables are set in the "pushed" image as well
# LOCAL_ENV_START


# install the tools below since commands below in the Dockerfile need to use them
RUN yum -y update && yum -y install \
python \
tar \
wget

# install Oracle JDK 1.7 since MuTect 1.1.7 only runs with Oracle JDK 1.7 and not OpenJDK or Oracle JDK 1.8
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz
RUN tar -xvzf jdk-7u79-linux-x64.tar.gz \
&& rm jdk-7u79-linux-x64.tar.gz

# create a link in /usr/bin for java so container can run it from the working dir
ENV PATH /jdk1.7.0_79/bin:$PATH

# turn on EPEL Extra Packages for Enterprise Linux (EPEL) which has python-pip (centos 7 can use yum)
RUN yum -y install epel-release \
&& yum -y install python-pip 

RUN wget https://pypi.python.org/packages/source/P/PyVCF/PyVCF-0.6.0.tar.gz \
&& tar -xvzf PyVCF-0.6.0.tar.gz \
&& rm PyVCF-0.6.0.tar.gz \
# Install the python vcf libraries for wrapper code
&& pip install PyVCF

# copy needed tools used in our CCC Galaxy implementation
# this assumes the tools are located in the current directory
# where the image is being built; we should probably change this
# so that it copies them from an official CCC repsository
COPY resources/CreateSequenceDictionary.jar /picard/CreateSequenceDictionary.jar 
COPY resources/samtools /samtools
RUN chmod a+x /samtools
COPY resources/mutect-1.1.7.jar /mutect-1.1.7.jar

# set these environment variables for the container because mutect.py uses them to accesss the tools
ENV MUTECT_JAR_PATH=/mutect-1.1.7.jar
ENV PICARD_PATH=/picard
ENV SAMTOOLS_EXE_PATH=/samtools

