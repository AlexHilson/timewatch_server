#!/usr/bin/env bash

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y nginx

sudo mkdir /etc/nginx/ssl
sudo openssl req \
    -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout /etc/nginx/ssl/nginx.key \
     -out /etc/nginx/ssl/nginx.crt \
     -subj "${ssl_dn}"

sudo chown root /etc/nginx/ssl/nginx.crt && sudo chmod 600 /etc/nginx/ssl/nginx.crt
sudo chown root /etc/nginx/ssl/nginx.key && chmod 600 /etc/nginx/ssl/nginx.key

cat << "EOF" > /etc/nginx/sites-available/default
${nginx_config}
EOF

sudo service nginx restart

