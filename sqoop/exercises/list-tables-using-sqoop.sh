#!/bin/bash

# Let us see how to list tables using Sqoop in a Database setup in MySQL.
# To list tables, we need to specify database name as part of JDBC URI.
# It will list the tables that exists in the underlying MySQL Server in case of MySQL.
sqoop list-tables \
  --connect "jdbc:mysql://localhost:3306/retail_db" \
  --username training \
  --password training