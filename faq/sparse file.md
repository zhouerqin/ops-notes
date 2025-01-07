# 稀疏文件 (Sparse File)

## 创建稀疏文件
```bash
# 创建 1GB 的稀疏文件
truncate -s 1G sparse.img

# 或使用 dd
dd if=/dev/zero of=sparse.img bs=1 count=0 seek=1G
```

## 检查稀疏文件
```bash
# 查看实际占用空间
ls -lsh sparse.img

# 查看是否是稀疏文件
du -h sparse.img
```

## tar 存档稀疏文件
```bash
# 创建存档时保持稀疏性
tar -S -czf archive.tar.gz sparse.img

# 或使用长选项
tar --sparse --create --gzip --file=archive.tar.gz sparse.img
```

## 参考文档
- 稀疏文件介绍：<https://zh.wikipedia.org/wiki/%E7%A8%80%E7%96%8F%E6%96%87%E4%BB%B6>
- Arch Linux 指南：<https://wiki.archlinux.org/title/Sparse_file>
