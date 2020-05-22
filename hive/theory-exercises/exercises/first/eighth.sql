/**
Create a database with the name - training_nyse
Table Name: stocks_eod
File Format: TEXTFILE (default)
Review the files by running Linux commands before using data sets. Data is compressed and we can load the files as is.
Copy one of the zip file to your home directory and preview the data. There should be 7 fields. You need to determine the delimiter.
Field Names: stockticker, tradedate, openprice, highprice, lowprice, closeprice, volume
Determine correct data types based on the values
Create Managed table with default Hive Delimiter.
As delimiters in data and table are not same, you need to figure out how to get data into the target table.

Validation
Run the following queries to ensure that you will be able to read the data.

SELECT * FROM training_nyse.stocks_eod;
SELECT count(*) FROM training_nyse.stocks_eod;

*/

ls /home/training/CCA159DataAnalyst/data/nyse_all/nyse_data
tail /home/training/CCA159DataAnalyst/data/nyse_all/nyse_data/NYSE_1997.txt;

/*
+-----------------------------------------------+--+
|                  DFS Output                   |
+-----------------------------------------------+--+
|                                               |
| WNC,19971231,28.37,28.62,28.25,28.44,70700    |
| WOR,19971231,16.25,16.5,15.94,16.5,588400     |
| WR,19971231,43.06,43.12,43,43,102800          |
| WRE,19971231,16.37,16.81,16.25,16.75,90500    |
| WRI,19971231,19.72,20,19.69,19.91,92250       |
| WSM,19971231,10.38,10.69,10.31,10.47,1798400  |
| WSO,19971231,16.25,16.75,16.25,16.47,106500   |
| WST,19971231,7.625,7.675,7.44,7.44,40200      |
| WTM,19971231,120,121,119.5,121,9900           |
| WTR,19971231,6.6,6.816,6.588,6.792,42968      |
*/

CREATE DATABASE IF NOT EXISTS training_nyse;

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

LOAD DATA LOCAL INPATH '/home/training/CCA159DataAnalyst/data/nyse_all/nyse_data/' INTO TABLE stocks_eod;

SELECT * FROM stocks_eod LIMIT 10;
SELECT count(1) FROM stocks_eod;