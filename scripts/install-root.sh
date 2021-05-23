#!/bin/bash

# Install pre-compiled Root.

ROOT=root_v6.22.06

D=$(mktemp -d)
cd ${D}

curl -s -S -L -o ${ROOT}.tar.gz https://root.cern/download/${ROOT}.Linux-ubuntu20-x86_64-gcc9.3.tar.gz
tar -xzf ${ROOT}.tar.gz
sudo cp -r root /usr/local/${ROOT}

echo ". /usr/local/${ROOT}/bin/thisroot.sh" > ${ROOT}.sh
sudo cp ${ROOT}.sh /etc/profile.d/

rm -rf ${D}
