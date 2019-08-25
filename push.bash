#!/bin/bash

# push to lyh543/lyh543.github.io.backuo

git add --all
git commit -m "update on $(date +%c)"
git push origin

# push to lyh543/lyh543.github.io

hexo d -g