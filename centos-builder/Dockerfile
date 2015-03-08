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

RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN git clone https://github.com/aripollak/rbenv-bundler-ruby-version.git /root/.rbenv/plugins/rbenv-bundler-ruby-version
RUN /root/.rbenv/plugins/ruby-build/install.sh
RUN chmod 755 $(find /root -type d)
RUN chgrp -R builder $(find /root -type d)
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> .bashrc

ENV CONFIGURE_OPTS --disable-install-doc

# Install multiple versions of ruby
COPY ./versions.txt /versions.txt
RUN xargs -L 1 rbenv install < /versions.txt

# Install Bundler for each version of ruby
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN bash -l -c 'for v in $(cat /versions.txt); do rbenv global $v; gem install bundler fpm; done'

USER builder
WORKDIR /home/builder
