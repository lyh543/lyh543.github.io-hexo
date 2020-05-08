---
title: Python 基础
date: 2020-2-18 21:18:37
tags:
- Python
- 编程语言入门
category:
- Python
---

> 学习链接：https://www.liaoxuefeng.com/wiki/1016959663602400
> 参考链接：https://docs.python.org/zh-cn/3.7/tutorial/index.html

比较基础的部分，新的东西就记一笔过一下就行了，方便以后查阅。

由于讲的偏系统，而不是深入浅出，比如一上来就把所有的东西讲完，也不说清哪些常用哪些不常用，其实不是很适合新手学习。

学起来才会感觉到，C++ 从会用到入门以后，学其他语言也不会只关心它的语法，还会去查它的实现，如 Python `list` 的实现，int 的上限（不存在的）。

## 基础语法

语句没有分号。

逗号不是用于分隔表达式，而是用于对多元组赋值：

```py
a, b = b, a+b
```

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

## 基本 IO

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
age = int(input('Please input your age')) # 需要输入 int 时需转换
```

## 基本数据类型

有整数 `int`，浮点数、字符串 `str`、字节串 `bytes` 布尔值 `bool`、空值 `None`。

### 整数的上限

知道怎么移位以后，我就尝试用 `(-1)>>1` 得知 Python 的上限。然而失败了。结果是 `-1` 是个什么意思？！

查了一下资料，发现 Python 整型是没有上限的？！因为它的实现是类似于高精度的变长数组（牺牲效率获取方便，没毛病）

那这个大概负数移位以后，自动把空出来的符号位又用 1 补上了。最后的结果就是，无论正负数，右移的结果是向下取整。

### 实数间的除法

Python 的 `\` 的结果是浮点数。

Python 的 `\\` 和 `%` 是广义的整除和取模，可以在浮点数间使用。

### 字符串

字符串可以理解为字符的 list，可以直接使用 list 的成员函数。

#### 字符串常量

1. 单双引号等价：`"a"` == `'a'`（Python 没有 `char` 的说法，只有 `one-character string`）  
2. 支持转义字符 `\`：`"'"` == `"\'"` == `'\''`，`'\n'`  
3. 类似于 C++ 的[逐字字符串](/Computer-Science/verbatim-strings-literal-grammar/)：`r'\n'` == `r'''\n'''`  
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

#### 字节串 bytes

字符编码原理可以看[这篇博客](/Computer-Science/字符编码/)。

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
>>> 'Age: %s. Gender: %s' % (25, True)
'Age: 25. Gender: True'
```

格式化字符串和参数中间由 `%` 隔开。和记一下就行。有意思的是，如果你不太确定应该用什么，`%s` 永远起作用，它会把任何数据类型转换为字符串。

另一种形式是用字符串的成员函数 `format()`，把一个字符串的 `{0}`、`{1}`等，用参数来一一替换得到一个新的字符串。

```
>>> 'Hello, {0}, 成绩提升了 {1:.1f}%'.format('小明', 17.125)
'Hello, 小明, 成绩提升了 17.1%'
```

### 前面各类型的转换

#### 字符、数字（ASCII 码）间的转换

单个字符和对应的 ASCII 码的转换可以使用 `ord()` 和 `chr()` 函数。

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

#### 字符串、实数间的转换

这种类型转换和 C++ 类似，把类型看作一个函数，如 `int()`，`str()`。

使用 `str()` 即可把 `int` 或 `float` 转为 `str`；  
使用 `int()` 可以把 `float`（和 C 一样，向 0 取整）和 `str`（要求是能转化为整数的字符串）转为 `int`。  
使用 `float()` 可以把 `int` 和 `str`（要求是能转化为实数的字符串）转化为 `float`。

```py
str(123.0) # = '123.0'
int('123') # = 123
int('123.0') # 报错 ValueError
float('123') # = 123.0
```

### 布尔值

`True`, `False` 大小写敏感

`print(True)` 输出 `True`（而非 C 的 1）。

布尔运算：`and`，`or`，`not`

#### 位运算

位运算： `&`，`|`，`^`，`~`，`>>`，`<<`

注意无论正负，进行右移 `>>` 操作都等价于除以 $2^n$ 后向下取整。参见[整数的上限](#整数的上限)。

`&&`，`||`，`!`：不存在的

### 空值

空值是 Python 里一个特殊的值，用 `None` 表示。`None` 不能理解为 0，因为 0 是有意义的，而 `None` 是一个特殊的空值。如输出没有返回值的函数的返回值，会输出 `None`：

```py
def foo()
    return

print(foo())
```

## 其他数据类型

此外，Python 还提供了`列表`、`字典`等多种数据类型，还允许创建自定义数据类型.

### 列表 list

和 C++ STL 的 `list` 不同，Python 的 `list` 实际上不是链表，是可变长度的数组（元素是指针，类似于 C++ STL 的 `vector<void *>`，所以可以不同类型的变量混合存储）。因此，`list.insert(index, elem)` 和 `list.pop(index)` 是 `O(n)` 时间复杂度的。

#### list 定义

`list` 内可存不同类型，可以嵌套 list。

```py
>>> classmates = ['Michael', 233 , "Tracy"]
>>> print(classmates)
['Michael', 233, 'Tracy']
>>> nestedList = [[1, 2], [3, 4]] # 类似与二维数组
>>> emptyset = []
```

如何初始化一个大小为 100，元素全为 0 的 `list` 呢？ 

```py
>>> newlist = [0] * 100
```

没错——  
Python 的列表居然支持乘法！！！！这也太香了！

但是这种语法有陷阱——如果想要建立二维 list，以下语法是不行的：

```py
>>> list2d = [[0] * 10] * 100
```

当你想要编辑第二行第二列个元素时，执行 `list2d[1][1] = 1` 后，会发现第二列的所有元素都变成了 `1`！

究其本质，是上面所说的，元素是指针，`[[0] * 10] * 100` 的外层 list 的 100 个元素实际上是指向了同一个 `list`。

解决方案有三个：

一是在外层老老实实的迭代：

```py
list2d = []
for i in range(100):
    list2d.append([0] * 10)
```

二是使用后面才会学到的列表生成式：

```py
list2d = [ [0 for i in range(10)] for j in range(100) ]
```

三是使用 `numpy.zeros`

```py
import numpy as np
test = np.zeros((m, n), dtype=np.int)
```


#### list 成员函数

函数名|函数用法
-|-
`len(classmates)`|列表中元素个数
`classmates[0]`|第一个元素 'Michael'
`classmates[3]`|返回 `IndexError`
`classamte[-1]`|返回最后一个元素（等价于`classmate[2]`）
`classmate[0:2]`|返回子列表，其元素在 `classmate` 的下标范围为 `[0,2)`，详见[切片](#切片-slice)
`classmate[-3:0]`|返回最后三个元素组成的子列表，详见[切片](#切片-slice)
`classmates.append('Adam')`|向末尾追加元素（类似于 C++ `std::vector::push_back()`）
`classmates.insert(index, 'Jack')`|在索引号为 index 的位置前插入元素（`O(n)` 时间复杂度）
`classmates.pop()`|删除末尾的元素
`classmates.pop(index)`|删除索引号为 index 的元素（`O(n)` 时间复杂度）

#### list 和 str

C 中，字符串是字符数组 `char[]`。
Python 中虽然二者是不同的类型，但是可以互通。

str 到 list 直接类型转换就好了。而 list 到 str 则需要使用 join 函数。

```
>>> list('abc')
['a', 'b', 'c']

>>> ''.join(['a', 'b', 'c'])
'abc'

'-'.join(['a', 'b', 'c'])
'a-b-c'
```

### 元组 tuple

~~元组这翻译怪怪的，可是谁叫 n-tuple 翻译过来是  n 元组呢~~

相当于是 list 的常量版本，一旦初始化就不能修改。但是可以使用 `[]`。

```
>>> classmates = ('Michael', 'Bob', 'Tracy')
>>> one_tuple = (1,)
>>> empty_tuple = ()
```

一元组要在 `)` 后加 `,` 以示和括号表达式的区分。

### 字典 dict

> Python 内置了字典：dict 的支持，dict 全称dictionary，在其他语言中也称为 map，使用键-值（key-value）存储，具有极快的查找速度。
> 查找和插入的速度极快，不会随着key的增加而变慢；
> 需要占用大量的内存，内存浪费多。

看到这里，其实已经猜到 dict 的实现是 hashmap 了。查了一下，果然是的。

#### 定义

```py
d = {'Michael': 95, 'Bob': 75, 'Tracy': 85}
d['Adam'] = 67
```

对同一个键进行存入，会直接覆盖原先的值。

#### 访问

访问：`d['Adam']`，（返回 67）。如果不存在键，则返回 `KeyError`。

如果要查询是否存在，可以使用 `if 'Adam' in d`。

#### dict 的 key

dict 的 key 要求是不可变的量，如整数、字符串、`tuple`。而 `list` 则不可以。若强行作为 key， 会返回 `TypeError: unhashable type: 'list'`。

## 变量

和 C 一样，变量名必须是大小写英文、数字和 `_` 的组合，且不能用数字开头。

赋值过程和 C 一样。

```py
a = 1
t_007 = 'T007'
a = True
```

Python （基本数据类型？）变量不需要初始化，且同一个变量可以反复赋值，而且可以是不同类型的变量。这种被称为 **动态语言**，反之为**静态语言**，如 C，Java。

### 查询、判断变量类型

查询类型使用 `type()`：

```py
>>> type(123)
<class 'int'>
>>> type('c')
<class 'str'>
```

判断类型使用 `isinstance()`：

```py
>>> isinstance(123,int)
True
>>> isinstance(123,str)
False
>>> isinstance(123,lyh543)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'lyh543' is not defined
```

### 常量

对基本数据类型，Python 没有常量。

习惯上，使用全大写命名来指代常量。

## 流程控制

### 条件判断（if）

`if` 中没有括号，判断条件后要加`:`。

貌似需要加缩进之前，前一个语句都需要加 `:`。这是个规律吧。

```py
age = 20
if age >= 18:
    print('your age is', age)
    print('adult')
```

`if` 后还可以加 `else`，`elif`。

```py
elif age < 0:
    print('input error')
else:
    print('teenage')
```

#### “三目运算符”

C / Java 中有很好用的三目运算符：

```c
printf("%s", value == true ? "Yes" : "No");
```

Python 没有三目运算符，但是 `if` 也可以用一行做到类似的功能：

```py
print("Yes" if value == True else "No")
```

### 循环

不精准的测试了一下，在我的 `i7-6600U` 下，以下代码大概要 10s：

```py
n = 0
sum = 0
while n < 1e7:
    sum += n
    n += 1
print(sum)
```

可以粗略得出，python 的整数加法计算次数约为 1e6 左右，为 C++ 的 1/1000。（C++ 相关测试可见我的另一篇博客：[C++ 基本计算的速度](/cpp/cpp-grammar/calculating_efficiency/)）。~~这只是一个没有感情的测试，不存在说 Python 慢就是垃圾的意思~~

#### for ... in ...

##### 在 list 用 for

类似于 C++ 的 `for(int : vector<int>)`，Python 可以使用 `for <variable> in <list/tuple>`：

```py
names = ['Michael', 'Bob', 'Tracy']
for name in names:
    print(name)
```

##### 用 range 生成序列

而如果是整数等差序列，可以使用 `range(start, stop[, step])` 函数，然后转为 list。`[start, stop)` 左闭右开。左闭右开可以按 C++ 常用的 `for (i = start; i < stop; i += step)` 来记。

如果是倒序的话，只要令 `step` 为负数即可。依旧是 `start` 闭，`end` 开（即 `for (i = start; i > stop; i += step)`）

以下四种语法等价。

```py
list(range(5))
list(range(0,5))
list(range(0,5,1))
[0, 1, 2, 3, 4]
```

就可以愉快的 `for i in list(range(5)):` 了。

顺便一提，`range` 可以类型转换为 `list`。

##### 在其他数据结构用 for

`str`，`dict`也是可迭代的。默认情况下，`dict` 迭代的是 key，但也可以迭代 key 和 value。

```py
d = {'a': 1, 'b': 2, 'c': 3}
for k in d:
for v in d.values():
for k, v in d.items():
```

判断某对象是否可迭代，可使用 `Iterable` 类型。

```py
from collections import Iterable
isinstance('abc', Iterable) # return true
```

如果想要实现下标循环，可以用 `emumerate()` 把 list 变为 `索引-元素对`。

```py
for i, v in enumerate(['A', 'B', 'C']):
```

同时引用两个变量是很常见的。

```py
for x, y in [(1, 1), (2, 4), (3, 9)]:
```

### while

和 `if` 一样。

```
sum = 0
i = 0
while i <= 100:
    sum += i
    i += 1
print(sum)
```

### break 和 continue

和 C 语言一样。

```py
n = 0
while n < 10:
    n = n + 1
    if n == 8:
        break
    if n % 2 == 0: # 如果n是偶数，执行continue语句
        continue # continue语句会直接继续下一轮循环，后续的print()语句不会执行
    print(n)
```

## 函数

### 调用函数

简单，不多说。

```py
abs(100) # = 100
abs(100,1) # TypeError: abs() takes exactly one argument (2 given)
abs('abc') # TypeError: bad operand type for abs(): 'str'
```

### 定义函数

函数前写 `def`，后面全部缩进。

```py
def my_abs(x):
    if x >= 0:
        return x
    else:
        return -x
```

如果函数保存在 `abstest.py` 中，需要使用 `from ... import ...` 来引入函数。

```py
from abstest import my_abs
```

`import` 的更复杂用法会在[模块](#模块)一节中详细介绍。

#### 空函数 pass

如果函数定义留空会报错，此时可以使用 `pass` 来占位。（`pass` 和 `return` 是不一样滴！！！）

```py
def nop():
    pass
```

在条件分支中也可以使用 `pass`：

```py
if age >= 18:
    pass
```

#### 函数类型检查

Python 解释器只进行参数个数的检查，不进行参数类型的检查。需要自己使用 `isinstance(variable, tuple of type)` 手动检查。

注意 `isinstance()` 中 `int` 和 `float` 是不一样的（本来也是，`str` `float` `int` 之间随便转，他们也不是一个东西）。

```py
def my_abs(x):
    if not isinstance(x, (int, float)):
        raise TypeError('bad operand type')
    pass
```

还用到了 `raise` 返回错误。要多练习一下。

##### 函数练习

给定 $a,b,c$，解一元二次方程$ ax^2 + bx + c = 0$：

```py
import math

def isnum(x):
    return isinstance(x,(int,float))

def quadratic(a, b, c):
    if not (isnum(a) or isnum(b) or isnum(c)):
        raise TypeError
    delta = b * b - 4 * a * c
    if (delta < 0):
        print('delta < 0, no real root')
        pass
    sqrt_delta = math.sqrt(delta)
    return (-b+sqrt_delta)/2, (-b-sqrt_delta)/2

print(quadratic(1,1,1));
```

### 函数参数

其中 3.-5. 有点硬核，先不管。用到再学。

#### 1. 必选参数

即最普通的用法。

```py
def pow(x, n):
    pass

pow(3, 2)
```

#### 2. 默认参数

和 C++ 一样，Python 也有默认参数。

```py
def pow(x, n = 2):
    pass

pow(3)
```

**声明参数时必选参数在前，默认参数在后**，否则会导致编译错误。

调用函数时，默认参数可以不写，也可以按顺序给出。如无法按顺序给出（第一个默认参数为默认，但第二个不默认），可以指明变量名。

```py
enroll('Adam', 'M', city='Tianjin')
```

##### 坑

**默认参数要指向不变对象！！**

如：

```py
def add_end(L = []):
    L.append('END')
    return L

add_end() # return ['END']
add_end() # return ['END', 'END']
```

究其本质，还是 [] 只是一个指针。

用 `add_end(L = None)` 即可解决。

```py
def add_end(L = None):
    if L is None
        L = []
    L.append('END')
    return L

add_end() # return ['END']
add_end() # return ['END']
```

#### 3. 可变参数

如果不使用可变参数，传入 list 或 tuple 时就需要先组装。

```py
def calc(numbers):
    sum = 0
    for n in numbers:
        sum += n * n
    return sum

calc([1,2,3]) # = 14
calc((4,5,6)) # = 77
```

如果使用可变参数，就不用组装了，也可以调用 0 个参数。在变量名前面加 `*` 即是可变参数。而调用 list 或 tuple 时也可以加一个 `*`。

```py
def calc(*numbers):
    # ...

calc(1,2,3) # = 14
nums = (4,5,6)
calc(*nums) # = 77
```

`print()` 也是使用这种形式。

#### 4. 关键字参数

上面是把所有参数变为 tuple，而这里是把额外的 0 个或 n 个参数变为 dict。

```py
def person(name, age, **kw):
    print('name:', name, 'age:', age, 'other:', kw)

>>> person('Michael', 30)
name: Michael age: 30 other: {}
>>> person('Adam', 45, gender='M', job='Engineer')
name: Adam age: 45 other: {'gender': 'M', 'job': 'Engineer'}
```

这有什么用呢？比如，在 `person` 函数里，我们保证能接收到 `name` 和 `age` 这两个参数，但是，如果调用者愿意提供更多的参数，我们也能收到。  
试想你正在做一个用户注册的功能，除了用户名和年龄是必填项外，其他都是可选项，利用关键字参数来定义这个函数就能满足注册的需求。

```py
>>> extra = {'city': 'Beijing', 'job': 'Engineer'}
>>> person('Jack', 24, **extra)
name: Jack age: 24 other: {'city': 'Beijing', 'job': 'Engineer'}
```

而传 dict 进去也是，加 `**` 就可以了。

但是请注意，这种用法中，不管是传很多组，还是直接传 dict，Keywords 必须为 string 名。诸如 `1=one`，`'one'=1` 都不能作为关键词参数传进函数。而传进去的 Keywords，会加引号。

#### 5. 命名关键字参数

关键字参数中，对参数名没有直接限制；如果需要限制名字，可以使用命名关键字参数。

```py
def person(name, age, *, city, job):
    print(name, age, city, job)
```

这样，我们只接受 city 和 job，其他参数会被忽略。

#### 参数组合

Python 定义函数，可以按顺序组合使用 `必选参数`、`默认参数`（y=1）、`可变参数`（\*kw，组成 tuple）、`命名关键字参数`（\*,x,y）、`关键字参数`（\*\*kw，组成 dict）。

但是不要使用太多的组合~~否则代码就太难理解了~~。

## 高级特性

这部分和 C 差异有点大，因此先水过去，等用到的时候再看。

### 切片 slice

现在有一个 `list L = list(range(20))`。使用切片可以快速得到其子序列。

使用 `L[begin:end]` 可以得到 L 下标在 [begin, end) 范围内的数据。注意：

1. begin 和 end 可以按[规定](#list-函数)使用负数。
2. begin 和 end 可以省略，缺省值为 begin = 0， end = 末尾下标+1。
3. 若 end > begin，则返回空 list `[]`。

slice 也可以使用于 tuple，str 等支持切片的功能。

另外还可以用 `L[start:end:step]` 指定 `step` 大小。每隔五个取一个就是 `arr[::5]`。

```py
>>> a=list(range(100))
>>> a[::5]
[0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95]
```

### del 语句

list 自带了 `append` 和 `insert`，分别是在 list 最后追加元素、在中间插入元素。也可以使用 `del` 删除元素。

```py
>>> a = [-1, 1, 66.25, 333, 333, 1234.5]
>>> del a[0]
>>> a
[1, 66.25, 333, 333, 1234.5]
>>> del a[2:4]
>>> a
[1, 66.25, 1234.5]
>>> del a[:]
>>> a
[]
```

### 迭代 iteration

其实就是前面讲了的 [for ... in ...](#for-…-in-…) 语法。

### 列表生成式

这个东西可以把 list（或可迭代的数据类型）中的元素通过自定义的映射函数生成新的 list 或 tuple。还可以配合 if、两层 for。

```py
>>> [x * x for x in range(1, 11)]
[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
>>> [x * x for x in range(1, 11) if x % 2 == 0]
[4, 16, 36, 64, 100]
```

另外还可以使用两个变量。

```py
>>> d = {'x': 'A', 'y': 'B', 'z': 'C' }
>>> [k + '=' + v for k, v in d.items()]
['y=B', 'x=A', 'z=C']
```

### 生成器 generator

列表生成式是新建一个链表，而生成器是保存映射关系，需要时再进行计算。

#### 第一种方法

用法仅仅把列表生成式的 `[]` 改为 `()`。

```py
>>> g = (x * x for x in range(10))
>>> g
<generator object <genexpr> at 0x1022ef630>
```

我们可以反复使用 `next()` 获得 generator 的下一个返回值。

```py
>>> next(g)
0
>>> next(g)
1
>>> next(g)
4
>>> next(g)
9
>>> next(g)
16
>>> next(g)
25
>>> next(g)
36
>>> next(g)
49
>>> next(g)
64
>>> next(g)
81
>>> next(g)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
StopIteration
```

当然可以使用 for 循环。

#### 第二种方法：yield

输出 Fibonacci 数的前 max 位，可以使用一个函数：

```py
def fib(max):
    n, a, b = 0, 0, 1
    while n < max:
        print(b)
        a, b = b, a + b
        n = n + 1
    return 'done'
```

上述程序会一次性计算完前 max 位。

把上面的程序改为 generator。

学不会学不会，感觉也不常用。留个坑吧。

https://www.liaoxuefeng.com/wiki/1016959663602400/1017318207388128

## 函数式编程

函数式编程就不仅仅是单纯的函数体、调用函数了了，还有更多的东西，比如类似于 C/C++ 函数指针的功能等等。

### 将函数赋给变量

其实就是将函数指针赋给了变量。

```py
>>> abs(-10)
10

>>> f=abs
>>> f(10)
10
>>> f
<built-in function abs>
```

理所应当地，也可以把函数作为函数的参数。

```py
def add(x, y, f):
    return f(x) + f(y)
print(add(5, -6, abs)) # 输出 11
```

下面是一些应用：`map`、`reduce`、`filter`、`sorted`。

### map

python 的 `map` 其实类似于对一个 list/tuple 的每个元素使用函数 `f`，得到一个新的 list（实际上是把 `map` 类型转换为了 `list`），具体操作如下：

```py
>>> r = map(f,list(range(10)))
>>> list(r)
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
```

显然该操作也可以使用循环，但是 python 追求的就是极致的简洁。

### reduce

> reduce() 函数会对参数序列中元素进行累积。  
> 函数将一个数据集合（链表，元组等）中的所有数据进行下列操作：用传给 reduce 中的函数 function（有两个参数）先对集合中的第 1、2 个元素进行操作，得到的结果再与第三个数据用 function 函数运算，最后得到一个结果。
>  --[Python reduce() 函数| 菜鸟教程](https://www.runoob.com/python/python-func-reduce.html)

`reduce` 和 `map` 一样，也接受两个参数，第一个是 `f(x,y)`，第二个是一个 list/tuple，作用类似于叠加：

```py
>>> def f(x,y):
...     return x + y
...
>>> from functools import reduce
>>> r = reduce(f,[1,2,3,4,5]);
>>> r
15
```

也可以尝试手写一个将存有 digit 的 list 转为 int：

```py
from functools import reduce

def fn(x, y):
    return x * 10 + y

print(reduce(fn, [1, 2, 3, 5, 8, 3])) # 输出123583
```

#### 函数式编程练习

使用 `reduce` 和 `map` 手写一个 `str2int` 函数，将字符串转为整数。

这也说明，字符串可以当做字符的 list 来用。

```py
def str2int(_str):
    from functools import reduce

    def char2digit(x):
        return ord(x)-ord('0')

    def fn(x, y):
        return x * 10 + y
    return reduce(fn, map(char2digit, _str))


print(str2int("123") + 321)
```

### filter

这个函数有两个参数，第一个是返回 `True` 或 `False` 的函数 `f`，第二个是一个 list。 filter 函数返回 list 中 `f(x)` 为真的所有 `x`。

```py
def is_odd(n):
    return n % 2 == 1

list(filter(is_odd, [1, 2, 4, 5, 6, 9, 10, 15]))
# 结果: [1, 5, 9, 15]
```

### sorted

`sorted` 函数返回原 list/tuple 被排序以后的 list/tuple（而不是直接在 list/tuple 上修改）。

```py
>>> arr=[3,1,8,4,5]
>>> sorted(arr)
[1, 3, 4, 5, 8]
```

可以用一个函数作为 `key` 参数指定排序的依据。可以用 `Reverse=True` 参数使降序排列。

注意这个函数不是类似于 C++ sort 所需的返回两个元素的大小的 bool 值，而是**返回一个元素的大小**，如可使用 `abs` 函数：

```py
>>> '-'.join(['a', 'b', 'c'])
'a-b-c'
>>> arr2=[-4, -2, 1, 3, 5]
>>> sorted(arr2, key=abs)
[1, -2, 3, -4, 5]
```

对字符串 list 可以直接以字典序排序：

```py
>>> arr3=['banana', 'anana', 'nana', 'ana', 'na', 'a']
>>> sorted(arr3)
['a', 'ana', 'anana', 'banana', 'na', 'nana']
```

注意在 Python 中，`Z<a`，如果想要忽略大小写，可以把 `key` 设定为 `str.tolower` 函数。

```py
>>> sorted(['bob', 'about', 'Zoo', 'Credit'], key=str.lower, reverse=True)
['Zoo', 'Credit', 'bob', 'about']
```

### 函数作为返回值

我们可以在函数内部创建一个函数（又名嵌套函数），然后返回。刚看到这里，说实话不知道这个有什么意义。

```py
def lazy_sum(*args):
    def sum():
        ax = 0
        for n in args:
            ax = ax + n
        return ax
    return sum
```

```py
>>> f = lazy_sum(1, 3, 5, 7, 9)
>>> f
<function lazy_sum.<locals>.sum at 0x101c6ed90>
>>> f()
25
```

多次调用 lazy_sum 时，会在不同位置创建多个函数，虽然他们本质是一样的。

```py
>>> f1 = lazy_sum(1, 3, 5, 7, 9)
>>> f2 = lazy_sum(1, 3, 5, 7, 9)
>>> f1==f2
False
```

对于输入或输出是函数的函数，我们称为这种函数叫高阶函数。

### 闭包 closure

廖雪峰的博客这一部分讲的有点糙，没看懂。

> 以下参考 [FOOFISH-PYTHON之禅](https://foofish.net/python-closure.html)。

先来看一个例子：

```py
def print_msg():
    # print_msg 是外围函数
    msg = "zen of python"
    def printer():
        # printer 是嵌套函数
        print(msg)
    return printer

another = print_msg()
another() # 输出 zen of python
```

这个例子乍一眼看上去没什么问题，但是问题就在于，`msg` 其实是 `print_msg()` 的局部变量，在执行完 `print_msg` 以后，`msg` 应该被删掉，但是执行 `another` 的时候，又输出了。这就是闭包。

> 在计算机科学中，闭包（Closure）是词法闭包（Lexical Closure）的简称，是引用了自由变量的函数。这个被引用的自由变量将和这个函数一同存在，即使已经离开了创造它的环境也不例外。所以，有另一种说法认为闭包是由函数和与其相关的引用环境组合而成的实体。

闭包避免了使用全局变量，此外，闭包允许将函数与其所操作的某些数据（环境）关连起来。这一点与面向对象编程是非常类似的，在面对象编程中，对象允许我们将某些数据（对象的属性）与一个或者多个方法相关联。

一般来说，当对象中只有一个方法时，这时使用闭包是更好的选择。来看一个例子：

```py
def adder(x):
    def wrapper(y):
        return x + y
    return wrapper

adder5 = adder(5)

adder5(10) # 输出 15
adder5(6)  # 输出 11
```

这比用类来实现更优雅，此外装饰器也是基于闭包的一中应用场景。

没看大懂，以后再来看叭。

### lambda 函数

lambda 函数就是匿名函数。一般用于函数比较简短的情况。

```py
def is_odd(x):
    return x % 2 == 1

L=range(10)
print(list(filter(is_odd, L))) # 输出 [1, 3, 5, 7, 9]
```

对于这个简短的的 `is_odd` 函数，写了不仅让代码多了两行（不考虑那种按代码行数计算工资的程序员），还多占用了一个 `is_odd` 名字。其实我们完全可以用匿名函数来解决：

```py
L=range(10)
print(list(filter(lambda x : x % 2 == 1, L))) # 输出 [1, 3, 5, 7, 9]
```

也就是说，`lambda x : x % 2 == 1` 这是一个函数，完全等价于我们在第一段函数定义的 `is_odd(x)`。

当然，当 lambda 函数变复杂时，还是推荐使用 `is_odd(x)` 这样的常规函数。

### 装饰器 decorator

装饰器是什么？在调试程序的时候，可能需要在函数的前后输出相关信息。此时，我们就可以对函数进行“装饰”，使得运行该函数时，会输出相关信息。

那么，如何实现呢？我们定义一个 `wrapper` 函数，他做的事情是在某函数开始时输出、在函数结束时再输出。

如果我们还想要写一个通用 `wrapper` 函数对于所有函数都生效，那么 `wrapper` 执行的函数应该作为一个参数。作为谁的参数呢？

在 Python 的装饰器里，我们定义一个 `wrapper` 函数，其输入、输出和 `func` 完全一致，这个函数做的事，就是调用 `func` 函数，并在调用 `func` 前后做一些事情（输出、计时等等）。

而指定 `func` 的办法，是我们再定义一个 `log` 函数，这个函数输入 `func`，这个函数的操作是定义并返回调用了 `func` 的 `wrapper`。说了这么多大概晕了，那么直接上代码吧。

```py
def log(func):

    def wrapper(*args, **kw):
        print('starting executing function %s' % func.__name__)
        start_time = time.time()
        value = func(*args, **kw)
        end_time = time.time()
        print('function %s end in %d seconds' % (func.__name__, start_time - end_time))
        return value
    
    return wrapper
```

有了上面的代码，我们可以在需要装饰的函数前（示例为 `test`）加上 `@log`。

```py
@log
def test(x, y):
    time.sleep(2)
    return x + y
```

先不说 `@log` 的原理，我们先来调用一下 `test` 函数。把上面的两段代码整合在一起，然后调用 `test`。

```py
def log(func):

    def wrapper(*args, **kw):
        print('starting executing function %s' % func.__name__)
        start_time = time.time()
        value = func(*args, **kw)
        end_time = time.time()
        print('function %s end in %d seconds' % (func.__name__, end_time - start_time))
        return value
    
    return wrapper

@log
def test(x, y):
    time.sleep(2)
    return x + y

print(test(12,138))
```

输出如下

```
starting executing function test
function test end in 2 seconds
150
```

如果把 `@log` 去掉，那么程序只会输出 `150`。也就是说，我们成功地在 `test` 执行前后进行了计时、输出。

再回来说 `@log` 的原理：在定义 `test` 函数前加 `@log`，程序会在 `test` 定义完以后，执行 `test=log(test)`。配合 `log` 函数的定义就能做到前面所述的效果。具体过程如下：

1. 定义原 `test`
2. 把 `test` 作为参数给 `log`。
   - `log` 创造了 `wrapper(*args, **kw)` 函数，该 `wrapper` 函数执行 `test(*args, **kw)` 并返回 `test` 的返回值
3. `test=log(test)`。将创造的 `wrapper` 函数改名为 `test`。
4. 以后调用 `test`，执行的实际上是在 `log(test)` 中定义的 `wrapper`。

大致原理如上。

但是还有一点问题，在以后我们调用 `test.__name__` 时，由于此时的 `test` 实际上是 `wrapper`，所以返回就有点问题。

解决方法可以在 `wrapper` 定义中加一句 `wrapper.__name__ = func.__name__`。但是推荐直接调用 Python 自带的装饰器。

```py
import functools

def log(func):
    @functools.wraps(func)
    def wrapper(*args, **kw):
        print('starting executing function %s' % func.__name__)
        start_time = time.time()
        value = func(*args, **kw)
        end_time = time.time()
        print('function %s end in %d seconds' % (func.__name__, start_time - end_time))
        return value
    
    return wrapper
```

完整代码如下：

```py
import time
import functools

def log(func):
    @functools.wraps(func)
    def wrapper(*args, **kw):
        print('starting executing function %s' % func.__name__)
        start_time = time.time()
        value = func(*args, **kw)
        end_time = time.time()
        print('function %s end in %d seconds' % (func.__name__, end_time - start_time))
        return value
    return wrapper

@log
def test(x, y):
    time.sleep(2)
    return x + y

f = test(11, 22)

print(f)
print(test.__name__)
```

> 在面向对象（OOP）的设计模式中，decorator 被称为装饰模式。OOP 的装饰模式需要通过继承和组合来实现，而 Python 除了能支持 OOP 的 decorator 外，直接从语法层次支持 decorator。Python 的 decorator 可以用函数实现，也可以用类实现。
> decorator 可以增强函数的功能，定义起来虽然有点复杂，但使用起来非常灵活和方便。—— 廖雪峰的 Python 教程

### 偏函数 partial function

看到这个名字想到了微积分的偏导数。其实差不多，偏导数是 `f(x,y)` 固定了 `x` 求关于 `y` 的导数，Python 的偏函数也是，用于固定一个参数。

那么偏函数和重新定义一个函数有什么区别呢？如下：

```py
int2_1 = functools.partial(int, base = 2)

def int2_2(x):
    return int(x, base = 2)

print(int2_1(12138), int2_1(12138))
```

## 模块

在 Python 中，一个 `.py` 文件就称之为一个模块（Module）。

### 使用模块

```py
import sys
import numpy as np
```

按第一行导入 `sys` 模块后，我们就有了变量 `sys` 指向该模块，利用访问 `sys` 这个变量的成员（如 `sys.argv`），就可以访问 `sys` 模块的所有功能。也可以使用别的变量名，比如后面一句，就用 `np` 指向了 `numpy`。

顺便，在 Python 环境中（即 `>>>` 中）貌似没法直接运行脚本，如果需要调用脚本中的函数，应该当做模块一样，`import filename` 然后 `filename.function_name()` 来调用。

## 面向对象编程

见 [Python 面向对象编程](../python-oop)。