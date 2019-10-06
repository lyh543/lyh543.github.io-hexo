---
title: Wolfram Alpha 和 Mathematica
date: 2019-7-7
category:
- MATLAB
---

之前一直分不清 Wolfram Alpha 和 Mathematica，以为在线的那个网站就是 Mathematica。

后来装了桌面 Mathematica，并且简单了解了一点语法以后，才明白二者的区别。

这两个是同一个公司的两款产品，别搞混了。他们的语法虽然有点区别，但是都是基于 Wolfram 语言。

## Wolfram Alpha

[Wolfram Alpha](https://wolframalpha.com) 是 Wolfram 公司的在线产品，具有 web 版（免费版功能较少）、移动端 app。

Wolfram Alpha 里面一般只写一个语句，基本不能进行编程。

但是他的语法比较松散，如积分用 `int()`、`INT[]`、`integrate()`、`integrAte()` 等都可以识别，不会产生歧义的括号缺失也可以自动补齐。

小白也能很方便的使用，而且打开网站，或在手机上就能用、所以大多数人用的是这个。

### 二重积分

```MATLAB
integrate((x+y)/sqrt(1-x^2-y^2)+1,[y,0,1],[x,-sqrt(1-y^2),sqrt(1-y^2)])
```

{% asset_img iint.gif %}

## Wolfram Mathematica

Mathematica 是一个强大的计算软件，能够在 PC 上进行计算，也可以进行编程。

缺点是语法严格，如函数名第一个字母都是大写，不大写则不会被识别；  
另外需要在电脑上安装数 GB 的程序，手机端不能使用；
而且该软件不提供免费版。
