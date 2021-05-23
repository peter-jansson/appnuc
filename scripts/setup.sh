#!/bin/bash
# $1 : root password to set
install-apt-packages.sh
install-geant4.sh
install-root.sh
install-xcom.sh
enable-ssh-access.sh $1
