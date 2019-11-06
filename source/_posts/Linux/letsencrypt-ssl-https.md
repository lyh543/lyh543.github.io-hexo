---
title: 用 Let's Encrypt 给网站加 https
date: 2019-10-18 15:42:05
tags:
- 服务器
- https
category:
- Linux
mathjax: true
---

现在基本都要求各网站使用 `HTTPS` 、`SSL` 之类的。于是准备给自己的博客和网站也整一个。

## HTTPS、SSL、TLS 相关术语

参考[这篇博客](https://blog.csdn.net/enweitech/article/details/81781405)，可以知道 `HTTPS`、`SSL`、`TLS` 的定义和区别。

简单来说，

* SSL 是指安全套接字层，简而言之，它是一项标准技术，可确保互联网连接安全；
* TLS（传输层安全）是更为安全的升级版 SSL。由于 SSL 这一术语更为常用，因此我们仍然可以将我们的 TLS 安全证书称作 SSL。但当您从赛门铁克购买 SSL 时，您真正购买的是最新的 TLS 证书；
* TLS/SSL是一种加密通道的规范；
* HTTPS 实际上就是 HTTP over SSL

## 用 LET'S ENCRYPT 给网站加 HTTPS 

转载自 [LET'S ENCRYPT 给网站加 HTTPS 完全指南](https://ksmx.me/letsencrypt-ssl-https/)

