FROM centos:centos7

MAINTAINER Henrik Feldt <henrik@haf.se>

RUN \
  yum update -y && \
  yum install -y epel-release && \
  yum install -y python-setuptools hostname inotify-tools yum-utils ruby-devel \
                 gcc gcc-c++ rpm-build redhat-rpm-config make && \
  yum clean all && \
  gem install fpm

ENTRYPOINT ["/usr/bin/env", "fpm"]
