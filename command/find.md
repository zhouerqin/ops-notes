# find 命令

## 显示相对路径
```bash
# 移除命令行参数的路径前缀，只显示相对路径
find . -type f -printf "%P\n"
```

## 参考文档
- GNU Find 手册：<https://www.gnu.org/software/findutils/manual/html_mono/find.html#Format-Directives>
