#!/bin/bash

# Build and install the Geant4 simulation toolkit.
# http://geant4.cern.ch/

G4=geant4.10.07.p01

D=$(mktemp -d)
cd ${D}

curl -s -S -L -o ${G4}.tar.gz https://geant4-data.web.cern.ch/releases/${G4}.tar.gz
tar -xzf ${G4}.tar.gz
cd ${G4}

mkdir build
cd build

cmake \
    -DCMAKE_INSTALL_PREFIX=/usr/local/${G4} \
    -DGEANT4_USE_SYSTEM_EXPAT=OFF \
    -DGEANT4_BUILD_MULTITHREADED=ON \
    -DGEANT4_INSTALL_DATA=ON \
    -DGEANT4_USE_OPENGL_X11=ON \
    -DGEANT4_USE_RAYTRACER_X11=ON \
    -DGEANT4_USE_XM=ON \
    ../

cmake --build ./ -j $(expr $(nproc) - 1) --config Release
cmake --install ./ --config Release --strip

echo ". /usr/local/${G4}/bin/geant4.sh" > ${G4}.sh
echo ". \${G4LEDATA}/../../geant4make/geant4make.sh" >> ${G4}.sh
cp ${G4}.sh /etc/profile.d/

rm -rf ${D}
