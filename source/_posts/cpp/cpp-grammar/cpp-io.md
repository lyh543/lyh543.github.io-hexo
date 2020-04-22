---
title: C++ I/O 输入输出
date: 2019-09-04 10:34:08
tags:
- C++
- iostream
- C++
- C++语法
category:
- C++
- C++语法
mathjax: true
---

C 语言风格 I/O 请见[C I/O](../C_IO/)。

流：从某种 IO 设备上读入或写出的字符序列。

标准库中的 IO 对象，除了 `cin`、`cout`，还有：
1. `cerr`：用来输出警告、错误给程序的使用者（可以理解为第二块屏幕）  
2. `clog`：用于产生 log。

## cin, cout

```c++
int ch;
cin >> ch; //ignore endline when reading
cout << endl;
```

## istream::getline()

`getline()` 会吃掉回车。

下面这种方法只能用于读 `char *`。

```c++
char word[50];
cin.getline(word, 50); //ignore endline when storing
```

而下面这种方法，把 `cin` 作为参数则只能用于读取 `string`。

```c++
string str;
getline(cin,str);
```

需要注意，`cin.getline` 是属于 `iostream` 的，而 `getline(cin,str)` 是属于 `string` 的。


## istream::get()

`get()` 有两个重载函数：

1. 读一个字符
2. 读一个字符串。

如果无参数，则是读字符，类似于 `getchar()`：

```c++
ch = cin.get();
```

上面两个都是读取一个字符，若可用则返回它，不可用时会对 `cin` 设置 `failbit` 和 `eofbit`。

如果带参数，可以读 `char` `char *‘。

```c++
char str1[n];
cin.get(str1, n, '\n')
```

这是读一个字符串，并且可以指定分隔符（最后分隔符会被吃掉）。

### 错误示范1

```c++
int a; char s[10];
cin >> a;
cin.getline(s);
```

`istream& operator>>` 不会吃掉最后的空格！！！ 

紧接在读取数字等类型的 `cin` 语句后，`getline` 会读取其前一条语句留在输入法中的 `"\n"`而结束。

```c++
cin >> a >> s;
```

而上面这个方法则没有问题。

**cin会过滤空白字符，而cin.getline()不会。**

### 错误示范2

```c++
int a, b, c;
cin >> a >> b;
cin >> c;
```

输入"1a2"时，当'a'不能输入到b时，输入流将关闭。
需要`cout.flush()`

## 设置输出格式

```c++
#include<iomanip>
cout << fixed; //一定先 cout <<fixed, 某 OJ 上不写会出错
cout << setprecision(n); //设置有效位数，四舍五入
cout << setw(n); //设置对齐位数
cout << setiosflags(ios::left); //设置对齐方向
resetiosflags(ios::left);
cout << hex << setiosflags(ios::showbase) <<  17 << 18; //hex十六进制，oct八进制，dec十进制
```

## 二进制输出

函数|作用
`basic_istream& read(char_type* s, std::streamsize count)`|以二进制形式输入（不看是不是字符，直接莽输入）
`basic_ostream& write(const char_type* s, std::streamsize count)`|以二进制形式输出（失败时调用 `setstate(badbit)`）

## 从文件输入、输出

```c++
int i;
ofstream output;
ifstream input;
output.open("output.txt");
input.open("input.txt");
input >> i;
output << i;
```

### fstream 的成员函数

函数|作用
-|-
`void open(filename, mode)`|打开文件，详见 [open()](#open)
`bool is_open() const`|判断是否打开
`void close()`|关闭文件
`get()`|读取一个字符或一行，详见 [get()](#istreamget)
`getline()`|读取一行（不读回车），详见 [getline()](#istreamgetline)
`basic_istream& read(str, std::streamsize count)`|以二进制形式输入（不看是不是字符，直接莽输入）
`basic_ostream& write(str, std::streamsize count)`|以二进制形式输出（失败时调用 `setstate(badbit)`
`bool eof()`|判断文件是否结束

### open()

```c++
void fstream::open(const char * filename, ios_base::openmode mode)
void fstream::open(const std::string & filename, ios_base::openmode mode)
```

其中 mode 是位掩码类型（即可以用 `|` 进行叠加）：

常量|解释
-|-
`app`|每次写入前寻位到流结尾（输出补充在文末）
`binary`|以二进制模式打开
`in`|为读打开
`out`|为写打开
`trunc`|在打开时舍弃流的内容（若存在文件则覆盖）
`ate`|打开后立即寻位到流结尾（初始位置：文件末）

mode 的默认参数：  
fstream：`ios_base::in | ios_base::out`
ifstream：`ios_base::in | ios_base::trunc`
ofstream：`ios_base::out`

### 文件指针位置相关操作

以下 `p` 代表 `put`，对输出流操作；`g` 代表 `get`，对输入流操作。

文件指针实际上就是一个标记字节的数字，起始为 `0`。

用成员函数 `tellg()/tellp()` 获取当前位置，返回 `streampos`（实际上是一个整型，在 VS 2017 x86/x64 上范围和 `signed long long` 相同）。

修改的成员函数有绝对和相对的。下仅以 `seekp()` 作示范，`seekg()` 用法相同。

```c++
istream& seekg (streampos pos); //(1)
istream& seekg (streamoff off, ios_base::seekdir way); //(2)
```

(1) 修改到绝对指针，(2) 修改到相对指针，`off` (offset) 为位移量（可以为负），`way` 为位移的正负（`way > 0` 时往流的末尾，`way == 0` 时往流的开头，建议用 `true/false`，但既然 `off` 可以为负，感觉就很鸡肋了）。

## string 和 iostream 的关系

参见这篇[博客](../string/#string-和-iostream-的关系)。

### 重载 iostream

> 参考博客: http://blog.csdn.net/caroline_wendy/article/details/15336063

### 1. 输出操作符(ostream)重载

```c++
std::ostream &operator<< (std::ostream& os, const ClassA& ca);
```

ostream需要修改，不能复制，所以应该为**非常量引用类型(nonconst &)**；输出类不需要修改, 应该为**常量引用类型(const &)**；

函数有可能使用内部的私有成员，需要定义为**友元(friend)**；

重载操作符应该为非类成员函数(nonmember function)。如果为类成员函数，则也必须为标准库成员函数，显然无法完成。

注意函数不要有格式信息(minimal formatting)，为了和标准输入操作符进行统一。

### 2. 输入操作符(istream)重载

```c++
std::istream &operator>> (std::istream& is, ClassA& ca);
```

基本同输出操作符；

参数都为 `non-const`（都需要修改)；

操作符函数应该包括错误恢复(error recovery)，保证输入错误时，不会产生未知错误；

可以增加 I/O 条件状态(condition state)进行判断，输入错误原因。

## 刷新输入缓冲区

在读 `int` 的时候如果读到了非数字字符，输入流就会被关闭（输入流会变成错误状态），无法继续读入。

解决的办法就是重新打开输入流（将错误状态更改为有效状态），顺便可能需要忽略掉一些字符。

> `cin.clear()` 是将错误状态更改为有效状态
> `cin.sync()` 是清除缓冲区中的未读信息
> `cin.ignore()` 是忽略缓冲区中指定个数的字符，还可以指定忽略的结束符

也就是说，当我们想要刷新输入流并忽略掉已经在缓冲区的字符时，我们可以使用以下方法：

```cpp
cin.clear();
cin.sync();
```

但是，在 Visual Studio 2019 上，他貌似并没有清楚缓冲区的未读信息。

在 [Stack Overflow](https://stackoverflow.com/a/10585440/12208030) 上提到了这么一句，

> `cin.sync` discards all unread characters from the input buffer. **However, it is not guaranteed to do so in each implementation.** Therefore, ``ignore`` is a better choice if you want consistency.

大意是， `cin.sync` 在各个平台上实现的方法可能不一样，比如这里在 Visual Studio 2019 上就不能用 `sync` 来清楚缓冲区的未读信息。可以改为如下：

```cpp
cin.clear();
cin.ignore(10000, '\n');
```

这样可以忽略掉缓冲区的一行字符。

注意 `ignore` 还可以忽略还没有输入的字符，如以下程序：

```
char ch;
cin.igore(10);
while (cin >> ch)
    cout << ch;
```

运行程序，输入 `qwertyuiopasdf`，会输出 `asdf`。

## 命令行程序控制输入

命令行防止错误的输入真是令人头疼的问题了。一般有两个方案：

1. 只使用 `cin.getline()` 读入，一行一行的读
2. 读错了以后马上刷新，按上面一个标题的办法
