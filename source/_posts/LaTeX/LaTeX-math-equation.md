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

## 常用关系符

在关系符前面加`\not`可得其否定形式。
`\not\equiv`: $\not\equiv$

中文|LaTeX语句|数学符号
-|-|-
等价|`\equiv`|$\equiv$
不等于|`\neq`|$\neq$
相似|`\sim`|$\sim$

## 微积分

中文|LaTeX语句|数学符号
-|-|-
极限|`\lim_(n->\infty)\frac{\sin n}{n}`|$\lim_{n\to 0}\frac{\sin n}{n}$
连续求和|`\sum_{n=1}^{\infty}{\frac{1}{n}}`|$\sum_{n=1}^{\infty} {\frac{1}{n}}$
连续求积|`\prod_\epsilon`|$\prod_\epsilon$
积分|`\int_{0}^{1}{\frac{1}{n+1}}`|$\int_{0}^{1}{\frac{1}{n+1}}$
二重积分|`\iint_{0}^{1}{\frac{1}{n+1}}`|$\iint_{0}^{1}{\frac{1}{n+1}}$
偏导数|`\frac{\partial y}{\partial x}`|$\frac{\partial y}{\partial x}$

## 上下划线

中文|LaTeX语句|数学符号
-|-|-
上划线|`\overline{123}`|$\overline{123}$
上括弧|`\overbrace{a+b+\cdots+z}^{26}`|$\overbrace{a+b+\cdots+z}^{26}$
下括弧|`\underbrace{a+b+\cdots+z}_{26}`|$\underbrace{a+b+\cdots+z}_{26}$
向量|`\vec{a}\qquad\vec{AB}`|$\vec{a}\qquad\vec{AB}$
||`\overrightarrow{AB}`|$\overrightarrow{AB}$
||`\overleftarrow{AB}`|$\overleftarrow{AB}$

## 矩阵

> 参考博客：https://blog.csdn.net/bendanban/article/details/44221279

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

如果需要带括号的矩阵，一种是加 `\left( \begin{matrix} ... \end{matrix} \right)`，另一种是使用 `\begin{bmatrix}...\end{bmatrix}`。  
不过对于 `smallmatrix`，只能使用前面的方法，不能使用后面的加括号的方法。

#### 花括弧

注意花括弧 `{}` 也是需要用 `\` 转义的。

```latex
$$
    \left\\{
    \begin{matrix}
    1 & 2 \\\\
    3 & 4
    \end{matrix}
    \right\\}
$$
```

$$
    \left\\{
    \begin{matrix}
    1 & 2 \\\\
    3 & 4
    \end{matrix}
    \right\\}
$$

#### 中括弧及小括弧

```latex
$$
    \left[
    \begin{\matrix}
    1 & 2 \\\\
    3 & 4
    \end{matrix}
    \right]
$$
```

或

```latex
$$
    \begin{bmatrix}
    1 & 2 \\\\
    3 & 4
    \end{bmatrix}
$$
```

的效果如下：

$$
    \left[
    \begin{matrix}
    1 & 2 \\\\
    3 & 4
    \end{matrix}
    \right]
$$

不同的 matrix 名对应的矩阵列表如下：

代码|`pmatrix`|`bmatrix`|`Bmatrix`|`vmatrix`|`Vmatrix`
-|-|-|-|-|-
示例|$$\begin{pmatrix} 1&2\\\\3&4\end{pmatrix}$$|$$\begin{bmatrix} 1&2\\\\3&4\end{bmatrix}$$|$$\begin{Bmatrix} 1&2\\\\3&4\end{Bmatrix}$$|$$\begin{vmatrix} 1&2\\\\3&4\end{vmatrix}$$|$$\begin{Vmatrix} 1&2\\\\3&4\end{Vmatrix}$$

## 奇奇怪怪的括号

> 参考博客：https://blog.csdn.net/miao0967020148/article/details/78712811

使用括号的时候，可以加一句`\left` `\right`，大概是告诉 LaTeX，我要用括号了，而不是简单的符号  
~~好像用不用没有什么影响，不想打，好几个字符呢~~

中文|LaTeX语句|数学符号
-|-|-
大括号|`$\left\\{ \frac{a}{b} \right\\}$` `$\\{ \\}$`|$\left\\{ \frac{a}{b} \right\\}$
尖括号|`$\left \langle \frac{a}{b} \right \rangle$`|$\left \langle \frac{a}{b} \right \rangle$
单竖线|`$\left\| \frac{a}{b} \right\|$`|$\left\| \frac{a}{b} \right\|$
双竖线|`$\left \|\| \frac{a}{b} \right \|\|$`|$\left \| \frac{a}{b} \right \|$
取整函数|`$\left \lfloor \frac{a}{b} \right \rfloor$`|$\left \lfloor \frac{a}{b} \right \rfloor$
取顶函数|`$\left \lceil \frac{c}{d} \right \rceil$`|$\left \lceil \frac{c}{d} \right \rceil$
混合括号|`$\left [ 0,1 \right )\left \langle \psi \right \|$`|$\left [ 0,1 \right )\left \langle \psi \right \|$
单左括号|`$\left \\{ \frac{a}{b} \right .$` 加个点就可以省略了|$\left \\{ \frac{a}{b} \right .$

另外，可以使用 `\big`，`\Big`，`\bigg`，`\Bigg` 来控制括号的大小。

```latex
$$\Bigg ( \bigg [ \Big \\{ \big \langle \left | \| x \| \right | \big \rangle \Big \\} \bigg ] \Bigg )$$
```

$$\Bigg ( \bigg [ \Big \\{ \big \langle \left | \| x \| \right | \big \rangle \Big \\} \bigg ] \Bigg )$$

分段函数的大括号写法：

```latex
$$f(x)=
\begin{cases}
0& x=0\\\\
1& x \neq 0
\end{cases}$$
```

$$f(x)=
\begin{cases}
0& x=0\\\\
1& x \neq 0
\end{cases}$$

## 排版

中文|LaTeX语句|数学符号|注释
-|-|-|-
普通空格|`$a \space b \\; c \\  d$`|$a \space b \\; c \\  d$|
1cm短空格|`$a\quad b$`|$a\quad b$|
2cm长空格|`$a\qquad b$`|$a\qquad b$|
换行并对齐|`$\begin{split}`<br>`x&=a+b+c\\`<br>`&=d+e\\`<br>`&=g+f`<br>`\end{split}$`|$\begin{split}x&=a+b+c\\\\&=d+e\\\\&=g+f\end{split}$|开头`\begin{split}`<br>结束`\end{split}`<br>行末`\\`<br>需要对齐的符号前`&`
||`&`常用于对齐
省略号|`1...n`<br>`1 \dots n`|$1 \dots n$
|`1 \cdots n`|$1 \cdots n$
|`\vdots`|$\vdots$
|`\ddots`|$\ddots$
公式标号|`a^2 + b^2 = c^2 \tag{1}`|$a^2 + b^2 = c^2 \tag{1}$

## 数学符号表

常用：

中文|LaTeX语句|数学符号
-|-|-
|`\varphi`|$\varphi$

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
