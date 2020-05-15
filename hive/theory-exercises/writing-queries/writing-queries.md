## WRITING QUERIES

### BASIC QUERIES

### OVERVIEW
````text
Let us get an overview of Basic Hive Queries.

    Let us make sure _retail database is created.
    Make sure orders and order_items tables are added in the database.
    SQL Clauses
        SELECT - Project fields or derived fields
        FROM - Specify Tables
        JOIN - Join multiple data sets. It can also be OUTER
        WHERE - To filter data
        GROUP BY [HAVING] - For group operations such as aggregation
        ORDER BY - To sort the data

$ beeline -u jdbc:hive2://localhost:10000/training_retail

SELECT FROM JOIN WHERE GROUP BY HAVING ORDER BY
````

### HIVE QUERY - EXECUTION LIFE CYCLE
````text
$ beeline -u jdbc:hive2://localhost:10000/training_retail

Let us understand the execution life cycle of a query.

    Here is the query

SELECT order_item_order_id, sum(order_item_subtotal) AS order_revenue
FROM order_items
GROUP BY order_item_order_id
LIMIT 10;

Once the query is submitted, this is what happens.

Syntax and Semantecs Check
Compile Hive query into Map Reduce application
Submit Map Reduce Application as one or more Job
Execute all the associated Map Reduce Jobs
````

### REVIEWING LOGS FOR HIVE QUERIES
````text
Let us go through the details related to logs for Hive Queries.

Once the query is submitted details will be logged to /tmp/OS_USER_NAME/hive.log by default.
As Hive will be running as Map Reduce jobs, we can actually go through Map Reduce Job logs using Job History Server UI.
We can also go to Job Configuration and get more details about run time details of associated Map Reduce jobs.
    Running Query
    Number of reducers
    Input Directory
    and any other run time property for the underlying Map Reduce jobs.

$ beeline -u jdbc:hive2://localhost:10000/training_retail

cd /tmp/training
view hive.log

Tracking URL = http://localhost.localdomain:8088/proxy/application_1567490171890_0101/

search for logs

job => configuration => search for "query"
````

### PROJECTING DATA USING SELECT AND OVERVIEW OF FROM CLAUSE
````text
$ beeline -u jdbc:hive2://localhost:10000/training_retail

SHOW tables;

DESCRIBE orders;
DESCRIBE order_items;

SELECT * FROM orders LIMIT 10;

SELECT order_id, order_customer_id FROM orders LIMIT 10;

DESCRIBE order_items;

SELECT order_item_order_id, order_item_product_id,order_item_quantity * order_item_product_price AS order_item_revenue, order_item_subtotal
FROM order_items LIMIT 10;
````

### USING CASE AND WHEN AS PART OF SELECT CLAUSE
````text
$ beeline -u jdbc:hive2://localhost:10000/training_retail

SELECT * FROM orders LIMIT 10;

SELECT DISTINCT order_status FROM orders;

SELECT o.*,
  CASE WHEN o.order_status IN('COMPLETE','CLOSED') THEN 'COMPLETED'
  WHEN o.order_status IN('PENDING', 'PENDING_PAYMENT','PAYMENT_REVIEW','PROCESSING') THEN 'PENDING'
  ELSE 'OTHER'
END AS actual_status
FROM orders o LIMIT 100;
````

### PROJECTING DISTINCT VALUES
````text
$ beeline -u jdbc:hive2://localhost:10000/training_retail

SELECT COUNT(*) FROM orders;

SELECT DISTINCT(order_date) FROM orders;

SELECT DISTINCT(order_status) FROM orders;

SELECT DISTINCT(order_item_product_id) FROM order_items;

SELECT COUNT(DISTINCT order_date) FROM orders;

SELECT * FROM orders LIMIT 10;

SELECT DISTINCT *  FROM orders LIMIT 10;
````

### FILTERING DATA USING WHERE CLAUSE
````text
$ beeline -u jdbc:hive2://localhost:10000/training_retail

SELECT * FROM orders LIMIT 10;

SELECT * FROM orders WHERE order_status = 'COMPLETE' LIMIT 10;

SELECT * FROM orders WHERE order_status = 'CLOSED' LIMIT 10;

SELECT * FROM orders WHERE order_customer_id = 8827 LIMIT 10;

SELECT * FROM orders WHERE order_customer_id = '8827' LIMIT 10;

SELECT * FROM order_items LIMIT 10;

SELECT * FROM order_items WHERE order_item_quantity > 1 LIMIT 10;

SELECT * FROM order_items WHERE order_item_quantity >= 2 LIMIT 10;

SELECT * FROM order_items WHERE order_item_subtotal >= 100 LIMIT 10;

SELECT * FROM order_items WHERE order_item_subtotal >= 100.0 LIMIT 10;

SELECT * FROM orders WHERE order_status <> 'COMPLETE' LIMIT 10;

SELECT * FROM orders WHERE order_status != 'COMPLETE' LIMIT 10;

SELECT * FROM orders WHERE order_status NOT IN ('COMPLETE') LIMIT 10;
````

### BOOLEAN OPERATIONS SUCH AS OR & AND USING MULTIPLE FIELDS
````text
$ beeline -u jdbc:hive2://localhost:10000/training_retail

SELECT * FROM orders LIMIT 10;


SELECT * FROM orders WHERE order_status = 'COMPLETE' LIMIT 10;

SELECT * FROM orders WHERE order_status = 'COMPLETE' OR order_status = 'CLOSED' LIMIT 10;

SELECT * FROM orders WHERE order_status = 'COMPLETE' AND order_date = '2013-07-25 00:00:00.0' LIMIT 10;

SELECT COUNT(*) FROM orders WHERE order_status = 'COMPLETE' AND order_date = '2013-07-25 00:00:00.0';

SELECT * FROM orders WHERE order_status = 'COMPLETE' OR order_date = '2013-07-25 00:00:00.0' LIMIT 10;

SELECT COUNT(1) FROM orders WHERE order_status = 'COMPLETE' OR order_date = '2013-07-25 00:00:00.0';

SELECT COUNT(1) FROM orders WHERE order_status = 'COMPLETE';

SELECT COUNT(1) FROM orders WHERE order_status <> 'COMPLETE' AND order_date = '2013-07-25 00:00:00.0';
````

### BOOLEAN OR VS IN
````text
$ beeline -u jdbc:hive2://localhost:10000/training_retail

SELECT * FROM orders LIMIT 10;

SELECT * FROM orders WHERE order_status = 'COMPLETE' OR order_status = 'CLOSED' LIMIT 10;

SELECT * FROM orders WHERE order_status IN('COMPLETE','CLOSED') LIMIT 10;

SELECT * FROM orders WHERE order_status IN('COMPLETE','CLOSED', 'PENDING') LIMIT 100;

SELECT * FROM orders WHERE order_status NOT IN('COMPLETE','CLOSED') LIMIT 10;

SELECT * FROM orders WHERE order_status <> 'COMPLETE' AND order_status <> 'CLOSED' LIMIT 10;

SELECT COUNT(*) FROM orders WHERE order_status NOT IN('COMPLETE','CLOSED');

SELECT COUNT(*) FROM orders WHERE order_status <> 'COMPLETE' AND order_status <> 'CLOSED';
````

### FILTERING DATA USING LIKE OPERATOR
````text
$ beeline -u jdbc:hive2://localhost:10000/training_retail

SELECT * FROM orders LIMIT 10;

SELECT * FROM orders WHERE order_date LIKE '2014' LIMIT 10;

SELECT COUNT(*) FROM orders WHERE order_date LIKE '2014';

SELECT * FROM orders WHERE order_date LIKE '%-07-%' LIMIT 10;

SELECT COUNT(*) FROM orders WHERE order_date LIKE '%-07-%';

SELECT order_date, COUNT(1) FROM orders WHERE order_date LIKE '%-07-%' GROUP BY order_date;
````

### BASIC AGGREGATIONS USING AGGREGATE FUNCTIONS
````text
Let us see how we can use aggregate functions such as count, sum, min, max etc.

Here are few examples with respect to count.

$ beeline -u jdbc:hive2://localhost:10000/training_retail

SELECT count(1) FROM orders;
SELECT count(DISTINCT order_date) FROM orders;
SELECT count(DISTINCT order_date, order_status) FROM orders;

Let us see functions such as min, max, avg etc in action.

SELECT * FROM order_items WHERE order_item_order_id = 2;

SELECT sum(order_item_subtotal) 
FROM order_items 
WHERE order_item_order_id = 2;

SELECT sum(order_item_subtotal),
  min(order_item_subtotal),
  max(order_item_subtotal),
  avg(order_item_subtotal)
FROM order_items 
WHERE order_item_order_id = 2;
````

### PERFORMING BASIC AGGREGATIONS SUCH AS SUM, MIN, MAX, ETC USING GROUP BY
````text
Let us get an overview of GROUP BY and perform basic aggregations such as SUM, MIN, MAX etc using GROUP BY…

It is primarily used for performing aggregate type of operations based on a key.
When GROUP BY is used, SELECT clause can only have those columns/expressions specified in GROUP BY clause and then aggregate functions.
We need to have key defined in GROUP BY Clause.
Same key should be specified in SELECT clause along with aggregate function.

Let us see aggregations using GROUP BY in action.

$ beeline -u jdbc:hive2://localhost:10000/training_retail

SELECT * FROM order_items LIMIT 10;

SELECT order_item_order_id,
  sum(order_item_subtotal) AS order_revenue,
  min(order_item_subtotal) AS min_order_item_subtotal,
  max(order_item_subtotal) AS max_order_item_subtotal,
  avg(order_item_subtotal) AS avg_order_item_subtotal,
  count(order_item_subtotal) AS cnt_order_item_subtotal
FROM order_items
GROUP BY order_item_order_id
LIMIT 10;


SELECT order_date, COUNT(DISTINCT order_status) distinct_status
FROM orders
GROUP BY order_date;

SELECT order_date,order_status, COUNT(DISTINCT order_status) distinct_status
FROM orders
GROUP BY order_date, order_status
LIMIT 10;
````

### FILTERING POST AGGREGATION USING HAVING
````text
Let us see how we can filter the data based on aggregated results using HAVING Clause.

Having clause can be used only with GROUP BY
We need to use function as part of HAVING clause to filter the data based on aggregated results.

$ beeline -u jdbc:hive2://localhost:10000/training_retail

SELECT order_item_order_id,
  sum(order_item_subtotal) AS order_revenue
FROM order_items
GROUP BY order_item_order_id
HAVING sum(order_item_subtotal) >= 500
LIMIT 10;
````

### GLOBAL SORTING USING ORDER BY
````text
Let us see how we can sort the data globally using ORDER BY.

When we sort the data using ORDER BY, only one reducer will be used for sorting.
We can sort the data either in ascending or descending order.
By default data will be sorted in ascending order.
We can sort the data using multiple columns.
If we have sort the data in descending order on a particular column, 
then we need to specify DESC on that column.

Let us see few examples of using ORDER BY to sort the data.

$ beeline -u jdbc:hive2://localhost:10000/retail_training

SELECT * FROM orders
ORDER BY order_customer_id
LIMIT 10;

SELECT * FROM orders
ORDER BY order_customer_id, order_date
LIMIT 10;

SELECT * FROM orders
ORDER BY order_customer_id ASC, order_date DESC
LIMIT 10;
````

### OVERVIEW OF DISTRIBUTE BY
````text
$ jdbc:hive2://localhost:10000/training_retail

SELECT order_item_order_id,sum(order_item_subtotal) AS order_revenue
FROM order_items
GROUP BY order_item_order_id
LIMIT 10;

SELECT order_item_order_id,sum(order_item_subtotal) AS order_revenue
FROM order_items
GROUP BY order_item_order_id
DISTRIBUTE BY order_item_order_id
LIMIT 10;
````

### SORTING DATA WITH IN GROUPS USING DISTRIBUTE BY AND SORT BY
````text
$ beeline -u jdbc:hive2://localhost:10000/

Let us create database training_nyse if it is not already existing and then create table stocks_eod

CREATE DATABASE IF NOT EXISTS training_nyse;
USE training_nyse;

CREATE TABLE stocks_eod (
  stockticker STRING,
  tradedate INT,
  openprice FLOAT,
  highprice FLOAT,
  lowprice FLOAT,
  closeprice FLOAT,
  VOLUME BIGINT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INPATH '/home/training/CCA159DataAnalyst/data/nyse_all/nyse_data' INTO TABLE stocks_eod;

Let us try creating new table stocks_eod_orderby using stocks_eod data sorting by tradedate and then volume descending.

Create table stocks_eod_orderby
Set number of reducers to 8
Insert into stocks_eod_orderby from stocks_eod using ORDER BY tradedate, volume DESC
Even though number of reducers are set to 8, it will use only 1 reducer as we have ORDER BY clause in our query.
Here are the commands to create table stocks_eod_orderby and insert data into the table.

CREATE TABLE stocks_eod_orderby (
  stockticker STRING,
  tradedate INT,
  openprice FLOAT,
  highprice FLOAT,
  lowprice FLOAT,
  closeprice FLOAT,
  VOLUME BIGINT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

SET mapreduce.job.reduces=8;

INSERT INTO stocks_eod_orderby
SELECT * FROM stocks_eod
ORDER BY tradedate, volume DESC;

Now let us create the table stocks_eod_sortby where data is grouped and sorted with in each date by volume in descending order.

Create table stocks_eod_sortby
Set number of reducers to 8
Insert into stocks_eod_sortrby from stocks_eod using DISTRIBUTE BY tradedate SORT BY tradedate, volume DESC
Now data will be inserted into stocks_eod_sortby using 8 reducers.
Data will be distributed/grouped by tradedate and with in each tradedate data will be sorted by volume in descending order.
Data need not be globally sorted on the tradedate.

Here are the commands to create table stocks_eod_sortby.

CREATE TABLE stocks_eod_sortby (
  stockticker STRING,
  tradedate INT,
  openprice FLOAT,
  highprice FLOAT,
  lowprice FLOAT,
  closeprice FLOAT,
  VOLUME BIGINT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

Let us take care of inserting the data using DISTRIBUTE BY and SORT BY.

SET mapreduce.job.reduces=8;

INSERT INTO stocks_eod_sortby
SELECT * FROM stocks_eod
DISTRIBUTE BY tradedate
SORT BY tradedate, volume DESC;

Now we can look into the location of the table and we will see 8 files as 8 reducers are used.
````

### OVERVIEW OF CLUSTER BY
````text
$ beeline -u jdbc:hive2://localhost:10000/training_nyse

CREATE TABLE stocks_eod_clusterby
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
AS SELECT * FROM stocks_eod
CLUSTER BY tradedate;

$ awk -F',' '{ print $2 }' 000000_0 |uniq
````

### OVERVIEW OF NESTED SUB QUERIES
````text
$ beeline -u jdbc:hive2://localhost:10000/training_retail

SELECT * 
FROM orders
LIMIT 10;

SELECT * 
FROM (SELECT * FROM orders) AS q 
LIMIT 10;

CREATE TABLE wordcount(line STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\n'
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/training/CCA159DataAnalyst/data/files/catsat.txt' INTO TABLE wordcount;

SELECT * FROM wordcount;

SELECT SPLIT(line, ' ') FROM wordcount;

SELECT * 
FROM wordcount;

SELECT word, COUNT(word) AS count_word FROM (
SELECT EXPLODE(SPLIT(line, ' ')) AS word FROM wordcount) AS q
GROUP BY word;
````

### NESTED SUB QUERIES IN WHERE CLAUSE WITH IN OR NOT IN
````text
$ beeline -u jdbc:hive2//localhost:10000/training_retail

SELECT * 
FROM orders o 
WHERE o.order_id NOT IN (SELECT oi.order_item_order_id FROM order_items oi) LIMIT 10;

SELECT * 
FROM orders o 
WHERE o.order_id IN (SELECT oi.order_item_order_id FROM order_items oi) LIMIT 10;
````

### NESTED SUB QUERIES IN WHERE CLAUSE WITH EXISTS OR NOT EXISTS
````text
beeline -u jdbc:hive2://localhost:10000/training_retail

SELECT * 
FROM orders 
WHERE EXISTS (SELECT * FROM order_items WHERE order_items.order_item_order_id = orders.order_id) LIMIT 10;

SELECT * 
FROM orders o 
WHERE EXISTS (SELECT * FROM order_items oi WHERE oi.order_item_order_id = o.order_id) LIMIT 10;

SELECT * 
FROM orders o 
WHERE NOT EXISTS (SELECT * FROM order_items oi WHERE oi.order_item_order_id = o.order_id) LIMIT 10;
````

### OVERVIEW OF JOINS
````text
$ beeline -u jdbc:hive2//localhost:10000/training_retail

SELECT order_date, order_status, order_item_subtotal 
FROM orders JOIN order_items ON(order_id = order_item_order_id)
LIMIT 10;

SELECT DISTINCT o.* 
FROM orders o
JOIN order_items oi ON(o.order_id = oi.order_item_order_id)
LIMIT 10;

SELECT DISTINCT o.* 
FROM orders o, order_items oi
WHERE o.order_id <> oi.order_item_order_id
LIMIT 10;
````

### JOINING MULTIPLE TABLES IN HIVE
````text
$ beeline -u jdbc:hive2://localhost:10000/training_retail

DESCRIBE orders;
DESCRIBE order_items;

SELECT order_id, order_date, order_status, order_item_product_id, order_item_subtotal 
FROM orders INNER JOIN order_items ON(order_id = order_item_order_id)
LIMIT 10;

SELECT COUNT(*) AS num_items
FROM orders INNER JOIN order_items ON(order_id = order_item_order_id);

SELECT order_id, order_date, order_status, order_item_product_id, order_item_subtotal 
FROM orders INNER JOIN order_items ON(order_id = order_item_order_id)
WHERE order_status IN('COMPLETE','CLOSED')
LIMIT 10;
````

### OUTERS JOINS IN HIVE

````text
$ beeline -u jdbc:hive2://localhost:10000/training_retail

SELECT COUNT(1)
FROM orders o INNER JOIN order_items oi
ON o.order_id = oi.order_item_order_id;

SELECT COUNT(DISTINCT o.order_id)
FROM orders o INNER JOIN order_items oi
ON o.order_id = oi.order_item_order_id;

SELECT o.order_id,o.order_date,o.order_status,
       oi.order_item_product_id,oi.order_item_subtotal
FROM orders o LEFT OUTER JOIN order_items oi
ON o.order_id = oi.order_item_order_id
LIMIT 10;

SELECT COUNT(*)
FROM orders o LEFT OUTER JOIN order_items oi
ON o.order_id = oi.order_item_order_id;

SELECT o.*
FROM orders o LEFT OUTER JOIN order_items oi
ON o.order_id = oi.order_item_order_id
WHERE oi.order_item_order_id IS NULL;

SELECT COUNT(*)
FROM orders o LEFT OUTER JOIN order_items oi
ON o.order_id = oi.order_item_order_id
WHERE oi.order_item_order_id IS NULL;

SELECT COUNT(*)
FROM order_items oi RIGHT OUTER JOIN orders o
ON o.order_id = oi.order_item_order_id
WHERE oi.order_item_order_id IS NULL;

SELECT COUNT(*)
FROM orders o RIGHT OUTER JOIN order_items oi
ON o.order_id = oi.order_item_order_id
WHERE oi.order_item_order_id IS NULL;
````

### FULL OUTER JOINS IN HIVE
````text
$ beeline -u jdbc:hive2://localhost:10000/training_retail

SELECT o.order_id, o.order_date, o.order_status,
       oi.order_item_product_id,oi.order_item_subtotal
FROM orders o FULL OUTER JOIN order_items oi
ON (o.order_id = oi.order_item_order_id)
LIMIT 100;

SELECT COUNT(DISTINCT oi.order_item_id)
FROM orders o FULL OUTER JOIN order_items oi
ON (o.order_id = oi.order_item_order_id);
````

### MAP SIDE JOIN VS REDUCE SIDE JOIN
````text
$ beeline -u jdbc:hive2://localhost:10000/training_retail

SET hive.auto.convert.join;

SELECT o.order_id, o.order_date, o.order_status,
       oi.order_item_product_id, oi.order_item_subtotal
FROM orders o INNER JOIN order_items oi ON(o.order_id = oi.order_item_order_id)
LIMIT 10;

SET hive.auto.convert.join=false;

SET hive.auto.convert.join=true;
````

### JOINING USING LEGACY SYNTAX
````text
beeline -u jdbc:hive2://localhost:10000/training_retail

SELECT o.order_id, o.order_date, o.order_status,
       oi.order_item_product_id, oi.order_item_subtotal
FROM orders o, order_items oi
WHERE o.order_id = oi.order_item_order_id
LIMIT 10;
````

### CARTESIAN BETWEEN TWO DATASETS
````
beeline -u jdbc:hive2://localhost:10000/training_retail

SELECT o.order_id, order_date, o.order_status,
       oi.order_item_product_id, oi.order_item_subtotal
FROM orders o 
CROSS JOIN order_items oi
LIMIT 100;

SELECT COUNT(1)
FROM orders o CROSS JOIN order_items oi;
````

### OVERVIEW OF SET OPERATIONS
````text
beeline -u jdbc:hive2://localhost:10000/training_retail

CREATE TABLE orders_2013_08_to_2013_11 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
AS SELECT * FROM orders
WHERE order_date BETWEEN '2013-08-01 00:00:00.0' AND
                         '2013-11-30 00:00:00.0';

SELECT * 
FROM orders_2013_08_to_2013_11 
LIMIT 10;

SELECT * 
FROM orders_2013_08_to_2013_11 
WHERE order_date = '2013-08-01 00:00:00.0';

SELECT order_date, COUNT(1) 
FROM orders_2013_08_to_2013_11
GROUP BY order_date;

SELECT DATE_FORMAT(order_date, 'YYYYMM'), COUNT(1) 
FROM orders_2013_08_to_2013_11
GROUP BY DATE_FORMAT(order_date, 'YYYYMM');

SELECT DATE_FORMAT(order_date, 'YYYYMM'), COUNT(1) 
FROM orders
GROUP BY DATE_FORMAT(order_date, 'YYYYMM');


CREATE TABLE orders_2013_09_to_2013_12 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
AS SELECT * FROM orders
WHERE order_date >= '2013-09-01 00:00:00.0' AND
      order_date <= '2013-12-31 00:00:00.0';

SELECT DATE_FORMAT(order_date, 'YYYYMM'), COUNT(1) 
FROM orders_2013_09_to_2013_12
GROUP BY DATE_FORMAT(order_date, 'YYYYMM');

SELECT DATE_FORMAT(order_date, 'YYYYMM'), COUNT(1) 
FROM orders
GROUP BY DATE_FORMAT(order_date, 'YYYYMM');
````

### PERFORM UNION BETWEEN TWO DATASETS
````text
-- UNION, UNION ALL, UNION DISTINCT

SELECT c1,c2,c3 FROM table1
UNION
SELECT e1,e2,e3 FROM table2
UNION
SELECT f1,f2,f3 FROM table3;


SELECT COUNT(1) FROM orders_2013_08_to_2013_11
UNION ALL
SELECT COUNT(1) FROM orders_2013_09_to_2013_12;

SELECT 'orders_2013_08_to_2013_11',COUNT(1) FROM orders_2013_08_to_2013_11
UNION ALL
SELECT 'orders_2013_09_to_2013_12',COUNT(1) FROM orders_2013_09_to_2013_12;

SELECT order_id, order_date, order_status FROM orders_2013_08_to_2013_11
UNION
SELECT order_id, order_date, order_status FROM orders_2013_09_to_2013_12;

SELECT order_id, order_date, order_status FROM orders_2013_08_to_2013_11
UNION ALL
SELECT order_id, order_date, order_status FROM orders_2013_09_to_2013_12;

SELECT * FROM (
SELECT order_id, order_date, order_status FROM orders_2013_08_to_2013_11
UNION
SELECT order_id, order_date, order_status FROM orders_2013_09_to_2013_12) q
LIMIT 10;

SELECT COUNT(*) AS count_ast FROM (
SELECT order_id, order_date, order_status FROM orders_2013_08_to_2013_11
UNION
SELECT order_id, order_date, order_status FROM orders_2013_09_to_2013_12) q;

SELECT COUNT(*) AS count_ast FROM (
SELECT order_id, order_date, order_status FROM orders_2013_08_to_2013_11
UNION ALL
SELECT order_id, order_date, order_status FROM orders_2013_09_to_2013_12) q;
````

### NOT SUPPORTED - PERFORM INTERSECTION OR MINUS
````text
# SUPPORTED UNION
# NOT SUPPORTED INTERSECTION and MINUS

-- This query will fail
SELECT * FROM orders_2013_08_to_2013_11
INTERSECT
SELECT * FROM orders_2013_09_to_2013_12;

-- This query will fail
SELECT * FROM orders_2013_08_to_2013_11
MINUS
SELECT * FROM orders_2013_09_to_2013_12;
````
































