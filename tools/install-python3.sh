#!/bin/bash

set -e

function add_profile(){
    cat >/etc/profile.d/python3.sh <<EOF
export PATH="/usr/local/python3/bin:\$PATH"
EOF
}

function add_ldconf(){
    cat >/etc/ld.so.conf.d/python3.conf <<EOF
/usr/local/python3/lib
EOF
}

yum -y groupinstall "Development tools"
yum install -y ncurses-devel gdbm-devel xz-devel sqlite-devel tk-devel uuid-devel readline-devel bzip2-devel libffi-devel
yum install -y openssl-devel openssl11 openssl11-devel

tar -zxf  Python-3.10.7.tgz
cd ./Python-3.10.7/
export CFLAGS=$(pkg-config --cflags openssl11)
export LDFLAGS=$(pkg-config --libs openssl11)
./configure --prefix="/usr/local/python3" --enable-shared --enable-optimizations
make
make install
add_profile
add_ldconf
