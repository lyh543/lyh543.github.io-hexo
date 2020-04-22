---
title: Hexo 备份（及一次翻车的经历）
date: 2019-9-17
tags:
- Hexo
- Blog
category:
- Blog
mathjax: true
---

由于 Hexo 的本地文件是没有上传到 Github 的，某天突发奇想，想把 Hexo 文件夹直接移至 Onedrive 自动备份。  
后来发现由于 Hexo 的 node_modules 文件太多了(10000+)，以至于需要同步很久。  
另外，每一次 generate，都会有一堆东西要删除，但是由于 Onedrive 的设定，这些文件就在 Onedrive 云端保留了，非常混乱。

于是就不整了。

把文件移出 Onedrive 时，每次都会导致死机（是的，死机~~也可能和我用 Win10 预览版有关~~），猜测是文件夹太深了，于是删掉了 Node_modules 文件夹再复制过来就好了。

然后，  
然后，  
接下来才是重点，

**当我 `npm install hexo && hexo d -g` 以后，发现根本没有 html 文件生成！！！**

查了一下才发现 hexo 本身有一大堆依赖的东西，但是仅仅 `npm install hexo` 一句是不会完全安装的。[参考博客](https://blog.csdn.net/huihut/article/details/73196343)

于是自己把安装所有依赖的包的过程写了一个 bash 脚本，以后备份了文件夹，要是原来的文件没了，可以直接调用这个脚本。

```bash
# setup.bash
# 放在 Hexo 目录下
set -x
npm install hexo
npm install --save hexo-deployer-git
npm install --save hexo-server
npm install --save hexo-generator-archive
npm install --save hexo-generator-category
npm install --save hexo-generator-index
npm install --save hexo-generator-search
npm install --save hexo-generator-tag
# npm install --save hexo-helper-post-top
npm install --save hexo-helper-qrcode
npm install --save hexo-inject
# npm install --save hexo-math
npm install --save hexo-renderer-ejs
npm install --save hexo-renderer-marked
npm install --save hexo-renderer-stylus
```

------------------------------------------

但是，当我切换到另一个 [indigo](https://github.com/yscoder/hexo-theme-indigo) 主题的时候，它的 toc 我怎么也用不了。可能是上面这一步出了问题。建议按照下面的备份方法以后，重建 Hexo 目录使用官方[建立新博客的方法](https://hexo.io/zh-cn/)，然后再把配置文件、博客文件复制过去。

那么，备份又怎么办呢？

干脆写个批处理脚本，再弄进任务计划，每周执行一次。

~~由于批处理的语法都是现查，Windows自带的帮助还写的很烂，~~整个过程可能花了一两个小时。

```batch
:: backup.bat
:: 放在 Hexo 目录下
@echo off
title Backup lyh543.github.io
set sourceDirectory=C:\Users\lyh\Documents\Git\lyh543.github.io
set destinationDirectory=C:\Users\lyh\OneDrive\Documents\lyh543.github.io.backup

del /f /s /q %destinationDirectory% >nul
rd /s /q %destinationDirectory% >nul
md %destinationDirectory%\

echo .deploy_git\ >xcopy_exlude_files.txt
echo public >>xcopy_exlude_files.txt
echo node_modules >>xcopy_exlude_files.txt

echo.
xcopy /s /i %sourceDirectory% %destinationDirectory%\ /EXCLUDE:xcopy_exlude_files.txt
echo.

del /q xcopy_exlude_files.txt %destinationDirectory%\xcopy_exlude_files.txt >nul

pause
```

加入任务计划的方法就[自行百度](https://www.cnblogs.com/wensiyang0916/p/5773828.html)吧。

-------------------------------------------------------

2019.11.5 更新

这样还是很蠢啊。最好的办法就是基于 Git 本身，将整个项目 push 到 Github。

可以选择 push 到同一个库的另一个 branch，坏处是必须要公开所有文件。

我采用的方法是全部 push 到另一个私有 Github 库。

具体实现就不多说了，这些是 [Git 基础](/Linux/Git)。