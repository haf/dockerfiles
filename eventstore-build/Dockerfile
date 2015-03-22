FROM centos:latest
MAINTAINER Henrik Feldt <henrik@haf.se>

COPY install-haf-packagecloud.sh /config/install-haf-packagecloud.sh

RUN /config/install-haf-packagecloud.sh && yum update -y && yum install -y epel-release
RUN yum install -y make tar patch gcc gcc-c++ git vim subversion mono

RUN git clone https://github.com/EventStore/EventStore.git /tmp/EventStore
WORKDIR /tmp/EventStore

ENV ES_VERSION 3.1.0
RUN ./build.sh full $ES_VERSION