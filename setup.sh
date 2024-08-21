#!/bin/bash

INSTALLATION_PATH='/etc/bookstack-reports/'


#TMP till i create deb package then delete this
mkdir /var/log/bookstack-reports/
mkdir /etc/bookstack-reports/
#s

#till this


echo "Looking for Bookstack setup..."
FULL_PATH=$(find  / -type d \( \
 -path /dev -o\
 -path /proc -o\
 -path /sys -o\
 -path /tmp -o\
 -path /var/tmp -o\
 -path /var/log -o\
 -path /snap -o\
 -path /var/spool -o\
 -path /var/lib -o\
 -path /boot -o\
 -path /var/cache -o\
 -path /var/snap -o\
 -path /lost+found -o\
 -path /run \) -prune -o -name 'bookstack-system-cli' -print 2>/dev/null )

if [ -n "$FULL_PATH" ]
then
    DIR_INST=$(dirname "$FULL_PATH")
    source "$DIR_INST"/.env
    if [ -z "$DB_HOST" ]\
     || [ -z "$DB_DATABASE" ]\
     || [ -z "$DB_USERNAME" ]\
     || [ -z "$DB_PASSWORD" ]\
     || [ -z "$APP_URL" ]\
     || [ -z "$MAIL_FROM" ]\
     || [ -z "$MAIL_HOST" ]\
     || [ -z "$MAIL_PORT" ]\
     || [ -z "$MAIL_USERNAME" ]\
     || [ -z "$MAIL_PASSWORD" ]
    then
      echo "Some variables are not specified"
      exit 1
    fi
    mkdir "$INSTALLATION_PATH"
cat <<EOF > "$INSTALLATION_PATH"envs.py
db_host = "$DB_HOST"
db_database = "$DB_DATABASE"
db_username = "$DB_USERNAME"
db_password = "$DB_PASSWORD"
app_url = "$APP_URL"
mail_from = "$MAIL_FROM"
mail_host = "$MAIL_HOST"
mail_port = "$MAIL_PORT"
mail_username = "$MAIL_USERNAME"
mail_password = "$MAIL_PASSWORD"
subject = f"Звіт з відвідувань платформи Bookstack {app_url}"
body = "Сформований звіт відображає статистику відвідувань сторінок, книг та полиць платформи за 24 години"
recipients = ["samuel.edmund.morgan@gmail.com"]
report_path = f"/var/log/bookstack-reports/"
sql_queries_file = "/etc/bookstack-reports/report_data.sql"
EOF
echo "Bookstack was found in "$DIR_INST""
echo "Database and email settings have successfully been exported to "$INSTALLATION_PATH"envs.py"
exit 0
else
   echo "Bookstack is not installed..."
   exit 1
fi
