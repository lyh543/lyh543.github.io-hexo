---
title: Lutece 速度
date: 2019-8-18
tags:
- 测试
category:
- C++
- ACM
---

||long long 运算|int 运算|double 运算|
|--------|--------------|----|------|
|          |2e9次 406ms|2e9次 395ms|2e9次 794ms|
|1000ms|5e9次|5e9次|2.5e9次|

```c++
//int test
int main()
{
    int a =0;
    for (int i =0;i<1e9;i++)
        a += i;
    return a;
}
```

```c++
//long long test
int main()
{
    long long a =0;
    for (long long i =0;i<1e9;i++)
        a += i;
    return a;
}
```

```c++
//double test
int main()
{
    long double a = 0;
    for (long double i = 0; i < 1; i += 1e-9)
        a += i;
    return a;
}
```
