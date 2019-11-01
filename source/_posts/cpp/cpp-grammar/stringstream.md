---
title: C++ stringstream
date: 2019-8-16
tags:
category:
- C++
- C++语法
mathjax: true
---

> 参考博客: http://www.usidcbbs.com/read-htm-tid-1898.html

C++ 的 `iostream` 输入输出流很好用，而它也有两个兄弟：`fstream` 和 `sstream` （或 `stringstream`），三个的用法差不多，能够触类旁通，就很舒服。本文就介绍一下 `stringstream` 和 `iostream` 的相同和不同的地方。

## iostream 和 stringstream 的继承关系

![iostream 和 stringstream](http://www.pconline.com.cn/pcedu/empolder/gj/c/0504/pic/08cppios01.gif)

## 引入头文件和定义变量

```c++
#include<sstream>
std::istringstream istr;
std::ostringstream ostr;
std::stringstream sstr;
```

其中，`istringstream` 用于流的输入，`ostringstream` 用于流的输出，`stringstream` 用于流的输入输出。具体的区别在下面提到。

## istringstream 使用方法

`cin` 是从控制台读取数字、字符串，而 `istringstream` 就是从指定的字符串中读取数字、字符串。

首先指定 `istringstream` 读取的源字符串。下两种形式是等价的：

```c++
istringstream istr1;
istr1.str("12 3.1415");

istringstream istr2("12 3.1415");
```

然后用类似于 `cin` 的语法就可以从该字符串读取数字等了。

```c++
int a;
float b;
istr1 >> a >> b; //a==12, b==3.1415
```

## ostringstream 使用方法

`cout` 是把内容往屏幕上输出，而 `ostringstream` 就是把内容往字符串输出。

`ostringstream` 是先读入数字等内容到该 `ostringstream`，然后获取该 `ostringstream` 中存的字符串。

```c++
ostr << a << b;//a==12, b==3.1415
```

读取 `ostringstream` 中的字符串需要使用成员函数 `str()`。

```c++
cout << ostr.str() <<endl;
cout << ostr.str().length() << endl;
```

成员函数 `str()` 返回一个 `string`。搭配头文件 `string` 就可以使用 `string` 类的各种功能。  
注意该函数也可以在 `istringstream` 和 `stringstream` 中使用，同样是获取流中存储的字符串。

ostringstream 同样可以赋初值，但是在进行输入的时候，输入的东西会先修改初值的对应部分，输出超过原长的那一部分才会追加到串的后面。

```c++
ostringstream ostr("abc");
ostr.put('d');
ostr.put('e');
cout << ostr.str() << endl;
ostr << "fg";
cout << ostr.str() << endl;
```

上面这段代码输出：

```
dec
defg
```

## stringstream 使用方法

stringstream 就可以同时进行输入和输出了。（但是好像用的不多，故略）
