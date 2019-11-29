---
title: 在 Windows 上安装 Anaconda 和 Jupyter Notebook
date: 2019-11-28 21:28:59
tags:
- Anaconda
- Jupyter Notebook
category:
- Windows
mathjax: true
---

诚然，在 Linux 上使用 Anaconda、Jupyter Notebook 的体验远远高于 Windows，但博主由于自身因素，只能在台式机上使用 Windows 系统，而微软的 wsl 暂时还不能连接到显卡，后期如果要考虑用 Python 进行深度学习方面的学习，不能使用显卡加速是一个很麻烦的地方。

综上，博主想要尝试在 Windows 上安装 Anaconda 和 Jupyter Notebook。

## Anaconda 简介

> 摘抄自：https://blog.csdn.net/ITLearnHall/article/details/81708148

Anaconda 指的是一个开源的 Python 发行版本，其包含了 conda、Python 等 180 多个科学包及其依赖项。 

因为包含了大量的科学包，Anaconda 的下载文件比较大（约 531 MB），如果只需要某些包，或者需要节省带宽或存储空间，也可以使用 Miniconda 这个较小的发行版（仅包含 conda 和 Python）。

Conda 是一个开源的包、环境管理器（类似于 Debian 的 apt，Python 的 pip？），可以用于在同一个机器上安装不同版本的软件包及其依赖，并能够在不同的环境之间切换

Anaconda 包括 Conda、Python 以及一大堆安装好的工具包，比如：numpy、pandas 等

Miniconda 包括 Conda、Python

## Anaconda 安装

直接丢链接吧：https://blog.csdn.net/ITLearnHall/article/details/81708148（还是上面那个）

包括安装、添加环境变量及其他常见使用方法。

### Anaconda Windows 环境变量

为方便使用，我个人添加了一些其他的 `PATH` 环境变量（添加 `PATH` 环境变量的方式请自行百度）。如下：

```
C:\Program Files\Anaconda\
C:\Program Files\Anaconda\Scripts
C:\Program Files\Anaconda\condabin
C:\Program Files\Anaconda\Library\bin
```

## conda 包管理命令

列举已安装的包：`conda list`

安装 `requests` 包（以下命令二选一）：

```py
conda install requests
pip install requests
```

卸载：

```py
conda uninstall requests
pip uninstall requests
```

更新：

```py
conda upgrade --all
```

## 配置 Jupyter Notebook

安装完 Anaconda 以后，就自带了 Jupyter Notebook。双击就可以用了。配置什么的，先鸽了。

另外，Jupyter Notebook 对 Linux 和 Mac 平台支持很好，可以在上面使用 C++、MATLAB、Mathematica，只要安装了对应内核就行。然而现在还不支持 Windows。所以，想要最好的体验请使用 Linux / Mac 安装 Jupyter Notebook。

## 部分报错及解决办法

### conda list 报错 conda 不是可运行的程序

将 Anaconda 安装目录的 `Anaconda3\Scripts` 文件夹加入  `PATH` 环境变量。参考[conda list 报错](https://blog.csdn.net/qq_42273575/article/details/83345455)

### conda list 报错 LoadLibrary() ...

错误提示 `TypeError LoadLibrary() argument 1 must be str, not None`。

不是很清楚具体的原因，倒是找到了三篇 CSDN 博客解决这个的问题：

* 环境变量和（单独安装的） Python 的 Scripts 冲突？—— 将 Anaconda 的 `PATH` 置顶（或者考虑直接将单独安装的 Python 卸载）。[参考链接](https://blog.csdn.net/Noxi_lumors/article/details/99207714)  
* 将 `Anaconda3\condabin` 文件夹加入  `PATH` 环境变量。[参考链接](https://blog.csdn.net/taoqick/article/details/99415975)
* 每次使用 `conda.bat activate` 进入 Anaconda 环境；或者 `conda init bash` 激活基础环境。[参考链接](https://blog.csdn.net/AI414010/article/details/100011008)

最后都没好，但重启以后就好了，~~到底哪一条是对的，我也不知道~~

### conda upgrade 报错 SSL is not available

具体报错是 `Can't connect to HTTPS URL because the SSL module is not available`。  
更有意思的是，在 Anaconda Prompt 命令行中不会报错，而在 cmd 中 `conda install` 就会报错。

* 解决办法一：将默认源换为清华的镜像源，并将 `https` 改为 `http`。（[参考链接](https://blog.csdn.net/sinat_29315697/article/details/80516498)，不推荐）  
* 解决办法二：将 `\Anaconda3\Library\bin` 包含进 `PATH` 环境变量。（亲测有效）
* 解决办法三（没有试过）：安装 OpenSSL。[参考链接](https://github.com/conda/conda/issues/8046#issuecomment-450492945)

### conda upgrade 报错 EnvironmentNotWritableError

```
EnvironmentNotWritableError: The current user does not have write permissions to the target environment.
```

使用管理员权限运行命令行窗口即可。
