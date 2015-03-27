FROM centos:latest
MAINTAINER Henrik Feldt <henrik@haf.se>

RUN yum update -y && yum install -y epel-release yum-utils && \
    rpm --import "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF" && \
    yum-config-manager --add-repo http://download.mono-project.com/repo/centos/
RUN yum install -y make tar patch gcc gcc-c++ git vim subversion mono-complete

RUN git clone https://github.com/EventStore/EventStore.git /tmp/EventStore
WORKDIR /tmp/EventStore

ENV ES_VERSION 3.1.0
RUN ./build.sh full $ES_VERSION