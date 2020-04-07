/*
Let us understand how we can insert data into partitioned table using dynamic partition mode.
Using dynamic partition mode we need not pre create the partitions.
Partitions will be automatically created when we issue INSERT command in dynamic partition mode.
To insert data using dynamic partition mode, we need to set the property hive.exec.dynamic.partition to true
Also we need to set hive.exec.dynamic.partition.mode to nonstrict

hive -e "SET;" | grep dynamic.partition
*/

beeline -u jdbc:hive2://localhost:10000

USE training_retail;

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

INSERT INTO TABLE orders_part PARTITION (order_month)
SELECT o.*, date_format(order_date, 'YYYYMM') order_month
FROM orders o
WHERE order_date >= '2013-12-01 00:00:00.0';

SELECT distinct order_month
FROM orders_part;

SELECT order_month, COUNT(1)
FROM orders_part
GROUP BY order_month;

-- You will see new partitions created starting from 201312 to 201407.