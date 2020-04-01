-- $ beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail

CREATE TABLE orders (
  order_id STRING COMMENT 'Unique order id',
  order_date STRING COMMENT 'Date on which order is placed',
  order_customer_id STRING COMMENT 'Customer id who placed the order',
  order_status STRING COMMENT 'Table to save order level details'
) COMMENT 'Table to save order level details'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INPATH '/home/cloudera/CCA159DataAnalyst/data/retail_db/orders' INTO TABLE orders;

DESCRIBE orders;

TRUNCATE order_items;

INSERT INTO OVERWRITE TABLE order_items
SELECT * FROM order_items_stage;