#!/bin/bash

SSH_PORT=$1_SERVER_SSH_PORT
SSH_HOST=$1_SERVER_HOST
SSH_KEY=$1_SERVER_KEY

echo "Try copy ssh key to scope $1 and host ${!SSH_HOST}:${!SSH_PORT}"
ssh-copy-id -p ${!SSH_PORT} -i ${!SSH_KEY}.pub user@${!SSH_HOST}

ssh -i ${!SSH_KEY} -p ${!SSH_PORT} user@${!SSH_HOST} 'echo Connection success'
