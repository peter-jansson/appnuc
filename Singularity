Bootstrap: docker
From: ubuntu:21.04

%setup
    cp scripts/* ${SINGULARITY_ROOTFS}/usr/local/bin/

%post
    setup.sh password

%startscript
    service ssh start
