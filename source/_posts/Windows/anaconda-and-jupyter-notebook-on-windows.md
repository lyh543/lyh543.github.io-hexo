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

## Anaconda 安装

直接丢链接吧：https://blog.csdn.net/ITLearnHall/article/details/81708148

包括安装、正确的添加环境变量及其他常见使用方法。

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

安装完 Anaconda 以后，就自带了 Jupyter Notebook。双击就可以用了。配置什么的，需要了再改。

## 部分报错及解决办法

### conda list 报错不是可运行的程序

将 Anaconda 安装目录的 `Anaconda3\Scripts` 文件夹加入  `PATH` 环境变量。参考[conda list 报错](https://blog.csdn.net/qq_42273575/article/details/83345455)

### conda list 报错 LoadLibrary() ...

错误提示 `TypeError LoadLibrary() argument 1 must be str, not None`。

不是很清楚具体的原因，倒是找到了三篇 CSDN 解决这方面的问题：

* 环境变量和 Python 的 Scripts 冲突？——将 Anaconda 的 `PATH` 置顶。[参考链接](https://blog.csdn.net/Noxi_lumors/article/details/99207714)  
* 将 `Anaconda3\condabin` 文件夹加入  `PATH` 环境变量。[参考链接](https://blog.csdn.net/taoqick/article/details/99415975)
* 每次使用 `conda.bat activate` 进入 Anaconda 环境；或者 `conda init bash` 激活基础环境。[参考链接](https://blog.csdn.net/AI414010/article/details/100011008)

