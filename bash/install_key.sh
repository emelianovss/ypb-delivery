#!/bin/bash

SSH_PORT=$1_SERVER_SSH_PORT
SSH_HOST=$1_SERVER_HOST
SSH_KEY=$1_SERVER_KEY
SSH_USER=$1_SERVER_SSH_USER

echo "Try copy ssh key to scope $1 and host ${!SSH_HOST}:${!SSH_PORT}"
# Копируем ключ
ssh-copy-id -p ${!SSH_PORT} -i ${!SSH_KEY}.pub ${!SSH_USER}@${!SSH_HOST}

# Проверяем подключение
./ssh.sh $1 'echo Connection success'
