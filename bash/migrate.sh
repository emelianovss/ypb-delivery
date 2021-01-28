#!/bin/bash

./ssh.sh WEB "source venv/bin/activate && cd application && DJANGO_SETTINGS_MODULE=project.current_settings python manage.py migrate"
