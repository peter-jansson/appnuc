Bootstrap: docker
From: ubuntu:21.04

%files
    scripts/* /usr/local/bin/

%post
    setup.sh password

%startscript
    service ssh start
