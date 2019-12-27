---
title: C++ 异常处理
date: 2019-12-26 22:10:56
tags:
- 课程笔记
- C++
- 面向对象编程
- 坑
category:
- C++
- C++语法
mathjax: true
---

> 参考 https://www.runoob.com/cplusplus/cpp-exceptions-handling.html

C++ 自带的异常处理，可以用来处理 `除数为 0`、`加法溢出` 等一些情况。虽然我们可以使用普通的 `if` 来判断，但是也可以使用 C++ 提供的一些异常。

这样的好处，是用标准统一了异常处理，方便了一些操作，也“提高了代码的复用性”。

## 三个关键字：try throw catch

`try` `catch` `throw` 是 C++ 为异常处理设定的关键字。从字面上来理解：

* throw: 当问题出现时，程序会抛出 `throw` 一个异常。
* catch: 用于捕获 `catch` 异常。
* try: 尝试 `try` 触发异常。它后面通常跟着一个或多个 `catch` 块。

从代码上来看：

```cpp
try
{
    // try 块
    //如果出错，就进行 throw
}catch( ExceptionType e1 )
{
    // catch 块
}catch( ExceptionType e2 )
{
    // catch 块
}
```

## 异常处理的机制

看到这里可能还是一脸懵逼。我们需要 `throw` 什么？`catch` 什么？

我看到的教程中很少明确指出了这一点：C++ 中，我们**需要 `throw` 的是一个对象，在 `catch` 中通过判断对象的类**来判断是否执行。

比如，我们在 `try` 块中 `throw` 了一个字符串 `"divided by zero"`，在 `catch` 中，我们就需要判断是不是 `const char *`：

```cpp
int main()
{
	int a, b;
	cin >> a >> b;
	try
	{
		if (b == 0)
			throw "divided by zero";
        cout << a / b;
	}
	catch (const char* errorString)
	{
		cout << errorString;
	}
	cout << a / b;
}
```

输入 `2 0` 时，会输出 `divided by zero`，然而还是运行错误，执行到了 15 行 `a / b`。这说明：

* 异常被 catch 后，会跳过 try 剩下的语句，执行对应的 catch 代码块，然后按顺序向下继续执行 catch 代码块后的第一句。

看到这里，你可能觉得这功能还是很蠢：当你想要 `catch` 两种错误时，`throw` 一个字符串是行不通的（因为 `catch` 识别的是类型），这又怎么办呢？

## C++ 标准异常

上文说道，一个字符串行不通。于是，C++ 提供了一系列标准的异常，定义在 `<exception>` 中，他们都是继承于 `std::exception` 类。~~这也是为什么这篇异常处理会被插上面向对象的标签~~

![C++ 标准异常](https://www.runoob.com/wp-content/uploads/2015/05/exceptions_in_cpp.png)

既然有了异常类，那么传递一个对象，判断类的类型，就是水到渠成的想法了。

## 定义新的异常类：

我们通过公有继承 `std::exception` 来定义自己的 `MyException` 类。

```cpp
#include <iostream>
#include <exception>
using namespace std;
 
struct MyException : public exception
{
    //what() 是异常类提供的一个公共方法，它已被所有子异常类重载。
    const char * what () const throw ()
    {
        return "C++ Exception";
    }
};
 
int main()
{
    try
    {
        throw MyException();
    }
    catch(MyException& e)
    {
        std::cout << "MyException caught" << std::endl;
        std::cout << e.what() << std::endl;
    }
    catch(std::exception& e)
    {
        //其他的错误
    }
}
```

上面的代码会返回如下的结果：

```cpp
MyException caught
C++ Exception
```

## 坑

这篇博客对异常处理讲的很草率~~马上期末考试了没时间深究了啊啊啊啊~~
有空再更。