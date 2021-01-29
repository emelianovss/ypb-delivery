1. `./env.sh stage.env ./install_key.sh WEB`
2. `./env.sh stage.env ./install_nginx.sh`

    Если такая ошибка:
`The following signatures couldn't be verified because the public key is not available: NO_PUBKEY ABF5BD827BD9BF62`

    Выполнить:
`./env.sh stage.env ./add_nginx_key.sh WEB ABF5BD827BD9BF62`
3. `./env.sh stage.env ./install_postgres.sh`
4. `./env.sh stage.env ./install_env.sh`
5. `./env.sh stage.env ./migrate.sh`
6. `./env.sh stage.env ./static.sh`
7. `./env.sh stage.env ./code.sh`
