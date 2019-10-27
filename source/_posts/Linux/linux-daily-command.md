---
title: linux 日常
date: 2019-10-14 22:04:00
tags:
category:
- Linux
mathjax: true      
---

常用命令的详细部分都分为单独博客撰写：

* [纯 bash 语法](../bash)
* [Git](../Git)
* [APT](../APT)
* [npm](../npm)
* [vi 基础](../vi)

## 系统

### 以 root 身份登录

```sh
sudo su
```

### 修改 root 密码

```sh
sudo passwd root
```

### 查看 Linux 发行版名称和版本号

> 转载自：[如何查看LINUX发行版的名称及其版本号](https://www.qiancheng.me/post/coding/show-linux-issue-version)

#### 查看 Linux 内核版本

1. `cat /proc/version`

2. `uname -a`

#### 查看 Linux 系统版本

1. `lsb_release -a`，通用；

2. `cat /etc/issue`，也是通用；

3. `cat /etc/redhat-release` 只适用于 Redhat 系 Linux。

## 文件

### 下载、解压

```bash
wget https://github.com/fatedier/frp/releases/download/v0.29.0/frp_0.29.0_linux_amd64.tar.gz
tar -zxvf frp_0.29.0_linux_amd64.tar.gz
```

## 进程

### 杀进程

以杀掉 `vi` 为例：

```
ps aux | grep vi
# 返回之中有一行如下，则用户名后的 138 即为其 PID
# root 138  0.0  0.0  27612  6224 tty2     S    00:16   0:00 vi
kill -9 138
```

### 后台进程

#### 使用 nohup

使用 `nohup` 的话，一行代码就 ok：

```bash
# nohup <command> & &>/dev/null
nohup ssserver & &> /dev/null
```

可能会看到 `ignore input` 之类的警告，不用管，`Ctrl+C` 退出前台即可，此时 `ssserver` 正在后台运行。

#### 使用 pm2

这个要麻烦一点，要从 `npm` 下载，所以还得先下载 `npm`。

```bash
apt install npm
npm install pm2 -g
pm2 --name s1 -f start ss-server # 配置 pm2
pm2 startup # 启动
pm2 save # 保存
```

### 开机自启

在 `sudo /etc/rc.local` 最后追加命令，然后给权限 `sudo chmod a+x /etc/re.local` 即可。

