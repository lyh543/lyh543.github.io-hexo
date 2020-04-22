---
title: LightOJ 1298 递推求一堆数的乘积之和
date: 2019-9-17
tags:
- 数论
- DP
- C++
- ACM
category:
- C++
- ACM
mathjax: true
---

这是一道在 2019 暑期集训做到的题。

链接：https://vjudge.net/contest/312000#problem/G

这个题意是给定 $k$ 和 $p$，要求 $\varphi(x)$ 之和，$x$ 的质因数分解有 $k$ 个质数并且包含且只包含质数表前 $p$ 个（下称“前 $p$ 种”）质数。$k, p \leq 500$。

当时做这个题的时候，直接就交了一个 $O(n^3)$ 的 DP 上去，就 T 掉了。还以为是被卡常了，结果发现标程是 $O(n^2)$ 的。（~~LightOJ 真是慢，`n = 500` `O(n^3)` 都过不了，别人 CodeForces `n=10000` `O(n^2)` 就能卡过去~~）

转换以后，我认为题意是要从前 $p$ 种质数中枚举 $k-p$ 个数（可重复），然后相乘求和，类似于 $n$ 球放进 $m$ 盒问题，每一个 `dp[m][n]` 都是由 `dp[m-1][t]` $0 \leq t \leq n$ 得到的，就写了一个 $O(n^3)$ 的算法。

但实际上这个题，每个 `dp[m][n]` 可以由 `dp[m-1][n-1]` 和 `dp[m][n-1]` 得到。**因为这是数学问题**（指涉及到了一堆乘法和加法）。

看到别人的 dp 转移方程我是懵逼的，但是我尝试者打表举例来说：

同样是按照我的定义来说吧：从前 $n$ 种质数中取 $m$ 个数（可重复）。dp[0][0] = 1。

dp[n][m]|n=1|n=2|n=3|n=4
-|-|-|-|-
m=1|dp[1][1]<br>=2|dp[2][1]=<br>2+3|dp[3][1]=<br>2+3+5|dp[4][1]=<br>2+3+5+7
m=2|dp[2][1]<br>=2\*2|dp[2][2]=<br>2\*2+2\*3<br>+3\*3|dp[3][2]=<br>2\*2+2\*3+3\*3<br>+2\*5+3\*5+5\*5|dp[4][2]=2\*2+2\*3+3\*3+2\*5+3\*5+5\*5<br>+2\*7+3\*7+5\*7+7\*7
m=3|dp[3][1]<br>=2\*2\*2|dp[3][2]=2\*2\*2+dp[2][2]*3|dp[3][3]=<br>2\*2\*2+2\*2\*3+2\*3\*3+3\*3\*3<br>+dp[3][2]\*5|数据过长，略

写完 $m=2$，貌似已经可以看到一点规律了：

```
dp[n][m] = dp[n-1][m] + dp[n][m-1]*prime[n]
(dp[0][i] = 1)
```

用人话举例来说，就是 `dp[3][2]`（前两种质数中取三个）的情况是以下两种情况的求和：一是不取第三种质数，该情况等于 `dp[2][2]`；二是取至少一个第三种质数，该情况的值又正好等于 `dp[3][1]` 的值乘以第三个质数。

这题的分析就很明了了。

**其实这样一手动打表，转移方程具体该谁乘谁加谁就很明了了，并不需要O(n)，只需要O(1)**。这大概就是这题的教训了吧。

另外 Light OJ 上把 `%lld` 改成 `I64d`，就从 `9ms` 卡到 `3000ms` 了。心态爆炸。以后还是用 `iostream` 吧。

最后放一下 AC 代码：

```c++
#include<bits/stdc++.h>
//#define _CRT_SECURE_NO_WARNINGS
#define ld long double
#define ll long long
#define int ll
#define eps 1e-11
#define fastio ios::sync_with_stdio(0);cin.tie(0);cout.tie(0);
using namespace std;
typedef pair<int, int> P;
const int maxn = 1e4 + 5, mod = 1e9 + 7;

bool vis[maxn] = { 0 };
int prime[maxn], cnt = 0;
void euler(int n)
{
	for (int i = 2; i < n; i++)
	{
		if (!vis[i]) prime[cnt++] = i, vis[i] = 1;
		for (int j = 0; j < cnt && i * prime[j] < n; j++)
		{
			vis[i*prime[j]] = 1;
			if (i%prime[j] == 0)
				break;
		}
	}
}

int dp[505][505] = { 0 }, base[505];

signed main()
{
	//ofstream fout("out.txt");
	fastio;
	euler(maxn);
	for (int n = 1; n <= 501; n++)
	{
		dp[n][0] = 1;
		for (int m = 1; m <= 501; m++)
		{
			dp[n][m]  = dp[n - 1][m] + dp[n][m - 1] * prime[n - 1];
			dp[n][m] %= mod;
		}
	}
	base[0] = 1;
	for (int i = 1; i <= 500; i++)
	{
		base[i] = base[i - 1] * (prime[i - 1] - 1);
		base[i] %= mod;
	}
	int T;
	scanf("%I64d", &T);

	for (int kase = 1; kase <= T; kase++)
	{
		int k, p;
		scanf("%I64d%I64d", &k, &p);

		printf("Case %I64d: %I64d\n", kase, dp[p][k - p] * base[p] % mod);
	}
}
```
