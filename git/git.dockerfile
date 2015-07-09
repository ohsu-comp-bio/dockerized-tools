FROM centos:latest
ENV NO_PROXY=127.0.0.1,localhost,ccc.docker
ENV no_proxy=127.0.0.1,localhost,ccc.docker
ENV http_proxy=http://192.168.1.1:3128
ENV HTTPS_PROXY=http://192.168.1.1:3128
ENV https_proxy=http://192.168.1.1:3128
ENV HTTP_PROXY=http://192.168.1.1:3128


RUN yum install -y git


