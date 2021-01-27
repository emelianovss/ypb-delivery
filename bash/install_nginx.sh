#!/bin/bash

SSH_PORT=$1_SERVER_SSH_PORT
SSH_HOST=$1_SERVER_HOST
SSH_KEY=$1_SERVER_KEY
release=$(ssh -i ${!SSH_KEY} -p ${!SSH_PORT} user@${!SSH_HOST} \
          "cat /etc/os-release | grep UBUNTU_CODENAME | grep -o =\.* | grep -o '[[:alpha:]]*'")

nginx_deb="deb https://nginx.org/packages/ubuntu/ $release nginx\ndeb-src https://nginx.org/packages/ubuntu/ $release nginx"

deb_command=$(echo "echo -e '$nginx_deb' | sudo tee /etc/apt/sources.list.d/nginx.list && sudo apt-get update && sudo apt-get install -y nginx && sudo service nginx start && sudo service nginx status")


ssh -t -i ${!SSH_KEY} -p ${!SSH_PORT} user@${!SSH_HOST} $deb_command

