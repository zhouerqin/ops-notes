# jq

> jq是一个轻量级且灵活的命令行 JSON 处理器
> 更多信息: <https://jqlang.github.io/jq/manual/>

* --raw-input / -R:

不以 JSON 格式解析输入。相反，每行文本都以字符串形式传递给过滤器。

* --raw-output / -r:

使用该选项后，如果过滤器的结果是字符串，它将直接写入标准输出，而不是格式化为带引号的 JSON 字符串。这对 jq 过滤器与非基于 JSON 的系统对话非常有用。
