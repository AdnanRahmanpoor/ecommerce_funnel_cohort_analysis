from google.cloud import bigquery
import pandas as pd

# init
client = bigquery.Client.from_service_account_json('./config/credentials.json')

# Read sql file (Replace with sql file name)
with open('./sql/products/02_affinity.sql', 'r') as f:
    query = f.read()

# run and print
print("Executing query...")
df = client.query(query).to_dataframe()
print(f"Got {len(df)} rows")
print(df)