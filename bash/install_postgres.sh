#!/bin/bash

release=$(./ssh.sh DB "lsb_release -cs" | grep -o '[[:alpha:]]*')

echo "deb http://apt.postgresql.org/pub/repos/apt $release-pgdg main"  > tmp_deb
./scp.sh DB tmp_deb /home/user/tmp_deb
./ssh.sh DB "sudo mv ~/tmp_deb /etc/apt/sources.list.d/pgdg.list"
rm tmp_deb

command=$(echo "
    sudo locale-gen ru_RU
    && sudo locale-gen ru_RU.UTF-8
    && sudo update-locale LANG=ru_RU.UTF-8
")
./ssh.sh DB $command
./ssh.sh DB "locale"

command=$(echo "
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - 
    && sudo apt-get update 
    && sudo apt-get install -y libicu-dev
    && sudo dpkg --configure -a
    && sudo apt-get install -y postgresql-12 libpq-dev 
    && sudo service postgresql start 
    && sudo service postgresql status"
)
./ssh.sh DB $command

sql=$(echo "ALTER USER $DB_USER WITH ENCRYPTED PASSWORD '$DB_PASSWORD';")
command=$(echo "sudo -i -u $DB_USER psql -c "'"'$sql'"'"")
./ssh.sh DB $command