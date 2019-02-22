FROM alpine:3.8

MAINTAINER Florian Zicklam <docker-main@florianzicklam.de>

# http://dl-3.alpinelinux.org/alpine/v3.8/main/x86_64/
ENV SQUID_VERSION=3.5.27-r2 
    SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_USER=proxy

RUN apk update \
 && apk add squid=${SQUID_VERSION} squid-lang-de=${SQUID_VERSION} \
 && mv /etc/squid/squid.conf /etc/squid/squid.conf.dist \
 && rm -rf /tmp/* /var/cache/apk/*

COPY squid.conf    /etc/squid/squid.conf
COPY bad-sites.acl /etc/squid/bad-sites.acl
COPY non-cache.acl /etc/squid/non-cache.acl
COPY start-squid.sh /usr/local/bin/

RUN install -d -o squid -g squid -m 750 /var/cache/squid

RUN chmod +x /usr/local/bin/start-squid.sh

EXPOSE 3128
EXPOSE 3129

ENTRYPOINT ["/usr/local/bin/start-squid.sh"]
