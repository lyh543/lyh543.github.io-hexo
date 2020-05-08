---
title: 逐字字符串在各语言中的表达式
date: 2020-05-08 11:29:55
tags:
- C++
- C#
- Python
- 计算机科学
category:
- 计算机科学
mathjax: true
---

不少语言都支持 `跨行字符串` （或 `verbatim string literal` `raw string` `字符串字面量`）这一特性，即在写字符串的时候加一定的前缀、后缀，即可逐字的保留字符串中的内容，无需转义。

下面将用 C++、C#、Python 的逐行字符串将 `"verbatim\n\\\nstring"` 赋给 `testString`，使得在输出 `testString` 的时候将输出：

```
verbatim
\
string
```

## C++

```cpp
string testString = R"(verbatim
\
string)";
```

貌似 C 是不支持这种语法的。

## C# #

```cs
string testString = @"verbatim
\
string";
```

## Python

```py
testString = r'''verbatim
\
string'''
```

需要注意的是，Python 不允许逐字字符串用 `\` 结尾。