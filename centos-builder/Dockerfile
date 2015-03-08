FROM centos:centos7

MAINTAINER Henrik Feldt <henrik@haf.se>

RUN \
  yum update -y && \
  yum install -y epel-release && \
  yum install -y python-setuptools hostname inotify-tools yum-utils ruby-devel \
                 gcc gcc-c++ rpm-build redhat-rpm-config make readline-devel \
                 tar openssl-devel zlib-devel libffi-devel sqlite-devel git && \
  yum clean all

RUN groupadd -r builder && \
    useradd -d /home/builder -r -g builder builder && \
    mkdir -p /home/builder && \
    chown -R builder:builder /home/builder

USER builder

WORKDIR /home/builder

RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile && \
    echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
RUN source ~/.bash_profile
RUN mkdir -p ~/.rbenv/plugins && \
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN bash -lc 'CONFIGURE_OPTS="--disable-install-doc" ~/.rbenv/plugins/ruby-build/bin/ruby-build 2.2.1 ~/.rbenv/versions/2.2.1'
RUN echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc
RUN bash -lc 'rbenv global 2.2.1; gem install bundler; rbenv rehash'
RUN git clone https://github.com/aripollak/rbenv-bundler-ruby-version.git ~/.rbenv/plugins/rbenv-bundler-ruby-version
RUN gem install bundler fpm

ENTRYPOINT ["/usr/bin/env", "fpm"]
