#!/bin/bash
# set -x

# About Tenda U12 drive, please look up in https://github.com/likwidoxigen/mt7610u_wifi.git

# update apt-get source

sudo sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sudo apt-get update

# install and configure git

sudo apt-get install git
git config user.name "lyh543"
git config user.email "lyh543@github.com"
git config --global http.https://github.com.proxy socks5://127.0.0.1:2080
git config --global https.https://github.com.proxy socks5://127.0.0.1:2080

git remote set-url origin git@github.com:lyh543/lyh543.github.io.backup.git

# install hexo

sudo apt-get install npm
npm install hexo
npm install hexo-cli -g