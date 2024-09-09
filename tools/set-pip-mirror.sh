#!/bin/bash
#
#
if [[ !-d ~/.pip ]];then
  mkdir -p ~/.pip
fi

cat <<EOF > ~/.pip/pip.conf
[global]
index-url=http://mirrors.cloud.aliyuncs.com/pypi/simple/

[install]
trusted-host=mirrors.cloud.aliyuncs.com
EOF
