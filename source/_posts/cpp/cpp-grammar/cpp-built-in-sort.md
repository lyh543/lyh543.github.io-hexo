---
title: C++ 内置排序的排序顺序
date: 2019-7-25
tags:
- 测试
- STL
- C++
- C++
- C++语法
category:
- C++
- C++语法
---

## 结论

|类型|自带排序|定义`cmp`结构（为<）|`greater<int>`|定义`bool cmp`函数（为<）|
|-|-|-|-|-|
|`set`|升序|升序|降序|\|
|`priority_queue`|降序|降序|升序|\|
|`sort`|升序|\ |\ |升序


表中 `\` 表示这种语法无法适用于该排序。

## 测试代码

```c++
//test for set
#include<bits/stdc++.h>
using namespace std;


struct cmp {bool operator()(int a, int b){return a < b;}};

int main()
{
	set<int> test1;、
	set<int,cmp> test3;
	set<int, greater<int> > test4;
	test1.insert(1);
	test3.insert(1);
	test4.insert(1);
	test1.insert(2);
	test3.insert(2);
	test4.insert(2);

	cout << *test1.begin() << " " << *test3.begin() << " " << *test4.begin();
//output:1 1 2
}
```

```c++
//test for priority_queue
#include<bits/stdc++.h>
using namespace std;

struct str{int v;};
bool operator < (str a, str b) { return a.v < b.v; };
struct cmp {bool operator()(int a, int b){return a < b;}};


int main()
{
	priority_queue<int> test1;
	priority_queue<int, vector<int>, cmp> test2;
	priority_queue<int, vector<int>, greater<int> > test3;
	test1.push(1);
	test2.push(1);
	test3.push(1);
	test1.push(2);
	test2.push(2);
	test3.push(2);
	cout << test1.top() << " " << test2.top() << " " << test3.top();
}
//output: 2 2 1
```

```c++
//test for std::sort
#include<bits/stdc++.h>
using namespace std;

bool cmp(int a, int b) { return a < b; };

int main()
{
	int a[2] = { 0,1 };
	sort(a, a + 1);
	cout << a;
	sort(a, a+1, cmp);
	cout << a;
}
//output: 0 0
```
