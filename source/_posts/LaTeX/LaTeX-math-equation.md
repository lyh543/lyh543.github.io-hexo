---
title: LaTeX 数学公式学习笔记
date: 2019-10-15
category:
- LaTeX
mathjax: true
---

LaTeX 更多语法请见另一篇[博客](../LaTeX-class-note)。

纯正的 LaTeX 调用公式的语法请见[最后一部分](#纯正-LaTeX-插入公式)。

## 基本语法

1. MathJax 在一对 `$` 中间即是行内公式，在一对 `$$` 即是行间居中公式。亦可以在 `\begin{equation}` 和 `\end{equation}` 之间打行间公式。  
LaTeX 稍有区别（[见后](#纯正-LaTeX-插入公式)），但也可以使用上面的东西。

```
$$a+b=c$$
```

$$a+b=c$$

------------------------------

```
\begin{equation}a+b\end{equation}
```

\begin{equation}a+b\end{equation}

另外，还可以使用 `\(` `\)`、

2. 下标`_`，上标`^`，后面跟`{}`  
如`$a^{2}_{j}$`: $a^{2}_{j}$
3. `[]`即是中括号。
如`$[1+2]$`: $[1+2]$
4. 编译时无视空格、回车，空格只用于分隔识别符。公式中需要空格请前往[#排版](#排版)
5. LaTeX换行中行末需要`\\`，由于 Markdown 和 MathJax 进行了两次渲染，所以需要`\\\\`。
6. 目前已发现的需要用 `\`（Markdown 中需要 `\\`。下如不提及是在 Markdown 中使用 `\`，均为`\\`）转义的符号有：`%`，`&`，`\`，`{}`。

```latex
\begin{equation}
\begin{aligned}
x&=a+b+c\\\\
&=d+e\\\\
&=f+g
\end{aligned}
\end{equation}
```

\begin{equation}
\begin{aligned}
x&=a+b+c\\\\
&=d+e\\\\
&=f+g
\end{aligned}
\end{equation}


7. 符号和 Onenote 的基本一样，大概是相互借鉴 ~~Onenote 把 LaTeX 的符号照搬~~，然后 Onenote 简化了分数等一些部分吧。

## 常用运算符

中文|LaTeX语句|数学符号
-|-|-
点乘|`\cdot`|$\cdot$
叉乘|`\times`|$\times$
除号|`\div`|$\div$
分数|`\frac{1}{x^2+1}`|$\frac{1}{x^2+1}$
|`1/2`|$1/2$
方根|`\sqrt[3]{2}`|$\sqrt[3]{2}$
|`\surd{2}`|$\surd{2}$
取模|`a \bmod b`|$a \bmod b$
|`7 \equiv 1 \pmod 3`|$7 \equiv 1 \pmod 3$

## 常用关系符

在关系符前面加`\not`可得其否定形式。
`\not\equiv`: $\not\equiv$

另外，可以使用 `\stackrel{}{}` 实现两符号的上下重叠。见[排版](#排版)。

中文|LaTeX语句|数学符号
-|-|-
等价|`\equiv`|$\equiv$
不等于|`\neq`|$\neq$
相似|`\sim`|$\sim$
全等|`\simeq`|$\simeq$

## 微积分

中文|LaTeX语句|数学符号
-|-|-
极限|`\lim_(n->\infty)\frac{\sin n}{n}`|$\lim_{n\to 0}\frac{\sin n}{n}$
连续求和|`\sum_{n=1}^{\infty}{\frac{1}{n}}`|$\sum_{n=1}^{\infty} {\frac{1}{n}}$
连续求积|`\prod_\varepsilon`|$\prod_\varepsilon$
积分|`\int_{0}^{1}{\frac{1}{n+1}}`|$\int_{0}^{1}{\frac{1}{n+1}}$
二重积分|`\iint_{0}^{1}{\frac{1}{n+1}}`|$\iint_{0}^{1}{\frac{1}{n+1}}$
偏导数|`\frac{\partial y}{\partial x}`|$\frac{\partial y}{\partial x}$

有些上下标的位置在文中公式和独立公式中是不一样的，以 `\sum` 为例：

* 文中公式 `$\sum_1^2x$` 的效果为：$\sum_1^2x$；
* 独立公式 `$$\sum_1^2x$$` 的效果为：

$$\sum_1^2x$$


但也可以用 `\limits` 和 `\nolimits` 来控制上下标的出现位置：

* 使用方法如 `$\sum\limits_1^2x$` 就强制将上下标写在上边和下边：$\sum\limits_1^2x$  
* 而 `$$\sum\nolimits_1^2x$$` 使其强制出现在右边角上：

$$\sum\nolimits_1^2x$$

## 上下划线

中文|LaTeX语句|数学符号
-|-|-
加粗|`\mathbf{X}`|$\mathbf{X}$
上划线|`\overline{123}`|$\overline{123}$
下划线|`\underline{123}`|$\underline{123}$
上括弧|`\overbrace{a+b+\cdots+z}^{26}`|$\overbrace{a+b+\cdots+z}^{26}$
下括弧|`\underbrace{a+b+\cdots+z}_{26}`|$\underbrace{a+b+\cdots+z}_{26}$
向量|`\vec{a}\qquad\vec{AB}`|$\vec{a}\qquad\vec{AB}$
|`\overrightarrow{AB}`|$\overrightarrow{AB}$
|`\overleftarrow{AB}`|$\overleftarrow{AB}$

## 矩阵 matrix

> 参考博客：https://blog.csdn.net/bendanban/article/details/44221279

另外貌似也可以使用 `\begin{array}`。

### 裸矩阵

使用 `$$\begin{matrix}...\end{matrix}$$` 生成矩阵。矩阵中每一行以 `\\`换行（Markdown 中是`\\\\`），矩阵的元素用 `&` 来分隔开。  

行间矩阵 $$\left(\begin{smallmatrix}1&2\\\\3&4\end{smallmatrix}\right)$$ 请使用 `$$\begin{smallmatrix}...\end{smallmatrix}$$`

如，

```latex
$$
    \begin{matrix}
    1 & 2 & 3 \\\\
    4 & 5 & 6 \\\\
    7 & 8 & 9
    \end{matrix} \tag{1}
$$
```

$$
    \begin{matrix}
    1 & 2 & 3 \\\\
    4 & 5 & 6 \\\\
    7 & 8 & 9
    \end{matrix}
$$

### 带括号的矩阵

如果需要带括号的矩阵，一种是用 `\left(` 和 `\right)` 括住 `\begin{matrix} ... \end{matrix}`。注意，如果不加 `\left` 和 `\right`，括号是和其他字符等高，而不是完全括住了矩阵。

另一种是使用 `\begin{bmatrix}...\end{bmatrix}`。  

不同的 matrix 名对应的矩阵列表如下：

代码|`pmatrix`|`bmatrix`|`Bmatrix`|`vmatrix`|`Vmatrix`
-|-|-|-|-|-
示例|$$\begin{pmatrix} 1&2\\\\3&4\end{pmatrix}$$ | $$\begin{bmatrix} 1&2\\\\3&4\end{bmatrix}$$|$$\begin{Bmatrix} 1&2\\\\3&4\end{Bmatrix}$$|$$\begin{vmatrix} 1&2\\\\3&4\end{vmatrix}$$|$$\begin{Vmatrix} 1&2\\\\3&4\end{Vmatrix}$$

但是直接用 `{}`，它不香吗？

对于 `smallmatrix`，只能使用第一种方法，不能使用后面的更改 `matrix` 类型的方法。

### 数组 array

貌似 `array` 也可以用于建矩阵，而且**必须**指定列对齐的形式：

$$
\begin{array}{clr}
1 & 2 & 3 \\\\
4 & 5 & 6 \\\\
7 & 8 & 9
\end{array}
$$

```
\begin{array}{clr}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{array}
```

`clr` 的每个字母分别代表了一列的对齐方式：第一列居中 `c(enter)`、第二列左对齐 `l(eft)`、第三列右对齐 `r(ight)`。

### 讨论情况 cases

```latex
$$f(x)=
\begin{cases}
0& x=0\\
1& x \neq 0
\end{cases}$$
```

$$f(x)=
\begin{cases}
0& x=0\\\\
1& x \neq 0
\end{cases}$$

如果是需要对齐等于号，可以使用 `\begin{align}`（详解看 [排版](#排版)）。大括号需要下一段提到的 `\left\{ \right.` 来实现。


$$ \left\\{ \begin{aligned}
I_0 &= 1 - e^{-1} \\\\
I_n &= 1-nI_{n-1} \quad (n=1,2,...)
\end{aligned} \right.$$


## 奇奇怪怪的括号

> 参考博客：https://blog.csdn.net/miao0967020148/article/details/78712811

使用括号的时候，可以加一句`\left` `\right`，大概是告诉 LaTeX，我要用括号了，而不是简单的符号  
~~好像用不用没有什么影响，不想打，好几个字符呢~~

中文|LaTeX语句|数学符号
-|-|-
大括号|`$\left\{ \frac{a}{b} \right\}$` `$\{ \}$`|$\left\\{ \frac{a}{b} \right\\}$
尖括号|`$\left \langle \frac{a}{b} \right \rangle$`|$\left \langle \frac{a}{b} \right \rangle$
单、双竖线|由于和 Markdown 表格语法冲突，单竖线和双竖线的语法写在表格下|
取整函数|`$\left \lfloor \frac{a}{b} \right \rfloor$`|$\left \lfloor \frac{a}{b} \right \rfloor$
取顶函数|`$\left \lceil \frac{c}{d} \right \rceil$`|$\left \lceil \frac{c}{d} \right \rceil$
混合括号|`$\left [ 0,1 \right )\left \langle \psi \right \|$`|$\left [ 0,1 \right )\left \langle \psi \right\|$
单左括号|`$\left \{ \frac{a}{b} \right .$` <br>加个点就可以省略了|$\left \\{ \frac{a}{b} \right .$

单竖线：`$\left| \frac{a}{b} \right|$` $\left| \frac{a}{b} \right|$
双竖线：`$\left\| \frac{a}{b} \right\|$` $\left\\| \frac{a}{b} \right\\|$

（提醒 MathJax 用户：上述符号前的 `\` 都应使用 `\\`，而 `left` 和 `right` 前仍为 `\`）

另外，可以使用 `\big`，`\Big`，`\bigg`，`\Bigg` 来控制括号的大小。

```latex
$$\Bigg ( \bigg [ \Big \\{ \big \langle \left | \| x \| \right | \big \rangle \Big \\} \bigg ] \Bigg )$$
```

$$\Bigg ( \bigg [ \Big \\{ \big \langle \left | \| x \| \right | \big \rangle \Big \\} \bigg ] \Bigg )$$


## 排版

中文|LaTeX语句|数学符号|注释
-|-|-|-
普通空格|`$a \space b \\; c \\  d$`|$a \space b \\; c \\  d$|
1cm短空格|`$a\quad b$`|$a\quad b$|
2cm长空格|`$a\qquad b$`|$a\qquad b$|
换行并对齐|`$\begin{aligned}`<br>`x&=a+b+c\\`<br>`&=d+e\\`<br>`&=g+f`<br>`\end{aligned}$`|$\begin{aligned}x&=a+b+c\\\\&=d+e\\\\&=g+f\end{aligned}$|开头`\begin{aligned}`<br>结束`\end{aligned}`<br>行末`\\`<br>需要对齐的符号前`&`
||`&`常用于对齐
省略号|`1...n`<br>`1 \dots n`|$1 \dots n$
|`1 \cdots n`|$1 \cdots n$
|`\vdots`|$\vdots$
|`\ddots`|$\ddots$
公式标号|`a^2 + b^2 = c^2 \tag{1}`|$a^2 + b^2 = c^2 \tag{1}$|原生 LaTeX 的 `$$a+b$$` 是自带编号的
重叠符号|`\stackrel{F}{=}`|$\stackrel{F}{=}$

## 数学符号表

常用：

LaTeX语句|数学符号
-|-
`\varphi`|$\varphi$
`\epsilon`|$\epsilon$
`\varepsilon`|$\varepsilon$

更多的：

{%asset_img 50.gif%}
{%asset_img 51.gif%}
{%asset_img 52.gif%}
{%asset_img 53.gif%}
{%asset_img 54.gif%}
{%asset_img 55.gif%}
{%asset_img 56.gif%}

## 纯正 LaTeX 插入公式

由于博主在接触 LaTeX 之前就学了 MathJax，所以上述的大多数语法都是基于 MathJax 而非纯正 LaTeX 语法。

LaTeX 插入公式的格式和 MathJax 稍有区别，但是公式的语法还是差不多的。

LaTeX 插入数学公式需要调用宏包：

```latex
\usepackage{amsmath}
\usepackage{amssymb}
```

（貌似 TeXstudio 自带，不需要这两行命令也能写数学公式）

行内公式的格式有：

```latex
\(a+b\)
$a+b$ %最常用；MathJax 仅支持这种
\begin{math}a+b\end{math}
```

行间公式：

```latex
\[a+b\]
$$a+b$$ %最常用；MathJax 仅支持这种
\begin{displaymath}a+b\end{displaymath}
```

MathJax 支持另一种行间公式：`\begin{equation}a+b\end{equation}`。

LaTeX 也支持这个功能，但是会进行自动标号（MathJax 不会标号）。

要想不标号，请使用 `\begin{equation*}`。与 `\section*{}` 如出一辙。
