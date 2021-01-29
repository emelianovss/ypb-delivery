#!/bin/bash

./ssh.sh WEB "rm -Rf /home/$WEB_SERVER_SSH_USER/$WEB_APP_FOLDER"
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
./ssh.sh WEB "sudo service gunicorn restart"
