#!/bin/bash
#
#

OS_VERSION=$(. /etc/os-release && echo $ID/$VERSION_ID)

case $OS_VERSION in
centos/7)
  echo "操作系统: $OS_VERSION"
  echo "设置镜像源-清华大学开源软件镜像站"
  sed -e "s|^mirrorlist=|#mirrorlist=|g" \
    -e "s|^#baseurl=http://mirror.centos.org/centos/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/7.9.2009|g" \
    -e "s|^#baseurl=http://mirror.centos.org/\$contentdir/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/7.9.2009|g" \
    -i.bak \
    /etc/yum.repos.d/CentOS-*.repo
  ;;
*)
  echo "不支持的操作系统 $OS_VERSION"
  exit 1
  ;;
esac
