/*
Get NYSE data
Download data from GitHub repository: https://github.com/dgadiraju/nyse_all
Make sure data is cloned into a directory in Gateway node of the cluster where you want to run Impala Script (say /home/itversity/data/nyse_all)
It should contain 2 directories - nyse_data and nyse_stocks
We are interested in nyse_data

Create Impala Script
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

Assigment

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
*/
-- I did the assigment in my Cloudera VM, not in the ITVersity Labs.

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