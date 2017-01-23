#!/usr/bin/env bash

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y xvfb

cd ~
wget https://github.com/AlexHilson/timewatch_server/archive/v0.0.1.tar.gz -O timewatch_server.tar.gz
tar zxf timewatch_server.tar.gz

cd timewatch_server-0.0.1/app
npm install

cat << "EOF" > ./process.json
{
  "apps" : [{
    "name"        : "timewatch_server",
    "script"      : "bin/www"
  },
    {
      "name"        : "Xvfb",
      "interpreter" : "none",
      "script"      : "Xvfb",
      "args"        : "-a"
    }]
}
EOF

pm2 start process.json