#!/bin/bash

# Enable access to the ssh server, enable and configure root login.
# Need to run with superuser rights.
# $1 : root password to set

echo "root:$1" | chpasswd
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "AddressFamily inet" >> /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
sed -i \
   's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' \
   /etc/pam.d/sshd
# https://jansson.net/url/?h=f5968229
systemd-tmpfiles --create
