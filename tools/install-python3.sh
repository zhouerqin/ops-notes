#!/bin/bash
#
# 在 CentOS 7 上从源码编译安装 Python 3.14
# 依赖：gcc 11+（devtoolset-11）、OpenSSL 3.5 LTS
#

set -euo pipefail

trap 'echo "错误：第 $LINENO 行失败，运行方式如右：./install-python3.sh 2>&1 | tee install.log" >&2' ERR

if [[ $# == 1 ]]; then
  version=$1
else
  version=3.14.6
fi
function add_profile() {
  cat >/etc/profile.d/python3.sh <<EOF
export PATH="/usr/local/python3/bin:\$PATH"
EOF
}

function add_ldconf() {
  cat >/etc/ld.so.conf.d/python3.conf <<EOF
/usr/local/python3/lib
EOF
  ldconfig
}
function set_pip() {
  mkdir -p ~/.pip
  cat >~/.pip/pip.conf <<EOF
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
EOF
}
function install_openssl() {
  local openssl_version=3.5.7
  if [[ -d /usr/local/ssl ]]; then
    echo "OpenSSL ${openssl_version} 已安装，跳过编译"
    return
  fi
  echo "==> 编译 OpenSSL ${openssl_version}（约 5-15 分钟，取决于 CPU 核数）..."
  if [[ ! -f openssl-${openssl_version}.tar.gz ]]; then
    wget -q https://github.com/openssl/openssl/releases/download/openssl-${openssl_version}/openssl-${openssl_version}.tar.gz
  fi
  tar -zxf openssl-${openssl_version}.tar.gz
  cd openssl-${openssl_version}
  ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib
  make -j $(nproc)
  make install
  cd ..
  echo "/usr/local/ssl/lib64" > /etc/ld.so.conf.d/openssl3.conf
  ldconfig
  export PATH="/usr/local/ssl/bin:$PATH"
  export PKG_CONFIG_PATH="/usr/local/ssl/lib64/pkgconfig:/usr/local/ssl/lib/pkgconfig:$PKG_CONFIG_PATH"
  echo "OpenSSL ${openssl_version} 编译安装完成"
}

function install_python() {
  if [[ -f /usr/local/python3/bin/python3 ]]; then
    local installed_version
    installed_version=$(/usr/local/python3/bin/python3 --version 2>&1 | awk '{print $2}')
    echo "Python ${installed_version} 已安装，跳过编译"
    set_pip
    return
  fi
  echo "==> 编译 Python ${version}（启用 PGO 优化，约 10-30 分钟，期间会运行性能测试，请耐心等待）..."
  if [[ ! -f Python-$version.tgz ]]; then
    wget -q https://mirrors.aliyun.com/python-release/source/Python-$version.tgz
  fi
  tar -zxf Python-$version.tgz
  cd Python-$version/
  export CFLAGS="-I/usr/local/ssl/include"
  export LDFLAGS="-L/usr/local/ssl/lib64 -Wl,-rpath,/usr/local/ssl/lib64"
  ./configure --prefix="/usr/local/python3" --enable-shared --enable-optimizations --with-system-ffi --with-openssl=/usr/local/ssl --with-openssl-rpath=auto
  make -j $(nproc)
  make install
  cd ..
  add_profile
  add_ldconf
  set_pip
  echo "Python ${version} 编译安装完成"
}

function fix_scl_repo() {
  local repo_file
  for repo_file in /etc/yum.repos.d/CentOS-SCLo-*.repo; do
    [[ -f "${repo_file}" ]] || continue
    if ! grep -q "^mirrorlist=" "${repo_file}"; then
      echo "$(basename ${repo_file}) 已修复，跳过"
      continue
    fi
    echo "==> 修复 $(basename ${repo_file})..."
    cp "${repo_file}" "${repo_file}.bak"
    sed -i 's|^mirrorlist=|#mirrorlist=|g' "${repo_file}"
    sed -i 's|^# *baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' "${repo_file}"
  done
}

echo "==> 安装开发工具包（yum groupinstall，约 2-5 分钟）..."
yum -y -q groupinstall "Development tools"
yum install -y -q centos-release-scl
fix_scl_repo
echo "==> 安装 devtoolset-11 GCC 11+（约 2-5 分钟）..."
yum install -y -q devtoolset-11-gcc devtoolset-11-gcc-c++
yum install -y -q ncurses-devel gdbm-devel xz-devel sqlite-devel tk-devel uuid-devel readline-devel bzip2-devel libffi-devel zlib-devel perl perl-IPC-Cmd perl-Time-Piece

source /opt/rh/devtoolset-11/enable
install_openssl
install_python

echo ""
echo "============================================"
echo " Python ${version} 安装完成！"
echo " 安装路径：/usr/local/python3"
echo "============================================"
echo ""
echo "重要：请注销当前会话后重新登录，或执行以下命令使 PATH 生效："
echo "  source /etc/profile.d/python3.sh"
echo ""
echo "如果遇到动态库链接问题，请执行：ldconfig"
