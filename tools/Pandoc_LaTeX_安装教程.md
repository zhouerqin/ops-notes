# Pandoc + LaTeX 模板安装教程

> **适用环境**：Debian / Ubuntu Linux  
> **最后更新**：2026-03-26  
> **预计耗时**：15-30 分钟（取决于网络和 TeX Live 安装速度）

---

## 目录

- [1. 概述](#1-概述)
- [2. 安装 Pandoc](#2-安装-pandoc)
- [3. 安装 TeX Live (XeLaTeX)](#3-安装-tex-live-xelatex)
- [4. 安装 Eisvogel 模板](#4-安装-eisvogel-模板)
- [5. 编写测试文档](#5-编写测试文档)
- [6. 转换为 PDF](#6-转换为-pdf)
- [7. 验证输出](#7-验证输出)
- [8. 常见问题排查](#8-常见问题排查)
- [9. 进阶用法](#9-进阶用法)

---

## 1. 概述

**Pandoc** 是一款通用的文档格式转换工具，被誉为"文档界的瑞士军刀"。结合 **LaTeX** 引擎和精美的模板（如 Eisvogel），你可以用 Markdown 编写内容，一键生成排版精美的 PDF 文档。

### 工具链说明

```
Markdown (.md) → Pandoc → XeLaTeX → PDF (.pdf)
                         ↑
                    Eisvogel 模板
```

### 为什么选择这套方案？

| 特性 | 说明 |
|------|------|
| **中文支持** | XeLaTeX 原生支持 Unicode，配合中文字体完美排版 |
| **模板美观** | Eisvogel 提供现代风格的学术/技术文档模板 |
| **写作高效** | 用 Markdown 写作，专注内容而非排版 |
| **可重复构建** | 纯命令行工作流，易于自动化和版本控制 |

---

## 2. 安装 Pandoc

### 2.1 通过包管理器安装

```bash
sudo apt update && sudo apt install -y pandoc
```

### 2.2 验证安装

![检查 Pandoc 版本](screenshots/01_pandoc_version.png)

```bash
pandoc --version
```

> **说明**：建议安装 Pandoc 2.x 或更高版本。本教程基于 Pandoc 3.1.11.1 编写。

---

## 3. 安装 TeX Live (XeLaTeX)

TeX Live 是一个完整的 LaTeX 发行版。我们只需要安装 XeLaTeX 相关的包。

### 3.1 安装核心包

```bash
sudo apt update && sudo apt install -y \
  texlive-xetex \
  texlive-lang-chinese \
  texlive-latex-extra \
  texlive-fonts-recommended \
  texlive-science
```

![安装 TeX Live](screenshots/02_install_texlive.png)

> **[!NOTE] 注意**：TeX Live 完整安装包非常大（约 5-8 GB）。上述命令只安装必要的子集，大约 500MB-1GB。如果网络较慢，可以泡杯咖啡等一等。

### 3.2 各包用途说明

| 包名 | 用途 |
|------|------|
| `texlive-xetex` | XeLaTeX 引擎，支持 Unicode 和系统字体 |
| `texlive-lang-chinese` | 中文排版支持（ctex 宏包等） |
| `texlive-latex-extra` | 额外的 LaTeX 宏包（Eisvogel 模板依赖） |
| `texlive-fonts-recommended` | 推荐字体集 |
| `texlive-science` | 科学排版宏包（数学公式、表格等） |

### 3.3 验证 XeLaTeX

![验证 XeLaTeX](screenshots/03_xelatex_version.png)

```bash
xelatex --version
```

---

## 4. 安装 Eisvogel 模板

[Eisvogel](https://github.com/Wandmalfarbe/pandoc-latex-template) 是一款精美的 Pandoc LaTeX 模板，适合生成技术文档、报告和简历。

### 4.1 创建模板目录

Pandoc 默认在 `~/.local/share/pandoc/templates/` 下查找用户模板。

![创建模板目录](screenshots/04_create_template_dir.png)

```bash
mkdir -p ~/.local/share/pandoc/templates
```

### 4.2 下载模板

![下载 Eisvogel](screenshots/05_download_eisvogel.png)

```bash
cd /tmp && git clone https://github.com/Wandmalfarbe/pandoc-latex-template.git
```

### 4.3 安装模板到 Pandoc 目录

![安装模板](screenshots/06_install_template.png)

```bash
cp /tmp/pandoc-latex-template/eisvogel.tex \
  ~/.local/share/pandoc/templates/eisvogel.latex
```

> **说明**：Pandoc 查找模板时会自动添加 `.latex` 后缀，所以文件名是 `eisvogel.latex`，使用时只需指定 `--template=eisvogel`。

### 4.4 清理临时文件

```bash
rm -rf /tmp/pandoc-latex-template
```

---

## 5. 编写测试文档

创建一个测试用的 Markdown 文件，验证整个工具链是否正常工作。

![创建测试文件](screenshots/07_create_test_md.png)

```bash
cat > test.md << 'EOF'
---
title: "Pandoc + LaTeX 快速入门"
author: "周二琴"
date: \today
lang: zh-CN
template: eisvogel
toc: true
numbersections: true
---

# 引言

这是一篇使用 **Pandoc** 和 **Eisvogel** 模板生成的示例文档。

## 功能特性

- 支持 Markdown 语法编写
- 自动生成目录
- 中文排版支持

## 代码示例

```python
def hello():
    print("Hello, Pandoc!")
```

## 数学公式

行内公式：$E = mc^2$

行间公式：

$$
\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}
$$
EOF
```

> **说明**：YAML Front Matter（`---` 之间的内容）用于控制文档元数据和模板参数。

### Front Matter 参数说明

| 参数 | 说明 |
|------|------|
| `title` | 文档标题 |
| `author` | 作者 |
| `date` | 日期，`\today` 表示当前日期 |
| `lang` | 语言，`zh-CN` 启用中文排版规则 |
| `template` | 使用的模板名称 |
| `toc` | 是否生成目录 |
| `numbersections` | 是否为章节编号 |

---

## 6. 转换为 PDF

![转换为 PDF](screenshots/08_convert_to_pdf.png)

```bash
pandoc test.md -o test.pdf \
  --pdf-engine=xelatex \
  -V CJKmainfont="Noto Sans CJK SC" \
  -V geometry:margin=1in
```

### 参数说明

| 参数 | 说明 |
|------|------|
| `test.md` | 输入的 Markdown 文件 |
| `-o test.pdf` | 输出的 PDF 文件名 |
| `--pdf-engine=xelatex` | 使用 XeLaTeX 作为 PDF 渲染引擎 |
| `-V CJKmainfont=...` | 指定中文主字体 |
| `-V geometry:margin=1in` | 设置页边距为 1 英寸 |

> **[!NOTE] 注意**：`CJKmainfont` 的值必须是系统中已安装的字体名称。使用 `fc-list :lang=zh` 查看可用中文字体。

---

## 7. 验证输出

![验证输出](screenshots/09_verify_output.png)

```bash
ls -lh test.pdf
file test.pdf
```

如果一切正常，你会看到生成的 PDF 文件，用 PDF 阅读器打开即可查看效果。

---

## 8. 常见问题排查

![常见问题排查](screenshots/10_troubleshooting.png)

### 8.1 中文字体缺失

**症状**：PDF 中中文显示为方块或空白。

**解决**：

```bash
# 查看已安装的中文字体
fc-list :lang=zh

# 安装 Google Noto 中文字体（推荐）
sudo apt install -y fonts-noto-cjk

# 刷新字体缓存
fc-cache -fv
```

### 8.2 模板找不到

**症状**：`pandoc: template not found: eisvogel`

**解决**：

```bash
# 确认模板文件存在
ls ~/.local/share/pandoc/templates/eisvogel.latex

# 如果不存在，重新安装（参见第 4 节）
```

### 8.3 LaTeX 宏包缺失

**症状**：编译报错 `! LaTeX Error: File 'xxx.sty' not found.`

**解决**：

```bash
# 搜索并安装缺失的宏包
apt search texlive- | grep xxx

# 或者安装完整的 texlive-latex-extra
sudo apt install -y texlive-latex-extra
```

### 8.4 XeLaTeX 编译超时

**症状**：首次编译非常慢（超过 5 分钟）。

**说明**：XeLaTeX 首次运行时会缓存字体信息，后续编译会快很多。耐心等待即可。

### 8.5 目录不显示

**解决**：确保 Front Matter 中设置了 `toc: true`，并且文档至少包含一级标题（`#`）。

---

## 9. 进阶用法

### 9.1 自定义 Eisvogel 主题

Eisvogel 支持通过 YAML 变量自定义外观：

```yaml
---
titlepage: true
titlepage-color: "2C3E50"
titlepage-text-color: "FFFFFF"
titlepage-rule-color: "FFFFFF"
titlepage-rule-height: 2
colorlinks: true
linkcolor: "Blue"
header-includes:
  - \usepackage{booktabs}
---
```

### 9.2 创建 Shell 别名

将常用命令封装为别名，写入 `~/.bashrc`：

```bash
# 添加到 ~/.bashrc
alias md2pdf='pandoc $1 -o ${1%.md}.pdf \
  --pdf-engine=xelatex \
  -V CJKmainfont="Noto Sans CJK SC" \
  -V geometry:margin=1in \
  --template=eisvogel \
  --toc \
  --highlight-style=tango'

# 使其生效
source ~/.bashrc

# 使用
md2pdf test.md
```

### 9.3 批量转换

```bash
for f in *.md; do
  pandoc "$f" -o "${f%.md}.pdf" \
    --pdf-engine=xelatex \
    -V CJKmainfont="Noto Sans CJK SC" \
    --template=eisvogel
done
```

### 9.4 输出其他格式

Pandoc 不仅支持 PDF，还可以输出多种格式：

```bash
# 输出 Word 文档
pandoc test.md -o test.docx

# 输出 HTML
pandoc test.md -o test.html --standalone --mathjax

# 输出 EPUB 电子书
pandoc test.md -o test.epub

# 输出 Reveal.js 幻灯片
pandoc test.md -o slides.html -t revealjs
```

### 9.5 其他推荐模板

| 模板 | 适用场景 | 地址 |
|------|----------|------|
| **Eisvogel** | 通用技术文档、报告 | [GitHub](https://github.com/Wandmalfarbe/pandoc-latex-template) |
| **Typst** | 现代排版系统（Pandoc 3.x 支持） | [typst.app](https://typst.app) |
| **Corporate** | 企业风格文档 | 通过 `--template` 自定义 |

---

## 附录：一键安装脚本

将以下内容保存为 `setup_pandoc.sh` 并执行：

```bash
#!/bin/bash
set -e

echo "=== 安装 Pandoc ==="
sudo apt update && sudo apt install -y pandoc

echo "=== 安装 TeX Live ==="
sudo apt install -y \
  texlive-xetex \
  texlive-lang-chinese \
  texlive-latex-extra \
  texlive-fonts-recommended \
  texlive-science \
  fonts-noto-cjk

echo "=== 安装 Eisvogel 模板 ==="
mkdir -p ~/.local/share/pandoc/templates
cd /tmp
git clone https://github.com/Wandmalfarbe/pandoc-latex-template.git
cp pandoc-latex-template/eisvogel.tex \
  ~/.local/share/pandoc/templates/eisvogel.latex
rm -rf pandoc-latex-template

echo "=== 验证安装 ==="
echo "Pandoc: $(pandoc --version | head -1)"
echo "XeLaTeX: $(xelatex --version | head -1)"
echo ""
echo "✓ 安装完成！"
```

```bash
chmod +x setup_pandoc.sh
./setup_pandoc.sh
```

---

> **参考链接**
> - [Pandoc 官方文档](https://pandoc.org/MANUAL.html)
> - [Eisvogel 模板文档](https://github.com/Wandmalfarbe/pandoc-latex-template)
> - [TeX Live 官网](https://www.tug.org/texlive/)
> - [XeLaTeX 中文排版指南](https://www.ctan.org/pkg/ctex)
