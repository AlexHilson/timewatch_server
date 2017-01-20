#!/usr/bin/env bash

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y git

cd ~
wget https://nodejs.org/dist/v6.9.4/node-v6.9.4-linux-x64.tar.xz
mkdir node
tar xvf node-v*.tar.?z --strip-components=1 -C ./node
rm -rf node-v*

mkdir node/etc
echo 'prefix=/usr/local' > node/etc/npmrc
sudo mv node /opt/
sudo chown -R root: /opt/node
sudo ln -s /opt/node/bin/node /usr/local/bin/node
sudo ln -s /opt/node/bin/npm /usr/local/bin/npm

sudo npm install -g pm2
