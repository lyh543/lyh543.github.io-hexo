#!/bin/bash

if [ -z $1 ]; then
    echo
    echo pushing to lyh543/lyh543.github.io
    echo

    hexo d -g
fi

echo
echo pushing to lyh543/lyh543.github.io.backup
echo

git add --all
git commit -m "update on $(date +%c)"
git push origin