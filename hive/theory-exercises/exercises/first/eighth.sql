/**
Let us use NYSE data and see how we can create tables in Hive.


Data Location (Local): /data/nyse_all/nyse_data
Create a database with the name - YOUR_OS_USER_NAME_nyse
Table Name: nyse_eod
File Format: TEXTFILE (default)
Review the files by running Linux commands before using data sets. Data is compressed and we can load the files as is.
Copy one of the zip file to your home directory and preview the data. There should be 7 fields. You need to determine the delimiter.
Field Names: stockticker, tradedate, openprice, highprice, lowprice, closeprice, volume
Determine correct data types based on the values
Create Managed table with default Hive Delimiter.
As delimiters in data and table are not same, you need to figure out how to get data into the target table.

Validation
Run the following queries to ensure that you will be able to read the data.

SELECT * FROM YOUR_OS_USER_NAME_nyse.nyse_eod;
SELECT count(*) FROM YOUR_OS_USER_NAME_nyse.nyse_eod;
*/