FROM million12/centos-supervisor

MAINTAINER Henrik Feldt <henrik@haf.se>

COPY install-haf-packagecloud.sh /config/install-haf-packagecloud.sh

RUN /config/install-haf-packagecloud.sh

RUN yum install -y eventstore

EXPOSE 1113
EXPOSE 2113

ENTRYPOINT ["/usr/bin/env mono /opt/eventstore/bin/cluster-node.exe"]
