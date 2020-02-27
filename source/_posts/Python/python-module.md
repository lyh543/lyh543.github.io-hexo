---
title: Python 模块
date: 2020-02-25 20:40:18
tags:
category:
- Python
mathjax: true
---

在 Python 中，一个 `.py` 文件就称之为一个模块（Module）。

## 使用模块

```py
import sys

```

按第一行导入 `sys` 模块后，我们就有了变量 `sys` 指向该模块，利用 `sys` 这个变量，就可以访问 `sys` 模块的所有功能。

顺便，在 Python 环境中（即 `>>>` 中）貌似没法直接运行脚本，如果需要调用脚本中的函数，应该当做模块一样，`import filename` 然后 `filename.function_name()` 来调用。

