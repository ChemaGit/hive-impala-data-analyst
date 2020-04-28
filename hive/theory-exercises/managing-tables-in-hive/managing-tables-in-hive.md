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

### Loading Data Into Hive Tables From Local System
````iso92-sql
USE training_retail;
DROP TABLE orders;

CREATE TABLE orders (
  order_id INT COMMENT 'Unique order id',
  order_date STRING COMMENT 'Date on which order is placed',
  order_customer_id INT COMMENT 'Customer id who placed the order',
  order_status STRING COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INPATH '/data/retail_db/orders' INTO TABLE orders;

-- Once the data is loaded we can run these queries to preview the data.

SELECT * 
FROM orders 
LIMIT 10;

SELECT COUNT(1) 
FROM orders;

-- beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail

CREATE TABLE orders (
  order_id INT COMMENT 'Unique order id',
  order_date STRING COMMENT 'Date on which order is placed',
  order_customer_id INT COMMENT 'Customer id who placed the order',
  order_status STRING COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details'
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
 STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/cloudera/CCA159DataAnalyst/data/retail_db/orders' INTO TABLE training_retail.orders;

TRUNCATE TABLE orders;

LOAD DATA LOCAL INPATH '/home/cloudera/CCA159DataAnalyst/data/retail_db/orders' INTO TABLE training_retail.orders;

dfs -ls /home/cloudera/CCA159DataAnalyst/data/retail_db/orders;
````

### Loading Data Into Hive Tables From HDFS Location
````text
Let us understand how we can load data from HDFS location into Hive table.

We can use load command with out inpath to get data from HDFS location into Hive Table.
User running load command from HDFS location need to have write permissions 
on the source location as data will be moved (deleted on source and copied to Hive table)
Make sure user have write permissions on the source location.
First we need to copy the data into HDFS location where user have write permissions.

$ hdfs dfs -mkdir /user/training/retail_db
$ hdfs dfs -put /data/retail_db/orders /user/training/retail_db

Here is the script which will truncate the table and then load the data from HDFS location to Hive table.
````

````iso92-sql
USE training_retail;
TRUNCATE TABLE orders;

LOAD DATA INPATH '/user/training/retail_db/orders' 
  INTO TABLE orders;

-- $ beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail

TRUNCATE TABLE orders;
LOAD DATA INPATH '/user/cloudera/orders' INTO TABLE traning_retail.orders;
````

### Loading Data Into Hive Tables - Overwrite VS. Append
````text
Let us see how we can overwrite or append into Hive table.

INTO TABLE will append in the existing table
If we want to overwrite we have to specify OVERWRITE INTO TABLE
````
````iso92-sql
dfs -ls /apps/hive/warehouse/training_retail.db/orders

LOAD DATA LOCAL INPATH '/data/retail_db/orders' INTO TABLE orders;

dfs -ls /apps/hive/warehouse/training_retail.db/orders;

LOAD DATA LOCAL INPATH '/data/retail_db/orders' OVERWRITE INTO TABLE orders;

dfs -ls /apps/hive/warehouse/training_retail.db/orders;

$ beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail

SHOW tables;

TRUNCATE TABLE orders;

LOAD DATA LOCAL INPATH '/home/cloudera/CCA159DataAnalyst/data/retail_db/orders' INTO TABLE orders;

SELECT COUNT(*) 
FROM orders;

LOAD DATA LOCAL INPATH '/home/cloudera/CCA159DataAnalyst/data/retail_db/orders' OVERWRITE INTO TABLE orders;

SELECT *
FROM orders 
LIMIT 10;
````

### Creating external tables in Hive
````text
Let us understand how to create external table in Hive using orders as example. 
Also we will see how to load data into external table.

We just need to add EXTERNAL keyword in the CREATE clause.
If we do not specify EXTERNAL between CREATE and TABLE, then table is called as Managed Table.
We can use same LOAD commands to get data from either local file system or HDFS which we have used for Managed table.
Once table is created we can run DESCRIBE FORMATTED orders to check the metadata of the table 
and confirm whether it is managed table or external table.
````

````iso92-sql
USE training_retail;
DROP TABLE orders;

CREATE EXTERNAL TABLE orders (
  order_id INT COMMENT 'Unique order id',
  order_date STRING COMMENT 'Date on which order is placed',
  order_customer_id INT COMMENT 'Customer id who placed the order',
  order_status STRING COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INPATH '/data/retail_db/orders' 
  INTO TABLE orders;

-- $ beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail

hive> DESCRIBE FORMATTED orders;

DROP TABLE orders;

CREATE EXTERNAL TABLE orders (
  order_id INT COMMENT 'Unique order id',
  order_date STRING COMMENT 'Date on which order is placed',
  order_customer_id INT COMMENT 'Customer id who placed the order',
  order_status STRING COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details'
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INPATH '/home/cloudera/CCA159DataAnalyst/data/retail_db/orders' INTO TABLE orders;

SELECT * FROM orders LIMIT 10;
````

### Specifying Location For Hive Tables
````text
Let us understand how to specify the location while creating managed table or external table in Hive.

LOCATION can be specified for both Managed tables as well as external tables.
Default location is determined by hive.metastore.warehouse.dir, then sub directory with 
database name and then another sub directory with table name. 
In our case it is /apps/hive/warehouse/training_retail.db/orders
User creating table with LOCATION should be having write permission on that location.
Here is the script to drop the table and recreate with LOCATION, then load data into it.
````
````iso92-sql
dfs -rm -R /user/training/retail_db/orders;
dfs -mkdir /user/training/retail_db/orders;

USE training_retail;
DROP TABLE orders;

CREATE EXTERNAL TABLE orders (
  order_id INT COMMENT 'Unique order id',
  order_date STRING COMMENT 'Date on which order is placed',
  order_customer_id INT COMMENT 'Customer id who placed the order',
  order_status STRING COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/user/training/retail_db/orders';

LOAD DATA LOCAL INPATH '/data/retail_db/orders' INTO TABLE orders;


-- beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail

SHOW tables;
DESCRIBE FORMATTED orders;
dfs -rm -r /user/hive/warehouse/training_retail.db/orders;

DROP TABLE orders;

dfs -mkdir /user/cloudera/retail_db;
dfs -mkdir /user/cloudera/retail_db/orders;

CREATE EXTERNAL TABLE orders (
  order_id INT COMMENT 'Unique order id',
  order_date STRING COMMENT 'Date on which order is placed',
  order_customer_id INT COMMENT 'Customer id who placed the order',
  order_status STRING COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/cloudera/retail_db/orders';

LOAD DATA LOCAL INPATH '/home/cloudera/CCA159DataAnalyst/data/retail_db/orders' INTO TABLE training_retail.orders;

SELECT * FROM orders LIMIT 10;
````

### Managed Tables Vs External Tables
````text
Let us compare and contrast between Managed Tables and External Tables.

When we say EXTERNAL as part of CREATE TABLE, it makes the table EXTERNAL.
Rest of the syntax is same as Managed Table.
However, when we drop Managed Table, it will delete metadata from metastore as well as data from HDFS.
When we drop External Table, only metadata will be dropped, not the data.
Typically we use External Table when same dataset is processed by multiple 
frameworks such as Hive, Pig, Spark etc.
````

### Default Delimiters in Hive Tables Using Text File Format 
````iso92-sql
DESCRIBE FORMATTED orders;

DROP TABLE orders;

CREATE TABLE orders (
order_id INT COMMENT 'Unique order id',
order_date STRING COMMENT 'Date on which order is placed',
order_customer_id INT COMMENT 'Customer id who placed the order',
orders_status STRING COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details';

CREATE TABLE orders_stage (
order_id INT COMMENT 'Unique order id',
order_date STRING COMMENT 'Date on which order is placed',
order_customer_id INT COMMENT 'Customer id who placed the order',
orders_status STRING COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/cloudera/CCA159DataAnalyst/data/retail_db/orders' INTO TABLE orders_stage;

INSERT INTO TABLE orders SELECT * FROM orders_stage;

SELECT * 
FROM orders;

DROP TABLE orders_stage;
````

### Overview Of File Formats - Stored As Clause
````text
Let us go through the details about STORED AS Clause.

Go to this link 
````
[https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-CreateTableCreate/Drop/TruncateTable][Hive Documetation]

````text
and review supported file formats.

Supported File Formats
    TEXTFILE
    ORC
    PARQUET
    AVRO
    SEQUENCEFILE
    JSONFILE
    and more
We can even specify custom file formats
````

### Differences Between RDBMS And Hive
````text
Let us understand the differences between RDBMS and Hive.

RDBMS Tables are Schema on Write. For each and every write operation 
there will be validations such as Data Types, Scale, Precision, 
Check Constraints, Null Constraints, Unique Constraints performed.

RDBMS Tables are fine tuned for best of the performance for transactions (PoS, Bank Transfers etc) 
where as Hive is meant for heavy weight batch data processing.

We can create indexes which are populated live in RDBMS. 
In Hive, indexes are typically static and when ever we add the data, indexes have to be rebuilt.
Even though one can specify constraints in Hive tables, they are only informational. 
The constraints might not be enforced.
We don’t perform ACID Transactions in Hive Tables.
There are no Transaction based statements such as COMMIT, ROLLBACK etc. in Hive.
Metastore and Data are decoupled in Hive. Metastore is available in RDBMS and 
actual business data is typically stored in HDFS.
````
### Truncating And Dropping Tables in Hive
````text
Let us understand how to DROP tables in Hive.
````
We can use DROP TABLE command to drop the table… Let us drop tables orders as well as orders_stage.
````iso92-sql
DROP TABLE orders;
DROP TABLE orders_stage;
DROP DATABASE training_retail;
-- OR
DROP DATABASE training_retail CASCADE;
````
````text
DROP TABLE on managed table will delete both metadata in metastore as well as data in HDFS, 
while DROP TABLE on external table will only delete metadata in metastore.
We can drop database by using DROP DATABASE Command. 
However we need to drop all the tables in the database first.
Here is the example to drop the database training_retail - 
````
````iso92-sql
DROP DATABASE training_retail;
````

### Let us understand how to truncate tables.
````text
TRUNCATE works only for managed tables. Only data will be deleted, structure will be retained.
````
````iso92-sql
CREATE DATABASE training_retail;
CREATE TABLE orders (
  order_id INT,
  order_date STRING,
  order_customer_id INT,
  order_status STRING
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INPATH '/data/retail_db/orders'
INTO TABLE orders;

SELECT * 
FROM orders 
LIMIT 10;

TRUNCATE TABLE orders;

SELECT * 
FROM orders; 
````

[Hive Documetation]: https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-CreateTableCreate/Drop/TruncateTable