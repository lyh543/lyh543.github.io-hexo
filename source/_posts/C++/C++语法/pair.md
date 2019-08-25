---
title: pair 使用方法
tags:
- STL
category:
- C++
- C++语法
mathjax: true
---

pair 是。。。  
pair 是啥？  
pair 好像就是一个包含两个元素的结构。

## 包含头文件及定义变量

```c++
#include <utility>
using namespace std;
pair<int,int> p[10];
```

## 数据存储

```c++
p[0] = {1,2};
p[1] = make_pair(3,4); //类似于强转吧
```

## 访问元素

```c++
cout << p[0].first; //输出1
cout << p[1].second; //输出4
```

## 排序

对于字典序排序（先按第一元素升序排序、再按第二元素升序排序），可以直接调用 `sort`：

```c++
sort(p,p+10);
```

其余情况就需要自己定义了。

```c++
bool cmp(const pair<int,int> &a,  const pair<int,int> &b)
{
    return (a.second < b.second);
}
```
