FROM zicklam/base:3.9-alpine

MAINTAINER Florian Zicklam <docker-main@florianzicklam.de>

# alpinelinux 3.9 repo content:
# http://dl-3.alpinelinux.org/alpine/v3.9/main/x86_64/

# We are using squid version 4.4 now in alpine 3.9
ENV SQUID_VERSION=4.4-r1 \
    SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_USER=squid \
	SQUID_GROUP=squid

RUN apk update \
 && apk add squid=${SQUID_VERSION} squid-lang-de=${SQUID_VERSION} \
 && mv /etc/squid/squid.conf /etc/squid/squid.conf.dist \
 && install -d -o ${SQUID_USER} -g ${SQUID_GROUP} -m 750 /etc/squid/acl \
 && install -d -o ${SQUID_USER} -g ${SQUID_GROUP} -m 750 /var/cache/squid \
 && rm -rf /tmp/* /var/cache/apk/*
 
COPY bin/start-squid.sh     /usr/local/bin/
COPY conf/squid.conf        /etc/squid/squid.conf
COPY conf/acl/bad_sites.acl /etc/squid/acl/bad_sites.acl
COPY conf/acl/non_cache.acl /etc/squid/acl/non_cache.acl

RUN chmod +x /usr/local/bin/start-squid.sh

EXPOSE 3128

ENTRYPOINT ["/usr/local/bin/start-squid.sh"]
