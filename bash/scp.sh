#!/bin/bash

SSH_PORT=${@:1:1}_SERVER_SSH_PORT
SSH_HOST=${@:1:1}_SERVER_HOST
SSH_KEY=${@:1:1}_SERVER_KEY

scp -i ${!SSH_KEY} -P ${!SSH_PORT} ${@:4} $2 user@${!SSH_HOST}:$3
