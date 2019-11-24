---
title: 使用 iperf3 测速
date: 2019-11-19 20:04:49
tags:
- 服务器
- 语法测试
category:
- Linux
mathjax: true
---

Iperf3 是一个开源的多平台跨架构的命令行测速软件，只要在两个设备上同时运行这个软件，就可以进行测速。

## iperf3 下载、使用

官网下载链接如下：https://iperf.fr/iperf-download.php

其中 Windows 是一个 exe 和一个 dll，而 Debian 推荐使用他的命令行下载，红帽系的 Linux 可以直接使用 `xxx install iperf3`。

使用方法直接看说明就行，服务端直接 `iperf -sD` 即可后台运行；

客户端进行 `iperf -c <server port>` 即可测试上传至服务端的速度。测试下载，需要使用 `iperf -c <server port> -R`。

## 局域网测试

博主进行了一个简单的局域网网速的测试。

终端设备：
1. 台式电脑，使用 Tenda U12 1300Mbps ( 2.4GHz 下 400Mbps + 5Ghz 下 867 Mbps) USB 无线网卡
2. Surface Book
3. 小米 Mix2s

路由设备
1. TP-Link TL-WDR5620 1200Mbps ( 2.4GHz 下 300Mbps + 5Ghz 下 867 Mbps) 路由器，在 5GHz 下工作
2. 小米 Mix2s 的移动热点，分别在 5GHz 和 2.4GHz 下工作

[测试结果的 Excel](speedtest.xlsx)

简要结论：

1. 终端设备上，台式和 Mix2s 表现较好（毕竟 Surface Book 已经是 3 年前的产品了）
2. 路由设备上，Mix2s 的热点甚至比路由器还强。
3. 测试不同距离的 Wifi 速度，两个终端距离路由器 3m 时，速度会较距离 30cm 时下降 10% 左右。~~反正平时也跑不满电信的带宽~~
4. 5GHz 网速明显快于 2.4Ghz