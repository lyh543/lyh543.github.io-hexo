---
title: Git笔记
date: 2019-09-01 22:02:19
tags: 
- Git
- ssh
category: 
- Linux
top: false
---

常用命令可查表：[Git-CheatSheet](git-cheatsheet.pdf)

## git 新建库

```bash
mkdir lyh543.github.io
cd lyh543.github.io
git init
```

然后就可以按照下面的[常规三连](#git-常规三连)了

## git 常规三连

```bash
# 如果本地、服务器端不一致，需要 git pull
$ git add --all # 单文件是 git add <file>
$ git commit -m "upload 2 files."
$ git push
```

## git 保存密码

git 默认是不能保存密码的，每次 push 都需要输入账号密码，很烦。  

一个选择是 ssh，这个方便，但是问题就是，使用 ssh 以后，就不能直接挂梯子了（梯子走 https 的）。
第二个方案是走 https，不过让 Git 保存密码。这又分了两种方法。

多 ssh 部署可以看链接：https://www.awaimai.com/2200.html

### 在 Linux 下 git 使用 ssh 密钥

大概分为三步走：

1. 本地生成密钥对；
2. 设置 github 上的公钥；
3. 修改 git 的 remote url 为 git 协议。

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

#### 修改 git 的 remote url 从 `https` 改为 `ssh`

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

## 命令行 Git 上代理

经常会有挂上代理，浏览器访问 Github 快到飞起的，但是 Git Clone 却慢死的经历。awsl。

以下方法收集自知乎的同一问题：[git clone一个github上的仓库，太慢，经常连接失败，但是github官网流畅访问，为什么？](
https://www.zhihu.com/question/27159393/answer/141047266)

### Shadowsocks 全局 HTTPS 代理（不推荐）

```bash
git config --global http.proxy socks5://127.0.0.1:1080
git config --global https.proxy socks5://127.0.0.1:1080
```

其中 `1080` 是 Shadowsocks 代理的端口，可能需要根据自己的 Shadowsocks 配置进行修改。  
另外使用该方法以后，需要用 HTTPS 协议（而不是 SSH）进行传输。

该方法的缺点是会导致连向国内仓库时极慢。毕竟全局走服务器了嘛。

### Shadowsocks 对 Github 进行 HTTPS 代理

```bash
git config --global http.https://github.com.proxy socks5://127.0.0.1:1080
git config --global https.https://github.com.proxy socks5://127.0.0.1:1080
```

也要注意 `1080` 是 Shadowsocks 代理的端口，可能需要根据自己的 Shadowsocks 配置进行修改。  
另外使用该方法以后，需要用 HTTPS 协议（而不是 SSH）进行传输。

### ssh 代理

放个链接。[git clone一个github上的仓库，太慢，经常连接失败，但是github官网流畅访问，为什么？ - 戈登走過去的回答 - 知乎](https://www.zhihu.com/question/27159393/answer/809693236)

### 改 hosts

```
151.101.72.249 github.http://global.ssl.fastly.net
192.30.253.112 github.com
```

## 时光机穿梭

> 参考链接：https://www.liaoxuefeng.com/wiki/896043488029600/896954074659008#0

```bash
git log
git reset --hard HEAD^
git reset --hard HEAD^^
git reset --hard HEAD~100
git reset --hard 236c
git reflog
```

### 修改上次 commit

可以使用 `git commit --amend -m "xxx"` 以修改上次的 commit。

如果已经 push 了，下次就需要 `git push -f` 强制推送。如果还没有 `push`，就当一切都没发生过，直接 `git push` 就行。

## git 修改设置

```bash
git config [--local] --list # 查看设置；--local 用于本地库
git config --local remote.origin.url git@github.com:lyh543/lyh543.github.io.git # 修改设置，项和名用空格间隔
```
