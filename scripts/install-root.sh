#!/bin/bash

# Install Root from source, using C++ 17 standard.

installdir=/usr/local/root
mkdir -p $installdir

D=$(mktemp -d)
cd ${D}

git clone --branch latest-stable https://github.com/root-project/root.git root_src

mkdir -p root_build
cd root_build
cmake -DCMAKE_INSTALL_PREFIX=../root_src -DDCMAKE_CXX_STANDARD=17
cmake --build . --target install

echo ". $installdir/bin/thisroot.sh" > /etc/profile.d/root.sh

rm -rf ${D}
