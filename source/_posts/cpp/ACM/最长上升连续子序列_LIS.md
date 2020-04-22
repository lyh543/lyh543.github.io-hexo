---
title: 最长上升连续子序列 LIS
date: 2019-8-18
tags:
- 数据结构
- C++
- ACM
category:
- C++
- ACM
---

贪心，二分搜索，O(nlogn)

注意 `lower_bound` 和 `upper_bound` 的选择：`upper_bound` 是不下降子序列，`lower_bound` 是上升子序列。
因为上升子序列的 LIS 里面一个数不能排在相同的数的后面，所以这个数必须要找到 `lower_bound()`

`upperbound()` 的 `last` 参数取不到这个点，类似于end()
[lower_bound 和 upper_bound](../../cpp-grammar/lowerbound_upperbound/)

```c++
//上升子序列
//leng[i]: max lis length from a[0] to a[i]
//lis[i]: least last number of a i-length lis
void getLIS(int a[], int lis[], int leng[])
{
    int maxlen = 0;
	lis[1] = a[0];
	int len = 1; // length of lis
	leng[0] = 1;
	for (int i = 0; i < n; i++)
	{
		if (a[i] > lis[len])
		{
			lis[++len] = a[i];
			leng[i] = len;
		}
		else
		{
			leng[i] = upper_bound(lis+1, lis + len+1, a[i]) - lis;
			lis[leng[i]] = a[i];
		}
		maxlen=max(maxlen, leng[i]);
	}
}
```
