#!/bin/bash

source /var/www/bookstack/.env

cat <<EOF > /home/samuel/bookstack-reports/envs.py
db_host = "$DB_HOST"
db_database = "$DB_DATABASE"
db_username = "$DB_USERNAME"
db_password = "$DB_PASSWORD"
EOF
