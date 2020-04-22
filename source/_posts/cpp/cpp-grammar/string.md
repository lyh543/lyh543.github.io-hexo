---
title: C++ string
date: 2019-8-14
tags:
- C++
- string
- iostream
- C++
- C++语法
category:
- C++
- C++语法
---

## `string.length()` 的复杂度

在 `C++ 11` 以前是未定义，在 `C++ 11` 及以后为常数，使用时须注意。

## 字符串字面量

```R "分隔符( 原始字符 )分隔符"```

示例：`R"66(njjnb)66" == "njjnb"`

另有 `L`, `u8`, `u`, `U` 作为前缀，类似于66L,表示`长char`、`UTF-8`、`UTF-16`、`UTF-32`字符。

[string_literal](
https://zh.cppreference.com/w/cpp/language/string_literal)

## cin >> string 的细节

只以空格为分隔符。输入 `123:123`，str 即为 `123:123`。

## string 和 iostream 的关系

> 转载自：https://www.cnblogs.com/Solstice/archive/2011/07/17/2108715.html

`iostream` 可以与 `string` 配合得很好。但是有个问题：谁依赖谁？

`std::string` 的 `operator <<` 和 `operator >>` 是如何声明的？`string` 头文件在声明这两个 operators 的时候要不要 include `iostream` ？

`iostream` 和 `string` 都可以单独 `include` 来使用，显然 `iostream` 头文件里不会定义 `string` 的 `<<` 和 `>>` 操作。但是，如果 `string` 要include `iostream`，岂不是让 `string` 的用户被迫也用了 `iostream`？编译 `iostream` 头文件可是相当的慢啊（因为 `iostream` 是 template，其实现代码都放到了头文件中）。

标准库的解决办法是定义 `iosfwd` 头文件，其中包含 `istream` 和 `ostream` 等的前向声明 (forward declarations)，这样 `string` 头文件在定义输入输出操作符时就可以不必包含 `iostream`，只需要包含简短得多的 `iosfwd`。我们自己写程序也可借此学习如何支持可选的功能。

值得注意的是，`istream::getline()` 成员函数的参数类型是 `char*`，因为 `istream` 没有包含 `string`，而我们常用的 `std::getline()` 函数是个 non-member function，定义在 `string` 里边。

博主注：这也解释了，`cin` 的所有成员函数都不支持 `string`，只能只用非成员函数 `getline`（在 `string` 中） 或 `operator >>`（在 `xstring` 中）。