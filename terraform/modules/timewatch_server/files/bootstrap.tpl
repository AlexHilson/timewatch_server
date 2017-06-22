#!/usr/bin/env bash

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y xvfb \
                        x11-xkb-utils \
                        xfonts-100dpi \
                        xfonts-75dpi \
                        xfonts-scalable \
                        xfonts-cyrillic \
                        x11-apps \
                        clang \
                        libdbus-1-dev \
                        libgtk2.0-dev \
                        libnotify-dev \
                        libgnome-keyring-dev \
                        libgconf2-dev \
                        libasound2-dev \
                        libcap-dev \
                        libcups2-dev \
                        libxtst-dev \
                        libxss1 \
                        libnss3-dev \
                        gcc-multilib \
                        g++-multilib

sudo npm install -g electron

cd ~
wget https://github.com/AlexHilson/timewatch_server/archive/v0.0.3.tar.gz -O timewatch_server.tar.gz
tar zxf timewatch_server.tar.gz

cd timewatch_server-0.0.1/app
npm install

cat << "EOF" > ./process.json
{
  "apps" : [{
    "name"        : "timewatch_server",
    "script"      : "bin/www",
    "watch"       : "true",
    "env" : {
      "DEBUG"     : "nightmare:*,electron:*"
    }
  },
  {
    "name"        : "Xvfb",
    "interpreter" : "none",
    "script"      : "Xvfb",
    "args"        : ":99",
    "watch"       : "true",
    "env" : {
      "DEBUG"     : "nightmare:*,electron:*"
    }
  }]
}
EOF

sudo apt install -y awscli

aws s3 cp s3://timewatch/db.sqlite ./db.sqlite
aws s3 cp s3://timewatch/crontab.txt ./crontab.txt
crontab crontab.txt

pm2 start process.json
