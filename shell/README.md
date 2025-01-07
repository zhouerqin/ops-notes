# Shell 脚本编码规范

## 文件格式
### 文件扩展名
- 可执行脚本不需要扩展名
- 库文件必须使用 `.sh` 扩展名
- 临时文件推荐使用 `.sh` 扩展名

### 文件头
```bash
#!/bin/bash
#
# 简短描述：这个脚本的用途
#
# 详细描述：
# - 功能点1
# - 功能点2
#
# 作者：[你的名字] (you@example.com)
```

## 格式规范
### 缩进
- 使用 2 个空格进行缩进
- 不要使用 tab
- 命令行参数换行时，将参数对齐

```bash
# 正确示例
command arg1 \
       arg2 \
       arg3
```

### 行长度
- 最大行长度为 80 个字符
- 管道命令可以分多行，管道符放在新行开头

```bash
# 正确示例
command1 \
  | command2 \
  | command3
```

## 命名规范
### 变量命名
- 变量名使用小写字母
- 使用下划线分隔单词
- 常量使用大写字母

```bash
# 正确示例
local my_variable="value"
readonly MAX_COUNT=100
```

### 函数命名
- 使用小写字母
- 使用下划线分隔单词
- 使用 `function` 关键字声明（可选）

```bash
# 正确示例
function my_function() {
  ...
}
```

## 命令规范
### 命令替换
- 优先使用 `$(command)` 而不是反引号
- 嵌套时使用 `$(command "$(command)")`

```bash
# 正确示例
files=$(ls -l "$(dirname "$0")")
```

### 测试命令
- 使用 `[[ ... ]]` 而不是 `[ ... ]` 或 test
- 使用引号包裹变量

```bash
# 正确示例
if [[ "${my_var}" == "value" ]]; then
  ...
fi
```

## 安全性
### 变量引用
- 始终使用引号包裹变量
- 使用 `${var}` 而不是 `$var`
- 使用 `set -e` 在错误时退出
- 使用 `set -u` 引用未定义变量时报错

```bash
# 正确示例
readonly MY_PATH="${HOME}/bin"
set -eu
```

### 临时文件
- 使用 mktemp 创建临时文件
- 在脚本退出时清理临时文件

```bash
# 正确示例
temp_file=$(mktemp)
trap 'rm -f "${temp_file}"' EXIT
```

## 注释规范
### 代码注释
- 解释复杂的算法
- 说明不明显的依赖
- 解释特殊情况的处理

```bash
# 正确示例
# 检查输入参数数量
if [[ "$#" -lt 2 ]]; then
  echo "Error: Insufficient arguments"
  exit 1
fi
```

### 函数注释
```bash
# 函数名称：process_file
# 描述：处理给定的文件并输出结果
# 参数：
#   $1 - 输入文件路径
#   $2 - 输出文件路径
# 返回值：
#   0 - 成功
#   1 - 失败
function process_file() {
  ...
}
```

## 错误处理
### 错误检查
- 检查命令返回值
- 使用有意义的错误消息
- 在错误时提供有用的调试信息

```bash
# 正确示例
if ! mkdir -p "${dir_path}"; then
  echo "Error: Failed to create directory ${dir_path}" >&2
  exit 1
fi
```

## 脚本模板
```bash
#!/bin/bash
#
# 简短描述：这个脚本的用途
#
# 详细描述：
# - 功能点1
# - 功能点2
#
# 作者：[你的名字] (you@example.com)

set -eu

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
```

## 参考文档
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [Shell 脚本静态检查工具 ShellCheck](https://www.shellcheck.net/)
