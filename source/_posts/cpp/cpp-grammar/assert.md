---
title: assert
date: 2019-8-1
tags:
- C++
category:
- C++
- C++语法
mathjax: true
---

## 用途

最初看到 `assert`，是在 ACM 时，看到的别人的高精度板子，限定了除数大于0：

```c++
assert(b>0)
```

但是感觉没什么用：如果 此时不等于 0，程序立即停止（`abort`）并返回一个非 0 值，就算 RE 了， 好像没什么用。

直到看程序设计的时候看到了它的用处：它能限定当前程序的状态（如果和预期不一样就会报错），一方便是方便调试（能让程序一直保持在正确等状态下），另一方面是能让其他人理解自己的程序。

## 语法

该函数在 `<assert.h>` 或 `<cassert>` 中。

### 用法

```c++
assert(bool)
```

可以这么用：

```c++
assert(i >= 0 && i < n)
```

还可以把布尔判断式写成一个 `bool` 类型的函数。

```c++
bool isSorted(int * arr, int n)
{
    for (int i = 0; i < n - 1; i++)
        if (arr[i] >= arr[i+1]) return false;
    return true;
}
assert(isSorted(arr, n));
```

### 禁用所有 `assert`

甚至还有一行关掉所有 `assert` 语句的方法：

```c
#define NDEBUG
```

## `assert(0)` 用法

1. 捕捉逻辑错误。可以在程序逻辑必须为真的条件上设置断言。除非发生逻辑错误，否则断言对程序无任何影响。即预防性的错误检查，在认为不可能的执行到的情况下加一句 `assert(0)`，如果运行到此，代码逻辑或条件就可能有问题。
2. 程序没写完的标识，放个 `assert(0)` 调试运行时执行到此为报错中断，好知道成员函数还没写完。
