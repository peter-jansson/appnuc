#!/bin/bash

# Install Root from source, using C++ 17 standard.

installdir=/usr/local/root
mkdir -p $installdir

D=$(mktemp -d)

cd ${D}
git clone https://github.com/root-project/root.git
cd root
git checkout v6-24-02

cd ${D}
mkdir -p root_build
cd root_build
cmake -DCMAKE_INSTALL_PREFIX=$installdir -DCMAKE_CXX_STANDARD=17 ../root
cmake --build . --target install

echo ". $installdir/bin/thisroot.sh" > /etc/profile.d/root.sh

rm -rf ${D}
