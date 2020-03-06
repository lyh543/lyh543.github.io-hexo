---
title: LaTeX 基础
date: 2019-11-19
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

在接下来的学习中，可以使用 Bing/Google 到的模板。

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

* `\title{}`：标题。
* `\author{}`：作者信息，以及邮件信息等等。如需换行，可在大括号中使用换行。
* `\date{2017\\December}`：日期

以上命令可放全局变量位置或文档正文位置。

然后在正文里调用一句 `\maketitle` 产生标题及以上信息。

## 引用参考文献

LaTeX 的引用原理是给每个文献写一个好记的名字，然后引用的时候直接引用名字。  
编译的时候自动对文献进行标号，并将引用处和文献根据名字绑定，然后标号。最后名字是不会呈现在文档里的。好评。

了解了原理以后，基本也是无脑抄板子。不需要额外的库。

```latex
\documentclass{article} % 源文件第一行必须是介个
\usepackage[UTF8]{ctex}
\begin{document}

xxx说的对。\cite{Zhang10} \\
\indent yyy说的也对。\cite{Li10}

\begin{thebibliography}{}
	
	\bibitem{Li10}
	L. Ming, Y. Shucheng, R. Kui, and L. Wenjing, Securing Personal Health Records in Cloud Computing: Patient-Centric and Fine-Grained
	Data Access Control in Multi-owner Settings, in: Processing of SecureComm 2010, LNICST 50, pp. 89-106, 2010.
	
	\bibitem{Zhang10}
	R. Zhang, and L. Liu, Security Models and Requirements for Healthcare Application Clouds, in: Processing of  Cloud 2010, pp. 268-275, 2010.
\end{thebibliography}

\end{document} 
```

![引用参考文献 示例](bibliography.jpg)

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

## 表格

创建表格，除了自己编辑，还可以使用生成工具，如：

> https://tablesgenerator.com/
> https://github.com/krlmlr/Excel2LaTeX

### 创建表格

使用 `\begin{tabular}` `\end{tabular}` 和 `&` `\\` 即可创建表格。

和数学矩阵一样，在 `\begin{tabular}`  后加入 `{clcr}` 即可说明每一列的对齐方式（`c` 居中，`l` 左对齐、`r` 右对齐）。

```latex
\begin{tabular}{cl}
1 & 2 \\
3 & 4
\end{tabular}
```

![表格](tabular.jpg)

### 给表格加边框

可以看到，如不加说明，LaTeX 表格是不带边框的。

如果要对一整行添加水平边框，在行间（或第一行前，最后一行后，下同）使用 `\hline` 命令即可。

注意最后一行加边框时，最后一行必须换行 `\\`。

如需部分列添加水平边框（如想在第 i 列到第 j 列加入边框），将 `\hline` 换为 `\cline{i-j}` 的形式即可。  
如果只有一列，则需使用 `\cline{i-i}`。  
如果需要添加多个间断的水平边框，连续使用多个命令（如 `\cline{1-2}\cline{4-4}` 即可。

对于竖直边框，在表格 `\begin` 的 `clr` 部分加入 `|` 即可，如 `\begin{tabular}{|c|l|rr|}`。

如果需要间断的数值边框，书上说的 `\vline`，但是貌似不可用，会歪的。

```latex
\begin{tabular}{|c|lr|}
	\hline
	ab & cd & ef \\
	\cline{1-1}\cline{3-3}
	cd & ef & ab \\
	\cline{1-2}
	ef & ab & cd \\
	\hline
\end{tabular}
```

![边框 示例](tabular-border.jpg)

### 合并单元格

这一段会比较硬核，于是再分三个小段讲。

#### 合并水平单元格

这是最简单的。格式为 `\multicolumn{2}{|c|}{ef}`。  
1. 第一个 `{2}` 为要合并的水平单元格数量；  
2. 第二个 `{|c|}` 表示该单元格的对齐方式和列边框（**会覆盖掉上面的列边框设置**）；  
3. 第三个 `{ef}` 为文本格式。

注意合并单元格以后，该行的 `&` 数较其他行会少一些。

测试的时候不要把每一行的同两列都合并了，不然合并了还是没效果。（逃

#### 合并竖直单元格

合并竖直单元格还需要调宏包 `\usepackage{multirow}`。

调用格式为（在合并的第一行写） `\multirow{2}{*}{ab}`。

`{2}` 和 `{ab}` 和上述的意思相近，注意这里的 `{*}` 是需要无脑抄的参数，没有会报错。

另外，`\cline` 和 `\hline` 设置不会被覆盖，需要自己调整（要不就会出现单元格被穿过去的情况）。

#### 同时合并行和列

虽然理论实现非常简单，就是上述两个语句的嵌套，但是因为细节太多太多，这才是最硬核的部分。

1. 仍然需要在合并的第一行调用。
2. 必须 `\multicolumn` 在外，`\multirow` 在内，如 `\multicolumn{2}{c|}{ \multirow{2}{*}{gh} }`。不然会报错。
3. 合并的后面几行需要写 `\multicolumn`，数量和列对齐格式和第一行的 `\multicolumn` 相同，内容留空 `{}`。

最后是以上几个例子的综合实例。

```latex
\begin{tabular}{|c|c|c|c|}
	\hline
	\multirow{2}{*}{ab} & \multicolumn{2}{|c|}{ef} & cd\\
	\cline{2-4}
	& ef & \multicolumn{2}{c|}{\multirow{2}{*}{gh}} \\
	\cline{1-2}
	ef & gh & \multicolumn{2}{c|}{} \\
	\hline
	1 & 2 & 3 & 4 \\
	\hline
\end{tabular}
```

![合并单元格 示例](tabular-multicoluimn-multirow.jpg)

### 美观地插入表格

上面是“如何创建一个表格”，这一部分是“如何将表格美观的插入文档”。

如下是无脑抄板子：

```latex
\begin{table}[!hbp]  % 有关[!hbp]，详见：插入浮动体
	\centering       % 表格居中
	\begin{tabular}{|c|c|c|c|c|}

	\hline
	lable 1-1 & label 1-2 & label 1-3 & label 1 -4 & label 1-5 \\
	\hline
	label 2-1 & label 2-2 & label 3-3 & label 4-4 & label 5-5 \\
	\hline
	\end{tabular}

	\caption{表格标题} % 表格标题
\end{table} 
```

有关 `[!hbp]` 等，详见：[插入浮动体](#插入浮动体)。

### tabular\* 表格

tabular\* 在兼容 tabular 的语法上，又增加了功能。

一是必须指定表格的总宽度，二是可以将所有列在设定的表格宽度中均匀展开（即让表格横向均匀展开，不留横向空位）。

不需要新的宏包。

```latex
\begin{tabular*}{10cm}{lll}
	\hline
	Start & End  & Character Block Name \\
	\hline
	3400  & 4DB5 & CJK Unified Ideographs Extension A \\
	4E00  & 9FFF & CJK Unified Ideographs \\
	\hline
\end{tabular*}
```

这是没有横向展开的。把第一行的 `{lll}` 改为 `{@{\extracolsep{\fill}}lll}` 即可横向展开。下面是两个对比图。

![不使用 extracolsep](tabular-extracolsep-off.jpg)
![使用 extracolsep](tabular-extracolsep-on.jpg)

#### tabularx 表格

tabularx 也可以实现对表格总宽度的设定。

```latex
\begin{tabularx}{8cm}{llX}  
    \hline
    Start & End  & Character Block Name \\
    \hline
    3400  & 4DB5 & CJK Unified Ideographs Extension A \\
    4E00  & 9FFF & CJK Unified Ideographs \\
    \hline
\end{tabularx}
```

![tabularx](tabularx.jpg)

## 文档内容元素

这部分的内容，Markdown 也有，但是 LaTeX 可以调各种参数，功能强大。相对应的，命令也会比较长。

~~Markdown 真香~~

### 水平横线

Markdown 里的预览：

---------------------------

LaTeX 版本：

```latex
\rule[raise-height]{width}{thickness}
\rule[4pt]{18cm}{0.5pt} % 参考配置
```

### 分条目命令

#### 无标号

Markdown 里的预览：

* a
* b

LaTeX 版本：

```latex
\begin{itemize}
	\item[*] a
	\item[*] b
\end{itemize}
```

`[*]` 可以不要（即默认使用黑点），或者换成其他的符号 `+` `-` 等。

#### 数字标号

Markdown 里的预览：

1. a
2. b

LaTeX 版本：

```latex
\usepackage{enumerate}
\begin{enumerate}[1.]
	\item a
	\item b
\end{enumerate}
```

也可以使用其他的标号，修改 `[1.]` 部分即可。

#### 文字描述

```latex                                                
\begin{description}
	\item[研究生课程：] 数据挖掘等；
	\item[本科课程：] 高等代数等；
	\item[自学课程：] Stanford:编程方法。
\end{description}
```

![文字描述](description.jpg)

### 插入图片

插入图片的板子：

```latex
\documentclass{article}
\usepackage{graphicx}    %   使用graphicx 包
\begin{document}
	\includegraphics{file.eps}    %    按图片原尺寸插入图片 file.eps
\end{document}
```

插入的图片需要为 `eps` 格式。可以使用  PS 或 LaTeX 带的 `bmeps` 工具转换（详见 [bmeps 工具](#bmeps-工具)）。

`includegraphics` 的详细语法：

```
\includegraphics[option]{file}
```

`option` 可以为（多个 `option` 用逗号隔开）：

选项|解释
-|-
`[width=3in]`|图片宽度为 3 inches
`[width=\testwidth]`|图片宽度为文本宽度
`[width=0.8\textwidth]`|图片宽度为文本宽度的 0.8 倍（可以做乘法）
`[width=\testwidth-2.0in]`|图片宽度比文本宽度少 2 inches（居然还能做减法）
|
`[angle=270]`|顺时针旋转 270°

#### 美观的插入图片

依旧是抄板子。

```latex
\begin{figure}[!hbp]
\centering
\includegraphics[width=0.7\textwidth]{图片文件}
\caption{标题名称}\label{fig1}
\end{figure}
```

* 有关这段代码的详细解释，详见：[插入浮动体](#插入浮动体)。


#### bmeps 工具

`bmeps` 可将照片转为 `eps` 格式。

```
bmeps [options] [ <inputfile> [ <outputfile> ] ]
```
常用参数中 `-g` 是无色彩转化，`-c` 是有色彩转化。

### 插入浮动体

表格的 `\table` 和图片的 `\figure` 等都算是浮动体，他们有类似的语法体系。

下面以插入图片为例：

```latex
\begin{figure}[!hbp]
\centering               % 居中
\includegraphics[width=0.7\textwidth]{图片文件}
\caption{标题名称}\label{fig1}
\end{figure}
```

关于 `[!hbp]` 的解释如下（默认为 `[tbp]`）：

* ! 严格按照说明放置，即使看起来不好。
* h 浮动体就放在当前页面上。这主要用于小浮动体
* t 放在页面顶部
* b 放在页面底部
* p 放在一专门页面，仅含一个浮动体

但论文写作中，不推荐使用 `h`，一般的配置为 `[tb]`。

如果把 `\caption{标题名称}` 写在 `\includegraphics` 之前，则得到的图片的标题在图片的上面。

`\label{fig1}` 是这个图片的标签，在别的地方那个引用这个图片的话，用 `\ref{fig1}` 就可以了。（注意：`\label` 必须放在 `\caption` 命令的后面，如果放在其他的地方，则插图的计数器就会出错）

## 使用 LaTeX 制作幻灯片

什么是 beamer？

beamer 是 LaTeX 的一个文档类，和 article、 book 一样；beamer 主要是写幻灯片用的，目前表现最好的书写幻灯片的宏包之一；采用 LaTeX 命令来组织幻灯片，用 `frame` 命令生成单页幻灯片（`Slide`）。

### Hello, World!

先跑一下，看下什么效果。

如果编译不过，请参照文末解决。

```latex
\documentclass[red]{beamer}
\usepackage[UTF8]{ctex}
\usetheme{Warsaw}
\begin{document}
	%%------------------------------------------
	\title{beamer~测试}
	\author{XXX}
	\institute{lyh543}
	\date{\today}
	
	\frame{\titlepage}
	%%------------------------------------------
	\begin{frame}
		\frametitle{test}
		Hello, world!
	\end{frame}
	%%------------------------------------------
\end{document}
```

需要说明的几点：

1. `\usetheme{}` 显然是用来换主题的。可供选择的有：`Madrid`、`Warsaw`、`CambridgeUS`；
2. `\begin{frame}` `\end{frame}` 是 beamer 里面重要的概念，每一个 `frame` 定义了一张 Page。

### 

## bug 及可能的解决方法

### 无法编译/更新宏包

这里仅列举 beamer 编译不成功的例子，其他宏包是类似的。

> 使用 beamer 编译不能成功, 可能是使用的 beamer, pgf, xcolor 宏包需要更新，更新地址为：  
> ~~当然也可以使用 LaTeX 发行版提供的宏包管理工具~~
>  
> beamer 更新地址: http://sourceforge.net/projects/latex-beamer/  
> pgf 更新地址: http://sourceforge.net/projects/pgf/  
> xcolor 更新地址: http://www.ctan.org/tex-archive/macros/latex/contrib/xcolor/  
> 
> 具体更新步骤如下:
>   
> (1) 下载: 下载最新的 `beamer`, `pgf`, `xcolor` 包;  
> (2) 安装: 找到 TeX 的安装目录 `texmf`, 放到下面的地方即可： `texmf/tex/latex/beamer`, `texmf/tex/latex/pgf`,  `texmf/tex/latex/xcolor`  
> 这里有一个细节要注意一下: 如果 `texmf/tex/latex/` 目录下原来有 `beamer`, `pgf` 等文件夹, 宜先删除原有的旧文件夹, 再粘贴新文件。(直接覆盖的话，可能会因为文件名不同，使旧文件没有被删除。)
