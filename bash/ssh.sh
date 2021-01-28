#!/bin/bash

SSH_PORT=${@:1:1}_SERVER_SSH_PORT
SSH_HOST=${@:1:1}_SERVER_HOST
SSH_KEY=${@:1:1}_SERVER_KEY

ssh -t -i ${!SSH_KEY} -p ${!SSH_PORT} user@${!SSH_HOST} ${@:2}
