1. `./env.sh stage.env ./install_key.sh WEB`
2. `./env.sh stage.env ./install_nginx.sh WEB`

    Если такая ошибка:
`The following signatures couldn't be verified because the public key is not available: NO_PUBKEY ABF5BD827BD9BF62`

    Выполнить:
`./env.sh stage.env ./add_nginx_key.sh WEB ABF5BD827BD9BF62`
3. `./env.sh stage.env ./install_postgres.sh WEB`