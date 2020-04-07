/*
### BUCKETING WITH SORTING

We can also ensure that data is sorted with in the bucket in the bucketed table.

    Number of files in the bucketed tables will be multiples of number of buckets.
    Using hash mod algorithm on top of bucket key, data will land into appropriate file.
    However data is not sorted with in bucket.
    We can sort the data with in the bucket by using SORTED BY while creating bucketed tables
    Let us get create table statement of orders_buck and recreate with SORTED BY clause.

Here is the example of creating bucketed table using sorting and then inserting data into it.

$ beeline -u jdbc:hive2://localhost/training_retail
*/
SET hive.exec.infer.bucket.sort;
SET hive.exec.infer.bucket.sort=true;
SET hive.enforce.sortmergebucketmapjoin;
SET hive.enforce.sortmergebucketmapjoin=true;

DROP TABLE orders_buck_sorted;

CREATE TABLE orders_buck_sorted (
 order_id INT,
 order_date STRING,
 order_customer_id INT,
 order_status STRING)
CLUSTERED BY (order_id)
SORTED BY(order_id)
INTO 8 BUCKETS
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

INSERT INTO TABLE orders_buck_sorted
SELECT * FROM orders;

SELECT *
FROM orders_buck_sorted
LIMIT 10;

dfs -ls /user/hive/warehouse/training_retail.db/orders_buck_sorted;

-- Use dfs -tail command to confirm data is sorted as expected.

-- Divide the key between num of buckets and the remain is 0
dfs -tail /user/hive/warehouse/training_retail.db/orders_buck_sorted/000000_0;

-- Divide the key between num of buckets and the remain is 1
dfs -tail /user/hive/warehouse/training_retail.db/orders_buck_sorted/000001_0;

-- Divide the key between num of buckets and the remain is 7
dfs -tail /user/hive/warehouse/training_retail.db/orders_buck_sorted/000007_0;

-- so on and so forth