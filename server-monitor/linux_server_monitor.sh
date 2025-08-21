#!/bin/bash

# 服务器资源统计脚本
# 统计CPU、内存和硬盘使用情况

echo "===== 服务器资源使用情况统计 ======"
echo "日期时间: $(date '+%Y-%m-%d %H:%M:%S')"

# 服务器信息
 echo -e "\n===== 服务器信息 ======"
 echo "主机名: $(hostname)"
 # 操作系统信息
 echo "操作系统: $(grep '^NAME=' /etc/os-release | cut -d '=' -f2 | tr -d '"') $(grep '^VERSION=' /etc/os-release | cut -d '=' -f2 | tr -d '"')"

# 内网IP (只显示第一个非回环IP)
echo -n "内网IP: "
INTERNAL_IP=$(hostname -I | cut -d " " -f1)
if [ -n "$INTERNAL_IP" ]; then
    echo "$INTERNAL_IP"
else
    echo "未获取到"
fi

# 外网IP
echo -n "外网IP: "
EXTERNAL_IP=$(curl -s -m 5 http://ipinfo.io/ip)
if [ -n "$EXTERNAL_IP" ]; then
    echo "$EXTERNAL_IP"
else
    echo "无法获取(超时或网络错误)"
fi


echo -e "\n===== CPU使用情况 ======"
echo "逻辑核数量: $(nproc)"
# 使用top命令获取CPU使用率
top -bn1 | grep "%Cpu" | awk '{print "用户空间: " $2 "%", "系统空间: " $4 "%", "空闲: " $8 "%"}'
echo ""

echo -e "\n===== 内存使用情况 ======"
# 显示总内存、已用内存、空闲内存、可用内存和使用率
free -b | awk 'NR==2 {total=$2; used=$3; free=$4; avail=$7; usage=used/total*100; printf "总内存: %.2fGi, 已用: %.2fGi, 空闲: %.2fGi, 可用: %.2fGi, 使用率: %.1f%%\n", total/1024/1024/1024, used/1024/1024/1024, free/1024/1024/1024, avail/1024/1024/1024, usage}'

# 解释: 在Linux中，"空闲"是完全未使用的内存，"可用"包含空闲内存和可释放的缓存/缓冲区
echo ""

echo -e "\n===== 硬盘使用情况 ======"
df -x devtmpfs -x tmpfs -x overlay -h | awk '$NF=="/" {print "/: " $2 " 总容量, " $3 " 已用, " $4 " 可用, " $5 " 使用率"}'
df -x devtmpfs -x tmpfs -x overlay -h | grep -v '^Filesystem' | grep -v '/$' | grep -v '/boot' | awk '{print $6 ": " $2 " 总容量, " $3 " 已用, " $4 " 可用, " $5 " 使用率"}'
echo ""

echo -e "\n===== 统计结束 ======"