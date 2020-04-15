## MANAGING TABLES IN HIVE

### Create Tables In Hive

[https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-CreateTableCreate/Drop/TruncateTable][Hive Documentation]

[Hive Documentation]: https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-CreateTableCreate/Drop/TruncateTable

````text
Let us understand how to create table in Hive using orders as example.
````
````iso92-sql
CREATE TABLE orders (
  order_id INT,
  order_date STRING,
  order_customer_id INT,
  order_status STRING
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';
````
````shell script
$ beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail -e "DROP TABLE orders"

$ beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail
````
````iso92-sql
CREATE TABLE orders(
 order_id INT,
 order_date STRING,
 order_customer_id INT,
 order_status STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

SHOW tables;
DESCRIBE FORMATTED orders;
````

### Overview Of Data Types in Hive

[https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-CreateTableCreate/Drop/TruncateTable][Hive Documentation]

[Hive Documentation]: https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-CreateTableCreate/Drop/TruncateTable

### Adding Commments to Columns and Tables
````shell script
$ beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail
````
````iso92-sql
DROP TABLE orders;

CREATE TABLE orders(
order_id INT COMMENT 'Unique order id',
order_date STRING COMMENT 'Date on which order is placed',
order_customer_id INT COMMENT 'Customer id who placed the order',
order_status INT COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
````