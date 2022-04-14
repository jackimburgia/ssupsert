
# CREATE TABLE [dbo].[People](
# 	[PeopleID] [int] NOT NULL,
# 	[FirstName] [varchar](100) NOT NULL,
# 	[LastName] [varchar](100) NOT NULL,
#  CONSTRAINT [PK_People] PRIMARY KEY CLUSTERED 
# (
# 	[PeopleID] ASC
# )
# ) 
# GO

# insert People values (1, 'Joe', 'Jones');
# insert People values (2, 'Mary', 'Smith');
# insert People values (3, 'John', 'Miller');

from ssupsert import upsert
import pyodbc
import pandas as pd

# read the People data into the dataframe
connection_str = "DRIVER={ODBC Driver 13 for SQL Server}; SERVER=(localdb)\\mssqllocaldb; DATABASE=Upsert_test; Trusted_Connection=yes"
conn = pyodbc.connect(connection_str) 
df = pd.read_sql("select * from People", conn)
conn.close()


# Update all of the last names - append an x
df["LastName"] = df["LastName"] + 'X'

# add a new row to the dataframe
dict = {"PeopleID":4, "FirstName":"Joe", "LastName":"Jones"}
df = df.append(dict, ignore_index = True)

# upsert the values
upsert(df, "People", "dbo", connection_str)
