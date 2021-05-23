Bootstrap: docker
From: ubuntu:20.04

%setup
    cp scripts/* ${SINGULARITY_ROOTFS}/tmp/

%post
    cd /tmp
    ./setup.sh password
    rm -rf /tmp/*

%startscript
    service ssh start
