# xargs 命令

## -r 参数说明

`-r` 或 `--no-run-if-empty` 参数用于控制 xargs 在标准输入为空时的行为。当使用此参数时，如果标准输入为空（即没有任何输入数据），xargs 将不会执行后面的命令。

### 使用场景

- 批量文件处理时，避免在没有匹配文件的情况下执行命令
- 处理可能为空的管道输入
- 编写更安全的自动化脚本

### 示例

```bash
# 不使用 -r 参数，即使没有找到文件也会执行 rm 命令
find . -name "*.temp" | xargs rm

# 使用 -r 参数，只有找到文件时才执行 rm 命令
find . -name "*.temp" | xargs -r rm
```

## 参考文档
- GNU Findutils 手册：<https://www.gnu.org/software/findutils/manual/html_mono/find.html#xargs-options>
- Linux 手册页：<https://man7.org/linux/man-pages/man1/xargs.1.html>