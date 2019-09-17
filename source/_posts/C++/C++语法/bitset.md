---
title: bitset
date: 2019-8-19
tags:
- 数据结构
- STL
category:
- C++
- C++语法
mathjax: true
---

数学的集合这个概念，可以用 C 的布尔数组实现。然而，使用 `bool` 类型，导致每一个元素都会占用一个字节。  
实际上，每一个字节理论上能存 8 个元素的状态，可以使用 `char` 或 `int` 数组来模拟。  
而 C++ STL 自带了一种数据结构，`bitset`，就不用自己手写啦。

## 声明

```c++
#include <bitset>
using std::bitset;
```

## 定义和初始化

```c++
bitset<32> b; //32位，全为0。
```

给出的长度值必须是常量表达式。

> 位集合的位置编号从 0 开始，因此，bs 的位序是从 0 到 31。以0位开始的位串是低阶位（low-order bit），以31位结束的位串是高阶位(high-order bit)。

简单的来说就是，bitset 和数组一样，从 string 的角度看，**string 的顺序和 bitset 顺序是相反的**（string 的最后一位被赋给了 bitset 第一位）；从 unsigned long 的角度看，从左往右是从低位到高位。

bitset 有以下构造函数：

```c++
bitset<n> b;                                   //b有 n 位，每位都为 0
bitset<n> b(unsighed long u);                  //b是 u 的一个副本
bitset<n> b(string s);                         //b是 s 中含有的位串的副本
bitset<n> b(const * s, size_t pos, size_t n);  //b是 s 中从位置 pos 开始的 n 位的副本
```

貌似不是很好懂，但只要记住以下形式等价即可：

1. `bitset<8> b("11000");`
2. `bitset<8> b(24); //24(10) == 00011000(2)`
3. `bitset<8> b; b[3] = b[4] = 1;`

并且记住“过多则忽略高位，过少则置高位为 0” 的原则。

## 访问 bitset 的位

使用 `b[]` 即可。

## bitset 的一堆函数

函数名|函数作用
-|-
`bool b.all()`|检查 b 中是否全部位被设为 1
`bool b.any()`|检查 b 中是否任一位被设为 1
`bool b.none()`|检查 b 中是否无位被设为 1
`size_t b.count()`|返回设为 1 的位数
`size_t b.size()`|返回 bitset 的大小，即 bitset 定义参数中的 n
|
`bool b.test(pos)`|类似 `operator[]`，但是进行越界检查，若越界则抛出 `std::out_of_range`
|
`b.set()`|设置所有位为 1
`b.set(size_t pos, bool value = true)`|类似使用 `b[pos] = value` 赋值，但是进行越界检查，同上
|
`b.reset()`|设置所有位为 0
`b.reset(size_t pos)`|类似 于`b[pos] = 0` 赋值为 0，但是进行越界检查，同上
|
`b.flip()`|类似于 `~b`，但是在原位，不进行 Copy Construction
`b[0].flip()`|等价于 `b[0] = ~b[0]`
`b.flip(size_t pos)`|仅翻转 pos 位（翻转 1 和 0），进行越界检查

## 输出 bitset 的函数

### 1. `to_string(char zero = '0', char one = '1')`

```c++
template<
    class CharT = char,
    class Traits = std::char_traits<CharT>
    class Allocator = std::allocator<CharT>
> std::basic_string<CharT,Traits,Allocator>
    to_string(CharT zero = CharT('0'), CharT one = CharT('1')) const;
```

用 `zero` 表示 0，用 `one` 表示 1，返回 bitset 的 basic_string （大概是广义的 string？）形式。  
默认 `to_string()` 就是返回 bitset 的 01 串的 string。

### 2. `to_ullong()`

`unsigned long long bitset::to_ullong()`

转换 bitset 的内容为 unsigned long long 整数。  
和构造 bitset 一样，bitset 的首位对应数的最低位，而尾位对应最高位。

如果不能用 unsigned long long 表示，则抛出 `std::overflow_error`。

（有意思的是，只有 bitset 的这两个函数会抛出 `std::overflow_error` 异常）

### 3. `b.to_ulong()`

和上面一样，就是改下数据范围。

为什么介绍这么草率呢？因为 MSVC 的实现是先强转为 unsigned long long 再转为 unsigned long 判越界。貌似也没什么毛病.jpg

```c++
_NODISCARD unsigned long to_ulong() const
    {    // convert bitset to unsigned long
    unsigned long long _Val = to_ullong();
    unsigned long _Ans = (unsigned long)_Val;
    if (_Ans != _Val)
        _Xoflo();
    return (_Ans);
}
```

## 题外话：bitset::any(), none(), all(), count() 的实现

`bitset::any()`，`bitset::none()`，`bitset::all()`，`bitset::count()`，这四个函数都可以通过记录 `count`，每次修改时记录 `count` 的变化，来实现 `O(1)` 的时间复杂度，然而 MSVC 2017 和 GCC 4.7.1 的实现是 `O(n)` 的。

猜测原因是记录 `count` 的变化会在修改 bitset 时花费更多的时间，对于不使用这四个函数的用户，这样会使程序变慢。而对于需要 `O(1)`时间复杂度的用户，手动实现类似功能是很方便的。

但是平时使用的时候需要注意时间复杂度是 `O(1)` 的。

另外，在 `bitset::count()` 的实现上，GCC 使用了汇编指令 `POPCNT`，而 MSVC 使用的是如下的神奇代码：

```c++
_NODISCARD size_t count() const noexcept
    {    // count number of set bits
    const char *const _Bitsperbyte =
        "\0\1\1\2\1\2\2\3\1\2\2\3\2\3\3\4"
        "\1\2\2\3\2\3\3\4\2\3\3\4\3\4\4\5"
        "\1\2\2\3\2\3\3\4\2\3\3\4\3\4\4\5"
        "\2\3\3\4\3\4\4\5\3\4\4\5\4\5\5\6"
        "\1\2\2\3\2\3\3\4\2\3\3\4\3\4\4\5"
        "\2\3\3\4\3\4\4\5\3\4\4\5\4\5\5\6"
        "\2\3\3\4\3\4\4\5\3\4\4\5\4\5\5\6"
        "\3\4\4\5\4\5\5\6\4\5\5\6\5\6\6\7"
        "\1\2\2\3\2\3\3\4\2\3\3\4\3\4\4\5"
        "\2\3\3\4\3\4\4\5\3\4\4\5\4\5\5\6"
        "\2\3\3\4\3\4\4\5\3\4\4\5\4\5\5\6"
        "\3\4\4\5\4\5\5\6\4\5\5\6\5\6\6\7"
        "\2\3\3\4\3\4\4\5\3\4\4\5\4\5\5\6"
        "\3\4\4\5\4\5\5\6\4\5\5\6\5\6\6\7"
        "\3\4\4\5\4\5\5\6\4\5\5\6\5\6\6\7"
        "\4\5\5\6\5\6\6\7\5\6\6\7\6\7\7\x8";
    const unsigned char *_Ptr = &reinterpret_cast<const unsigned char&>(_Array);
    const unsigned char *const _End = _Ptr + sizeof (_Array);
    size_t _Val = 0;
    for ( ; _Ptr != _End; ++_Ptr)
        _Val += _Bitsperbyte[*_Ptr];
    return (_Val);
}
```

其实就是把每个 byte 的 256 种情况对应的 1 的数量打了个表。

[Stack Overflow](https://stackoverflow.com/questions/48394450/why-does-msvc-not-use-popcnt-in-its-implementation-for-stdbitsetcount) 上有人提到为什么 MSVC 不使用 `POPCNT`实现，`POPCNT` 比这样实现更快。

回答是 `POPCNT` 在部分 CPU 架构上的结果是不可预测的，而 MSVC 更想要跨架构的通用解决方案。  

这篇[博客](https://www.cnblogs.com/zyl910/archive/2012/11/02/testpopcnt.html)的测试中显示， `POPCNT` 比打表形式快了约 2.7 倍。
