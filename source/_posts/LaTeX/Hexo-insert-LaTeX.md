---
title: Hexo 插入 LaTeX 公式
date: 2019-10-15
tags:
- Hexo
- LaTeX
category:
- LaTeX
mathjax: true
---

## 使用 MathJax 渲染 Hexo 中的数学公式

本文摘自 https://www.sail.name/2018/05/31/use-mathjax-in-hexo/.

> MathJax is an open-source JavaScript display engine for LaTeX, MathML, and AsciiMath notation that works in all modern browsers。

理论上方法是多种多样的，都是基于 MathJax 的。但我试了很多都不行~~不排除我太菜了，不会搞的可能~~

目前的方法摘自 https://github.com/viosey/hexo-theme-material/issues/604.

1. 在主题配置文件里加入：

```yml
vendors:

    # MathJax 2.7.0-2.7.1
    mathjax: https://cdn.bootcss.com/mathjax/2.7.0/MathJax.js
```

2. 在用到 mathjax 的 Markdown 文档的 front-matter 里填入`mathjax: true`即可。

```
---
title: Hexo 插入 LaTeX 公式
tags:
- Hexo
- LaTeX
category:
- LaTeX
mathjax: true
---
```

预览：

`Simple inline $a = b + c$.`

Simple inline $a = b + c$.

`$$\frac{|ax + by + c|}{\sqrt{a^{2}+b^{2}}}$$`

$$\frac{|ax + by + c|}{\sqrt{a^{2}+b^{2}}}$$

## 使用 MathJaX 注意

1. 具体 LaTeX 语法见[博客：LaTeX数学公式学习笔记](../LaTeX-math-equation)

2. 值得注意的是，LaTeX 中本来就存在的 `\` 在 MathJax 都需要替换为 `\\`，如换行为 `\\\\`，范数的 `\|` 在 MathJax 中应为 `\\|`。这个问题是 Markdown 和 MathJax 双重渲染造成的。

3. 而对于某些 Markdown 中的符号（指的就是一对 `*` 和 `_`），这个时候需要一个 `\` 来进行转义。

这里转义的目的是使得 Markdown 不把他识别为关键字，而上面的 `\\` 可以理解为先在 Markdown 中渲染在 `\`，然后进行 MathJax 编译的时候再理解为 LaTeX 转义符。

```latex
\begin{equation}
\begin{split}
x&=a+b+c\\\\
&=d+e\\\\
&=f+g
\end{split}
\end{equation}
```

\begin{equation}
\begin{split}
x&=a+b+c\\\\
&=d+e\\\\
&=f+g
\end{split}
\end{equation}
