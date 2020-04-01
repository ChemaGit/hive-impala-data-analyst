/*
Let us understand how to create partitioned table and get data into that table.

Earlier we have already created orders table. We will use that as reference and create partitioned table.
We can use PARTITIONED BY clause to define the column along with data type. In our case we will use order_month as partition column.
We will not be able to directly load the data into the partitioned table using our original orders data (as data is not in sync with structure).
*/

USE training_retail;
CREATE TABLE orders_part (
  order_id INT,
  order_date STRING,
  order_customer_id INT,
  order_status STRING
) PARTITIONED BY (order_month INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';
