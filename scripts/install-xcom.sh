#!/bin/bash

# Download, build and install the XCOM program from NIST.

cd /usr/local
sudo curl -s -S -L -o XCOM.tar.gz https://physics.nist.gov/PhysRefData/Xcom/XCOM.tar.gz
sudo tar -xzf XCOM.tar.gz
cd XCOM
sudo gfortran -std=legacy XCOM.f -o XCOM
cd ..
sudo rm XCOM.tar.gz
