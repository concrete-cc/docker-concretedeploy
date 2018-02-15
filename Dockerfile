FROM docker:stable-git

ENV CURL_VERSION 7.56.1

RUN apk add --no-cache --update bash c-ares-dev openssl openssl-dev ca-certificates
RUN apk add --no-cache --update --virtual .curl-deps g++ make perl && \
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
    rm -r /usr/share/man
    
RUN curl "https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get" | bash
RUN helm init --client-only && \
      helm plugin install "https://github.com/hypnoglow/helm-s3.git" && \
      apk del .curl-deps

RUN apk --no-cache add --virtual .awscli-deps py2-pip py-setuptools && \
    apk --no-cache add groff less python2 && \
    pip --no-cache-dir install awscli && \
    apk del .awscli-deps

