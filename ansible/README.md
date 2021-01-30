1. `ansible-playbook -i environments/stage/hosts install_key.yml --ask-pass`
2. `ansible-playbook -i environments/stage/hosts install_nginx.yml --ask-become-pass`
3. `ansible-playbook -i environments/stage/hosts install_postgres.yml --ask-become-pass`
4. `ansible-playbook -i environments/stage/hosts install_env.yml --ask-become-pass`
5. `ansible-playbook -i environments/stage/hosts update.yml --tags=migrate`
6. `ansible-playbook -i environments/stage/hosts update.yml --tags=static`
7. `ansible-playbook -i environments/stage/hosts update.yml --tags=code`
8. `ansible-playbook -i environments/stage/hosts update.yml --ask-become-pass`
