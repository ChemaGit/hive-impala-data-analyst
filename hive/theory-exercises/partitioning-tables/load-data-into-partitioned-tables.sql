/**
Let us understand how to use load command to load data into partitioned tables.

    We need to make sure that file format of the file which is being loaded into table is same as the file format used while creating the table.
    We also need to make sure that delimiters are consistent between files and table for text file format.
    Also data should match the criteria for the partition into which data is loaded.
    Our /data/retail_db/orders have data for the whole year and hence we should not load the data directly into partition.
    We need to split into files matching partition criteria and then load into the table.
    Splitting data into smaller files by month.

$ grep 2013-07 /home/training/CCA159DataAnalyst/data/retail_db/orders/part-00000

$ mkdir /home/training/CCA159DataAnalyst/data/retail_db/orders/201307
$ mkdir /home/training/CCA159DataAnalyst/data/retail_db/orders/201308
$ mkdir /home/training/CCA159DataAnalyst/data/retail_db/orders/201309
$ mkdir /home/training/CCA159DataAnalyst/data/retail_db/orders/201310

$ grep 2013-07 /home/training/CCA159DataAnalyst/data/retail_db/orders/part-00000 > /home/training/CCA159DataAnalyst/data/retail_db/orders/201307/orders_201307
$ grep 2013-08 /home/training/CCA159DataAnalyst/data/retail_db/orders/part-00000 > /home/training/CCA159DataAnalyst/data/retail_db/orders/201308/orders_201308
$ grep 2013-09 /home/training/CCA159DataAnalyst/data/retail_db/orders/part-00000 > /home/training/CCA159DataAnalyst/data/retail_db/orders/201309/orders_201309
$ grep 2013-10 /home/training/CCA159DataAnalyst/data/retail_db/orders/part-00000 > /home/training/CCA159DataAnalyst/data/retail_db/orders/201310/orders_201310

$ beeline -u jdbc:hive2://localhost:10000/retail_training
*/
CREATE TABLE orders_part (
  order_id INT,
  order_date STRING,
  order_customer_id INT,
  order_status STRING
) PARTITIONED BY (order_month INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INPATH '/home/training/CCA159DataAnalyst/data/retail_db/orders/201307' INTO TABLE orders_part PARTITION(order_month=201307);
LOAD DATA LOCAL INPATH '/home/training/CCA159DataAnalyst/data/retail_db/orders/201308' INTO TABLE orders_part PARTITION(order_month=201308);
LOAD DATA LOCAL INPATH '/home/training/CCA159DataAnalyst/data/retail_db/orders/201309' INTO TABLE orders_part PARTITION(order_month=201309);
LOAD DATA LOCAL INPATH '/home/training/CCA159DataAnalyst/data/retail_db/orders/201310' INTO TABLE orders_part PARTITION(order_month=201310);

SELECT *
FROM orders_part
WHERE order_month = 201309
LIMIT 10;

dfs -ls /user/hive/warehouse/training_retail.db/orders_part/order_month=201307;
