#!/bin/bash

prefix=/usr/local/cmake

function add_profile(){
    cat > /etc/profile.d/cmake.sh <<EOF
export PATH="$prefix/bin:\$PATH"
EOF
}

if [[ -d $prefix ]];then
    echo "$prefix 已存在，跳过安装"
    exit 0
fi

if [[ -f cmake-3.24.1-linux-x86_64.tar.gz ]];then
    tar -zxf cmake-3.24.1-linux-x86_64.tar.gz
    mv cmake-3.24.1-linux-x86_64 /usr/local/cmake
    add_profile
else
    echo "未找到安装包" >&2
    exit 1
fi
