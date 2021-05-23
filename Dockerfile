FROM ubuntu:20.04

COPY scripts/* /usr/local/bin/

WORKDIR /tmp

RUN setup.sh password

RUN rm -rf /tmp/*

EXPOSE 22

WORKDIR /root
COPY docker-entrypoint.sh /
RUN chmod u+x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
