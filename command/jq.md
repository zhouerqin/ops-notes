# jq 命令

## 常用选项
- `-R, --raw-input`: 不解析 JSON 输入，每行文本作为字符串传递
- `-r, --raw-output`: 输出原始字符串，不添加 JSON 引号

## 常用示例
```bash
# 解析 JSON 并格式化输出
echo '{"name": "test"}' | jq '.'

# 读取普通文本并转为 JSON
echo 'hello' | jq -R '.'

# 提取字符串值时不带引号
echo '{"name": "test"}' | jq -r '.name'
```

## 参考文档
- jq 手册：<https://jqlang.github.io/jq/manual/>
