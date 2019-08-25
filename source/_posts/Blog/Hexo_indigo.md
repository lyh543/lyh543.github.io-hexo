---
title: Hexo_indigo主题配置
tags:
- Indigo
category:
- Blog
mathjax: true
---

额，在用了两个月的 Material 主题以后，有点喜新厌旧了（逃

其实是有些地方不大方便：在读长文章的时候没有一个 Table of Content（toc，或者有但是我不会开）；另一个就是博客的分类和标签太弱了，再加上宽大的卡片式设计，遍历文章标题的效率非常低，跳转非常不方便，基本只能靠搜索；最后是每篇博客的那张图就是在那几张 Material Design 的壁纸里面随机，看久了确实没什么意思。  
再加上 Hexo 换个主题挺方便的，所以就动手了。

这次选的是 [indigo](https://github.com/yscoder/hexo-theme-indigo)，仍然是基于 Material Design 的，而且过渡动画挺好看的。分类和标签页都运用了选项卡，这样的查找效率就很高了。

在配置方面也还好，作者写了手册，按照手册一步一步做就行了，要是配置过一遍 Hexo 博客的人，做起来是不吃力的。

但是在评论部分，稍微有点卡，因为之前的 Material 主题是用 gitalk 配置的。而 gitalk 的 id 为了避免过长，于是用的是标题的 md5 值。  
indigo 的 gitalk 部分貌似也是有考虑到 id 过长的问题，但是处理方法不是 md5，于是以前的 issues 不能被现在识别到，需要去修改 gitalk 部分的代码。  
但是之前的 md5 也是自己改的，所以对于我这个 JS 小白来说，迁移到 indigo 也不是很难。

最后还是没有解决 toc 的问题。在 [issues](https://github.com/yscoder/hexo-theme-indigo/issues/268) 下我看到一个人有相同的情形，但他是 emacs 造成了，而我使用的是 vscode。于是挖个坑在这里，希望能解决吧。

-----------------------------------

更新：关于 toc，我最后解决的方案是，备份文件以后，重新 `hexo init blog` 和 `git clone git@github.com:yscoder/hexo-theme-indigo.git themes/indigo`，按照 indigo 作者的方法[安装依赖](https://github.com/yscoder/hexo-theme-indigo/wiki/%E5%AE%89%E8%A3%85#%E4%BE%9D%E8%B5%96%E5%AE%89%E8%A3%85)，然后再把配置文件、博客文件复制过去即可。

可能是我之前使用的 Material 主题，切换主题的时候直接修改站点配置文件的 `theme` 选项，某些文件出现错误导致的问题。
