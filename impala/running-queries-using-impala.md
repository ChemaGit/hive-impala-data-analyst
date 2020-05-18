### OVERVIEW OF IMPALA SHELL
````text
$ impala-shell

show tables;

show databases;

help;

help set;

exit;

$ impala-shell -h

$ impala-shell --impalad=localhost.localdomain:21000

show tables;

show databases;

exit;

$ impala-shell --impalad=localhost.localdomain:21000 --query="SHOW databases"
$ impala-shell --impalad=localhost.localdomain:21000 --query="SHOW tables"
````

### RELATIONSHIP BETWEEN HIVE AND IMPALA
````text
Impala uses the same metastore as Hive: Hive.Metastore

The metastore in the Cloudera VM is on MySQL
````

### OVERVIEW OF CREATING DATABASES IN IMPALA
````text
$ impala-shell

CREATE DATABASE retail_db;

CREATE DATABASE IF NOT EXISTS retail_db;

SHOW databases;

USE retail_db;

CREATE TABLE IF NOT EXISTS orders (
  order_id INT,
  order_date STRING,
  order_customer_id INT,
  order_status STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

SHOW tables;

DESCRIBE orders;

DESCRIBE FORMATTED orders;
````

### LOADING AND INSERTING DATA INTO IMPALA TABLES
````text
data directory: /public/retail_db/

$ impala-shell --impalad=localhost:21000

USE retail_db;
SHOW tables;

shell hdfs dfs -cp /public/retail_db/orders/* /user/hive/warehouse/retail_db.db/orders/;

OR

- This do a mv command
LOAD DATA INPATH '/public/retail_db/orders/' INTO TABLE orders;

- So I have to put the data again
shell hdfs dfs -put /home/training/CCA159DataAnalyst/data/retail_db/orders/part-00000 /public/retail_db/orders/;

invalidata metadata;

SELECT * FROM orders LIMIT 10;

SELECT COUNT(1) FROM orders;

CREATE TABLE order_count_by_date (
  order_date STRING,
  order_count INT
);

INSERT INTO TABLE order_count_by_date SELECT order_date, CAST(COUNT(order_id) AS INT) AS order_count FROM orders GROUP BY order_date;

SELECT * FROM order_count_by_date LIMIT 10;
````

### RUNNING QUERIES USING IMPALA SHELL
````text
impala-shell --impalad=localhost:21000

SHOW databases;
SHOW tables;

CREATE EXTERNAL TABLE IF NOT EXISTS order_items (
 order_item_id INT,
 order_item_order_id INT,
 order_item_product_id INT,
 order_item_quantity INT,
 order_item_subtotal DOUBLE,
 order_item_price DOUBLE
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/public/retail_db/order_items';

shell hdfs dfs -put /home/training/CCA159DataAnalyst/data/retail_db/order_items/* /user/training/order_items

LOAD DATA INPATH '/user/training/order_items' INTO TABLE order_items;

// Get daily revenue on COMPLETE and CLOSED orders in descending order

SELECT SUBSTRING(o.order_date,1,10) AS order_date, ROUND(SUM(oi.order_item_subtotal), 2) AS daily_revenue
FROM orders o JOIN order_items oi ON(o.order_id = oi.order_item_order_id)
WHERE o.order_status IN('COMPLETE','CLOSED')
GROUP BY o.order_date
ORDER BY daily_revenue DESC
LIMIT 10;
````

### REVIEWING LOGS OF IMPALA QUERIES
````text
impala-shell --impalad=localhost:21000

USE training_retail;

// Get daily revenue on COMPLETE and CLOSED orders in descending order

SELECT SUBSTRING(o.order_date,1,10) AS order_date, ROUND(SUM(oi.order_item_subtotal), 2) AS daily_revenue
FROM orders o JOIN order_items oi ON(o.order_id = oi.order_item_order_id)
WHERE o.order_status IN('COMPLETE','CLOSED')
GROUP BY o.order_date
ORDER BY daily_revenue DESC
LIMIT 10;

Query progress can be monitored at: http://localhost.localdomain:25000/query_plan?query_id=b34bbf48ab203a77:2c76400600000000
````

### SYNCHING HIVE METADATA WITH IMPALA - USING INVALIDATE METADATA
````text
impala-shell impalad=localhost=21000

SHOW databases;
SHOW tables;

invalidate metadata;
````

### RUNNING SCRIPTS USING IMPALA SHELL
````text
impala-shell --impalad=localhost:21000 -f /home/training/CCA159DataAnalyst/file_queries/query.sql

# query.sql
USE training_retail;

SHOW tables;

SELECT *
FROM orders
LIMIT 10;

exit;

# load_daily_revenue.sql

impala-shell --impalad=localhost:21000 -f /home/training/CCA159DataAnalyst/file_queries/load_daily_revenue.sql

USE training_retail;

DROP TABLE IF EXISTS daily_revenue;

CREATE TABLE IF NOT EXISTS daily_revenue AS 
SELECT SUBSTRING(o.order_date,1,10) AS order_date, ROUND(SUM(oi.order_item_subtotal),2) AS daily_revenue
FROM orders o 
JOIN order_items oi
ON(o.order_id = oi.order_item_order_id)
WHERE o.order_status IN('COMPLETE', 'CLOSED')
GROUP BY o.order_date
ORDER BY o.order_date;

SELECT *
FROM daily_revenue
LIMIT 10;

SHOW tables;

exit; 
````

### RUN IMPALA SCRIPT
````text
# Get NYSE data
    Download data from GitHub repository: https://github.com/dgadiraju/nyse_all
    Make sure data is cloned into a directory in Gateway node of the cluster where you want to run Impala Script (say /home/itversity/data/nyse_all)
    It should contain 2 directories - nyse_data and nyse_stocks
    We are interested in nyse_data

# Create Impala Script
    Script file should contain Impala or Shell commands for following tasks.
    Create Database by name nyse
    Create table stocks_eod with following fields - stockticker, tradedate, openprice, highprice, closeprice, lowprice, volume
    Make sure table is created based on the structure of data in the files.
    stockprice should be of type string, tradedate should be of type integer, volume should be of type bigint and other fields should be of type float.
    Load or Insert data from nyse_data on local file system to the newly created table.
    Create a new table stocks_eod_parquet by selecting data from stocks_eod. Data should be sorted by Trade Date and then by Stock Ticker.
    Make sure the new table is created to store data of type parquet file format.

Run using impala-shell
    Make sure the script is self contained
    Run using impala-shell by connecting to one of the impala daemons running in the cluster.

Questions for this assignment
Create impala script as mentioned in the instructions.

# Assigment

+-------------+--------+---------+
| name        | type   | comment |
+-------------+--------+---------+
| stockticker | string |         |
| tradedate   | int    |         |
| openprice   | float  |         |
| highprice   | float  |         |
| lowprice    | float  |         |
| closeprice  | float  |         |
| volume      | bigint |         |
+-------------+--------+---------+

impala-shell -i localhost:21000

assigment.sql

-- I did the assigment in my Cloudera VM, not in the ITVersity Labs.
````

````shell script
CREATE DATABASE IF NOT EXISTS nyse;
USE nyse;

CREATE TABLE IF NOT EXISTS stocks_eod (
  stockticker STRING,
  tradedate INT,
  openprice FLOAT,
  highprice FLOAT,
  lowprice FLOAT,
  closeprice FLOAT,
  volume BIGINT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

shell hdfs dfs -put /home/training/CCA159DataAnalyst/data/nyse_all/nyse_data /user/training/;

LOAD DATA INPATH '/user/training/nyse_data/' OVERWRITE INTO TABLE stocks_eod;

CREATE TABLE IF NOT EXISTS stocks_eod_parquet
STORED AS PARQUET
AS
SELECT * 
FROM stocks_eod
ORDER BY tradedate,stockticker; 

SHOW tables;

shell hdfs dfs -ls /user/hive/warehouse/nyse.db/stocks_eod_parquet;

SELECT *
FROM stocks_eod_parquet
LIMIT 10;

exit;

-- to run the script in the shell: impala-shell -i localhost:21000 -f /home/training/CCA159DataAnalyst/file_queries/assigment.sql
````





