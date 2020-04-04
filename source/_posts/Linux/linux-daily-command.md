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


## 当前文件夹 current directory

当前文件夹是便于写相对路径的。

假设你当前在 `/mnt/c/Users/lyh/Documents/Git/lyh543.github.io` 文件夹。  

当你需要访问文件夹下的 `_config.yml`，你就可以写 `_config.yml` 或 `./_config.yml` （注意一定要加`.`，否则会被视为根目录）来代替 `/mnt/c/Users/lyh/Documents/Git/lyh543.github.io/_config.yml`。

可以在命令行的`$`前看到当前文件夹，也可以使用非常简洁的命令：`pwd`。该命令返回当前文件夹。

* 更改当前文件夹使用 `cd [DIRECTORY]`  
* 若想跳到当前文件夹下的 `themes` 文件夹，可以使用 `cd themes`  
* 若想跳到上一级文件夹，可以使用 `cd ..`（Windows cmd 中 `cd` 和 `..` 间可以不加空格，但是 Linux Shell 必须要有空格）  
* 若想跳到上两级文件夹，可以使用 `cd ../..`  
* 若想跳到上两级文件夹下的`theme`文件夹，可以使用 `cd ../../theme`  

## 文件

### 下载、解压

```bash
wget https://github.com/fatedier/frp/releases/download/v0.29.0/frp_0.29.0_linux_amd64.tar.gz
tar -zxvf frp_0.29.0_linux_amd64.tar.gz   # -z 参数用于解压 .gz 文件
```

`tar` 的用法：

```bash
tar -cf archive.tar foo bar  # Create archive.tar from files foo and bar.
tar -tvf archive.tar         # List all files in archive.tar verbosely.
tar -xf archive.tar          # Extract all files from archive.tar.
```

对于 `zip`，可以使用 `unzip`。


### 读取文件 加权限

```bash
ls  # 显示文件夹的内容， -sh 显示大小（带大小单位）

cat text.txt  # 显示文档的内容
head [-n 10] text.txt # 显示文档开头
tail [-n 10] text.txt # 显示文档结尾
more text.txt # 逐段显示文本（按空格显示下一段）
less text.txt # 逐段显示文本，功能更多，按 q 退出

# 以上用法也可以使用 <command> | tail 的形式，将命令的输出进行对应的操作

mkdir new_dir # 新建文件夹
chmod a+x test.sh # 给脚本文件加可执行的权限
./test.sh  # 执行可执行文件
```

若想修改文档，请使用 [vi](../vi笔记)。

### 重定向 新建文本文件

在命令行控制台中的 `echo`（类似于 `C++` 的 `printf` 的输出语句）貌似没什么用。  

但是使用重定向，就可以把本来要输出到屏幕的东西输出到某文件。

在任意命令后（其实在前面也可以的）加 `>[FILE]` 即可把输出

### 删除

`rm [FILE]` 是 remove 的缩写，用于删除文件/文件夹。

很经典的一个删库跑路语句是`rm -rf /*`，我们能从这句话记它的用法。

* `-r`: recursive, 递归，即递归删除该文件夹以下的文件（夹），删非空文件夹时必加。
* `-f`: force, 强制，即强制删除~~虽然不知道有什么用~~
* `[File]`: 写文件、文件夹名就行啦。


### 查看文件/文件夹/磁盘的大小

中文|英文|命令
-|-|-
查看磁盘大小|**d**isplay **f**ilesystem|`df -h`
查看目录下的文件大小|**l**i**s**t|`ls -hs`
查看目录下的文件夹的大小|**d**isk **u**sage|`du -h --max-depth=1`

以上的 `-h` 都是 `--human-readable`，不使用这个开关，则会使用一个数字表示大小（单位为 `KB`）；使用开关后，则会使用 `200K`，`1.8G` 的形式。  
注意 `du` 如不加 `--max-depth` 参数，会统计完所有的目录。

## 进程

### 进程 CPU、内存占用

可以使用 `top` 工具。

如果想要让进程按 CPU 或内存排序，可以按 `X` 键使得焦点在某一列（那一列的数字呈亮白色），然后按 `<` `>` （`Shift+,` `Shift+.`）以左右移动焦点。

### 杀进程

以杀掉 `vi` 为例：

```sh
ps aux | grep vi
# 返回之中有一行如下，则用户名后的 138 即为其 PID
# root 138  0.0  0.0  27612  6224 tty2     S    00:16   0:00 vi
kill -9 138
```

或者使用 `killall`：

```sh
killall vi
```

### 进程后台运行

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
pm2 --name s1 -f start http-server # 配置 pm2

pm2 save # 可选命令，作用是保存当前的 pm2 状态
pm2 startup # 可选命令，下次开机的时候可以恢复到 save 的状态

pm2 ls   # 可选命令，列出当前 pm2 的任务
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

## 网络

### 查看端口占用

`lsof -i:8999`

### 查看网络流量

可以使用第三方的 `nethogs`。