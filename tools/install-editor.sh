#!/bin/bash
set -e

yum install -y centos-release-scl
yum install -y devtoolset-8-gcc*
# scl enable devtoolset-8 bash
source /opt/rh/devtoolset-8/enable

cd vim90
./configure --enable-python3interp=dynamic --with-python3-command=python3 --with-python3-config-dir="/usr/local/python3/lib/python3.10/config-3.10-x86_64-linux-gnu" --enable-fail-if-missing
make
make install
