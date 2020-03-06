---
title: Qt入门
date: 2019-6-26
tags:
- Qt
---

## Qt 简介

跨平台多语言应用开发框架，不仅能开发UI，还提供很多C++基础类库，很多吊打C++库

开源，非商用可免费使用。

Qt支持多语言，但是常用C++，Python

UI、QTL、Mulitimedia、Network、sql、xml......

## Qt 安装

安装以后，可以在 VS 里使用（配合插件）。

## Qt 使用

### 信号槽

将信号（用户点了按钮）与动作（程序执行动作）连接起来

旧版本：

```c++
connect(发送者, 信号, 接受者, 动作);
connect(..., SIGNAL(f(int)), ..., SLOT());
connect(ExitAction, &QAction::triggered, this, &std::exit);
```

新版本。。。。。

### 细节

更改程序编码

```cpp
#pragma execution_character_set("utf-8")
```

模态：程序/对话框运行时，不能执行其他动作
非模态：程序/对话框运行时，可以执行其他动作
