---
title: linux 日常
date: 2019-10-14 22:04:00
tags:
- ssh
- 服务器
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

### 添加 PATH 路径

以下方法（二选一）可以加入 `~/opt/bin` 目录。

```bash
PATH=$PATH:~/opt/bin
PATH=~/opt/bin:$PATH
```

### alias 简化命令

多次输入长语句着实麻烦，而 Linux 就提供了简化命令的方法。

执行下面的语句：

```bash
alias la='ls -al --color=auto'
```

以后，输入 `la` 就等价于 `ls -al --color=auto` 了。

不过注销以后就失效了。

如果想要以后登录都生效，可以把 `alias` 命令追加到 `~/.bashrc`。

我的 `~/.bashrc` 结尾是这样的：

```bash
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
```

注意到他推荐把 `alias` 放到 `~/.bash_aliases` 文件夹，其实也可以搞。因此，在 `~/.bashrc` 或 `~/.bash_aliases` 后追加（没有就创建并追加）以下命令，都是可以的。

```
alias la='ls -al --color=auto'
```

下次启动生效。如想本次启动就生效，输入 `source ~/.bashrc` 即可。

最后，输入 `alias` 即可查看所有的语句。

### 查看发行版名称和版本号

> 转载自：[如何查看LINUX发行版的名称及其版本号](https://www.qiancheng.me/post/coding/show-linux-issue-version)

#### 查看 Linux 内核版本

1. `cat /proc/version`

2. `uname -a`

#### 查看 Linux 系统版本

1. `lsb_release -a`，通用；

2. `cat /etc/issue`，也是通用；

3. `cat /etc/redhat-release` 只适用于 Redhat 系 Linux。

### 查看端口占用

`lsof -i 8999`

## 文件

### 新建、删除

新建、删除等操作请见 [bash笔记](../bash/#文件、文件夹操作)

### 下载、解压

```bash
wget https://github.com/fatedier/frp/releases/download/v0.29.0/frp_0.29.0_linux_amd64.tar.gz
tar -zxvf frp_0.29.0_linux_amd64.tar.gz
```

### 查看文件/文件夹/磁盘的大小

中文|英文|命令
-|-|-
查看磁盘大小|**d**isplay **f**ilesystem|`df -h`
查看目录下的文件大小|**l**i**s**t|`ls -hs`
查看目录下的文件夹的大小|**d**isk **u**sage|`du -h --max-depth=1`

以上的 `-h` 都是 `--human-readable`，不使用这个开关，则会使用一个数字表示大小（单位为 `KB`）；使用开关后，则会使用 `200K`，`1.8G` 的形式。  
注意 `du` 如不加 `--max-depth` 参数，会统计完所有的目录。



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

在 `sudo /etc/rc.local` 最后追加命令，然后给权限 `sudo chmod a+x /etc/rc.local` 即可。

不过貌似 `alias` 语句无效，可能 `alias` 是用户级的命令，需要用户登录时执行。

### 用户登录时执行语句

## ssh

### 一些链接

在使用 Git 和搭建服务器的时候都会用到 ssh，于是笔记也比较零散。

在这里丢几个链接：

* [创建 ssh 密钥并给 Git/服务器使用](../Git/#在-Linux-下-git-使用-ssh-密钥)
* [ssh 远程登录服务器](../build-shadowsocks/#ssh-远程登录)
* [修改 ssh 的端口](../change-ssh-port/)
* [Windows 上使用 ssh](/Windows/setup-ssh-windows/)
* 
### 查看 ssh 登陆日志

```
cat /var/log/secure
```

也可以根据需要搭配 less 或 tail 等命令进行查看。
