/*
stock.txt

exchange,stock_symbol,closing_date,closing_price
NSE,TCS,2009-08-09,2200.1
NSE,TCS,2009-08-10,2300.1
NSE,TCS,2009-08-11,12200.1
NSE,TCS,2009-08-12,22300.1
NSE,TCS,2009-09-09,2200.1
NSE,TCS,2009-09-10,2300.1
NSE,TCS,2009-09-11,12200.1
NSE,TCS,2009-09-12,22300.1
NSE,INFY,2009-08-09,2500.34
NSE,INFY,2009-08-10,1500.34
NSE,INFY,2009-08-09,7500.34
NSE,INFY,2009-08-10,14500.34
NSE,INFY,2009-09-09,2500.34
NSE,INFY,2009-09-10,1500.34
NSE,INFY,2009-09-09,7500.34
NSE,INFY,2009-09-10,14500.34
NSE,TCS,2010-08-09,2200.1
NSE,TCS,2010-08-10,2300.1
NSE,TCS,2010-08-11,12200.1
NSE,TCS,2010-08-12,22300.1
NSE,TCS,2010-09-09,2200.1
NSE,TCS,2010-09-10,2300.1
NSE,TCS,2010-09-11,12200.1
NSE,TCS,2010-09-12,22300.1
NSE,INFY,2010-08-09,2500.34
NSE,INFY,2010-08-10,1500.34
NSE,INFY,2010-08-09,7500.34
NSE,INFY,2010-08-10,14500.34
NSE,INFY,2010-09-09,2500.34
NSE,INFY,2010-09-10,1500.34
NSE,INFY,2010-09-09,7500.34
NSE,INFY,2010-09-10,14500.34

As you have been given below table.
*/

CREATE TABLE stock_table (exchanged string, stock_symbol string,  closing_date string, closing_price decimal(8,2))
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

dfs -put -f files/stock.txt /public/files/stock.txt;

dfs -cp -f /public/files/stock.txt /user/hive/warehouse/hadoopexamdb.db/stock_table/;

CREATE TABLE stock AS
SELECT exchanged, stock_symbol, CAST(from_unixtime(unix_timestamp(closing_date,'yyyy-MM-dd')) AS timestamp) AS closing_date, closing_price
FROM STOCK_TABLE;

INSERT OVERWRITE TABLE stock
SELECT exchanged, stock_symbol, CAST(from_unixtime(unix_timestamp(closing_date,'yyyy-MM-dd')) AS timestamp) AS closing_date, closing_price
FROM STOCK_TABLE;

/*
1. Write a query , which generate report as below.

exchanged, stock_symbol , closing_date , closing_price , yesterday_closing , diff_yesterday_price
(Price difference between Yesterday prices and today prices)

2. Write a query , which generate report as below.

exchange, stock_symbol , closing_date , closing_price , yesterday_closing , diff_last7days_price
(Price difference between last 7days price and todays price)

3. Write a query which will print, whether following day price is higher ,  lower . Output should be like this.

exchange,stock_symbol, closing_date, closing_price, position
*/
-- Query 1

-- $ beeline -u jdbc:hive2://quickstart.cloudera:10000/hadoopexamdb

SELECT TAB.*,yesterday_closing-closing_price AS diff_yesterday_price FROM (
        SELECT exchanged, stock_symbol, closing_date, closing_price,
               LAG(closing_price,1) OVER(PARTITION BY stock_symbol ORDER BY closing_date) AS yesterday_closing
        FROM stock_table
      ) AS TAB ORDER BY stock_symbol, closing_date;

-- Query 2

SELECT TAB.*, last7days_closing-closing_price AS diff_last7days_price  FROM (
        SELECT exchanged, stock_symbol, closing_date, closing_price,
               LAG(closing_price,7) OVER(PARTITION BY stock_symbol ORDER BY closing_date) AS last7days_closing
        FROM stock
      ) AS TAB ORDER BY stock_symbol, closing_date;

-- Query 3

SELECT TAB.* FROM
       (SELECT exchanged, stock_symbol, closing_date,
       closing_price,LEAD(closing_price,1) OVER (PARTITION BY stock_symbol ORDER BY closing_date) AS following_day_price,
          CASE (LEAD(closing_price,1) OVER (PARTITION BY stock_symbol ORDER BY closing_date) - closing_price) >= 0
            WHEN true THEN "Higher or equal"
            WHEN false THEN "Lower"
          END AS "Trending"
       FROM stock) AS TAB
     ORDER BY stock_symbol, closing_date;