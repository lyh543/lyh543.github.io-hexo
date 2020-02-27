---
title: 正则表达式
date: 2020-02-26 20:41:57
tags:
category:
- 计算机科学
mathjax: true
---

## 前言

先说点别的。一般来说，听到一个计算机科学的名词的中文，可能猜不到这是什么，但是听到英文就很好理解了。

正则表达式（regular expression）这个概念，是少数的，我听了英文以后还猜不知道是什么的概念之一。

> 正则表达式，又称规则表达式（英语：Regular Expression，在代码中常简写为regex、regexp或RE），计算机科学的一个概念。正则表达式通常被用来检索、替换那些符合某个模式（规则）的文本。

linux 中支持用正则表达式检索文本的有 `sed` 和 `grep`，Python 中有 `re` 模块。

## 速成：正则表达式常用规则

> 转自 [python正则表达式从字符串中提取数字_Python_赵大宝的博客](https://blog.csdn.net/u010412858/article/details/83062200)

```
## 总结
## ^ 匹配字符串的开始。
## $ 匹配字符串的结尾。
## \b 匹配一个单词的边界。
## \d 匹配任意数字。
## \D 匹配任意非数字字符。
## x? 匹配一个可选的 x 字符 (换言之，它匹配 1 次或者 0 次 x 字符)。
## x* 匹配0次或者多次 x 字符。
## x+ 匹配1次或者多次 x 字符。
## x{n,m} 匹配 x 字符，至少 n 次，至多 m 次。
## (a|b|c) 要么匹配 a，要么匹配 b，要么匹配 c。
## (x) 一般情况下表示一个记忆组 (remembered group)。你可以利用 re.search 函数返回对象的 groups() 函数获取它的值。
## 正则表达式中的点号通常意味着 “匹配任意单字符”
```

如，想要用 Python 匹配输入字符串中的所有数字子串，正则表达式应为 `\d+`。

```py
>>> import re
>>> re.findall('\d+', input())
123365874&&123       # 输入
['123365874', '123'] # 输出
>>>
```

## 彩蛋：匹配网址的正则表达式

```
( regexpTaobao = regexp.MustCompile(`￥([\w\s]+)￥`) regexpURL = regexp.MustCompile(`(?:http|https|www)(?:[\s\.:\/\/]{1,})([\w%+:\s\/\.?=]{1,})`) regexpWhitelist = regexp.MustCompile(`((acg|im9|bili|gov).*(com|html|cn|tv)|(av\d{8,}|AV\d{8,}))`) regexpQQ = regexp.MustCompile(`(?:[加qQ企鹅号码\s]{2,}|[群号]{1,})(?:[\x{4e00}-\x{9eff}]*)(?:[:，：]?)([\d\s]{6,})`) regexpWechat = regexp.MustCompile(`(?:[加+微＋+➕薇？vV威卫星♥❤姓xX信]{2,}|weixin|weix)(?:[，❤️.\s]?)(?:[\x{4e00}-\x{9eff}]?)(?:[:，：]?)([\w\s]{6,})`) )
```
