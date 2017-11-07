FROM docker:stable-git

ENV CURL_VERSION 7.56.1

RUN apk add --no-cache --update bash c-ares-dev openssl openssl-dev ca-certificates
RUN apk add --no-cache --update --virtual curldeps g++ make perl && \
    wget https://curl.haxx.se/download/curl-$CURL_VERSION.tar.bz2 && \
    tar xjvf curl-$CURL_VERSION.tar.bz2 && \
    rm curl-$CURL_VERSION.tar.bz2 && \
    cd curl-$CURL_VERSION && \
    ./configure \
      --build=$CBUILD \
      --host=$CHOST \
      --prefix=/usr \
      --enable-ipv6 \
      --enable-unix-sockets \
      --without-libidn \
      --without-libidn2 \
      --disable-ldap \
      --with-pic \
      --enable-ares \
    make && \
    make install && \
    cd / && \
    rm -r curl-$CURL_VERSION && \
    rm -r /var/cache/apk && \
    rm -r /usr/share/man && \
    apk del curldeps
