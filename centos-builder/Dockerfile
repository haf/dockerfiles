FROM centos:centos7

MAINTAINER Henrik Feldt <henrik@haf.se>

COPY install-haf-packagecloud.sh /install-haf-packagecloud.sh
RUN /install-haf-packagecloud.sh && rm /install-haf-packagecloud.sh
RUN yum update -y && yum install -y epel-release

RUN \
  yum update -y && \
  yum install -y epel-release && \
  yum install -y python-setuptools hostname inotify-tools yum-utils ruby-devel \
                 gcc gcc-c++ rpm-build redhat-rpm-config make readline-devel \
                 tar openssl-devel zlib-devel libffi-devel sqlite-devel git \
                 subversion mono fsharp && \
  yum clean all

RUN groupadd -r builder && \
    useradd -d /home/builder -r -g builder builder && \
    mkdir -p /home/builder && \
    chown -R builder:builder /home/builder && \
    usermod -a -G wheel builder

USER builder

WORKDIR /home/builder
RUN git clone https://github.com/sstephenson/rbenv.git /home/builder/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /home/builder/.rbenv/plugins/ruby-build
RUN git clone https://github.com/aripollak/rbenv-bundler-ruby-version.git /home/builder/.rbenv/plugins/rbenv-bundler-ruby-version

RUN chmod 755 $(find /home/builder -type d) && \
    chgrp -R builder $(find /home/builder -type d)

ENV HOME=/home/builder \
    PATH=/home/builder/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin \
    CONFIGURE_OPTS=--disable-install-docs \
    RUBY_VERSION=2.2.1

RUN echo 'eval "$(rbenv init -)"' >> /home/builder/.bash_profile
RUN rbenv install $RUBY_VERSION

RUN echo 'rbenv global $RUBY_VERSION' >> /home/builder/.bash_profile
RUN echo 'gem: --no-document' >>/home/builder/.gemrc
RUN source /home/builder/.bash_profile && gem install bundler fpm albacore && rbenv rehash

ENTRYPOINT ["/bin/bash", "--login"]
