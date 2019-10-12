library(tidyverse)

DB_HOST='server2053.cs.technik.fhnw.ch'
DB_PORT = 5432
DB_DBNAME = 'warenkorb_db' # or 'warenkorb_db'
DB_USERNAME = 'db_user' 
DB_PASSWORD = 'db_user_pw'

con <- DBI::dbConnect(odbc::odbc(),
                      Driver   = "PostgreSQL Unicode(x64)",
                      Server   = DB_HOST,
                      Database = DB_DBNAME,
                      UID      = DB_USERNAME,
                      PWD      = DB_PASSWORD,
                      Port     = DB_PORT)

t_products <- tbl(con, "product")
t_aisles <- tbl(con, "aisle")
t_departments <- tbl(con, "department")
t_orders <- tbl(con, "orders")
t_orders_product = tbl(con, "orders_product_prior") %>%
  union_all(tbl(con, "orders_product_train"))