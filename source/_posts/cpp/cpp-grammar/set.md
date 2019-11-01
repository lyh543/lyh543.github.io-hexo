---
title: set——STL自带的二叉平衡树
date: 2019-7-27
tags:
- 数据结构
- STL
category:
- C++
- C++语法
---

![wdgmultiset](/img/wdgmultiset.jfif)

## multiset

支持操作|C++代码
-|-
插入|`insert(value);`
删除|`erase(value);` `erase(iter);`
查询|`set::iterator iter = find(value);`
二分搜索|`lower_bound(value);` `upper_bound(value);`
开头（最小）|`begin()`
结尾（最大）|`--end()`

* `set.insert()` 的返回值是一个 `Pair`，`first` 是（新加入或原本就存在的）该元素的 `iterator`，`second` 是 插入成功与否的 `bool` 值。而 `multiset` 只返回 `iterator`。  
* `++`和`--`支持`list`和`set` `multiset`，简直无敌。  
* `set`的`*iter`不会随数据插入、删除而改变（想想指针你大概就懂了）。

## unordered_set

unordered_set 的实现不是二叉平衡树，而是 hash。对于自定义类型，可能需要定义 `hash_value()` 函数并且重载`operator==`。

使用的时候，没有排序，所以不能二分；遍历的效率也会很低（猜测是要遍历整个 hash 表）。用的话，一般用于查询某个数是否被存过，并且数据范围过大需要丽离散化。

## set.find()妙用

**𝒔𝒆𝒕的𝒇𝒊𝒏𝒅函数可以直接找到和一个元素在逻辑上相等的另外 一个元素**
`find`、`upper_bound`、`lower_bound`函数的相等用的并不是`a==b`，而是`!(a<b)&&!(b<a)`，只需要重定义`<`

`find()`没有找到就返回`set.end()`;

下面是一道潇神出的题，很好的利用这个性质，用 set 来判断两边是否有重叠。

```c++
//Lutece 2145 人在地上走，锅从天上来
//https://acm.uestc.edu.cn/contest/12/problem/C
#include<bits/stdc++.h>
#define LL long long
using namespace std;
const int maxn = 100001;
struct edge {
    int l;
    int r;
};

bool operator <(edge a, edge b)
{
    return a.r < b.l;
}
set<edge> s;
set<edge>::iterator iter;
int merge(edge & temp)
{
    if ((iter = s.find(temp)) != s.end())
    {
      temp.l = min(temp.l, iter->l);
      temp.r = max(temp.r, iter->r);
      s.erase(iter);
      merge(temp);
      return 1;
    }
    else
    {
      s.insert(temp);
      return 0;
    }
}
int main()
{
    cin.sync_with_stdio(0);
    cin.tie(0);
    int n;
    cin >> n;
    for (int i = 0; i < n; i++)
    {
      edge temp;
      cin >> temp.l >> temp.r;
      merge(temp);
      cout << (i?" ":"") << s.size();
    }
}
```
