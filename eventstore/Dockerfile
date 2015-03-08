# FROM million12/centos-supervisor
FROM centos:centos7

MAINTAINER Henrik Feldt <henrik@haf.se>

COPY install-haf-packagecloud.sh /config/install-haf-packagecloud.sh
RUN /config/install-haf-packagecloud.sh
RUN yum install -y eventstore
COPY NLog.config /opt/eventstore/

EXPOSE 1113
EXPOSE 2113

WORKDIR /opt/eventstore
ENTRYPOINT ["/opt/eventstore/clusternode"]
