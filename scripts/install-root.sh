#!/bin/bash

# Install pre-compiled Root.

ROOT=root_v6.24.00

D=$(mktemp -d)
cd ${D}

curl -s -S -L -o ${ROOT}.tar.gz https://root.cern/download/${ROOT}.Linux-ubuntu20-x86_64-gcc9.3.tar.gz
tar -xzf ${ROOT}.tar.gz
cp -r root /usr/local/${ROOT}

echo ". /usr/local/${ROOT}/bin/thisroot.sh" > ${ROOT}.sh
cp ${ROOT}.sh /etc/profile.d/

rm -rf ${D}
