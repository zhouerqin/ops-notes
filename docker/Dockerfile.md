# Dockerfile 指令

## RUN 指令
### Shell 格式
```dockerfile
# 单行命令
RUN echo "hello world"

# 多行命令，使用 \
RUN echo "hello world"; \
    echo "hello 123"

# 多行命令，使用 heredoc
RUN <<EOF bash
echo "hello world"
echo "hello 123"
EOF

# 多行命令，带错误检查
RUN <<EOF bash -ex
echo "hello world"
echo "hello 123"
EOF
```

### Exec 格式
```dockerfile
RUN ["executable", "param1", "param2"]
```

## COPY 指令

COPY 指令用于将文件或目录从 *构建上下文* 复制到镜像中。

### 基本复制
```dockerfile
# 复制单个文件到容器的指定路径
COPY file.txt /app/

# 复制多个文件
COPY file1.txt file2.txt /app/

# 复制整个目录
COPY src/ /app/
```

### 使用通配符
```dockerfile
# 复制所有 .py 文件
COPY *.py /app/

# 复制所有 txt 文件到特定目录
COPY *.txt /logs/
```

### 带权限和所有者的复制
```dockerfile
# 复制并设置文件权限
COPY --chown=myuser:mygroup app.py /app/

# 复制目录并设置权限
COPY --chown=1001:1001 src/ /app/
```

### 复制并重命名
```dockerfile
# 复制并重命名文件
COPY source.txt /app/destination.txt

# 复制目录并重命名
COPY source-dir/ /app/new-dir/
```

### 使用多行和特殊内容复制
```dockerfile
# 使用 here-document 风格创建文件并复制
COPY <<EOF /app/config.json
{
    "name": "example-app",
    "version": "1.0.0",
    "settings": {
        "debug": true,
        "log_level": "info"
    }
}
EOF

# 复制多行文本文件
COPY <<-EOT /app/README.md
    # 项目说明
    
    这是一个多行
    自动生成的文件
    包含详细说明
EOT

# 使用 printf 结合 COPY 创建文件
COPY <<EOF /app/entrypoint.sh
#!/bin/bash
echo "Starting application..."
python /app/main.py
chmod +x /app/entrypoint.sh
EOF
```

### 注意事项
- COPY 指令只能复制构建上下文中的文件
- 目标路径不存在时会自动创建
- 使用 `.dockerignore` 可以排除不需要复制的文件
- 对于需要解压或更复杂的文件处理，可以结合 RUN 指令
- Docker 17.06 及更高版本支持 COPY 的多行内容
- 对于复杂的文件生成，通常建议使用 RUN 指令
- 确保 Dockerfile 语法符合 Docker 构建规范

## 参考文档
- Dockerfile 参考：<https://docs.docker.com/engine/reference/builder/>
- Docker COPY 指令：<https://docs.docker.com/engine/reference/builder/#copy>
- 最佳实践：<https://docs.docker.com/develop/develop-images/dockerfile_best-practices/>
