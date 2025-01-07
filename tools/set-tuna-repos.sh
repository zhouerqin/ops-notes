#!/bin/bash
#
# 为 CentOS 配置清华大学镜像源
#
# 详细描述：
# - 检测操作系统版本
# - 为 CentOS 7 配置清华大学镜像源
# - 提供错误处理和权限检查
#
# 作者：zhouerqin (zhouerqin@qq.com)

# 遇到错误立即退出，并启用严格模式
set -euo pipefail

# 确保脚本以 root 权限运行
if [[ "${EUID}" -ne 0 ]]; then
  echo "错误：此脚本必须以 root 权限运行" >&2
  exit 1
fi

# 检测操作系统版本
readonly os_version=$(. /etc/os-release && echo "${ID}/${VERSION_ID}")

# 设置镜像源的主函数
set_tuna_repos() {
  local current_os_version="$1"

  case "${current_os_version}" in
    centos/7)
      echo "操作系统：${current_os_version}"
      echo "设置镜像源 - 清华大学开源镜像站"
      
      # 在修改前验证仓库文件目录是否存在
      if [[ ! -d /etc/yum.repos.d ]]; then
        echo "错误：未找到 Yum 仓库目录" >&2
        return 1
      fi

      # 使用安全的 sed 进行备份和替换
      sed -i.bak \
        -e 's|^mirrorlist=|#mirrorlist=|g' \
        -e 's|^#baseurl=http://mirror.centos.org/centos/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/7.9.2009|g' \
        -e 's|^#baseurl=http://mirror.centos.org/\$contentdir/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/7.9.2009|g' \
        /etc/yum.repos.d/CentOS-*.repo
      
      # 验证 sed 操作是否成功
      if [[ $? -ne 0 ]]; then
        echo "错误：修改仓库文件失败" >&2
        return 1
      fi
      ;;
    *)
      echo "不支持的操作系统：${current_os_version}" >&2
      return 1
      ;;
  esac
}

# 执行主逻辑
main() {
  set_tuna_repos "${os_version}"
}

# 运行主函数
main "$@"
