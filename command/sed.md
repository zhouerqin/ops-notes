# sed 命令

## 文本替换
```bash
# 将所有输入行中出现的 apple（基本 regex）替换为 mango
{{command}} | sed 's/apple/mango/g'

# 使用扩展正则表达式替换并转换大小写
{{command}} | sed -E 's/(apple)/\U\1/g'
```

## 文件编辑
```bash
# 替换特定文件中的文本并覆盖原文件
sed -i 's/apple/mango/g' {{path/to/file}}

# 在匹配行后插入另一个文件内容
sed -i '/apple/r other.txt' file.txt
```

## 特殊操作
```bash
# 执行特定的 sed 脚本文件
{{command}} | sed -f {{path/to/script.sed}}

# 只打印第一行
{{command}} | sed -n '1p'
```

## 参考文档
- GNU sed 手册：<https://www.gnu.org/software/sed/manual/sed.html>
