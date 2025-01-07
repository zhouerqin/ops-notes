# Shell 脚本规范

## 基本规范
1. 只用于小功能或简单包装脚本
2. 总是检查命令退出码
3. 使用标准输出传递变量
4. 保持脚本幂等性
5. 包含 help 函数

## 脚本模板
```bash
#!/bin/bash
set -e

# 显示帮助信息
function help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h    显示帮助信息"
    exit 1
}

# 参数解析
while getopts "h" opt; do
    case $opt in
        h)
            help
            ;;
        \?)
            help
            ;;
    esac
done

# 主要逻辑
main() {
    # 检查命令返回值
    if ! command; then
        echo "Error: command failed"
        exit 1
    fi
}

main "$@"
