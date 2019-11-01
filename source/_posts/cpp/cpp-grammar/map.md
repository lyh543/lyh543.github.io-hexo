---
title: (unoredered_)(multi)map & 离散化
date: 2019-8-4
tags:
- 数据结构
- STL
category:
- C++
- C++语法
mathjax: true
---

在 ACM 中经常会接触到数据范围 $10^9$，数据个数 $ 2\times10^5$ 的题，这种题按数据范围开数组都开不下，但是数据没有出现过的数据就没有用，于是可以只讨论那 $ 2\times10^5$ 个数。这个时候，就需要一个把不连续的 $(12,324,76)$ 映射 (map) 到连续的 $(1,2,3,...)$ 上的方法。

map 分为 treemap 和 hashmap。  
treemap 是树状结构，自带排序和二分搜索功能，但是插入、查询、删除的算法里面也就会带一个 $O(log n)$。hashmap 是由哈希值实现的，插入、查询、删除的算法复杂度是 $O(1)$，但是没有排序、不能二分，据说遍历的效率也会很低。

## hashmap unordered_map

hashmap 在 C++ 中叫做 unordered_map.

### 头文件及定义变量

```c++
#include<unordered_map>
using namespace std;
unordered_map<string, int> m;
```

如果 unordered_map 的第一个元素是自定义类型，可能还需要自定义 `hash_value` 函数并且重载 `operator==`。~~map：我只需要重载 `operator<`，来用我呀~~

```c++

struct person
{
    string name;
    int age;
    bool operator== (const person& p) const
    {
        return name==p.name && age==p.age;
    }
};

size_t hash_value(const person& p)
{
    size_t seed = 0;
    std::hash_combine(seed, std::hash_value(p.name));
    std::hash_combine(seed, std::hash_value(p.age));
    return seed;
}

unoreder_map<person,int> m;
```

另外，理论上 `unordered_map` 是包含在 `bits/stdc++.h` 里的，但是 Visual Studio 识别不到。原因是 `bits/stdc++.h` 中包含 `unordered_map` 有一句预处理 `#if __cplusplus >= 201103L`，但 Visual Studio 过不了。

### 存储数据，建立映射

很亲民。

```c++
m["njj"] = 1;
m["xj"] = 2;
m["lyh"] = -1;
```

### 寻找元素、输出

如果存在这个映射，则直接输出就好了。

```c++
cout << m["lyh"] << endl; //输出 -1
```

但如果不存在，并尝试访问，则会自动建立映射（映射值为默认），然后输出。

```
cout << m["yg"]; //会自动生成("yg",0)，然后输出 0 ，故不能检测该元素是否存在
```

需要检测是否存在的话，一定要用 `find()==end()` 这个套路。

```c++
if (m.find("kj") != m.end()) //检查元素是否存在
	cout << m["kj"];
```

### 删除映射

```c++
m.erase("yg");
```

### 遍历元素

和 STL 容器的遍历是一样的：

```c++
for (unordered_map<string,int>::iterator iter = m.begin(); iter != m.end(); iter++)
{
	cout << iter->first << " " << iter->second << endl;
}
```

或者

```c++
for (pair<string,int> p : m)
{
	cout << p.first << " " << p.second << endl;
}
```

很有意思的是，(unordered_)map 的元素是 pair。这样正好能够存两个数。

但是请注意，**unordered_map 的遍历效率并不高（大概是把 hash 表遍历了一遍）**，有需求请使用 map。

## map 的更多的操作

map：上面的操作我都有！
C++ 中 map 的实现是红黑树，因此可以遍历、保证有序、二分搜索。  

### map 和 unordered_map 定义中的不同

如果 map 的第一个元素是自定义类型，可能还需要重载 `operator<`。

### map 的遍历

对 map 的遍历实际上是对树的遍历，所以操作较 unordered_map 一样快。

但是遍历方法和 unordered_map 是一样的。

```c++
for (map<string,int>::iterator iter = m.begin(); iter != m.end(); iter++)
{
	cout << iter->first << " " << iter->second << endl;
}
```

或者

```c++
for (pair<string,int> p : m)
{
	cout << p.first << " " << p.second << endl;
}
```

### map 的二分搜索

同样是超级好用的 `lower_bound()` 和 `upper_bound()`，返回值是 map 的 iterator。不过这里这两个函数做的是 map 的成员函数。

```c++
map<string,int>::iterator iter = m.lower_bound("njjnb");
```

## multimap

由于 multimap 不再是单射的关系，也就不能使用 `m[1]` 的形式访问元素。具体有什么用，~~感觉挺没用的，要是打脸了以后就来填坑吧。~~
