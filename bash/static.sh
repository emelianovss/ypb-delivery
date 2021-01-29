#!/bin/bash

./ssh.sh WEB "source $WEB_VENV_NAME/bin/activate && cd $WEB_APP_FOLDER && DJANGO_SETTINGS_MODULE=project.current_settings python manage.py collectstatic --no-input"

