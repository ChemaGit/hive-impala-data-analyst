/*
Let us understand how to use insert data into static partitions in Hive from existing table called as orders.
We can pre-create partitions in Hive partitioned tables and insert data into partitions using appropriate INSERT command.
*/

USE training_retail;
ALTER TABLE orders_part ADD PARTITION (order_month=201311);

INSERT INTO TABLE orders_part PARTITION (order_month=201311)
  SELECT * FROM orders WHERE order_date LIKE '2013-11%';

$ beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail

ALTER TABLE orders_part ADD PARTITION(order_month=201311);

SELECT DISTINCT(order_month)
FROM orders_part;

dfs -ls /user/hive/warehouse/training_retail.db/orders_part;

INSERT INTO TABLE orders_part PARTITION(order_month=201311)
  SELECT * FROM orders WHERE order_date LIKE '2013-11%';