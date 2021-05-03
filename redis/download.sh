#!/bin/bash
cd roles/redis/files
REDIS_PACKAGENAME=redis-6.2.2.tar.gz
if [ -f $REDIS_PACKAGENAME ]
then
    echo "$REDIS_PACKAGENAME 文件已下载"
else
    echo "正在下载文件$REDIS_PACKAGENAME"
    curl -O https://repo.huaweicloud.com/redis/$REDIS_PACKAGENAME
fi
