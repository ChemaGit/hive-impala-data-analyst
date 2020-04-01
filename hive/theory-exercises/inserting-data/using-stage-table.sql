/**
INSERTING DATA INTO ORDER_ITEMS USING STAGE TABLE
Let us understand how to insert data into order_items with PARQUET file format.
As data is in text file format and our table is created with PARQUET file format,
we will not be able to use LOAD command to load the data.
Following are the steps to get data into table
which is created using different file format or delimiter than our source data.
We need to create stage table with text file format and comma as delimiter (order_items_stage).
Load data from our files in local file system to stage table.
Using stage table run insert command to insert data into our target table (order_items).

$ beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail;
*/

DROP TABLE order_items;
DROP TABLE order_items_stage;

CREATE TABLE order_items (
  order_item_id INT,
  order_item_order_id INT,
  order_item_product_id INT,
  order_item_quantity INT,
  order_item_subtotal FLOAT,
  order_item_product_price FLOAT
) STORED AS PARQUET;

CREATE TABLE order_items_stage (
  order_item_id INT,
  order_item_order_id INT,
  order_item_product_id INT,
  order_item_quantity INT,
  order_item_subtotal FLOAT,
  order_item_product_price FLOAT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
  STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/cloudera/CCA159DataAnalyst/data/retail_db/order_items' INTO TABLE order_items_stage;

INSERT INTO TABLE order_items SELECT * FROM order_items_stage;

DESCRIBE FORMATTED order_items;

SELECT COUNT(*)
order_items;

SELECT *
FROM order_items
LIMIT 10;

DROP TABLE order_items_stage;