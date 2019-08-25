---
title: Hexo 插入 LaTeX 公式
tags:
- Hexo
category:
- LaTeX
mathjax: true
---

本文摘自 https://www.sail.name/2018/05/31/use-mathjax-in-hexo/.

> MathJax is an open-source JavaScript display engine for LaTeX, MathML, and AsciiMath notation that works in all modern browsers。

理论上方法是多种多样的，但我试了很多都不行~~不排除我太菜了，不会搞的可能~~

目前的方法摘自 https://github.com/viosey/hexo-theme-material/issues/604.

1. 在主题配置文件里加入：

```yml
vendors:

    # MathJax 2.7.0-2.7.1
    mathjax: https://cdn.bootcss.com/mathjax/2.7.0/MathJax.js
```

2. 在用到mathjax的Markdown文档的front-matter里填入`mathjax: true`即可。

{% post_link LaTeX数学公式学习笔记 测试 %}

预览：

`Simple inline $a = b + c$.`

Simple inline $a = b + c$.

`$$\frac{|ax + by + c|}{\sqrt{a^{2}+b^{2}}}$$`

$$\frac{|ax + by + c|}{\sqrt{a^{2}+b^{2}}}$$

3. 具体 LaTeX 语法见[博客：LaTeX数学公式学习笔记](../LaTeX数学公式学习笔记)

4. 值得注意的是，LaTeX换行中行末需要`\\`，由于 Markdown 和 Mathjax 进行了两次渲染，所以需要`\\\\`。
5. 另外空格后面接的`_`有时也会被 Markdown 转义掉，导致无法被 Mathjax 渲染，因此有些时候需要在`_`前添加`\`转义。
    ~~具体什么时候发生不清楚，但是可以观察 markdown 编辑器的染色情况判断`_`是否被转义~~

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
