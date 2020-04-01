#!/bin/bash

### RUN QUERIES IN MYSQL  USING "sqoop eval"

# Apart from listing databases and tables, if we want to run any queeries in source database then we can use sqoop eval
# On top of common arguments, sqoop eval have evaluation argument.
# It can be passed by using -e or –query
# We can pass any valid query or command of the source database.
# Here are the some of the common tasks we perform using sqoop eval.
# Describe tables.
# Preview data using SELECT queries
# Invoke stored procedures

Let us see some common examples of sqoop eval.

sqoop eval \
  --connect "jdbc:mysql://localhost:3306/retail_db" \
  --username training \
  --password training \
  --query "SELECT * FROM orders LIMIT 10"

sqoop eval \
  --connect "jdbc:mysql://localhost:3306/retail_db" \
  --username training \
  --password training \
  --query "DESCRIBE orders"