---
title: C++ I/O 输入输出
date: 2019-09-04 10:34:08
tags:
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

```c++
char word[50];
cin.getline(word, 50); //ignore endline when storing

//input a string to x which is up to 100 char
//and see 'x' as end(default '\n')
cin.getline(ch, 100, 'x');
```

## istream::get()

```c++
cin.get(ch);
ch = cin.get();
```

上面两个都是读取一个字符，若可用则返回它，不可用时的处理略有不同，但都会设置 `failbit` 和 `eofbit`。

```c++
cin.get(str, n, delim = '\n')
```

### **错误示范1**

```c++
int a; char s[10];
cin >> a;
cin.getline(s);
```

紧接在读取数字等类型的cin语句后，getline会读取其前一条语句留在输入法中的”\n”而结束。

```c++
cin >> a >> s;
```

而上面这个方法则没有问题。

**cin会过滤空白字符，而cin.getline()不会。**

### **错误示范2**

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

## iostream 二进制输出

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

可以增加I/O条件状态(condition state)进行判断，输入错误原因。
