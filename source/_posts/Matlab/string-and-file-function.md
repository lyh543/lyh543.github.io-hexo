---
title: MATLAB 字符串与文件
date: 2019-09-23 19:46:47
tags:
- 课程笔记
category:
- MATLAB
mathjax: true
---

字符串是字符矩阵。

## 字符串函数

函数名|函数用途
`s=[s1,s3,num2str(num)]`|连接字符串
`num2str`|数字转字符串
`str2num`|字符串转数字
`strtok(str, delim)`|查找 `str` 的第一个 `delim` 之前和之后的字符串
`strcat`, `strvcat`|横向/纵向拼接字符串（纵向时可能会补长度）

### 分割字符串

`str2 = strsplit(str,delimiter)`

```m
str = 'ABC;UVW;QWERTY';
strsplit(str, {';', 'V'}); % == "ABC"    "U"    "W"    "QWERTY"
```

## 文件函数

和C语言很像。打开文件、读取、关闭。`fid` 是文件句柄。

```m
fid = fopen('myout.txt', 'wt');     %打开
fprintf(fid,'name=%s', name);    %格式化读取
fgets(fid);                                    %读取一行和回车
if ~feof(fid)                                 %判断文件末
    fgetl(fid);                                 %读取一行无回车
end
fclose(fid)                                    %关闭
```

打开模式|意义
-|-
`r`|只读，文件必须存在
`w`|写；若存在，则清空
`a`|在文末追加
字母后加 `t`|以文本形式（默认）
字母后加 `b`|以二进制形式
字母后加 `+`|读写都可

`fclose('all')` 直接关闭所有文件。
