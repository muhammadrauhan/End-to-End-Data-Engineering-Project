# NETFLIX DATA EXTRACTION 
import pandas as pd
df = pd.read_csv('netflix_titles.csv')
df.head()

# Creating Database Connection
import sqlalchemy as sac
from sqlalchemy import create_engine as ce
pg_engine = ce("postgresql://postgres:sql123@localhost:5432/postgres")
conn = pg_engine.connect()

# Loading the Data in a Database
df.to_sql('netflix_raw', con=conn, index=False, if_exists='append')
conn.close()

# Calculating No. of Rows
len(df)

# Calculating No. of Missing Rows
df.isna().sum()