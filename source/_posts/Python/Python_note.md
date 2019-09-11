---
title: Python 基础
date: 2019-08-30 21:18:37
tags: 
category: 
 - Python
---

> 学习链接：https://www.liaoxuefeng.com/wiki/1016959663602400

比较基础的部分，新的东西就记一笔过一下就行了，方便以后查阅。

学起来才有感觉，C++ 从会用到入门以后，学其他语言也不会只关心它的语法，还会去查它的实现，如 Python `list` 的实现，int 的上限（不存在的）。

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

#### 定义 list

`list` 内可存不同类型，可以嵌套 list。

```py
>>> classmates = ['Michael', 233 , "Tracy"]
>>> print(classmates)
['Michael', 233, 'Tracy']
>>> nestedList = [[1, 2], [3, 4]] # 类似与二维数组
>>> emptyset = []
```

#### 函数

函数名|函数用法
-|-
`len(classmates)`|列表中元素个数
`classmates[0]`|第一个元素 'Michael'
`classmates[3]`|返回 `IndexError`
`classamte[-1]`|返回最后一个元素（等价于`classmate[2]`）
`classmate[0:2]`|返回子列表 `classmate[0,2)`，详见[切片](#切片-slice)
`classmates.append('Adam')`|向末尾追加元素（类似于 C++ `std::vector::push_back()`）
`classmates.insert(index, 'Jack')`|在索引号为 index 的位置前插入元素（`O(n)` 时间复杂度）
`classmates.pop()`|删除末尾的元素
`classmates.pop(index)`|删除索引号为 index 的元素（`O(n)` 时间复杂度）

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

可以粗略得出，python 的整数加法计算次数约为 1e6 左右，为 C++ 的 1/1000。（C++ 相关测试可见我的另一篇博客：[C++ 基本计算的速度](/C++/C++语法/calculating_efficiency/)）。~~这只是一个没有感情的测试，不存在说 Python 慢就是垃圾的意思~~

#### for ... in ...

##### 在 list 用 for

类似于 C++ 的 `for(int : vector<int>)`，Python 可以使用 `for <variable> in <list/tuple>`：

```py
names = ['Michael', 'Bob', 'Tracy']
for name in names:
    print(name)
```

而如果是整数等差序列，可以使用 `range(start, stop[, step])` 函数，然后转为 list。`[start, stop)` 左闭右开，

以下四种语法等价。

```py
list(range(5))
list(range(0,5))
list(range(0,5,1))
[0, 1, 2, 3, 4]
```

就可以愉快的 `for i in list(range(5)):` 了、

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

交作业：给定 $a,b,c$，解一元二次方程$ ax^2 + bx + c = 0$：

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

### 切片 slice

现在有一个 `list L = list(range(20))`。使用切片可以快速得到其子序列。

使用 `L[begin:end]` 可以得到 L 下标在 [begin, end) 范围内的数据。注意：

1. begin 和 end 可以按[规定](#函数)使用负数。
2. begin 和 end 可以省略，缺省值为 begin = 0， end = 末尾下标+1。
3. 若 end > begin，则返回空 list `[]`。

slice 也可以使用于 tuple，str 等支持切片的功能。

### 迭代 iteration

可见[for](#for--in)部分。

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
