---
title: 尾递归优化
date: 2019-09-03 11:19:49
tags:
category:
- 计算机科学
mathjax: true
---

递归函数都会面临到栈溢出的问题，不过有些递归是可以改写为循环的形式。

这类递归有一个特点：总是在最后一步进行递归。

下面的 Python 代码不是一个尾递归函数：

```py
def fact(n):
    if n == 1:
        return 1
    return n * fact(n-1)
```

因为在递归 `fact()` 函数以后，又执行了 `n*结果，`。

要改写成尾递归，可以这么写：

```py
def fact(n, ans = 1):
    if n == 1l
        return ans
    return fact(n-1, ans * n)
```

但这么写已经能改写为普通循环了。

部分语言可以直接将尾递归优化为循环版本，但是大部分语言都没有作尾递归优化。Python 也没有。
