FROM ubuntu:21.04

COPY scripts/* /usr/local/bin/

RUN setup.sh password

EXPOSE 22

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
