#!/bin/bash

release=$(./ssh.sh WEB "lsb_release -cs" | grep -o '[[:alpha:]]*')

echo "deb https://nginx.org/packages/ubuntu/ $release nginx"  > tmp_deb
echo "deb-src https://nginx.org/packages/ubuntu/ $release nginx"  >> tmp_deb
./scp.sh DB tmp_deb /home/user/tmp_deb
./ssh.sh DB "sudo mv ~/tmp_deb /etc/apt/sources.list.d/nginx.list"
rm tmp_deb

command=$(echo "
    wget --quiet -O - https://nginx.org/packages/keys/nginx_signing.key | sudo apt-key add -
    && sudo apt-get update 
    && sudo dpkg --configure -a
    && sudo apt-get install -y nginx 
    && sudo service nginx start 
    && sudo service nginx status
")

./ssh.sh WEB $command

