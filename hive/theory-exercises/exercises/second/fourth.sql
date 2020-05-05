/*
Use tables created from previous exercise

Create  a static Partitioned tables, based on order_id and all the fields must be separated bt '~' :

1. Add two static partitions 8999 and 9000.
2. Load all the orders which has order id <9000 in partition 8999.
3. Load all the orders which has order id > 9000 in partition 9000.
*/
-- SOLUTIONS

-- Step 1: Create a static Partitioned tables, based on order_status and all the fields must be separated by '~'

CREATE TABLE orders_static_partition (
 courseID INT,
 join_date TIMESTAMP,
 userID INT,
 isactive STRING)
PARTITIONED BY(order_status STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '~'
STORED AS TEXTFILE;

-- Step 2: Add static partitions to the table.

ALTER TABLE orders_static_partition ADD PARTITION(order_status='CLOSED');
ALTER TABLE orders_static_partition ADD PARTITION(order_status='COMPLETE');

-- Step 3:
    --Copying data into static partition
    --Load command works when the files being copied only have order_id is < 9000 or >= 9000
    --Using insert command

INSERT INTO TABLE orders_static_partition PARTITION(order_status='CLOSED')
SELECT order_id,order_date,order_customer_id,order_status FROM orders WHERE order_status = 'CLOSED';

INSERT INTO TABLE orders_static_partition PARTITION(order_status='COMPLETE')
SELECT order_id,order_date,order_customer_id,order_status FROM orders WHERE order_status = 'COMPLETE';

-- Check data in each partitions have been loaded or not

SELECT *
FROM orders_static_partition
WHERE order_status = 'CLOSED'
LIMIT 10;

SELECT *
FROM orders_static_partition
WHERE order_status = 'COMPLETE'
LIMIT 10;

