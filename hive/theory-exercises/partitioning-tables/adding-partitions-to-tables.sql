/*
Let us understand how we can add static partitions to Partitioned tables in Hive.

    We can add partitions using ALTER TABLE command with ADD PARTITION.
    For each and every partition created a subdirectory will be created using partition column name and corresponding value under the table directory.
    Let us understand how to add partitions to orders_part table under training_retail database.
*/

USE training_retail;

CREATE TABLE orders_part (
  order_id INT,
  order_date STRING,
  order_customer_id INT,
  order_status STRING
) PARTITIONED BY (order_month INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

ALTER TABLE orders_part ADD PARTITION (order_month=201307);

ALTER TABLE orders_part ADD
  PARTITION (order_month=201308)
  PARTITION (order_month=201308)
  PARTITION (order_month=201308);

dfs -ls /user/hive/warehouse/training_retail.db/orders_part;
