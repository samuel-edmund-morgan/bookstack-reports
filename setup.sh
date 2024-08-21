#!/bin/bash

INSTALLATION_PATH='/etc/bookstack-reports/'
LOG_PATH='/var/log/bookstack-reports/'
SERVICE_PATH='/etc/systemd/system/'
SOURCE_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
SOURCE_PATH="$(cd -- "$MY_PATH" && pwd)"

apt update && apt -y upgrade
apt install python3-venv python3-pip python3.8-venv
pip install -r "$SOURCE_PATH/requirements.txt"

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
     || [ -z "$MAIL_PASSWORD" ]\
     || [ "$MAIL_FROM" == "null" ]\
     || [ "$MAIL_HOST" == "null" ]\
     || [ "$MAIL_PORT" == "null" ]\
     || [ "$MAIL_USERNAME" == "null" ]\
     || [ "$MAIL_PASSWORD" == "null" ]
    then
      echo "Some variables are null or not specified"
      exit 1
    fi

    #TMP till i create deb package then delete this
    mkdir "$LOG_PATH"
    mkdir "$INSTALLATION_PATH"
    cp "$SOURCE_PATH/report_data.sql" "$INSTALLATION_PATH"
    cp "$SOURCE_PATH/requirements.txt" "$INSTALLATION_PATH"
    cp "$SOURCE_PATH/bookstack-report.py" "$INSTALLATION_PATH"

    #till this
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
recipients = ["$1"]
report_path = f"/var/log/bookstack-reports/"
sql_queries_file = "/etc/bookstack-reports/report_data.sql"
EOF

cat <<EOF > "$SERVICE_PATH"bookstack-reports.service
[Unit]
Description=Creates report
Wants=bookstack-reports.timer

[Service]
Type=oneshot
ExecStart=/usr/bin/python3 /etc/bookstack-reports/bookstack-report.py

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF > "$SERVICE_PATH"bookstack-reports.timer
[Unit]
Description=Timer for bookstack reports
Requires=bookstack-reports.service

[Timer]
Unit=bookstack-reports.service
OnCalendar=*-*-* 08:00:00
AccuracySec=1us

[Install]
WantedBy=timers.target
EOF

systemctl start bookstack-reports.service
systemctl start bookstack-reports.timer
systemctl enable bookstack-reports.service
systemctl enable bookstack-reports.timer


#echo "Bookstack was found in "$DIR_INST""
#echo "Database and email settings have successfully been exported to "$INSTALLATION_PATH"envs.py"
exit 0
else
   echo "Bookstack is not found..."
   exit 1
fi
