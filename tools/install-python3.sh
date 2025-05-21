#!/bin/bash

set -e
if [[ $# == 1 ]]; then
  version=$1
else
  version=3.11.12
fi
function add_profile() {
  cat >/etc/profile.d/python3.sh <<EOF
export PATH="/usr/local/python3/bin:\$PATH"
EOF
  source /etc/profile
}

function add_ldconf() {
  cat >/etc/ld.so.conf.d/python3.conf <<EOF
/usr/local/python3/lib
EOF
  ldconfig
}
function set_pip() {
  mkdir ~/.pip
  cat >~/.pip/pip.conf <<EOF
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
EOF
}
yum -y groupinstall "Development tools"
yum install -y ncurses-devel gdbm-devel xz-devel sqlite-devel tk-devel uuid-devel readline-devel bzip2-devel libffi-devel
yum install -y openssl-devel openssl11 openssl11-devel

tar -zxf Python-$version.tgz
if [[ -d ./Python-$version/ ]]; then
  cd ./Python-$version/
  export CFLAGS=$(pkg-config --cflags openssl11)
  export LDFLAGS=$(pkg-config --libs openssl11)
  ./configure --prefix="/usr/local/python3" --enable-shared --enable-optimizations
  make -j $(nproc)
  make install
  add_profile
  add_ldconf
  set_pip
fi
