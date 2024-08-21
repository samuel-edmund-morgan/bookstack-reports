import mysql.connector
import csv
import pandas as pd
from envs import *


def parse_sql(sql_file_path):
    with open(sql_file_path, 'r', encoding='utf-8') as f:
        data = f.read().splitlines()
    stmt = ''
    stmts = []
    for line in data:
        if line:
            if line.startswith('--'):
                continue
            stmt += line.strip() + ' '
            if ';' in stmt:
                stmts.append(stmt.strip())
                stmt = ''
    return stmts

queries = parse_sql("/home/samuel/bookstack-reports/report_data.sql")


mydb = mysql.connector.connect(
  host=db_host,
  user=db_username,
  password=db_password,
  database=db_database
)


for query in queries:
	data_frame = pd.read_sql(query, mydb)
	print(data_frame.head())

csv_file_name = '/tmp/exported_data.xlsx'
data_frame.to_excel(csv_file_name, index=False)
print(f"Data exported to '{csv_file_name}' successfully.")
