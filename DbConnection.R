library(tidyverse)
library(DBI)

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
                      Port     = DB_PORT,
                      Encoding = "latin1")

t_products <- tbl(con, "product")
#t_products <- readRDS('./data/products.rds')
t_aisles <- tbl(con, "aisle")
t_departments <- tbl(con, "department")
t_orders <- tbl(con, "orders")
t_orders_product = tbl(con, "orders_product_prior") %>%
  union_all(tbl(con, "orders_product_train"))

#Data Cleaning

#t_orders
t_orders_Clean <- t_orders %>% filter(is.na())

t_orders_FirstBuy <- t_orders %>%
  filter(is.na(days_since_prior_order)) %>%
  select(-c(days_since_prior_order,order_number))

#t_orders
t_orders_Clean <- t_orders %>% filter(days_since_prior_order)

t_orders_FirstBuy <- t_orders %>%
  filter(is.na(days_since_prior_order)) %>%
  select(-c(days_since_prior_order))

#t_aisles
t_aisles_Clean <- t_aisles %>%
  filter(aisle != "missing" & aisle != "other")

t_aisles_Missing <- t_aisles %>%
  filter(aisle == "missing")

t_aisles_Other <- t_aisles %>%
  filter(aisle == "other")

#t_departments
t_departments_Clean <- t_departments %>%
  filter(department != "missing" & department != "other")

t_departments_Missing <- t_departments %>%
  filter(department == "missing")

t_departments_Other <- t_departments %>%
  filter(department == "other")


#show(t_aisles_Clean)