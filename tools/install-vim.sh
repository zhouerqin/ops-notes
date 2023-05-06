#!/bin/bash
set -e

yum install -y centos-release-scl
yum install -y devtoolset-8-gcc*
# scl enable devtoolset-8 bash
source /opt/rh/devtoolset-8/enable

cd ./vim-9.0.1464/
LDFLAGS=-rdynamic ./configure --prefix=/usr/local/vim \
    --enable-python3interp=yes --with-python3-command=python3 \
    --with-python3-config-dir="/usr/local/python3/lib/python3.11/config-3.11-x86_64-linux-gnu" \
    --enable-fail-if-missing
make
make install
