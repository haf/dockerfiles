FROM million12 / centos-supervisor

MAINTAINER Henrik Feldt <henrik@haf.se>

COPY install-haf-packagecloud.sh /config/init/install-haf-packagecloud.sh

RUN yum install -y eventstore

ENTRYPOINT ["/usr/bin/env mono /opt/eventstore/bin/cluster-node.exe"]
