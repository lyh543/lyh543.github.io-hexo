---
title: lower_bound() 和 upper_bound() 返回值
tags:
- 语言测试
- STL
category:
- C++
- C++语法
---

## 结论

`lower_bound() -1` 是最后一个小于 value 的数
`lower_bound()` 是第一个大于等于 value 的数

`upper_bound() - 1` 是最后一个小于等于 value 的数
`upper_bound()` 是第一个大于 value 的数

lower_bound() 和 upper_bound() 在 set/multiset/map/multimap 中仍可用（作为成员函数使用），其中 map 只能搜索第一个元素（毕竟是以第一个元素排序的）。

## 测试数据

> 1 2 2 2 3 3 4 5
>
> lower_bound:  
> a[1-1] = 1  
> a[1] = 2  
> a[1+1] = 2  
>
>
> upper_bound:  
> a[4-1] = 2  
> a[4] = 3  
> a[4+1] = 3

## 测试代码

```c++
#include<bits/stdc++.h>

using namespace std;

int main()
{
	const int n = 8;
	int a[n] = { 1,2,2,2,3,3,4,5 };
	for (int i = 0; i < n; i++)
		cout << a[i] << " ";
	cout << endl;

	cout << endl;
	cout << "lower_bound: " <<endl;
	int l = lower_bound(a, a + n, 2) - a;
	cout << "a[" << l << "-1] = " << a[l - 1] << endl;
	cout << "a[" << l << "] = " << a[l] << endl;
	cout << "a[" << l << "+1] = " << a[l + 1] << endl;

	cout << endl << endl;
	cout << "upper_bound: " << endl;
	l = upper_bound(a, a + n, 2) - a;
	cout << "a[" << l << "-1] = " << a[l - 1] << endl;
	cout << "a[" << l << "] = " << a[l] << endl;
	cout << "a[" << l << "+1] = " << a[l + 1] << endl;
}
```
