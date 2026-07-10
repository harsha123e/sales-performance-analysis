import pandas as pd
import duckdb

con = duckdb.connect("database/sales_performance.duckdb")

orders = pd.read_excel(
    "data/Sample_Superstore.xls",
    sheet_name="Orders"
)

returns = pd.read_excel(
    "data/Sample_Superstore.xls",
    sheet_name="Returns"
)

people = pd.read_excel(
    "data/Sample_Superstore.xls",
    sheet_name="People"
)

# Convert column names to a SQL-friendly format
def standardize_columns(df):
    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_", regex=False)
        .str.replace("-", "_", regex=False)
        .str.replace("/", "_", regex=False)
    )
    return df

orders = standardize_columns(orders)
returns = standardize_columns(returns)
people = standardize_columns(people)

con.register("orders_df", orders)
con.register("returns_df", returns)
con.register("people_df", people)

con.execute("""
CREATE OR REPLACE TABLE orders AS
SELECT * FROM orders_df
""")

con.execute("""
CREATE OR REPLACE TABLE returns AS
SELECT * FROM returns_df
""")

con.execute("""
CREATE OR REPLACE TABLE people AS
SELECT * FROM people_df
""")

con.close()

print("Data loaded successfully")
print(f"Orders: {len(orders)} rows")
print(f"Returns: {len(returns)} rows")
print(f"People: {len(people)} rows")