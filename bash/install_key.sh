#!/bin/bash

SSH_PORT=$1_SERVER_SSH_PORT
SSH_HOST=$1_SERVER_HOST

echo "Try copy ssh key to scope $1 and host ${!SSH_HOST}"
ssh user@${!SSH_HOST} -p ${!SSH_PORT}

