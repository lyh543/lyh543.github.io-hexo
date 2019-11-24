---
title: 精确搜索——用学号匹配名字
date: 2019-4-15
tags:
- Excel
category:
- Windows
---

```vb
=VLOOKUP(B2,Namelist!$A$2:$B$386,2,FALSE)
```

在Namelist工作簿的A2:B386里精确搜索B2，如果有，返回前者第二列的结果

如果文字格式不对，可能需要notepad复制粘贴消一波格式。

但是，仍然有bug。最后是用C++实现的。

<font size="30">垃圾excel</font>
