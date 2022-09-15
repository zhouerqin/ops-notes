#!/bin/bash
set -e
yum install -y make pcre-devel zlib-devel centos-release-scl
yum install -y devtoolset-8-gcc*
yum install -y devtoolset-8-gcc-c++*


