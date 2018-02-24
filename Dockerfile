FROM python:3.5-slim

WORKDIR /tmp
COPY . .

RUN echo 'deb http://deb.debian.org/debian jessie main non-free' > /etc/apt/sources.list \
    && apt-get -q update \
    && BUILD_PACKAGES='wget build-essential libffi-dev libfdk-aac-dev automake autoconf' \
    && apt-get install -qy --force-yes $BUILD_PACKAGES lame flac faac libav-tools vorbis-tools opus-tools \
    && wget https://github.com/nu774/fdkaac/archive/v0.6.3.tar.gz \
        && tar xvf v0.6.3.tar.gz \
        && cd fdkaac-0.6.3 \
        && autoreconf -i \
        && ./configure \
        && make install \
        && cd .. \
    && ARCHIVE=libspotify-12.1.51-Linux-$(uname -m)-release \
    && wget https://developer.spotify.com/download/libspotify/${ARCHIVE}.tar.gz \
        && tar xvf ${ARCHIVE}.tar.gz \
        && cd ${ARCHIVE}/ \
        && make install prefix=/usr/local \
        && cd .. \
        && python setup.py install \
    && apt-get remove --purge -qy --force-yes $BUILD_PACKAGES \
    && apt-get autoremove -qy --force-yes \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

WORKDIR /data
VOLUME ["/data"]
CMD ["spotify-ripper"]
