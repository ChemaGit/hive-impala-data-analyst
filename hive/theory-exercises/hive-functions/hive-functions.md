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
### STRING MANIPULATION - REVERSE AND CONCATENATING MULTIPLE STRINGS
````text
Let us understand how to reverse a string as well as concatenate multiple strings.

reverse is used to reverse the string.
We can use concat function to concatenate multiple strings.
````
````iso92-sql
SELECT reverse('Hello World');

SELECT concat('Hello ', 'World');

SELECT concat('Order Status is ', order_status)
FROM orders_part LIMIT 10;

SELECT * 
FROM (SELECT 2013 AS year, 7 AS month, 25 AS myDate) q;

SELECT concat(year, '-', lpad(month, 2, 0), '-',
              lpad(myDate, 2, 0)) AS order_date
FROM
(SELECT 2013 AS year, 7 AS month, 25 AS myDate) q;

$ beeline -u jdbc:hive2://localhost:10000/training_reatail

DESCRIBE FUNCTION reverse;

SELECT reverse('Hello World');

DESCRIBE FUNCTION concat;

SELECT concat('Hello ', 'World');

SELECT concat('Order Status is ', order_status)
FROM orders LIMIT 10;

SELECT * FROM (SELECT 2013 AS year, 7 AS month, 25 AS myDate) q;

SELECT concat(year, '-', lpad(month, 2, 0), '-',
              lpad(myDate, 2, 0)) AS order_date
FROM (SELECT 2013 AS year, 7 AS month, 25 AS myDate) q;
````

### DATE MANIPULATION - GETTING CURRENT DATE AND TIMESTAMP
````text
Let us understand how to get the details about current or today’s date as well as current timestamp.

current_date is the function or operator which will return today’s date.
current_timestamp is the function or operator which will return current time up to milliseconds.
These are not like other functions and do not use () at the end.
These are not listed as part of SHOW functions and we can get help using DESCRIBE
````

````iso92-sql
SELECT current_date;
SELECT current_timestamp;

$ beeline -u jdbc:hive2://localhost:10000/training_retail

SHOW FUNCTIONS;
DESCRIBE current_date;
DESCRIBE current_timestamp;

SELECT current_date;
SELECT current_timestamp;
````

### DATE MANIPULATION - DATE ARITHMETIC
````text
Let us understand how to perform arithmetic on dates or timestamps.

date_add can be used to add or subtract days.
days_sub can be used to subtract or add days.
datediff can be used to get difference between 2 dates
add_months can be used add months to a date
````
````iso92-sql
SELECT date_add(current_date, 32);

SELECT date_add('2018-04-15', 730);

SELECT date_add('2018-04-15', -730);

SELECT date_sub(current_date, 30);

SELECT datediff('2019-03-30', '2017-12-31');

SELECT add_months(current_date, 3);

SELECT add_months('2019-01-31', 1);

SELECT add_months('2019-05-31', 1);

SELECT add_months(current_timestamp, 3);

SELECT date_add(current_timestamp, -730);

$ beeline -u jdbc:hive2://localhost:10000/training_retail

DESCRIBE FUNCTION date_add;

SELECT date_add(current_date, 32);
SELECT date_add('2018-04-15', 730);
SELECT date_add('2018-04-15', -730);

DESCRIBE function date_sub;

SELECT date_sub(current_date, 30);

DESCRIBE FUNCTION datediff;

SELECT datediff('2019-03-30', '2017-12-31');

DESCRIBE FUNCTION add_months;

SELECT add_months(current_date, 3);
SELECT add_months('2019-01-31', 1);
SELECT add_months('2019-05-31', 1);
SELECT add_months(current_timestamp, 3);

SELECT date_add(current_timestamp, -730);
````

### DATE MANIPULATION - TRUNC
````text
Let us understand how to use trunc on dates or timestamps and get beginning date of the period.

We can use MM to get beginning date of the month.
YY can be used to get begining date of the year.
We can apply trunc either on date or timestamp, however we cannot apply it other than month or year (such an hour or day).

DESCRIBE FUNCTION trunc;

SELECT trunc(current_date, 'MM');
SELECT trunc('2019-01-23', 'MM');
SELECT trunc(current_date, 'YY');
SELECT trunc(current_timestamp, 'HH'); // will not work


$ beeline -u jdbc:hive2://localhost:10000/training_retail

DESCRIBE FUNCTION trunc;

SELECT trunc(current_date);
SELECT trunc(current_date, 'MM');
SELECT trunc('2019-01-23', 'MM');
SELECT trunc(current_date, 'YY');
SELECT trunc(current_timestamp, 'HH'); // will not work
````

### DATE MANIPULATION - EXTRACTING INFORMATION USING DATE_FORMAT
````text
Let us understand how to use date_format to extract information from date or timestamp.

Here is how we can get date related information such as year, month, day etc from date or timestamp.

DESCRIBE FUNCTION date_format;

SELECT current_timestamp;
SELECT current_timestamp, date_format(current_timestamp, 'YYYY');
SELECT current_timestamp, date_format(current_timestamp, 'YY');
SELECT current_timestamp, date_format(current_timestamp, 'MM');
SELECT current_timestamp, date_format(current_timestamp, 'dd');
SELECT current_timestamp, date_format(current_timestamp, 'DD');

Here is how we can get time related information such as hour, minute, seconds, milliseconds etc from timestamp.

SELECT current_timestamp, date_format(current_timestamp, 'HH');
SELECT current_timestamp, date_format(current_timestamp, 'hh');
SELECT current_timestamp, date_format(current_timestamp, 'mm');
SELECT current_timestamp, date_format(current_timestamp, 'ss');
SELECT current_timestamp, date_format(current_timestamp, 'SS'); // milliseconds

Here is how we can get the information from date or timestamp in the format we require.

SELECT date_format(current_timestamp, 'YYYYMM');
SELECT date_format(current_timestamp, 'YYYYMMdd');
SELECT date_format(current_timestamp, 'YYYY/MM/dd');

$ beeline -u jdbc:hive2://localhost:10000/training_retail

DESCRIBE FUNCTION date_format;

SELECT current_timestamp;
SELECT current_timestamp, date_format(current_timestamp, 'YYYY');
SELECT current_timestamp, date_format(current_timestamp, 'YY');
SELECT current_timestamp, date_format(current_timestamp, 'MM');
SELECT current_timestamp, date_format(current_timestamp, 'dd');
SELECT current_timestamp, date_format(current_timestamp, 'DD');

SELECT current_timestamp, date_format(current_timestamp, 'HH');
SELECT current_timestamp, date_format(current_timestamp, 'hh');
SELECT current_timestamp, date_format(current_timestamp, 'mm');
SELECT current_timestamp, date_format(current_timestamp, 'ss');
SELECT current_timestamp, date_format(current_timestamp, 'SS'); // milliseconds

SELECT date_format(current_timestamp, 'YYYYMM');
SELECT date_format(current_timestamp, 'YYYYMMdd');
SELECT date_format(current_timestamp, 'YYYY/MM/dd');
````

### DATE MANIPULATION - EXTRACTING INFORMATION USING YEAR, MONTH, DAY, ETC
````text
$ beeline -u jdbc:hive2://localhost:10000/training_retail

We can get year, month, day etc from date or timestamp using functions. 
There are functions such as day, dayofmonth, month, weekofyear, year etc available for us.

DESCRIBE FUNCTION day;
DESCRIBE FUNCTION dayofmonth;
DESCRIBE FUNCTION month;
DESCRIBE FUNCTION weekofyear;
DESCRIBE FUNCTION year;

Let us see the usage of the functions such as day, dayofmonth, month, weekofyear, year etc.

SELECT year(current_date);
SELECT month(current_date);
SELECT weekofyear(current_date);
SELECT day(current_date);
SELECT dayofmonth(current_date);
````
### DATE MANIPULATION - DEALING WITH UNIX TIMESTAMP
````text
$ beeline -u jdbc:hive2://localhost:10000/training_retail

Let us see how we can use functions such as from_unixtime, unix_timestamp 
or to_unix_timestamp to convert between timestamp and Unix timestamp or epoch.

We can unix epoch in Unix/Linux terminal using date '+%s'

SELECT from_unixtime(1556662731);
SELECT to_unix_timestamp('2019-04-30 18:18:51');

SELECT from_unixtime(1556662731, 'YYYYMM');
SELECT from_unixtime(1556662731, 'YYYY-MM-dd');
SELECT from_unixtime(1556662731, 'YYYY-MM-dd HH:mm:ss');

SELECT to_unix_timestamp('20190430 18:18:51', 'YYYYMMdd');
SELECT to_unix_timestamp('20190430 18:18:51', 'YYYYMMdd HH:mm:ss');
````
### OVERVIEW OF NUMERIC FUNCTIONS
````text
$ beeline -u jdbc:hive2://localhost:10000/training_retail

Here are some of the numeric functions we might use quite often.

    abs
    sum, avg
    round
    ceil, floor
    greatest, min, max
    rand
    pow, sqrt
    cumedist, stddev, variance

Some of the functions highlighted are aggregate functions, eg: sum, avg etc.

+--------------------------+------------+------+-----+---------+----------------+
| Field                    | Type       | Null | Key | Default | Extra          |
+--------------------------+------------+------+-----+---------+----------------+
| order_item_id            | int(11)    | NO   | PRI | NULL    | auto_increment |
| order_item_order_id      | int(11)    | NO   |     | NULL    |                |
| order_item_product_id    | int(11)    | NO   |     | NULL    |                |
| order_item_quantity      | tinyint(4) | NO   |     | NULL    |                |
| order_item_subtotal      | float      | NO   |     | NULL    |                |
| order_item_product_price | float      | NO   |     | NULL    |                |
+--------------------------+------------+------+-----+---------+----------------+

CREATE TABLE order_items (
order_item_id INT,
order_item_order_id INT,
order_item_product_id INT,
order_item_quantity INT,
order_item_subtotal DOUBLE,
order_item_product_price DOUBLE
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/training/CCA159DataAnalyst/data/retail_db/order_items' INTO TABLE order_items;

SELECT avg(order_item_subtotal) FROM order_items
WHERE order_item_order_id = 2;

SELECT round(avg(order_item_subtotal), 2) FROM order_items
WHERE order_item_order_id = 2;

SELECT ceil(avg(order_item_subtotal)) FROM order_items
WHERE order_item_order_id = 2;

SELECT floor(avg(order_item_subtotal)) FROM order_items
WHERE order_item_order_id = 2;

SELECT pow(2, 3);

SELECT sqrt(16);

SELECT rand();

SELECT ceil(rand() * 10);
````

### TYPE CAST FUNCTIONS FOR DATA TYPE CONVERSION
````text
$ beeline -u jdbc:hive2://localhost:10000/training_retail

Let us understand how we can type cast to change the data type of extracted value to its original type.

SELECT current_date;
SELECT split(current_date, '-')[1];
SELECT cast(split(current_date, '-')[1] AS INT);
SELECT cast('0.04' AS FLOAT);
SELECT cast('0.04' AS INT); //0

SELECT CONCAT(0,4);
SELECT CAST(CONCAT(0,4) AS INT);
````

### HANDLING NULL VALUES
````text
SELECT 1 + NULL;

DESCRIBE FUNCTION nvl;

SELECT nvl(1, 0);
SELECT nvl(NULL, 0);
````



