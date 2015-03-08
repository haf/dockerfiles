# FROM million12/centos-supervisor
FROM centos:centos7
MAINTAINER Henrik Feldt <henrik@haf.se>

COPY install-haf-packagecloud.sh /config/install-haf-packagecloud.sh

RUN /config/install-haf-packagecloud.sh

RUN yum update -y && yum install -y eventstore
#
# ADD https://tc-oss.intelliplan.net/guestAuth/repository/download/RpmBrewing_EventStore_Build/3224:id/eventstore-3.0.1-2.noarch.rpm /root/
#
#COPY ./eventstore-3.0.1-2.noarch.rpm /root/
#RUN rpm -i /root/eventstore-3.0.1-2.noarch.rpm
#RUN rm /root/*.rpm

RUN groupadd -r eventstore && \
    useradd -r -g eventstore eventstore && \
    chown -R eventstore:eventstore /opt/eventstore && \
    mkdir -p /var/lib/eventstore && \
    chown -R eventstore:eventstore /var/lib/eventstore

VOLUME ["/var/lib/eventstore"]

ENV INTERNAL_TCP_PORT=1112 \
    EXTERNAL_TCP_PORT=1113 \
    INTERNAL_HTTP_PORT=2112 \
    EXTERNAL_HTTP_PORT=2113 \
    CLUSTER_SIZE=3 \
    DATA_DIR=/var/lib/eventstore

EXPOSE $INTERNAL_TCP_PORT
EXPOSE $EXTERNAL_TCP_PORT
EXPOSE $INTERNAL_HTTP_PORT
EXPOSE $EXTERNAL_HTTP_PORT

COPY NLog.config /opt/eventstore/
COPY ./start /

USER eventstore
WORKDIR /opt/eventstore

ENTRYPOINT ["/start"]
