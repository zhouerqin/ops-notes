# sed

> 用脚本方式编辑文本。
> 更多信息： <https://www.gnu.org/software/sed/manual/sed.html>。

- 将所有输入行中出现的 `apple`（基本 regex）替换为 `mango`（基本 regex），并将结果打印到 `stdout`：

`{{command}} | sed 's/apple/mango/g'`

- 执行特定的脚本 [f]，并将结果打印到 `stdout`：

`{{command}} | sed -f {{path/to/script.sed}}`

- 将所有输入行中出现的 "apple"（扩展 regex）替换为 "APPLE"（扩展 regex），并将结果打印到 `stdout`：

`{{command}} | sed -E 's/(apple)/\U\1/g'`

- 只打印第一行到 `stdout`：

`{{command}} | sed -n '1p'`

- 用 "mango"（基本 regex）替换特定文件中出现的所有 "apple"（基本 regex），并覆盖原文件：

`sed -i 's/apple/mango/g' {{path/to/file}}`

- 在匹配行后插入另一个文件

`sed -i '/apple/r other.txt' file.txt`
