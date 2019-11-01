---
title: 状态压缩 DP
date: 2019.5.18
tags:
- 数据结构
- DP
category:
- C++
- ACM
---

## 定义

状态压缩（Bitmask）实际上是一种数据结构，用一个 int 存一行的二进制状态。

## 位运算技巧

独立为了另一篇博客：[位运算](/cpp/cpp-grammar/位运算)。

## 例题：oy环游世界

[Problem 2173  oy环游世界](
https://acm.uestc.edu.cn/contest/15/problem/A)

这是记忆化搜索而非标程DP

```c++
#include<bits/stdc++.h>
#define ll long long

using namespace std;

const int maxn = 17;

int x[maxn], y[maxn], dis[maxn][maxn];
ll dp[1 << maxn][maxn] = {0}; //dp[state][t]表示已经遍历完 state 中位为1的城市，正在t城市，还需要的最小花费
int n, s;

//直接递归做，最多只有18层，而且能忽略掉从 s 开始时不可能发生的情形
ll dfs(int state, int cur)
{
	if (dp[state][cur] != 0)
		return dp[state][cur];
	if (state + 1 == (1 << n)) // all are visited
		return 0;
	dp[state][cur] = LLONG_MAX;
	for (int next = 0; next < n; next++)
	{
		if ((state&(1<<next))==0) //next is not visited
			dp[state][cur] = min(dp[state][cur],
				dfs(state | (1 << next), next) + dis[cur][next]);//go from cur to next, and use dfs to visit remaining cities starting from next
	}
	return dp[state][cur];
}

int main()
{
	ios::sync_with_stdio(0);
	cin.tie(0);

	//我偏要用0标号，因为用1开始，第0个格子会浪费掉，空间会x2
	cin >> n >> s;
	s--;
	for (int i = 0; i < n;i++)
	{
		cin >> x[i] >> y[i];
	}
	for (int i = 0; i < n; i++)
	{
		dis[i][i] = -1;
		for (int j = i + 1; j < n; j++)
			dis[i][j] = dis[j][i] = abs(x[i] - x[j]) + abs(y[i] - y[j]);//与处理一下任意两点的距离
	}

	cout << dfs(1 << s, s);
	return 0;
}
```

标程的DP

```c++
for (int i = 0; i < 1 << n; i++)
	{
		for (int j = 0; j < n; j++)
		{
			if (dp[i][j] != -1)
			{
				for (int k = 0; k < n; k++)
				{
					if (!(i & (1 << k)))
					{
						dp[i | (1 << k)][k] = min(dp[i | (1 << k)][k], dp[i][j] + edges[j][k]);
						if ((i | (1 << k)) == (1 << n) - 1) ans = min(ans, dp[i | (1 << k)][k]);
					}
				}
			}
		}
	}
```

## 例题：苇名欧一郎

[Problem 2178 苇名欧一郎](
https://acm.uestc.edu.cn/contest/15/problem/F)

```c++
#include<bits/stdc++.h>
#define ll long long

using namespace std;

const int maxn = 17;

int init, k[maxn];
ll dp[1 << maxn]; //dp[state]表示已经杀掉 state 中位为1的怪兽，杀完剩下的方法数
int n;

void read(int & num)//读二进制
{
	num = 0;
	int i = 0;
	char c;
	while (i < n)
	{
		c = getchar();
		if (c < '0' || c > '9')
			continue;
		num = (num << 1) + c - '0';
		i++;
	}
}

ll dfs(int state)
{
	if (dp[state] != 0)
		return dp[state];
	if (state + 1 == (1 << n)) // all are killed
		return 1;

	int kill = init;
	for (int i = 0; i < n; i++)
		if (state&(1 << (n-i-1)))
			kill |= k[i];
	//calculate now who we can kill

	for (int next = 0; next < n; next++)
	{
		if ((state&(1<<(n-next-1)))==0&&(kill&(1<<(n-next-1)))) //next is not killed and we can kill
			dp[state] += dfs(state | (1 << (n-next-1)));//kill next!
	}
	return dp[state];
}

int main()
{
	int T;
	scanf("%d", &T);
	for (int i = 1; i <= T; i++)
	{
		ll ans = 0;
		scanf("%d", &n);
		read(init);
		memset(dp, 0, sizeof(dp));
		for (int j = 0; j < n; j++)
		{
			read(k[j]);
		}
		printf("Case %d: %lld",i,dfs(0));//谨防卡case
	}
	return 0;
}
```
