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

## 参考文档
- Dockerfile 参考：<https://docs.docker.com/engine/reference/builder/>
- 最佳实践：<https://docs.docker.com/develop/develop-images/dockerfile_best-practices/>
