#!/bin/bash

SSH_PORT=$1_SERVER_SSH_PORT
SSH_HOST=$1_SERVER_HOST
SSH_KEY=$1_SERVER_KEY
release=$(ssh \
    -i ${!SSH_KEY} \
    -p ${!SSH_PORT} \
    user@${!SSH_HOST} \
    "lsb_release -cs"
)

command=$(echo "
    echo 'deb http://apt.postgresql.org/pub/repos/apt $release-pgdg main' 
    | sudo tee /etc/apt/sources.list.d/pgdg.list
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - 
    && sudo apt-get update 
    && sudo apt-get install -y libicu-dev
    && sudo dpkg --configure -a
    && sudo apt-get install -y postgresql-12 libpq-dev 
    && sudo service postgresql start 
    && sudo service postgresql status"
)

ssh -t -i ${!SSH_KEY} -p ${!SSH_PORT} user@${!SSH_HOST} $command

