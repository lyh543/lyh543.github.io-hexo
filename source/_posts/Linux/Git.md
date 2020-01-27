---
title: Git笔记
date: 2019-09-01 22:02:19
tags: 
- Git
- ssh
- 服务器
category: 
- Linux
top: false
---

先说一个概念：Git 是目前最流行的**版本管理系统**，学会 Git 几乎成了开发者的必备技能。

如果你看不懂这句话，你可以从字面意思理解“版本管理系统”：多个开发者在同一个软件的基础上，开发了不同的版本，他们可以通过 Git 方便、严谨的实现上传、下载、比对、合并代码间的冲突等操作。

而我们最常用的把代码放到 GitHub（或其他 Git 服务器）上的操作，可以把远程服务器也看做一个开发者（虽然他什么也不会修改），我们每次开发完以后，就会将代码上传给他。

常用命令可查表：[Git-CheatSheet](git-cheatsheet.pdf)

## Git 入门

### 在本地 Git 新建仓库

入门，首先就是新建一个仓库了。对于这第一个概念，`仓库`，可以从字面理解为存代码的仓库，往往将一个项目的完整代码放在一个仓库。

有两种方法：一是在本地新建一个 Git 仓库，另一种是在 GitHub 上新建库，然后下载到本地。

如果你打算将代码放到 GitHub 上，这里推荐第二种方法。因为在 GitHub 新建了库以后，可能会有一些初始文件、初始设置，可能和本地不同。如果使用使问题更复杂，在初学阶段，可以先跳过这些麻烦的东西。

首先假设你已经在 GitHub 网站上建立了库（或者你想把别人的库下载到本机），链接为 `https://github.com/lyh543/lyh543.github.io/`。现在想要在当前文件夹中，新建 `lyh543.github.io` 文件夹，并将仓库下载到本地：

```bash
git clone https://github.com/lyh543/lyh543.github.io/
```

本地就多了一个文件夹 `lyh543.github.io`，内容和网站上的一致。

你也可以使用不同于 `HTTPS` 协议的 `SSH` 协议（如果你明白这是什么），将上面 clone 的 `HTTPS` 链接修改为 `SSH` 链接即可。

顺便提一下，在本地新建仓库的方法如下：

```bash
mkdir lyh543.github.io
cd lyh543.github.io
git init
```

### Git 上传三连

在建立好库以后，每次写完代码，就可以按照下面的[上传三连](#git-上传三连)了。如果该项目只有你的一台设备进行开发（即不会出现不同步的情况），在 99% 的情况，你只会用到以下三条语句。

```bash
# 如果本地、服务器端不一致，需要先 git pull，将服务器的内容拉取下来

git add --all # 单文件是 git add <file>

# git status # 这句可以看到到底 add 了哪些东西

git commit -m "upload 2 files." # 用文字说明这一次更新了什么东西，推荐写

git push
```

上传完以后，你就可以看到 GitHub 上的代码已经更新。

#### 一键三连

在很熟悉三连操作以后，就会感到有点麻烦了。于是用 `alias` 实现了一个命令缩写。

```bash
alias commit='git_commit() { git add --all && git commit -m "$1" && git push;}; git_commit'`
```

但是因为 `alias` 不是开机自启的，要想开机自启，可以看 [另一篇博客](../linux-daily-command/#alias-简化命令)，此略。

## Git SSH 协议

Git for Linux 如果操作 HTTPS 协议链接的仓库，是不能保存密码的，每次 push 都需要输入账号密码，很烦。（Git for Windows 貌似可以走网页认证，好像可以保存）  

一个选择是 ssh 协议，使用这个协议可以保存用户信息，很方便。
第二个方案是走 https，不过让 Git 明文保存密码（不推荐）

多 ssh 秘钥部署可以看链接：https://www.awaimai.com/2200.html

### 在 Linux 下 Git 使用 ssh 密钥

大概分为三步走：

1. 本地生成密钥对；
2. 设置 GitHub 上的公钥；
3. 修改 Git 的 remote url 为 `SSH` 协议。

#### Linux 下本地生成密钥对

`$ ssh-keygen -t rsa -C "lyh543@github.com"`

passphrase 可留空~~因为太懒，不然以后每次 push 都要输这个 passphrase~~

`The key fingerprint is:
SHA256:QtXXXXXXXXXXXXXXXXXXXXXXXXXXXXlk lyh543@github.com`

#### 设置 github 上的公钥

1. 查看你的公钥

```
$ cat ~/.ssh/id_rsa.pub
ssh-rsa AAAAXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXmp lyh543@github.com
```

2. 登陆你的`github`帐户。然后 `Account Settings` -> 左栏点击 `SSH Keys` -> 点击 `Add SSH key`
3. 然后你复制上面的公钥内容，粘贴进“Key”文本域内。 `title`域，你随便填一个都行。
4. 完了，点击 `Add key`。
5. 测试一下这个key。

```bash
$ ssh -T git@github.com
The authenticity of host 'github.com (52.74.223.119)' can't be established.
RSA key fingerprint is SHA256:nTXXXXXXXXXXXXXXXXXXXXXXX8.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'github.com,52.74.223.119' (RSA) to the list of known hosts.
Hi lyh543! You've successfully authenticated, but GitHub does not provide shell access.
```

看到最后一句就是OK了。

#### 修改 Git 的 remote url 从 `https` 改为 `ssh`

查看当前（git仓库下的）的remote url

```
# 需要到仓库根目录下
$ git remote -v
origin  https://github.com/lyh543/lyh543.github.io.git (fetch)
origin  https://github.com/lyh543/lyh543.github.io.git (push)
```

修改 remote url

```
git remote set-url origin git@github.com:lyh543/lyh543.github.io.git
```

### 题外话：把 ssh 密钥给服务器

使用 ssh 远程登录服务器的时候，每次都要输入密钥。其实也可以使用 ssh 密钥进行登录。而且甚至没有 git 这么麻烦，还要去官网上加入公钥。

直接一句：

```
ssh-keygen
ssh-copy-id -i ~/.ssh/id_rsa.pub  root@192.168.x.xxx -p22
```

即可。

### Windows 下 git 使用 ssh 密钥

Windows 下也可以生成 ssh 密钥对，但是需要使用第三方软件：PuTTYgen，在 Tortoise Git 中自带。由于方法不同，可以在 Windows 和 Linux 使用不同的 ssh Key。

1. 本地生成密钥对；
2. 设置github上的公钥；
3. 设置本地git使用的密钥。

#### Windows 下本地生成密钥对

进入软件，点`Generate`，然后就开始生成。由于生成时的随机数据是采集鼠标指针的移动，因此务必在生成过程中移动鼠标。

![PuTTYgen_1](PuTTYgen_1.jpg)

大约1分钟以后，生成完成，如图2。

![PuTTYgen_2](PuTTYgen_2.jpg)

然后 `Save Private Key` 把密钥文件存下来。  
文本框中的内容是公钥，按照[上面的方法](#设置github上的公钥)设置github上的密钥。

#### 设置本地 git 使用的密钥

由于笔者使用 Tortoise Git，在一个 reporisitory 中 push 的时候选中`自动加载 PuTTY密钥`即可。

命令行 Git 另有实现方法。

### (Linux) Git 保存密码

> 参考博客：https://blog.csdn.net/xx326664162/article/details/49686241  
> https://www.crifan.com/git_remember_record_user_and_password_no_need_input_again/

Git的凭据存储有 cache、store、manager 三种方式。可以通过

```bash
git config --global credential.helper store
```

切换。

其中，如果使用 `store`，密码将被会明文保存在 `~/.git-credentials`。感觉不大好。

如果使用 `cache` 密码会在内存中保存一段时间。密码永远不会被存储在磁盘中，并且默认在15分钟后从内存中清除。不过时间是可以修改的。

于是，就有人想到把这个时间设置为一个月 `2592000` 。

注销以后密码也会被清除，毕竟是存在内存里的。不过每次开机输一次密码也能接受。

```bash
git config --global credential.helper cache
git config credential.helper 'cache --timeout=1000000000'
```

还有一种在 `remote.url` 中加入自己的用户名和密码，更危险，就不表了。

## Git 代理

经常会有挂上代理，浏览器访问 Github 快到飞起的，但是 Git Clone 却慢死的经历。awsl。

以下方法收集自知乎的同一问题：[git clone一个github上的仓库，太慢，经常连接失败，但是github官网流畅访问，为什么？](https://www.zhihu.com/question/27159393/answer/141047266)

### Shadowsocks 对 Github 进行 HTTPS 代理

```bash
git config --global http.https://github.com.proxy socks5://127.0.0.1:1080
git config --global https.https://github.com.proxy socks5://127.0.0.1:1080
```

也要注意 `1080` 是 Shadowsocks 代理的端口，可能需要根据自己的代理配置进行修改。  
另外使用该方法以后，需要用 HTTPS 协议（而不是 SSH）进行传输。

### ssh 代理

Linux 的 ssh 代理可以通过[macOS 给 Git(Github) 设置代理（HTTP/SSH）](https://gist.github.com/chuyik/02d0d37a49edc162546441092efae6a1)的方法。

注意如果是 wsl 2，因为 wsl 2 实际上是一个 Hyper-V 虚拟机，因此 Windows 上的代理如果想要被 Linux 使用，上面填 ip 的地方应该填 Windows 在 wsl 网络下的 ip（命令行输入 `ipconfig`，看到 `以太网适配器 vEthernet (WSL)` 的就是）。另外还需要 代理软件“允许局域网的连接”。

而且目前 wsl 2 由于是由 Hyper-V 实现的，每次重启 windows，windows 和 wsl 的 ip 都会变，目前没有方法改为静态 ip，只能每次改 ip 了。（

如果是 Windows 下的 Git，可以参考：[git clone一个github上的仓库，太慢，经常连接失败，但是github官网流畅访问，为什么？ - 戈登走過去的回答 - 知乎](https://www.zhihu.com/question/27159393/answer/809693236)

### 改 hosts

还有一个方法是修改 Hosts 文件。对于没有代理的开发者，会有一点帮助（都是开发者了为什么还没有代理）。

```
151.101.72.249 github.http://global.ssl.fastly.net
192.30.253.112 github.com
```

## Git 进阶

对于刚入门 Git 的萌新，`clone` `pull` `add` `commit` `push` 已经够用了。然而，如果要发挥 Git 全部的功能，还需要了解更多的东西。

### 回溯版本

#### git status/diff/checkout 查看当前状态

> 学习链接：https://www.liaoxuefeng.com/wiki/896043488029600/896954074659008#0

下面只是对上述博客的一些简短的笔记。

使用 `git status` 可查看目前 Git 的状态（什么文件被修改过之类的……）

使用 `git diff readme.txt` 可查看 `readme.txt` 的还没有被 commit 的修改。

对于只是修改了 `readme.txt` 文件，还没有进行任何 Git 操作的，可以 `git checkout -- readme.txt` 恢复为之前 `add` 过的文件。

更多的情况可看[Git 之 恢复修改的文件](https://www.cnblogs.com/liuq/p/9203087.html)

#### git log/reflog/reset 版本回退

使用 `git log` 可查看当前分支的**所有** commit 日志。
可搭配 `--pretty=oneline` 简略显示。

```
$ git log --pretty=oneline
a4a32854a37319561d16f1618cd9c20e0b3290bf (HEAD -> master, origin/master) append GPL
f4d84ec5d20e8be8f7ef70802b1ba6e654986197 add distributed
d5fd90e99d8a1d91a34d7aef9e615d122d2a2904 new readme.txt
65a146ab6bc8b27dbaaed4d0c200d7d0ee8b6b65 add Hello world
```

前面的一串是 SHA1 值。

回退到上一个版本：`git reset --hard HEAD^`  
回退到上两个版本：`git reset --hard HEAD^^` 或 `HEAD~2`  
回退/前进到指定版本：`git reset --hard a4a3`（到 `append GPL` 版本）

如果回退以后想再前进，却忘了 SHA1 值，可以使用 `git reflog`。

注意至少要写四位，否则会报错：

```
$ git reset --hard 65a
fatal: ambiguous argument '65a': unknown revision or path not in the working tree.
Use '--' to separate paths from revisions, like this:
'git <command> [<revision>...] -- [<file>...]'
```

#### 相关概念浅析：工作区、暂存区

* 工作区 `working tree`：（对于 test 项目）test 文件夹
* 版本库 `Repository`：`test/.git` 文件夹
* 暂存区 `stage/index`：在版本库中
* `master`：第一个分支，也在版本库中
* `HEAD`：指向 `master` 的指针

其逻辑关系如下：

```
test 文件夹
 │
 ├─工作区 working tree
 │
 └─版本库 .git 文件夹
     │
     ├─ 暂存区
     │
     ├─ master 分支
     │
     └─ 其他分支
```

* `git add`：将文件修改添加进暂存区
* `git commit`：将暂存区的东西 commit 到当前分支。（在这之后用 `git status` 会显示 `working tree clean`）

#### git diff/checkout/reset 笔记

diff 只能比较两份文件，如果是操作中是新建文件/删除文件，`git diff` 会提示“没有差异”。

各 diff 的区别：

* `git diff`：显示工作区和暂存区的差异（即未 add 的内容）
* `git diff --cached`：显示暂存区和 `HEAD` 的差异（即未 commit 的内容）
* `git diff HEAD`：显示工作区和 `HEAD` 的差异（即未 add 或 commit 的内容）

在命令后可加文件名，指定比对某文件。

* `git checkout -- <file>` 可以认为是反向 add，是将暂存区的文档修改覆盖工作区的文档；
  - 使用不带参数的 `git checkout --` 可以查看工作区和暂存区的文件差异。
* `git reset HEAD <file>` 可以认为是反向 commit，是用当前分支的文档覆盖暂存区。（并不会修改工作区）



#### 远程库操作

在本地 `git init` 了一个库以后，如果需要上传到远程库，就需要设置远程库的地址（地址可以在 GitHub 网页上获取）：

```
git remote add origin git@github.com:lyh543/test.git
```

Git 规定，要给每一台远程主机命名。这里的 `origin` 就是 Git 给远程库的默认名字。虽然可以用别的名字，但是推荐 `origin`。

然后，进行 push：

```
git push -u origin master
```

push 命令将本地的当前分支上传到 origin 的 master 分支（简写 origin/master）。  
`-u`（或 `--set-upstream`）参数，还顺便将本地的 master 分支和 origin/master 分支进行关联，以后就不用指定。

### 分支管理

其他版本控制系统如SVN等都有分支管理，但是用过之后你会发现，这些版本控制系统创建和切换分支比蜗牛还慢，简直让人无法忍受，结果分支功能成了摆设，大家都不去用。

但Git的分支是与众不同的，无论创建、切换和删除分支，Git在1秒钟之内就能完成！无论你的版本库是1个文件还是1万个文件。

## Git 小技巧

### git rm

以下三种命令等价，都是从工作区删除并提交到暂存区

1. `rm readme.txt` `git add readme.txt`
2. `rm readme.txt` `git rm readme.txt`
3. `git rm readme.txt`

而从工作区删除，但是想恢复，只能在使用 `rm readme.txt` 的前提下 `git checkout -- readme.txt`。

### --amend 修改上次 commit

可以使用 `git commit --amend -m "xxx"` 以修改上次的 commit。

如果已经 push 了，下次就需要 `git push -f` 强制推送。如果还没有 `push`，就相当于之前的 commit 没发生过，直接 `git push` 就行。

### git 修改设置

```bash
git config [--local] --list # 查看设置；--local 用于本地库
git config --local remote.origin.url git@github.com:lyh543/lyh543.github.io.git # 修改设置，项和名用空格间隔
```

### git 修改远端

```bash
git remote -v # 查看所有远端
git remote set-url origin git@github.com:lyh543/lyh543.github.io.git # 修改远端
```

更多的命令，可以随便敲一个不存在的命令，如 `git remote hhh` 来查看所有命令。

## 当你在 branch 外 commit 后

如果你在 branch 外 commit，然后立即切回 branch，你的 commit 就会掉。

有两个解决方案：

1. 将 commit 的内容变为一个新的 branch，然后在原来的 branch 中 merge 新的 branch；
2. 用下面的 cherry-pick 命令在 branch 中把对应的 commit 捡回来。

### cherry-pick 捡 commit

`git cherry-pick` 是一个“捡” commit 的命令。可以把任意（非当前 branch 的） `commit` 拉到本 branch 来。

非当前 branch 的 `commit` 可以通过 `git reflog` 查看。

## git 大文件版本管理：git-lfs

[git-lfs 官网](https://git-lfs.github.com/)
[GitHub 中文帮助页面](https://help.github.com/cn/github/managing-large-files/versioning-large-files)

Git LFS 是 Github 开发的一个 Git 的扩展，他能够处理 Git 仓库里的大文件（如图片、视频等等），其原理是将 Git 仓库中的大文件替换为一个指针，然后将大文件存在另一个服务器上。这样做的好处有：

* 可让您存储最大 2 GB 的文件
* 使得 Git 仓库的容量更大
* 更快的 Cloning 和 Fetching（大概用的服务器更快）
* 操作和工作流等和原来完全一样

以上是官方的，个人感觉可能还会使得每次更新大文件时，他不会再保存在 `.git` 文件夹，占取大量硬盘空间了。

### git-lfs 安装

Windows 上官网就行。Ubuntu 下：

```bash
sudo apt install git-lfs
```

### git-lfs 配置

对于每个仓库下，第一次需要配置一下（如需要用 git-lfs 管理 psd 和 mp4 文件）

```bash
git lfs install
git lfs track "*.psd"
git lfs track "*.mp4"
git add .gitattributes
```

以后就和常规 [git 上传三连](#git-上传三连) 相同了。

```bash
git add file.psd
git commit -m "Add design file"
git push origin master
```