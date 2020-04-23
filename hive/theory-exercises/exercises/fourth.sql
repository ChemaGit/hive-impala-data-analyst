/*
Create a table as below.

Table Name :  HADOOP_STOCK
Columns : (exchange string, stock_symbol string,  closing_date timestamp, closing_price decimal(8,2));

Please insert below values.

stock.txt

NSE,TCS,09/08/09,2200.1
NSE,TCS,09/08/10,2300.1
NSE,INFY,09/08/09,2500.34
NSE,INFY,09/08/10,1500.34

- Write a Query to compute moving averages of the closing price, with 3-day span.
- Write a query to compute a cumulative moving average, from the earliest data up to the value for each day.
*/

USE hadoopexamdb;

CREATE TABLE HADOOP_STOCK(exchanged STRING,stock_symbol STRING,closing_date timestamp,closing_price decimal(8,2))
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

ALTER TABLE HADOOP_STOCK CHANGE closing_date closing_date STRING;

dfs -put files/stock.txt /user/hive/warehouse/hadoopexamdb.db/hadoopexam_stock/;

--  Query 1: Write a Query to compute moving averages of the closing price, with 3-day span.

SELECT stock_symbol, closing_date, closing_price,
       AVG(closing_price) OVER (PARTITION BY stock_symbol ORDER BY closing_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_average
FROM HADOOP_STOCK;

-- Notes: ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING produces an average of the value from a 3-day span, producing a different value for each row.
-- The first row, which has no preceding row, only gets averaged with the row following it. If the table contained more than one stock symbol,
-- the PARTITION BY clause would limit the window for the moving average to only consider the prices for a single stock.

-- Query 2: Write a query to compute a cumulative moving average, from the earliest data up to the value for each day.

SELECT stock_symbol, closing_date, closing_price,
       AVG(closing_price) OVER (PARTITION BY stock_symbol ORDER BY closing_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS moving_average
FROM HADOOP_STOCK;

-- Notes: The clause ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW produces a cumulative moving average, from the earliest data up to the value for each day.