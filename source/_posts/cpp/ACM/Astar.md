---
title: A*（坑）
date: 2019-9-17
tags:
- 图论
- 搜索
- 坑
category:
- C++
- ACM
---

一种搜索算法的优化（最优性剪枝），引入估值函数，同时考虑 f(n) 和 g(n) 来进行搜索（蜜汁复杂度）。

A* 的主体是 BFS（包括Dijkstra），

## 估值函数 h(x) 和最短路 d(x)（坑）

h(x) < d(x)
h(x) == d(x)
h(x) > d(x)

## K短路

给一张有向带权图，求 1 到 n 的第 k 短路。跑 Dijktra，即使每个点只跑 k 遍，也会炸掉。  
于是发明估值函数，

`f(i)=1到i的目前算的距离+i到n的最短距离`

然后以估值函数作为优先队列排序的依据即可。

h(x) = d(x)

~~代码？挂了！~~

```c++
#include <bits/stdc++.h>
#define ll long long
//#define DEBUG
using namespace std;
const ll maxn = 10005, maxm = 500005, maxd = 0x7fffffff;

struct edge {
    ll b;
    ll d;
};

list<edge> gg[maxn], gf[maxn];

//ll f[maxn]; // s 到 i 已经经过的距离
ll g[maxn]; // x 到 t 的最短距离
ll vf[maxn] = { 0 }; //经过i点的次数, 经过k次就不再入队
ll vg[maxn] = { 0 };

struct cmpf {
    bool operator ()(edge a, edge b)
    {
        return a.d + g[a.b] > b.d + g[b.b];
    }
};

struct cmpg {
    bool operator ()(ll a, ll b)
    {
        return g[a] > g[b];
    }
};

priority_queue<ll, vector<ll>, cmpg> qg;
priority_queue<edge, vector<edge>, cmpf> qf;
ll ans[maxn];

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);

    ll n, m, k = 1, s, t = 2;
    cin >> n >> m >> s;
    for (int i = 0; i < m; i++)
    {
        int _a, _b, _d;
        cin >> _a >> _b >> _d;
        //不知道要不要算已经到t还往回走的路，现在是没算的
        //if (_a != t)
        gf[_a].push_back({ _b,_d });
        gg[_b].push_back({ _a, _d });
    }

    for (int i = 1; i <= n; i++)
    {
        ans[i] = g[i] = maxd;
    }

    g[t] = 0;
    qg.push(t);
    while (!qg.empty())
    {
        ll cur = qg.top();
        qg.pop();
        if (vg[cur])
            continue;
        vg[cur] = 1;
        for (auto iter = gg[cur].begin(); iter != gg[cur].end(); iter++)
        {
            if (!vg[iter->b] && iter->d + g[cur] < g[iter->b])
            {
                g[iter->b] = iter->d + g[cur];
                qg.push(iter->b);
            }
        }
    }

    //f[s] = 0;
    qf.push({ s,0 });
    while (!qf.empty())
    {
        edge cur = qf.top();
        qf.pop();

        if (vf[cur.b] >= 1)
        {
            continue;
        }
        ans[cur.b] = cur.d;
        vf[cur.b]++;

        for (auto iter = gf[cur.b].begin(); iter != gf[cur.b].end(); iter++)
        {
            if (vf[iter->b] <= k)// && iter->d + f[cur] < f[iter->b])
            {
                //f[iter->b] = iter->d + f[cur.b];
                qf.push({ iter->b , iter->d + cur.d });
            }
        }
    }
    for (int i = 1; i <= n; i++)
    {
        cout << ans[i] << " ";
    }
}

```
