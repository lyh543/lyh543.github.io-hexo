---
title: C/C++ && 和 || 的优先级
date: 2019-8-20
tags:
- 测试
- C++
- C++
- C++语法
category:
- C++
- C++语法
---

**结论：`&&` 高于 `||`**  

记忆上面，可以认为我们更常使用 `Disjunctive normal form` 而不是 `Conjunctive normal from`。这是；离散数学-逻辑代数的一些知识。  
通俗的来讲，就是 `( x<1 and y<1 ) or (x>1 and y>1) or (x<2 and y>2)` 这样的先与后或的 `DNF` 结构更常用，因此规定没有括号的情况下，默认加括号为这样的形式。

顺便，`<<`高于`&&`。因此，`cout<<1&&1`只会输出 1。

测试代码 1：

```c++
int main()
{
	cout << "a	b	c	(a||b)&&c	a||(b&&c)	a||b&&c\n";
	for (int i = 0; i < 8; i++)
	{
		int a = i&1;
		int b = (i>>1)&1;
		int c = (i>>2)&1;
		cout << a << "\t" << b << "\t" << c << "\t" << ((a||b)&&c) << "\t\t" << (a||(b&&c)) << "\t\t" << (a||b&&c)<< endl;
	}
}
```

输出：

```
a       b       c       (a||b)&&c       a||(b&&c)       a||b&&c
0       0       0       0               0               0
1       0       0       0               1               1
0       1       0       0               0               0
1       1       0       0               1               1
0       0       1       0               0               0
1       0       1       1               1               1
0       1       1       1               1               1
1       1       1       1               1               1
```

测试代码2：

```c++
int main()
{
	cout << "a	b	c	(a&&b)||c	a&&(b||c)	a&&b||c\n";
	for (int i = 0; i < 8; i++)
	{
		int a = i&1;
		int b = (i>>1)&1;
		int c = (i>>2)&1;
		cout << a << "\t" << b << "\t" << c << "\t" << ((a&&b)||c) << "\t\t" << (a&&(b||c)) << "\t\t" << (a&&b||c)<< endl;
	}
}
```

输出：

```
a	b	c	(a&&b)||c	a&&(b||c)	a&&b||c
0	0	0	0		0		0
1	0	0	0		0		0
0	1	0	0		0		0
1	1	0	1		1		1
0	0	1	1		0		1
1	0	1	1		1		1
0	1	1	1		0		1
1	1	1	1		1		1
```
