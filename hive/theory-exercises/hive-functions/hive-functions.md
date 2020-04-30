### OVERVIEW OF FUNCTIONS
````text
Let us get overview of functions in Hive.

We can get list of functions by running SHOW functions
We can use DESCRIBE command to get the syntax and symantecs of a function - DESCRIBE FUNCTION substr
Following are the categories of functions that are more commonly used.
    String Manipulation
    Date Manipulation
    Numeric Functions
    Type Conversion Functions
    CASE and WHEN
    and more
````
````iso92-sql
-- $ beeline -u jdbc:hive2://localhost:10000/

SHOW FUNCTIONS;

DESCRIBE FUNCTION substr;

DESCRIBE FUNCTION substring;
````

### VALIDATING FUNCTIONS
````text
Let us see how we can validate Hive functions.

Hive follows MySQL style. To validate functions we can just use SELECT clause - e. g.: SELECT current_date;
Another example - SELECT substr('Hello World', 1, 5);
If you want to use Oracle style, you can create table by name dual and insert one record.
````
````iso92-sql
USE training_retail;
CREATE TABLE dual (dummy STRING);
INSERT INTO dual VALUES ('X');

SELECT current_date FROM dual;
SELECT substr('Hello World', 1, 5) FROM dual;

-- $ beeline -u jdbc:hive2://localhost:10000/training_retail

CREATE TABLE dual(dummy STRING);

INSERT INTO dual VALUES('x');

SELECT current_date FROM dual;
SELECT substr('Hello World',1,5) FROM dual;
````

### STRING MANIPULATION - CASE CONVERSION AND LENGTH
````text
Let us understand how to perform case conversion functions of a string and also length of a string.

Case Conversion Functions - lower, upper, initcap
Getting length - length
````
````iso92-sql
SELECT lower('hEllo wOrlD');
SELECT upper('hEllo wOrlD');

DESCRIBE FUNCTION initcap;

-- initcap(str) - Returns str, with the first letter of each word in uppercase, all other letters in lowercase. 
--Words are delimited by white space.

SELECT initcap('hEllo wOrlD');
SELECT length('hEllo wOrlD');
````
````text
Let us see how to use these functions on top of the table. 
We will use orders table which was loaded as part of last section.

order_status for some of the orders is in lower case and we will convert every thing to upper case.
````
````iso92-sql
SET hive.txn.manager=org.apache.hadoop.hive.ql.lockmgr.DbTxnManager;
SET hive.support.concurrency=true;
SELECT * FROM orders LIMIT 10;
SELECT order_id, order_date, order_customer_id,
  upper(order_status) AS order_status
FROM orders LIMIT 10;

CREATE TABLE orders(
 order_id INT,
 order_date STRING,
 order_customer_id INT,
 order_status STRING
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
  STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/training/CCA159DataAnalyst/data/retail_db/orders' INTO TABLE orders;

SELECT order_id, order_date, order_customer_id, 
       UPPER(order_status) AS order_status
FROM orders
LIMIT 10;
````

### STRING MANIPULATION - SUBSTR AND SPLIT
````text
Let us understand how to extract data from strings using substr/substring and split.

We can get syntax and symantecs of the functions using DESCRIBE FUNCTION
We can extract first four characters from string using substr or substring.
````
````iso92-sql
SELECT substr('2013-07-25 00:00:00.0', 1, 4);
SELECT substr('2013-07-25 00:00:00.0', 6, 2);
SELECT substr('2013-07-25 00:00:00.0', 9, 2);
SELECT substr('2013-07-25 00:00:00.0', 12);

-- Let us see how we can extract date part from order_date of orders.

SELECT order_id,
  substr(order_date, 1, 10) AS order_date,
  order_customer_id,
  order_status
FROM orders_part LIMIT 10;

-- Let us understand how to extract the information from the string where there is a delimiter.
-- split converts delimited string into array.

SELECT split('2013-07-25', '-')[1];

-- We can use explode to convert an array into records.

SELECT explode(split('2013-07-25', '-'));


-- $ beeline -u jdbc:hive2://localhost:10000/training_retail

SELECT order_id, SUBSTR(order_date,1,10) AS order_date, order_customer_id, order_status
FROM orders LIMIT 10;

SELECT split('2020-07-17','-');
SELECT split('2020-07-17','-')[0];
SELECT split('2020-07-17','-')[1];
SELECT split('2020-07-17','-')[2];

SELECT explode(split('2020-07-17','-'));
````

### STRING MANIPULATION - TRIMMING AND PADDING FUNCTIONS
````text
Let us understand how to trim or remove leading and/or trailing spaces in a string.

ltrim is used to remove the spaces on the left side of the string.
rtrim is used to remove the spaces on the right side of the string.
trim is used to remove the spaces on both side of the string.
````
````iso92-sql
SELECT ltrim('     Hello World');
SELECT rtrim('     Hello World       ');
SELECT trim('      Hello Workd       ');
SELECT length(trim('     Hello World       '));
````
````text
Let us understand how to use padding to pad characters to a string.

Let us assume that there are 3 fields - year, month and date which are of type integer.
If we have to concatenate all the 3 fields and create a date, we might have to pad month and date with 0.
````
````iso92-sql
SELECT 2013 AS year, 7 AS month, 25 AS myDate;
SELECT lpad(7, 2, 0);
SELECT lpad(10, 2, 0);
SELECT lpad(100, 2, 0);


-- $ beeline -u jdbc:hive2://localhost:10000/training_retail

DESCRIBE FUNCTION ltrim;
DESCRIBE FUNCTION rtrim;

SELECT ltrim('     Hello World');
SELECT rtrim('     Hello World       ');
SELECT trim('      Hello Workd       ');
SELECT length(trim('     Hello World       '));

DESCRIBE FUNCTION lpad;
DESCRIBE FUNCTION rpad;

SELECT 2013 AS year, 7 AS month, 25 AS myDate;
SELECT lpad(7, 2, 0);
SELECT lpad(10, 2, 0);
SELECT lpad(100, 2, 0);
SELECT rpad('p',4,'a');
````