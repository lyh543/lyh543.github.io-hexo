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

[官方文档](https://git-scm.com/book/zh/v2/) 也是很好的学习的手段。

> 本博客参考链接：https://www.liaoxuefeng.com/wiki/896043488029600

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

## Git 基础

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

* 工作区 `working tree`：（对于 test 项目）test 文件夹（`tree` 翻译成目录比较好）
* 版本库 `Repository`：`test/.git` 文件夹
* 暂存区 `stage/index`：在版本库中（Git 文档中凡是出现 `stage` 和 `index` 都是暂存区的意思）
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
  - 使用不带参数的 `git checkout` 可以查看工作区和暂存区的文件差异。
  - `--` 表示这条命令要无视 `--` 后的所有参数（实战中貌似也是可以去掉的）

* `git reset HEAD <file>` 可以认为是反向 commit，是用当前分支的文档覆盖暂存区。（并不会覆盖工作区）
  - 加上 `--hard` 参数，`git reset --hard HEAD <file>` 就会覆盖工作区了

![Git checkout/reset/diff 对比](git-checkout-reset-diff.jpg)

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
`-u`（或 `--set-upstream`）参数，还顺便将本地的 master 分支和 origin/master 分支进行关联（track），以后就不用指定。

### branch 分支管理

[学习链接](https://www.liaoxuefeng.com/wiki/896043488029600/896954848507552#0)

![分支管理](https://www.liaoxuefeng.com/files/attachments/919021987875136/0)

其他版本控制系统如 SVN 等都有分支管理，但是用过之后你会发现，这些版本控制系统创建和切换分支比蜗牛还慢，简直让人无法忍受，结果分支功能成了摆设，大家都不去用。

但 Git 的分支 `branch` 是与众不同的，无论创建、切换和删除分支，Git 在 1 秒钟之内就能完成！无论你的版本库是 1 个文件还是 1 万个文件。

#### 创建和合并分支

##### 相关概念

复习一下，`master` 是 Git 默认创建的分支，`HEAD` 是指向 `master` 的一个指针。

其实，分支，是一条 commit 线。

也就是说，Git 中的每一个状态，其实指的是每一次 commit，而分支就是将 commit 串起来了（然后 `HEAD` 又指向了当前分支的头）。

![分支](https://www.liaoxuefeng.com/files/attachments/919022325462368/0)

所以创建分支的本质就是添加一条线，更改一下 `HEAD`，很快的。而删除分支，就是删一条线（并不删除 commit），也很快。

##### 代码

新建 `dev` 分支并切换到该分支：

```sh
git branch dev   # 从当前分支新建 dev 分支
git checkout dev # 切换到 dev 分支
```

上述两个过程也可以用一行替代：

```sh
git checkout -b dev
```

实现的效果如图：

![新建 dev 分支并切换到该分支](https://www.liaoxuefeng.com/files/attachments/919022363210080/l)

顺便一提， `git checkout` 的确是有两个功能，一是切换分支，二是将暂存区的某文件修改覆盖工作区的对应文件，不过二需要使用 `git branch --`。

这之后，就可以在 `dev` 分支上修改，然后三连了。

```sh
echo "We are working on a new branch" >> readme.txt
git add readme.txt
git commit -m "commit on dev branch"
```

这之后，我们的仓库状态如下图：

![在 dev 上三连后的仓库](https://www.liaoxuefeng.com/files/attachments/919022533080576/0)

接下来，将 `dev` 上的 commit merge 进 `master`。

由上图可以看到，直接将 `master` 分支线延长至 `dev` 即可，所以 Git 能够轻松完成 merge 操作。

这种 merge 又叫 `fast-forward merge`：

> A fast-forward merge can occur when there is a linear path from the current branch tip to the target branch.  
> Instead of “actually” merging the branches, all Git has to do to integrate the histories is move (i.e., “fast forward”) the current branch tip up to the target branch tip. -- [Git Merge | Atlassian Git Tutorial](https://www.atlassian.com/git/tutorials/using-branches/git-merge)  

> When the merge resolves as a fast-forward, only update the branch pointer, without creating a merge commit. This is the default behavior. -- `git merge --help`

```sh
git checkout master # 从 dev 切回 master 分支
git merge dev       # 将 dev 分支的内容合并到当前分支
```

提一句，merge 本质也是一次 commit，其也可以使用 `-m <msg>` 来设定 commit 信息，而不是在弹出的文本编辑器中。

最后删除 dev 分支：

```sh
git branch -d dev # 删除已经完成合并的 dev 分支
```

#### no-fast-forward merge

fast-forward merge 的好处是相当快，并且 commit 线简洁，但是简洁的坏处就是丢失了一些信息。

在这种模式下，删除分支后，会丢掉分支信息。

`git merge` 默认使用 fast-forward 模式。如果要强制禁用 fast-forward 模式，Git就会在 merge 时生成一个新的 commit，这样，从分支历史上就可以看出分支信息。

使用方法很简单，就是在 `git merge` 时增加一个参数：

```
git merge --no-ff dev
```

#### 解决冲突

上面的分支图都是很简单的(linear)，如果复杂一点，比如两个分支都有自己的提交，`git merge` 就不能进行 `fast-forward merge` 了。

![两个分支都有新的提交](https://www.liaoxuefeng.com/files/attachments/919023000423040/0)

对于简单的情况（两个分支只有文件增添，没有文件修改的冲突），Git 仍然可以实现自动合并，如：

* 在 `feature1` 删除了 a.txt  
* 在 `master` 新增了 b.txt  

将 `feature1` 合并进 `master` 后，`master` 分支会呈现删除 a.txt，新增 b.txt 的状态。

但是，也会有复杂的情况。如两个分支的某文件内容不同：

在 `master` 分支的 `branch.txt` 如下：

```
branch:
master
```

在 `dev` 分支的 `branch.txt` 如下：

```
branch:
dev
```

在 `master` 分支下进行 `git merge dev` 会报失败：

```
$ git merge dev
Auto-merging branch.txt
CONFLICT (content): Merge conflict in branch.txt
Automatic merge failed; fix conflicts and then commit the result.
```

这时查看 `branch.txt`，会是这样：

```
branch:
<<<<<<< HEAD
master
=======
dev
>>>>>>> dev
```

上面标注了两个版本的区别。

现在我们有两个方案：一是放弃合并操作；二是进行合并。

如果想放弃合并操作，只需一句 `git merge --abort`，就可以回到 `git merge dev` 之前的状态（一切都没发生过.jpg）；

如果想进行合并，只需要在当前状态下，修改 `branch.txt` 到想要的样子，然后 add 和 commit：

```sh
git add branch.txt
git commit -m "fix merge confict"
```

就完成了 merge 和解决冲突。如何验证呢？可以用带图的 `git log`

```
git log --graph --pretty=oneline
```

#### 分支管理策略

在实际开发中，我们应该按照几个基本原则进行分支管理：

首先，`master` 分支应该是非常稳定的，也就是仅用来发布新版本，平时不能在上面干活；

那在哪干活呢？干活都在 `dev` 分支上，也就是说，`dev` 分支是不稳定的，到某个时候，比如 1.0 版本发布时，再把 `dev` 分支合并到 `master` 上，在 `master` 分支发布 1.0 版本；

你和你的小伙伴们每个人都在 `dev` 分支上干活，每个人都有自己的分支，时不时地往 `dev`分支上合并就可以了。

所以，团队合作的分支看起来就像这样：

![团队合作的分支](https://www.liaoxuefeng.com/files/attachments/919023260793600/0)

而对于一个小 bug 或者一个 issue-101，也可以通过开一个 `issue-101` 临时分支，写完、merge 以后，再将临时分支删掉。

#### git stash 工作区暂存

在当前分支的修改还有没 commit 的情况下，切换到其他分支后，这些修改会依然存在。

> `git checkout [<branch>]`  
> To prepare for working on \<branch\>, switch to it by updating the index and the files in the working tree, and by pointing HEAD at the branch. **Local modifications to the files in the working tree are kept**, so that they can be committed to the \<branch\>.
> -- [git checkout](https://git-scm.com/docs/git-checkout#Documentation/git-checkout.txt-emgitcheckoutemltbranchgt)

如果我们既不想 commit（当前工作还没做完），也不想将当前分支的修改带到别的分支里，应该怎么做呢？

```sh
git stash
```

使用这句命令，我们就可以把工作区的修改暂存起来，然后让工作区呈现修改前的状态。这之后，使用 `git status` 会显示 `working tree clean`。

然后我们就可以用 `git checkout` 切换分支，在别的分支进行工作了。

在别的分支工作完，并切回该分区以后，如何找回来呢？

```sh
git stash list  # 列出当前的 stash

git stash apply # 将最近的 stash 找回
git stash drop  # 将最近的 stash 删除

git stash pop   # 将最近的 stash 找回并删除
git stash pop stash@{0} # 还可以指定 stash
```

### remote 远端管理

这一节的内容其实和分支管理有一些交集，毕竟远端管理其本质也是在管理远端的分支。

#### git remote 查看远程库的信息

查看远程库的信息：

```sh
$ git remote
origin

$ git remote -v # 详细信息
origin  git@github.com:lyh543/test.git (fetch)
origin  git@github.com:lyh543/test.git (push)
```

上面显示了可以抓取 fetch 和推送 push 的 origin 的地址。如果没有推送权限，就看不到 push 的地址。

#### git push 推送分支

推送分支，就是把该分支上的所有本地提交推送到远程库。

推送时，要指定本地分支，这样，Git 就会把该分支推送到远程库对应的远程分支上：

```sh
git push origin master
```

如果要推送其他分支，比如 `dev`，就改成：

```sh
git push origin dev
```

但是，并不是一定要把本地分支往远程推送，那么，哪些分支需要推送，哪些不需要呢？

* `master` 分支是主分支，因此要时刻与远程同步；
* `dev` 分支是开发分支，团队所有成员都需要在上面工作，所以也需要与远程同步；
* `bug` 分支只用于在本地修复 bug，就没必要推到远程了，除非老板要看看你每周到底修复了几个 bug；
* `feature` 分支是否推到远程，取决于你是否和你的小伙伴合作在上面开发。

总之，就是在 Git 中，分支完全可以在本地自己藏着玩，是否推送，视你的心情而定！

#### git fetch 从远端拉取

`git clone` 只会获取远程的 `master` 分支，如果要获取 `dev` 分支，我们应该从 `origin/dev` 新建 `dev` 分支：

```sh
git checkout dev

# 等价于 git checkout -b dev origin/dev，见下
```

> `git checkout [<branch>]`
> If `<branch>` is not found but there does exist a tracking branch in exactly one remote (call it `<remote>`) with a matching name and --no-guess is not specified, treat as equivalent to
> `$ git checkout -b <branch> --track <remote>/<branch>`
> -- [git-checkout Documentation - Git](https://git-scm.com/docs/git-checkout#Documentation/git-checkout.txt-emgitcheckoutemltbranchgt)

这也太贴心了吧~ 那就不用记麻烦的了。

然后就可以愉快的在 `dev` 分支上进行修改了。


如果远端的内容更新了（比如你的小伙伴向远端 commit 了），但本地还没有更新，可以使用

```sh
git fetch
git merge

# 或

git pull # 两句的等价形式
```

来进行拉取（fetch）。

如果 merge 或 pull 中有冲突，需要按照 [解决冲突](#解决冲突) 的套路来合并冲突。

#### git rebase 变基

`git rebase` 通过修改 commit 的顺序使得某些情况下的分支图更简洁。

比如以下场景：

小伙伴 A 和 B 在合作开发同一个项目。

* 小伙伴 A 添加了 `a.txt`，并进行了 commit  和 push；
* 小伙伴 B 在没有 fetch 的情况下添加了 `b.txt`，并进行了 commit 和 push。当然，这里 push 会失败，提示需要 fetch。
* 小伙伴 B fetch 并 merge，完成了 merge 的过程，可以进行 pull 了。但是……

此时的 `git log --graph --pretty=oneline` 出现了分叉！

```
$ git log --graph --pretty=oneline
*   d2232e76aad5009a86a66399b0d4a1e3feb9e6ef (HEAD -> master) Merge branch 'master' of github.com:lyh543/test
|\
| * 98946ab30bbaf2fbc60531450731a8e840bdf62a (origin/master, origin/HEAD) add a.txt
* | 2eb60148822f268aa3510304fa409c1bdd2ec9b4 add b.txt
|/
*   591c9b045b7b84e75710fa96b1f77cb92ee82a85 remove dev.txt
```

这也没什么问题。  
但是，从理论上，这个分叉完全可以避免：只要 B 能在 commit 前进行 fetch 就可以少一次 merge 了。

于是，这时 B 拍出了 `git rebase`：

```
$ git rebase
First, rewinding head to replay your work on top of it...
Applying: add b.txt
```

（这里的 rebase 过程比较简单，如果 A B 对同一文件进行了修改，rebase 过程会稍微复杂，但同样能达到效果）

之后，工作区和暂存区都没有什么变化，但是 `git log --graph --pretty=oneline` 发生变化了：

```
$ git log --graph --pretty=oneline
* 3b3769ddfea3f6ddc0a36e3d5784bd676386030e (HEAD -> master) add b.txt
* 98946ab30bbaf2fbc60531450731a8e840bdf62a (origin/master, origin/HEAD) add a.txt
* 591c9b045b7b84e75710fa96b1f77cb92ee82a85 remove dev.txt
```

分支线的分叉消失了！

也就是说，`git rebase` 能通过修改 commit 顺序，使得分支线简单，但是会减少一个 merge 的 commit。

接下来就可以 push 了。

### tag 标签管理

[学习链接](https://git-scm.com/book/zh/v2/Git-基础-打标签)

> Git 可以给历史中的某一个提交打上标签，以示重要。
> 比较有代表性的是人们会使用这个功能来标记发布结点（v1.0 等等）。

标签也是一个指针，指向 commit 的。

标签有 轻量标签 `lightweight` 和 附注标签 `annotated`。

> 一个轻量标签很像一个不会改变的分支——它只是一个特定提交的引用。
> 然而，附注标签是存储在 Git 数据库中的一个完整对象。 它们是可以被校验的；其中包含打标签者的名字、电子邮件地址、日期时间；还有一个标签信息；并且可以使用 GNU Privacy Guard （GPG）签名与验证。 通常建议创建附注标签，这样你可以拥有以上所有信息；但是如果你只是想用一个临时的标签，或者因为某些原因不想要保存那些信息，轻量标签也是可用的。

添加轻量标签：

```sh
git tag v1.0      # 为 HEAD 添加 v1.0 的标签
git tag v1.0 366e # 为 commit 366e 添加 v1.0 的标签
```

添加附注标签，加一个 `-a` 开关就可以。

```
git tag -a v1.4 -m "my version 1.4"
```

列出已有标签：`git tag`

查看标签对应的 commit：`git show v1.0`

注意，标签默认不会被 push 至远程服务器（clone 和 fetch 时是会获得的）。

需要显式地 push 标签：`git push origin v1.0`  
或 push 时带上 `--tags`：`git push origin --tags`

删除标签可以使用 `git tag -d v1.0`。

但是，将删除标签推送至远端就有点复杂了： `git push origin :refs/tags/v1.0`。

查看标签所指的文件版本： `git checkout v1.0`

注意这之后会进入 `detached HEAD` 的状态，不再有 `HEAD` 的概念。  
在这个状态下会进行 commit 有一定副作用（具体见手册），推荐新开一个 branch 来进行操作。

## 看完了？

如果看完了，推荐去看看 [git-scm.com](git-scm.com) 的教程和手册，这里有官方对命令的解释，你对命令和概念的理解会更加精确。如 [git checkout](https://git-scm.com/docs/git-checkout)

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

### 当你在 branch 外 commit 后

如果你在 branch 外 commit，然后立即切回 branch，你的 commit 就会掉。

有两个解决方案：

1. 将 commit 的内容变为一个新的 branch，然后在原来的 branch 中 merge 新的 branch；
2. 用下面的 cherry-pick 命令在 branch 中把对应的 commit 捡回来。

#### cherry-pick 捡 commit

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