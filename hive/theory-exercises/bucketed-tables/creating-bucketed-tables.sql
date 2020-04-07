/*
Let us see how we can create Bucketed Tables in Hive.

Bucketed tables is nothing but Hash Partitioning in conventional databases.
We need to specify the CLUSTERED BY Clause as well as INTO BUCKETS to create Bucketed table.

beeline -u jdbc:hive2//localhost:10000
*/

USE training_retail;

CREATE TABLE orders_buck (
  order_id INT,
  order_date STRING,
  order_customer_id INT,
  order_status STRING
) CLUSTERED BY (order_id) INTO 8 BUCKETS
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

DESCRIBE FORMATTED orders_buck;

/*
Let us see how we can add data to bucketed tables.

Typically we use INSERT command to get data into bucketed tables, as source data might not match the criterial of our bucketed table.
If the data is in files, first we need to get data to stage and then insert into bucketed table.
We already have data in orders table, let us use to insert data into our bucketed table orders_buck
hive.enforce.bucketing should be set to true.

Here is the example of inserting data into bucketed table from regular managed or external table.
*/
SET hive.enforce.bucketing;
SET hive.enforce.bucketing=true;

INSERT INTO orders_buck
SELECT * FROM orders;

dfs -ls /user/hive/warehouse/training_retail.db/orders_buck;

SELECT *
FROM orders_buck
LIMIT 10;
