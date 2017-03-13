#!/bin/bash

# When you change this file, you must take manual action. Read this doc:
# - https://docs.sandstorm.io/en/latest/vagrant-spk/customizing/#setupsh

set -euo pipefail

apt-get update
apt-get install -y git

### Download & compile capnproto and the Sandstorm getPublicId helper.

# First, get capnproto from master and install it to
# /usr/local/bin. This requires a C++ compiler. We opt for clang
# because that's what Sandstorm is typically compiled with.
if [ ! -e /usr/local/bin/capnp ] ; then
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q clang autoconf pkg-config libtool
    cd /tmp
    if [ ! -e capnproto ]; then git clone https://github.com/sandstorm-io/capnproto; fi
    cd capnproto
    git checkout master
    cd c++
    autoreconf -i
    ./configure
    make -j2
    sudo make install
fi

### Download & compile capnproto and the Sandstorm getPublicId helper.

# First, get capnproto from master and install it to
# /usr/local/bin. This requires a C++ compiler. We opt for clang
# because that's what Sandstorm is typically compiled with.
if [ ! -e /usr/local/bin/capnp ] ; then
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q clang autoconf pkg-config libtool
    cd /tmp
    if [ ! -e capnproto ]; then git clone https://github.com/sandstorm-io/capnproto; fi
    cd capnproto
    git checkout master
    cd c++
    autoreconf -i
    ./configure
    make -j2
    sudo make install
fi

# Second, compile the small C++ program within
# /opt/app/sandstorm-integration.
if [ ! -e /opt/app/sandstorm-integration/getPublicId ] ; then
    pushd /opt/app/sandstorm-integration
    make
fi

cp /opt/app/sandstorm-integration/bin/getPublicId /usr/local/bin

curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
apt-get install -y nodejs
npm install -g yarn

apt-get install -y python-pip asciidoctor
pip install pygments

cd /tmp
wget https://github.com/spf13/hugo/releases/download/v0.19/hugo_0.19-64bit.deb -O hugo.deb
dpkg -i hugo.deb
rm hugo.deb
wget "https://caddyserver.com/download/build?os=linux&arch=amd64&features=filemanager%2Chugo" -O /tmp/caddy.tar.gz
cd /tmp
tar xfz caddy.tar.gz
mv caddy /usr/local/bin
rm caddy.tar.gz
