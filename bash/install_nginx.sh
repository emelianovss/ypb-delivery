#!/bin/bash

# Получаем название релиза
release=$(./ssh.sh WEB "lsb_release -cs" | grep -o '[[:alpha:]]*')

# Добавляем в список источников
echo "deb https://nginx.org/packages/ubuntu/ $release nginx"  > tmp_deb
echo "deb-src https://nginx.org/packages/ubuntu/ $release nginx"  >> tmp_deb
./scp.sh DB tmp_deb /home/$WEB_SERVER_SSH_USER/tmp_deb
./ssh.sh DB "sudo mv ~/tmp_deb /etc/apt/sources.list.d/nginx.list"
rm tmp_deb

# Команда установки и запуска
command=$(echo "
    wget --quiet -O - https://nginx.org/packages/keys/nginx_signing.key | sudo apt-key add -
    && sudo apt-get update 
    && sudo dpkg --configure -a
    && sudo apt-get install -y nginx 
    && sudo service nginx start 
    && sudo service nginx status
")

./ssh.sh WEB $command

