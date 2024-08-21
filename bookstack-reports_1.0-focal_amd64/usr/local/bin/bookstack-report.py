import mysql.connector
import pandas as pd
import datetime
import smtplib
from email.mime.text import MIMEText
from email import encoders
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
import sys
sys.path.append('/etc/bookstack-reports/')
from envs import *

current_date = datetime.date.today().strftime("%d.%m.%Y")
report_full_path = report_path + f"analytics_data_{current_date}.xlsx"

def parse_sql(sql_file_path):
    with open(sql_file_path, "r", encoding="utf-8") as f:
        data = f.read().splitlines()
    stmt = ""
    stmts = []
    for line in data:
        if line:
            if line.startswith("--"):
                continue
            stmt += line.strip() + " "
            if ";" in stmt:
                stmts.append(stmt.strip())
                stmt = ""
    return stmts

def send_email(subject_at, body_at, mail_from_at, recipients_at, sender_at, password_at):
    with open(f"{report_full_path}", "rb") as attachment:
        part = MIMEBase("application", "octet-stream")
        part.set_payload(attachment.read())
        encoders.encode_base64(part)
        part.add_header(
            "Content-Disposition",
            f"attachment; filename= analytics_data_{current_date}.xlsx",
        )
    msg = MIMEMultipart()
    msg["Subject"] = subject_at
    msg["From"] = mail_from_at
    msg["To"] = ", ".join(recipients_at)
    html_part = MIMEText(body_at)
    msg.attach(html_part)
    msg.attach(part)
    with smtplib.SMTP_SSL(mail_host, int(mail_port)) as smtp_server:
       smtp_server.login(sender_at, password_at)
       smtp_server.sendmail(sender_at, recipients_at, msg.as_string())




mydb = mysql.connector.connect(
  host=db_host,
  user=db_username,
  password=db_password,
  database=db_database
)
queries = parse_sql(sql_queries_file)
for query in queries:
    data_frame = pd.read_sql(query, mydb)
data_frame.to_excel(report_full_path, index=False)

send_email(subject, body, mail_from, recipients, mail_username, mail_password)
