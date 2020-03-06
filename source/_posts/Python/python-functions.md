---
title: Python 常用函数
date: 2019-08-30 21:42:45
tags:
category:
- Python
mathjax: true
---

需要引入模块的函数，以模块（需要 import 的文件名）为标题进行分组。函数和模块均以字母排序。

## builtins 内置函数

```py

# 数学相关

abs(float)
max(a1,a2,a3,...) # 这里的输入参数是一个 sequence，和 C 语言不同，很有意思

# 字符串相关

str.find(',')     # 找到就返回第一个下标，找不到就返回 -1（注意不是 False）
' '.join(list)    # 将 list 等组合为一个字符串，用 ' ' 分隔
str.split()       # 将字符串按 sep = ' ' 分拆成 list


# 容器相关

set()             # 定义集合

# 其他

elem in list                          # 在 list 中查找元素，返回 bool，这个直接用 in 关键字可太猛了
isinstance(variable, tuple of type)   # 判断变量类型
range(start, stop[, step])            # 得到一个序列，可用于 for，或转换为 list 类型
reversed(range(10))                   # 将一个 list/str 翻转

```

## bisect

二分搜索。

```py
bisect.bisect_left(a, x, lo=0, hi=len(a)) # 返回第一个大于等于 x 的下标
bisect.bisect_right(a, x, lo=0, hi=len(a)) # 返回第一个大于 x 的下标
bisect.bisect # == bisect_right
```

可见 Python 的 `bisect_left` 和 `bisect_right` 等价于 C++ 的 `lower_bound` 和 `upper_bound`。

## functools

```py
functools.partial(func, **kw)
functools.reduce(func, list)
functools.wraps(func)
```

## math

```py
math.sqrt(float)
```

## re

正则表达式相关内容请查看 [正则表达式](/Computer-Science/regular-expression.md)

```py
re.findall('\d+',str) % 找到 str 中的数并组成 list
```
## sys

```py
sys.argv % 以 list 形式返回程序被调用时的参数
```

## time

```py

time.sleep(second)
time.time() % 单位为秒
```
