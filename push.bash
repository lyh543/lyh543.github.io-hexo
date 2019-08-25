#!/bin/bash

echo pushing to lyh543/lyh543.github.io
echo

hexo d -g

echo
echo pushing to lyh543/lyh543.github.io.backup
echo

git add --all
git commit -m "update on $(date +%c)"
git push origin