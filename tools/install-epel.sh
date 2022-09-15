#!/bin/bash

if [[ ! -f /etc/yum.repos.d/epel.repo ]];then
    echo "add epel repo"
    wget -O /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo
fi
