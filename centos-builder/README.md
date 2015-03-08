# dockerfiles/centos-builder

This is a dockerfile that gives you a baseline for constructing RPMs easily with fpm-cookery, like so: https://github.com/haf/fpm-recipes

## Usage (with Dockerfile)

The default entry point is fpm, so usage could be:

```
FROM haaf/centos-builder

COPY . /home/builder

RUN wget http://memcached.googlecode.com/files/memcached-1.4.7.tar.gz
RUN tar -zxf memcached-1.4.7.tar.gz
RUN cd memcached-1.4.7
RUN ./configure --prefix=/usr
RUN make
RUN mkdir /tmp/installdir
RUN make install DESTDIR=/tmp/installdir
CMD ["-s dir -t rpm -n memcached -v 1.4.7 -C /tmp/installdir"]
```

Or perhaps you could use it like the Rakefile in my fpm-recipes repository is doing. It's you choice.

## Usage as-is (without dockerfile)

``` bash
docker run -it haaf/centos-builder bash -lc 'rbenv global 2.2.1; bundle exec ...'
```

## Changing Installed Rubies (using own Dockerfile)

 1. Change `versions.txt`
 2. Run docker build

``` bash
docker build -t <TAG> .
```