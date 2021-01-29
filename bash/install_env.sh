#!/bin/bash

command_pip=("
    sudo apt-get update
    && sudo apt-get install -y 
        python3-pip 
        python3-venv
")

command_venv=("
    python3 -m venv $WEB_VENV_NAME
    && source $WEB_VENV_NAME/bin/activate 
    && pip3 install wheel
    && pip3 install
        django 
        gunicorn 
        psycopg2
")

./ssh.sh WEB $command_pip
./ssh.sh WEB $command_venv

echo """[Unit]
Description=gunicorn daemon
Requires=gunicorn.socket
After=network.target

[Service]
Environment=DJANGO_SETTINGS_MODULE=project.current_settings
Type=notify
User=$WEB_SERVER_SSH_USER
Group=$WEB_SERVER_SSH_USER
RuntimeDirectory=gunicorn
WorkingDirectory=/home/$WEB_SERVER_SSH_USER/$WEB_APP_FOLDER
ExecStart=/home/$WEB_SERVER_SSH_USER/$WEB_VENV_NAME/bin/gunicorn project.wsgi
ExecReload=/bin/kill -s HUP \$MAINPID
KillMode=mixed
TimeoutStopSec=5
PrivateTmp=true

[Install]
WantedBy=multi-user.target
""" > tmp_gunicorn_service
./scp.sh  WEB tmp_gunicorn_service /home/$WEB_SERVER_SSH_USER/tmp_gunicorn_service
./ssh.sh WEB "sudo mv ~/tmp_gunicorn_service /etc/systemd/system/gunicorn.service"
rm tmp_gunicorn_service

echo """[Unit]
Description=gunicorn socket

[Socket]
ListenStream=/run/gunicorn.sock
SocketUser=nginx
SocketMode=600

[Install]
WantedBy=sockets.target
""" > tmp_gunicorn_socket_service
./scp.sh  WEB tmp_gunicorn_socket_service /home/$WEB_SERVER_SSH_USER/tmp_gunicorn_socket_service
./ssh.sh WEB "sudo mv ~/tmp_gunicorn_socket_service /etc/systemd/system/gunicorn.socket && sudo systemctl enable --now gunicorn.socket"
rm tmp_gunicorn_socket_service

./scp.sh WEB ./src /home/$WEB_SERVER_SSH_USER/$WEB_APP_FOLDER -r
echo """from project.settings import *

STATIC_ROOT = '$WEB_STATIC_FOLDER/static'
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': '$DB_NAME',
        'USER': '$DB_USER',
        'PASSWORD': '$DB_PASSWORD',
        'HOST': '$DB_HOST',
        'PORT': 5432,
    }
}
""" > tmp_settings
./scp.sh  WEB tmp_settings /home/$WEB_SERVER_SSH_USER/$WEB_APP_FOLDER/project/current_settings.py
rm tmp_settings

./ssh.sh WEB "sudo mkdir -p $WEB_STATIC_FOLDER/static && sudo chown -R $WEB_SERVER_SSH_USER:nginx $WEB_STATIC_FOLDER"
./ssh.sh WEB "source $WEB_VENV_NAME/bin/activate && cd $WEB_APP_FOLDER && DJANGO_SETTINGS_MODULE=project.current_settings python manage.py collectstatic --no-input"
./ssh.sh WEB "sudo -u nginx curl -I --unix-socket /run/gunicorn.sock localhost"

echo """
server {
    listen          80;
    server_name     127.0.0.1;

    location / {
        proxy_pass http://unix:/run/gunicorn.sock;
    }

    location /static {
        root $WEB_STATIC_FOLDER/;
    }

}
""" > tmp_nginx
./scp.sh WEB tmp_nginx /home/$WEB_SERVER_SSH_USER/tmp_nginx
./ssh.sh WEB "sudo mv ~/tmp_nginx /etc/nginx/conf.d/default.conf && sudo service nginx start && sudo service nginx restart"
rm tmp_nginx