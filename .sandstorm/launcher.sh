#!/bin/bash
set -euo pipefail

if [ ! -e /var/git ]; then
  cd /var
  hugo new site git
  cd git
  git init
  git add *
  echo public >.gitignore
  git add .gitignore
  git commit -m "Initial commit."
  git config receive.denyCurrentBranch ignore
fi

if [ ! -e /var/www ]; then
  /opt/app/post-receive
fi

cd /opt/app
cp post-receive /var/git/.git/hooks
NODE_ENV=production HOME=/tmp npm start
