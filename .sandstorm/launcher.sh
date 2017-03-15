#!/bin/bash
set -euo pipefail

if [ ! -e /var/git ]; then
  cd /var
  cp -R /opt/app/template git
  cd git
  git init
  git add *
  echo public >.gitignore
  git add .gitignore
  git config user.name sandstorm
  git config user.email sandstorm@localhost
  git commit -m "Initial commit."
  git config receive.denyCurrentBranch ignore
fi

if [ ! -e /var/www ]; then
  /opt/app/post-receive
fi

cd /opt/app
cp post-receive /var/git/.git/hooks
caddy &
NODE_ENV=production HOME=/tmp npm start
