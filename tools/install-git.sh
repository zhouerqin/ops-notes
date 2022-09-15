#!/bin/bash
set -e

function add_profile(){
    cat > /etc/profile.d/git.sh <<EOF
export PATH="/usr/local/git/bin:\$PATH"
EOF
}

function git_init_config(){
    git config --global user.email "zhouerqin@qq.com"
    git config --global user.name "zhouerqin"
    #取消转义，解决git status中文乱码
    git config --global core.quotepath false
    git config --global core.editor vim
    #提交检出均不转换
    git config --global core.autocrlf false
    #提交包含混合换行符的文件时给出警告
    git config --global core.safecrlf warn
    #log显示tag
    git config --global log.decorate short
    #设置log日期格式
    git config --global log.date iso
    git config --global color.ui true
}

if ! which git >/dev/null 2>&1;then
    echo "安装 git 2.37.3"
    yum install -y libcurl-devel
    yum install -y curl-devel
    wget --no-check-certificate https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.37.3.tar.gz
    tar -zxf git-2.37.3.tar.gz
    cd git-2.37.3
    export CFLAGS=$(pkg-config --cflags openssl11)
    export LDFLAGS=$(pkg-config --libs openssl11)
    ./configure --prefix="/usr/local/git"
    make
    make install
    add_profile
    git_init_config
else
    echo "git 已安装"
fi
