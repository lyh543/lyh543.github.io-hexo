---
title: KMP 和 AC 自动机
tags:
- 数据结构
- 字符串
- 坑
category:
- C++
- ACM
---

xyynb!

**KMP这里，字符串从1开始计数**！
由于串是从1开始计数，可以把第一个格子设为`$`，避免越界。

```c++
char s[maxn], p[maxn];
s[0] = p[0] = '$';
cin >> s+1 >> p+1;
```

## KMP

~~众所周知~~，KMP 是一种单串匹配算法，把朴素算法的`O(|S|*|T|)`优化到了`O(|S|+|T|)`。

![KMP](KMP.png)

如上图，在进行朴素算法时，如果我们已经进行了一些匹配成功，实际上我们就知道了原串的一些信息，**理论上**就可以使用这个信息来加速匹配，跳过一些绝对不可能匹配成功的情况。
所以，该怎么做呢？这就是 KMP 很迷的地方之一，也是我一直看不懂 KMP 的一个点。

### `border` ：最长相等前后缀

为此，`xyy`提到了 `border` 的概念。  
`border` 即是某个字符串的最长相等前后缀（不包含自己）。  
有了这个定义，再结合上面的图，就可以看到，如果在某个字符失配了，说明这个字符前的模式串 T 和字符串 S 是相等的，由于 `border` 的存在，可以直接跳过一些字符串，直接跳到失配字符前的模式串 T 的  `border`，比较 `border` 之后的字符。  
一定没有错过什么能够正确匹配的情况吗？是的，反证可以证明，要是存在，那`border`就不是最长了。  
也就是说，KMP 分为两个步骤，求 T 中每个字符前的子串对应的`border`长度，然后匹配。一般把前者（每个字符前的子串对应的 `border` 的长度）定义为 `fail[]` 数组，或者 `xyy` 的 `π() 函数`。

### 求 `fail[]` 数组

在T也很长的时候，暴力求解 `fail[]` 数组也是不可取的。  
![fail()](getFail.png)  
这种情况下，可以看出：

> 由于 `π(3)=1` ，可得 `T[1...1]==T[3...3]`；  
> 又由于 `T[2]==T[4]` ， `T[1...2]==T[3...4]`  
> 所以 `π(4)=2=π(3)+1`。

综上，**若`T[i+1]==T[π(i)+1]`，则`π(i+1)=π(i)+1`**。

那如果`T[i+1]≠T[π(i)+1]`呢？

![border的border仍然是原串的border](abacabadabacaba.png)  
有一个神奇的性质，`border`的`border`仍然是原串的`border`。

>由于 `abacaba` 是原串的 `border`，则 `黄串+c+绿串==蓝串+c+红串`。
由于 `aba` 是 `abacaba` 的 `border`，则 `黄串==绿串，蓝串==红串`。
所以，`黄串==绿串==蓝串==红串`。

因此，我们可以用递归的方法，如果`T[i+1]≠T[π(i)+1]`，则检查`T[i+1]==T[π(π(i))+1]`，以此类推，直至出现相等。如果真的很惨，一个`border`都没有，那么应该递归到某个`π(i)=0`，这时，`T[i+1]==0`。  

综上，求`fail[]`数组的代码为：

```c++
void getFail()
{
	for (int i = 1; i <= pl; i++)
	{
		int j = i-1;
		while (j > 0 && p[fail[j]+1] != p[i]) j = fail[j];
		fail[i] = j ? fail[j] + 1 : 0;
	}
	return;
}
```

### 匹配的过程

匹配的过程可以按照上面说的，“如果在某个字符失配了，说明这个字符前的模式串T和字符串S是相等的，由于`border`的存在，可以直接跳过一些字符串，直接跳到失配字符前的模式串T的`border`，比较`border`之后的字符。”

但是还有一个更为漂亮的方法：把原串“拼到”匹配串“的后面”。求原串中哪些位置出现了匹配串的问题，就转化成了：

求新串中有哪些串的`border`正好是匹配串。（忽略掉所有长于匹配串的`border`）

匹配过程的代码就和求`fail[]`数组差不多了。  
实际上我们也没有拼起来，只是模拟了一下。

```c++
void kmp()
{
	int j = 0;//fail[i-1]
	for (int i = 1; i <= sl; i++)
	{
		while (j > 0 && p[j + 1] != s[i]) j = fail[j];
		j = (p[j + 1] == s[i]) ? j + 1 : 0;
		//这里不使用(j>0)作为测试条件，是因为 j==0 和 p[j + 1] == s[i] 可能同时成立。
		//求fail[]过程中不存在这个问题，因为fail[0] = -1

		if (j == pl)
		{
			ans[anslen++] = i - pl + 1;
			j = fail[j];//border:不包含自己
		}
	}
}
```

### KMP完整代码：

```c++
//Lutece 2210 qh与复读机 III
//https://acm.uestc.edu.cn/problem/qhyu-fu-du-ji-iii/description
#include <bits/stdc++.h>
using namespace std;

const int maxn = 1e6+5;

char p[maxn], s[maxn];
int ans[maxn] = { 0 }, fail[maxn] = {-1 }, anslen = 0, pl, sl;

/*
fail[i]：前i位的最长border（不包含自己）
字符串从1计数!!!!
aabcaabaabcaa
0100123123456
*/

void kmp()
{
	//KmpGetFail
	for (int i = 1; i <= pl; i++)
	{
		int j = i - 1;
		while (j > 0 && p[fail[j] + 1] != p[i]) j = fail[j];
		fail[i] = j>0 ? fail[j] + 1 : 0;
	}

	int j = 0;//fail[i-1]
	for (int i = 1; i <= sl; i++)
	{
		while (j > 0 && p[j + 1] != s[i]) j = fail[j];
		j = (p[j + 1] == s[i]) ? j + 1 : 0;//不能使用(j>0)

		if (j == pl)
		{
			ans[anslen++] = i - pl + 1;
			j = fail[j];
		}
	}

	//原版匹配
	/*for (int  i = 1, j = 1; i < sl;)
	{
		if (j == 0)
		{
			i++;
			j++;
			continue;
		}
		if (s[i] == p[j])
		{
			j++;
			if (j == pl)
			{
				ans[anslen++] = i - j + 2 ;
				j = fail[j-1] + 1;
			}
			i++;
		}
		else
		{
			j = fail[j - 1] + 1;
		}
	}
	return;*/
}

int main()
{
	ios::sync_with_stdio(0);
	cin.tie(0);

	s[0] = p[0] = '$';
	cin >> s+1 >> p+1;
	pl = strlen(p+1), sl = strlen(s+1);
	kmp();
	for (int i = 0; i < anslen; i++)
	{
		cout << ans[i] << " ";
	}
}
```

## AC 自动机

留坑了。
