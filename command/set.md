# set

> 设置所使用shell的执行方式，可依照不同的需求来做设置。
> 更多信息： <https://man7.org/linux/man-pages/man1/set.1p.html>。

- 命令执行失败退出shell脚本：

`set -e`

- 调试或跟踪执行状态：

`set -x`

- 禁止重定向覆盖:

`set -C`

- 设置环境变量
`set -a`

- 打开

example

- 脚本文件常用选项

`set -eux -o pipefail`

- 加载env文件
```bash
set -a
source .env
set +a
```
