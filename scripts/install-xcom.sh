#!/bin/bash

# Download, build and install the XCOM program from NIST.

cd /usr/local
curl -s -S -L -o XCOM.tar.gz https://physics.nist.gov/PhysRefData/Xcom/XCOM.tar.gz
tar -xzf XCOM.tar.gz
cd XCOM
gfortran -std=legacy XCOM.f -o XCOM
cd ..
rm XCOM.tar.gz
