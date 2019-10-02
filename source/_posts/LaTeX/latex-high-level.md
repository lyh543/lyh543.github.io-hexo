---
title: LaTeX 高阶部分
date: 2019-09-24 21:23:36
tags:
- 课程笔记
category:
- LaTeX
mathjax: true
---

该文章记录 LaTeX 原理等部分，和前一篇的简单用法分开。

## LaTeX 编译过程

LaTeX 编译过程中会有六个文件：

1. `.aux`——存放交叉引用信息；  
2. `.dvi`——是 LaTeX 编译运行后的主要结果。用户可以使用 DVI 预览软件查看 `.dvi` 内容；  
3. `.log`——记录上一次编译器运行的日志；  
4. `.pdf`——PDF 文件，文件是 pdflatex 编译运行后的主要结果；  
5. `.synctex.gzl`；  
6. `.tex`——LaTeX 和 TeX 源文件，进行编译处理。
