---
title: Python 基础
tags: 
category: 
 - Python
---

> 学习链接：https://www.liaoxuefeng.com/wiki/1016959663602400

比较基础的部分，新的东西就记一笔过一下就行了，方便以后查阅。

## 基础语法

语句没有分号。

代码块不用大括号，**完全靠缩进**（约定俗成为 **4 个空格**）

注释用 `#` 号开头（和 shell 是一样的）

## 执行 python 脚本

### 用 python 运行

```
python test.py
```

### 直接运行

Windows 下不行，只能 Linux 或 MacOS X。

1. 在脚本开头加：

```py
#!/usr/bin/env python3
```

2. 通过命令给脚本权限

```bash
chmod a+x hello.py
./hello.py
```

## IO

### 输出：print()

```py
print("Hello world") # 自带换行
print("Hello", "world") # 二句等效，print多个字符串，会在中间加空格
print('100 + 200 =', 100 + 200) # 也可以输出计算结果
```

Python 也支持类似与 C 的格式化方式，但这部分内容属于[字符串](#格式化字符串)。

### 输入：input()

```py
name = input() # 输入的是 str 而非 int
name = input("Please input your name") # 这里的输出不带换行
```

## 基本数据类型

有整数 `int`，浮点数、字符串 `str`、字节串 `bytes` 布尔值 `bool`、空值 `None`。

### 实数间的除法

Python 的 `\` 的结果是浮点数。

Python 的 `\\` 和 `%` 是广义的整除和取模，可以在浮点数间使用。

### 字符串

#### 字符串常量

1. 单双引号等价：`"a"` == `'a'`（Python 没有 `char` 的说法，只有 `one-character string`）  
2. 支持转义字符 `\`：`"'"` == `"\'"` == `'\''`，`'\n'`  
3. 类似于 C++ 的[字符串字面量](/C++/C++语法/string#字符串字面量)：`r'\n'` == `r'''\n'''`  
4. 还可以用 `'''` 括起表示换行的字符串（该语法支持与第三条搭配）：

```python
print('''hello
world''')
```

在命令行中使用该语法会出现用 `...` 代替 `>>>` 的提示符，如下：

```python
>>> print('''hello
... world''')
hello
world
>>>
```

#### 数字、字符的转换

整型和单个字符的转换可以使用 `ord()` 和 `chr()` 函数。

```py
ord('A') # == 65
ord('中') # == 20013
chr(66) # == 'B'
```

还可以直接用八进制、十六进制写 `str`：

```py
'\u4e2d\u6587' # =='中文'
'\65' # == '5'
```

#### 字节串 bytes

字符编码原理可以看[这篇博客](/计算机科学/字符编码/)。

在 Python 3 中，字符串用 Unicode 编码。在内存中使用 Unicode，但是如果需要保存在磁盘上，就需要把 `str` 变为 `bytes`。

`bytes` 常量须在单/双引号前加前缀 `b`，如 `b'ABC'`。

#### Unicode（`str`）和 `bytes` 的转换

Python 的 `str` 使用 Unicode 的，而若要用 ASCII 或 UTF-8 （如在网络或磁盘上存、取），就得使用 `bytes`。

`str` 可以通过成员函数 `encode()` 编码为指定编码（如`'ascii'`，`'utf-8'`）的 `bytes`。

```
>>> 'ABC'.encode('ascii');
b'ABC'
>>> '中文'.encode('utf-8')
b'\xe4\xb8\xad\xe6\x96\x87'
>>> '中文'.encode('ascii')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
UnicodeEncodeError: 'ascii' codec can't encode characters in position 0-1: ordinal not in range(128)
```

中文编码为 `ascii` 会报错。而 `utf-8` 中无法显示为 `ASCII` 字符的字节，会用 `\x##` 显示。

为避免乱码，应当坚持使用 `UTF-8` 对 `str` 和 `bytes` 进行转换。

而反过来，把指定编码的字节串编码为 Unicode 的函数叫 `decode()`。

```
>>> b'ABC'.decode('ascii')
'ABC'
>>> b'\xe4\xb8\xad\xe6\x96\x87'.decode('utf-8')
'中文'
>>> b'\xe4\xb8\xad\xff'.decode('utf-8')
Traceback (most recent call last):
  ...
UnicodeDecodeError: 'utf-8' codec can't decode byte 0xff in position 3: invalid start byte
>>> b'\xe4\xb8\xad\xff'.decode('utf-8', errors='ignore')
'中'
```

解码过程中可以传入 `errors='ignore'` 忽略错误的字节。

#### 字符串、字节串的长度

对于字符串，`len()` 能返回字符数；对于字节串，`len` 返回的是字节数。

```py
len('中文') # == 2
len('中文'.encode('utf-8')) # == 6
```

#### Python 源文件的编码

1. 文本编辑器应使用 UTF-8 without BOM
2. 在源代码前加：

```py
#!/usr/bin/env python3
#-*- coding:utf-8 -*-
```

或者使用 ANSI 编码，然后加上 `#-*- coding:ansi -*-`。默认为 UTF-8。

#### 格式化字符串

和 C 的 `printf()` 一样，Python 也支持格式化字符串，也是使用 `%`，用法也差不多。但是格式略有不同。

```
>>> 'Hello, %s' % 'world'
'Hello, world'
>>> 'Hi, %s, you have $%d.' % ('Michael', 1000000)
'Hi, Michael, you have $1000000.'
```

记一下就行。有意思的是，如果你不太确定应该用什么，`%s` 永远起作用，它会把任何数据类型转换为字符串：

```
>>> 'Age: %s. Gender: %s' % (25, True)
'Age: 25. Gender: True'
```



### 布尔值

`True`, `False` 大小写敏感

`print(True)` 输出 `True`（而非 C 的 1）。

布尔运算：`and`，`or`，`not`

### 空值

空值是 Python 里一个特殊的值，用 `None` 表示。`None` 不能理解为 0，因为 0 是有意义的，而 `None` 是一个特殊的空值。

### 其他数据类型

此外，Python 还提供了`列表`、`字典`等多种数据类型，还允许创建自定义数据类型.

## 变量

和 C 一样，变量名必须是大小写英文、数字和 `_` 的组合，且不能用数字开头。

赋值过程和 C 一样。

```py
a = 1
t_007 = 'T007'
a = True
```

Python （基本数据类型？）变量不需要初始化，且同一个变量可以反复赋值，而且可以是不同类型的变量。这种被称为 **动态语言**，反之为**静态语言**，如 C，Java。

### 常量

Python 没有常量。

习惯上，使用全大写命名来指代常量。
