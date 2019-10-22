---
title: LaTeX 基础
tags:
- 课程笔记
category:
- LaTeX
mathjax: true
---

## LaTeX 简介

~~课上抄的~~

> LaTeX 是：
> 1. 一个以排版文章以及数学公式为目标的计算机程序
> 2. 充当了文档设计者和排版者
> 3. 与 Word 等所见即所得的方式有着巨大区别
> 4. 强制使用者声明文档的逻辑结构，避免版式错误
>
> LaTeX 与 Word 区别
> 1. Word 所遵循的思想是“**所见即所得**”，输出的文档效果与屏幕上显示一致， LateX 所遵循的思想是“**所想即所得**”，它有非常强大的功能，但入门学习要难于 Word，用 LaTeX 编写页面与最终得到的 pdf 有着较大的区别
> 2. 从美学观点来看，由于 LaTeX 强大的排版功能，尤其是强大的数学公式编辑功能，使得 LaTeX 排版出来的文档美观性一般强于 Word，这点在科技文档中尤为明显。此外，在编辑一份含大量公式的文档时，LaTeX 的稳定性高于 Word。
> 3. 完成一篇篇幅较长，含有很多插图，表格和公式的论文后，一旦论文需要修改，Word 在排版上会发生巨大的工作量，而 LaTeX 的工作量则要小得多。
> 4. 大部分国内外杂志，要求寄去的文章按 LateX 格式排版，国内越来越多的学校开始鼓励毕业论文采用 LaTeX 编写。

### 编译器、IDE 及 参考书

推荐 TeX Live 和 TeXStudio。参考书推荐：[一份不太简短的LaTeX教程.pdf](一份不太简短的LaTeX教程.pdf)。

## Hello, world

```latex
\documentclass{article} % 源文件第一行必须是介个
\begin{document}
	hello, LaTeX
\end{document}
```

更多 `documentclass` 可以自己查询。

### 你好， LaTeX

原生 LaTeX 不支持中文。需要引入包。课程使用的是 `CJK`。但是在我的 TeXstudio 编译不过？？？？？？

引入包的格式是在 `begin{document}` 后使用 `\usepackage[option]{packagename}`

```latex
\documentclass{article}
\usepackage{CJK}
\begin{document}
	\begin{CJK}{GBK}{song}
	hello, LaTeX
	你好
	\end{CJK}
\end{document}
```

于是我采用了另一个 `ctex` 包。`ctex` 用法可见[官方文档](http://www.ctex.org/PackageCTeX/files.xml?action=download&file=ctex.pdf)。

```latex
\documentclass{article}
\usepackage[UTF8]{ctex}
\begin{document}
	 \youyuan 你好，\LaTeX！
\end{document}
```

自带的六种字体见下表：

命令|字体
-|-
`\songti`|宋体
`\heiti`|黑体
`\fangsong`|仿宋
`\kaishu`|楷书
`\lishu`|隶书
`\youyuan`|幼圆

字号 `\zihao`、字距 `\ziju` 等特殊格式请查阅 ctex 官方文档。

## 文档基本符号

### 空格、回车

转义的字词后，空格不起作用，除了使用 `\space`，还可以使用`"\ "`（不含引号，最常用）、`\,`、`\;`、`\:`。  
MathJax 的写法：`\space`、`\\;`、`"\\ "`（不含引号）。

换行使用 `\endline`、`\\` ，也可以使用两个回车。一个回车没有用。（MathJax 中得 `\\\\`）

连续换行使用 `\\ \\` 会编译不过，需要使用一个 `~` 以占位：`\\~\\`。

### 注释

1. 单行注释：直接加入 `%` 即可；
2. 多行注释：

```latex
\usepackage{verbatim}
\begin{comment} ... \end{comment}
```

### 特殊符号

`\LaTeX` 即能打出 $\rm\LaTeX$ 的官方图标。

## 文档格式

### 文字格式

* 粗体：`\textbf{}`；
* 斜体：`\emph{}`；
* 下划线：`\underline{}`（这是唯一一个数学公式外能用的数学公式功能）。

可以进行叠加： `\textbf{\emph{\underline{Hello}}}`。

下划线处理大段文字时，不能自动换行（大概是数学公式并不需要换行）。  

需要引入 `ulem` 宏包，并将 `\underline` 改为 `\ulem`。  
如果中文包使用的是 `CJK`，需要将引入的宏包改为 `CJKulem`。


### 段落格式

分页：`\newpage`、`\clearpage`；

使用 `\noindent` 以去掉首行缩进，使用 `\indent` 以加入首行缩进。

左对齐：`\begin{flushleft}`（默认，所以不常用）  
右对齐：`\begin{flushright}`  
居中：`\begin{center}`

### 章节格式

* 通用：`\part{}`、`\paragraph{}`、`\subparagraph{}`、
* `\section{}`、`\subsection{}`、`\subsubsection{}` 关联编号（即 `1.1.1`）。
* 在 `book` 类中，`\section` 以上还有一级更高的 ：`\chapter{}` 。
* `\section*{}` 不参与自动编号。

### 页面格式

```
\usepackage{geometry}
\geometry{left=5.0cm, right=2.0cm, top=2.0cm, bottom=2.0cm} % 全局设置
```

### 文档信息及标题

`\title{}`：标题。
`\author{}`：作者信息，以及邮件信息等等。
`\date{2017\\December}`：日期

以上命令可放全局变量位置或文档正文位置。

然后在正文里调用一句 `\maketitle` 产生标题。

### 摘要和关键字

摘要可以用自带的，但是关键字需要自己写。

```latex
\begin{abstract}
	This is an example of abstract.
	
	\textbf{Keywords}: Abstract, Exmaple
\end{abstract}
```

如果你正在中文环境上写英文文章，你就会遇到啼笑皆非的情况~~和我一样~~：英文摘要上方写着大大的汉字“摘要”！

遇到这种情况，你只需要在摘要前加一行代码：

```latex
\renewcommand{\abstractname}{Your Abstract Name}
```
就可以把你的摘要标题变为 `Your Abstract Name` 了。

## 数学公式

正式学 LaTeX 之前我就开始写数学公式了，所有内容我就放在另外一篇[博客](../LaTeX-math-equation)了。