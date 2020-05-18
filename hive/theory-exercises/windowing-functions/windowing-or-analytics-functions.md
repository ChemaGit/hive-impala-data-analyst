### PREPARE HR DATABASE WITH EMPLOYEES TABLE
````text
CREATE DATABASE training_hr;

USE training_hr;

CREATE TABLE employees (
  employee_id     int,
  first_name      varchar(20),
  last_name       varchar(25),
  email           varchar(25),
  phone_number    varchar(20),
  hire_date       string,
  job_id          varchar(10),
  salary          double,
  commission_pct  double,
  manager_id      int,
  department_id   int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INPATH '/home/training/files/employee.csv' INTO TABLE employees;

SET hive.cli.print.header=true;

SELECT * FROM employees LIMIT 30;
````

### OVERVIEW OF ANALYTICS FUNCTIONS OR WINDOWING FUNCTIONS
````text
Let us get an overview of Analytics or Windowing Functions in Hive.

Aggregate Functions (sum, min, max, avg)
Window Functions (lead, lag, first_value, last_value)
Rank Functions (rank, dense_rank, row_number etc)
For all the functions we use OVER
For aggregate functions we typically use PARTITION BY
For ranking and windowing functions we might use ORDER BY or PARTITION BY partition_column ORDER BY sorting_column.
````

### PERFORMING AGGREGATIONS USING WINDOWING FUNCTIONS
````text
Let us see how we can perform aggregations with in a key using Windowing/Analytics Functions.

    For simple aggregations where we have to get grouping key and aggregateed results we can use GROUP BY.
    If we want to get the raw data along with aggregated results, then using GROUP BY is not possible or overly complicated.
    Instead we can use aggregate functions with OVER Clause.
    Let us take an example of getting employee salary percentage when compared to department salary expense.

Let us write the query using GROUP BY approach. This query will not work in Hive, but might work in traditional Databases.

SELECT department_id,
       sum(salary) AS department_salary_expense
FROM employees
GROUP BY department_id;

SELECT e.employee_id, e.department_id, e.salary,
       ae.department_salary_expense
FROM employees e JOIN (
     SELECT department_id, 
            sum(salary) AS department_salary_expense
     FROM employees
     GROUP BY department_id
) ae
ON e.department_id = ae.department_id;

WITH ae AS
(SELECT department_id, sum(salary) AS department_salary_expense
 FROM employees
 GROUP BY department_id)
SELECT e.employee_id, e.department_id, e.salary, ae.department_id,
       ae.department_salary_expense
FROM employees e JOIN ae ON e.department_id = ae.department_id;

Let us see how we can get it using Analytics/Windowing Functions.

SELECT e.employee_id, e.department_id, e.salary,
       sum(e.salary) 
         OVER (PARTITION BY e.department_id)
         AS department_salary_expense
FROM employees e
ORDER BY e.department_id;

SELECT e.employee_id, e.department_id, e.salary,
       SUM(e.salary) 
         OVER (PARTITION BY e.department_id)
         AS department_salary_expense,
       ROUND( (e.salary/SUM(e.salary) OVER (PARTITION BY e.department_id)) * 100, 2) AS pct_expense
FROM employees e
ORDER BY e.department_id;

SELECT e.employee_id, e.department_id, e.salary,
       SUM(e.salary) 
         OVER (PARTITION BY e.department_id)
         AS department_salary_expense,
       ROUND( (e.salary/SUM(e.salary) OVER (PARTITION BY e.department_id)) * 100, 2) AS pct_expense,
       ROUND( AVG(e.salary) OVER (PARTITION BY e.department_id), 2) AS avg_expense
FROM employees e
ORDER BY e.department_id;
````

### CREATE TABLES TO GET DAILY REVENUE AND DAILY PRODUCT REVENUE
````text
Let us create couple of tables which will be used for the demonstrations of Windowing and Ranking functions.

We have ORDERS and ORDER_ITEMS tables.
Let us take care of computing daily revenue as well as daily product revenue.
As we will be using same data set several times, let us create the tables to pre compute the data.
daily_revenue will have the order_date and revenue, where data is aggregated using order_date as key.
daily_product_revenue will have order_date, order_item_product_id and revenue. 
In this case data is aggregated using order_date and order_item_product_id as keys.

Let us create table to compute daily revenue.

USE training_retail;

CREATE TABLE daily_revenue
AS
SELECT o.order_date,
       round(sum(oi.order_item_subtotal), 2) AS revenue
FROM orders o JOIN order_items oi
ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY o.order_date;

Let us create table to compute daily product revenue.

USE training_retail;

CREATE TABLE daily_product_revenue
AS
SELECT o.order_date,
       oi.order_item_product_id,
       round(sum(oi.order_item_subtotal), 2) AS revenue
FROM orders o JOIN order_items oi
ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY o.order_date, oi.order_item_product_id;
````

### GETTING LEAD AND LAG USING WINDOWING FUNCTIONS - ORDER BY
````text
Let us understand LEAD and LAG functions to get column values from following or prior rows.

Here is the example where we can get prior or following records based on ORDER BY Clause.

USE training_retail;

SELECT * FROM daily_revenue
ORDER BY order_date DESC
LIMIT 10;

SELECT t.*,
  lead(order_date) OVER (ORDER BY order_date DESC) AS prior_date,
  lead(daily_revenue) OVER (ORDER BY order_date DESC) AS prior_revenue,
  lag(daily_revenue) OVER (ORDER BY order_date ASC) AS same_as_prior_revenue
FROM daily_revenue t
LIMIT 10;

We can also pass number of rows as well as default values for nulls as arguments.

USE training_retail;

SELECT t.*,
  lead(order_date, 7) OVER (ORDER BY order_date DESC) AS prior_date,
  lead(daily_revenue, 7) OVER (ORDER BY order_date DESC) AS prior_revenue,
  lag(daily_revenue, 7) OVER (ORDER BY order_date ASC) AS same_as_prior_revenue
FROM daily_revenue t
LIMIT 10;

SELECT t.*,
  lead(order_date, 7) OVER (ORDER BY order_date DESC) AS prior_date,
  lead(daily_revenue, 7) OVER (ORDER BY order_date DESC) AS prior_revenue,
  lag(daily_revenue, 7) OVER (ORDER BY order_date ASC) AS same_as_prior_revenue
FROM daily_revenue t;

SELECT t.*,
  lead(order_date, 7) OVER (ORDER BY order_date DESC) AS prior_date,
  lead(daily_revenue, 7, 0) OVER (ORDER BY order_date DESC) AS prior_revenue,
  lag(daily_revenue, 7, 0) OVER (ORDER BY order_date ASC) AS same_as_prior_revenue
FROM daily_revenue t;
````

### GETTING LEAD AND LAG USING WINDOWING FUNCTIONS - ORDER BY AND PARTITION BY
````text
Let us see how we can get prior or following records with in a group based on particular order.

Here is the example where we can get prior or following records based on PARTITION BY and then ORDER BY Clause.

USE training_retail;
DESCRIBE daily_product_revenue;
SELECT * FROM daily_product_revenue LIMIT 10;

SELECT t.*,
  LEAD(order_item_product_id) OVER (
    PARTITION BY order_date ORDER BY revenue DESC
  ) next_order_item_product_id,
  LEAD(revenue) OVER (
    PARTITION BY order_date ORDER BY revenue DESC
  ) next_revenue
FROM daily_product_revenue t
LIMIT 100;

We can also pass number of rows as well as default values for nulls as arguments.

USE training_retail;

SELECT t.*,
  LEAD(order_item_product_id) OVER (
    PARTITION BY order_date ORDER BY revenue DESC
  ) next_order_item_product_id,
  LEAD(revenue, 1, 0) OVER (
    PARTITION BY order_date ORDER BY revenue DESC
  ) next_revenue
FROM daily_product_revenue t
LIMIT 100;
````

### WINDOWING FUNCTIONS - USING FIRST_VALUE AND LAST_VALUE
````text
Let us see how we can get first and last value based on the criteria. We can also use min or max as well.

Here is the example of using first_value.

USE training_retail;

DESCRIBE daily_product_revenue;

SELECT * FROM daily_product_revenue LIMIT 10;

SELECT t.*,
  first_value(order_item_product_id) OVER (
    PARTITION BY order_date ORDER BY revenue DESC
  ) first_order_item_product_id,
  first_value(revenue) OVER (
    PARTITION BY order_date ORDER BY revenue DESC
  ) first_revenue
FROM daily_product_revenue t
LIMIT 100;

Let us see an example with last_value. While using last_value we need to specify ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING/PRECEEDING

USE training_retail;

SELECT t.*,
  last_value(order_item_product_id) OVER (
    PARTITION BY order_date ORDER BY revenue
    ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
  ) last_order_item_product_id,
  last_value(revenue) OVER (
    PARTITION BY order_date ORDER BY revenue
    ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
  )  last_revenue
FROM daily_product_revenue AS t
ORDER BY order_date, revenue DESC
LIMIT 100;
````

### APPLYING RANK FUNCTION
````text
Let us see how we can get sparse ranks using rank function.

If we have to get ranks globally, we just need to specify ORDER BY
If we have to get ranks with in a key then we need to specify PARTITION BY and then ORDER BY.
By default ORDER BY will sort the data in ascending order. 
We can change the order by passing DESC after order by.

Here is an example to assign sparse ranks using daily_product_revenue with in each day based on revenue.

USE training_retail;

SELECT t.*,
  rank() OVER (
    PARTITION BY order_date
    ORDER BY revenue DESC
  ) AS rnk
FROM daily_product_revenue t
ORDER BY order_date, revenue DESC
LIMIT 100;

Here is another example to assign sparse ranks using employees data set with in each department.

USE training_hr;

SELECT
  employee_id,
  department_id,
  salary,
  rank() OVER (
    PARTITION BY department_id
    ORDER BY salary DESC
  ) rnk
FROM employees
ORDER BY department_id, salary DESC;
````

### APPLYING DENSE_RANK USING WINDOWING FUNCTIONS
````text
Let us see how we can get dense ranks using dense_rank function.

If we have to get ranks globally, we just need to specify ORDER BY
If we have to get ranks with in a key then we need to specify PARTITION BY and then ORDER BY.
By default ORDER BY will sort the data in ascending order. 
We can change the order by passing DESC after order by.

Here is an example to assign dense ranks using daily_product_revenue with in each day based on revenue.

impala-shell -i localhost:21000
beeline -u jdbc:hive2://localhost/training_retail

USE training_retail;

DESCRIBE daily_product_revenue;
SELECT * 
FROM daily_product_revenue
LIMIT 10;

SELECT t.*,
  dense_rank() OVER (
    PARTITION BY order_date
    ORDER BY revenue DESC
  ) AS drnk
FROM daily_product_revenue t
ORDER BY order_date, revenue DESC
LIMIT 100;

Here is another example to assign dense ranks using employees data set with in each department.

USE training_hr;

DESCRIBE employees;

SELECT *
FROM employees
LIMIT 10;

SELECT
  employee_id,
  department_id,
  salary,
  dense_rank() OVER (
    PARTITION BY department_id
    ORDER BY salary DESC
  ) drnk
FROM employees
ORDER BY department_id, salary DESC;
````

### APPLYING ROW_NUMBER USING WINDOWING FUNCTION
````text
Let us see how we can assign row numbers using row_number function.

If we have to get ranks globally, we just need to specify ORDER BY
If we have to get ranks with in a key then we need to specify PARTITION BY and then ORDER BY.
By default ORDER BY will sort the data in ascending order. 
We can change the order by passing DESC after order by.

Here is an example to assign row numbers using daily_product_revenue with in each day based on revenue.

imapala-shell -i localhost:21000
beeline jdbc:hive2://localhost/training_retail

USE training_retail;

DESCRIBE daily_product_revenue;
SELECT *
FROM daily_product_revenue
LIMIT 10;

SELECT t.*,
  row_number() OVER (
    PARTITION BY order_date
    ORDER BY revenue DESC
  ) AS rn
FROM daily_product_revenue t
ORDER BY order_date, revenue DESC
LIMIT 100;

Here is another example to assign row numbers using employees data set with in each department.

USE training_hr;

SELECT
  employee_id,
  department_id,
  salary,
  row_number() OVER (
    PARTITION BY department_id
    ORDER BY salary DESC
  ) rn
FROM employees
ORDER BY department_id, salary DESC;
````

### DIFFERENCE BETWEEN RANK, DENSE_RANK AND ROW_NUMBER
````text
Let us understand the difference between rank, dense_rank and row_number.

We can either of the functions to generate ranks 
when the rank field does not have duplicates.
When rank field have duplicates then row_number should not be used as 
it generate unique number for each record with in the partition.
rank will skip the ranks in between if multiple people get 
the same rank while dense_rank continue with the next number.

There won’t be any difference when sorted field have unique values.

beeline -u jdbc:hive2://localhost:10000
impala-shell -i localhost

USE training_retail;

SELECT t.*,
  rank() OVER (
    PARTITION BY order_date ORDER BY revenue DESC) AS rnk,
  dense_rank() OVER (
    PARTITION BY order_date ORDER BY revenue DESC) AS drnk,
  row_number() OVER (
    PARTITION BY order_date ORDER BY revenue DESC) AS rn
FROM daily_product_revenue t
ORDER BY order_date, revenue DESC
LIMIT 100;

We should not use row_number for ranking when there are redundant values in sorted field.

USE training_hr;

SELECT
  employee_id,
  department_id,
  salary,
  rank() OVER (
    PARTITION BY department_id ORDER BY salary DESC) rnk,
  dense_rank() OVER (
    PARTITION BY department_id ORDER BY salary DESC) drnk,
  row_number() OVER (
    PARTITION BY department_id ORDER BY salary DESC) rn
FROM employees
ORDER BY department_id, salary DESC;
````
### UNDERSTANDING ORDER OF EXECUTION
````text
Let us review the order of execution of SQL. First let us review the order of writing the query.

SELECT
FROM
JOIN or OUTER JOIN with ON
WHERE
GROUP BY and optionally HAVING
ORDER BY

Let us come up with a query which will compute daily revenue using COMPLETE or CLOSED orders and also ordered by order_date.

beeline -u jdbc:hive2://localhost:10000
impala-shell -i localhost:21000

USE training_retail;

DESCRIBE orders;

SELECT order_date, count(1)
FROM orders
GROUP BY order_date
ORDER BY order_date
LIMIT 10;;

SELECT o.order_date,
  round(sum(oi.order_item_order_id), 2) AS revenue
FROM orders o JOIN order_items oi
ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY o.order_date
ORDER BY o.order_date
LIMIT 10;

However order of execution is different.

    FROM
    JOIN or OUTER JOIN with ON
    WHERE
    GROUP BY and optionally HAVING
    SELECT
    ORDER BY

As SELECT is executed before ORDER BY Clause, we will not be able to refer the aliases in SELECT in other clauses except for ORDER BY.
````

### QUICK RECAP OF NESTED SUB-QUERIES
````text
Let us recap about Nested Sub Queries.

We typically have Nested Sub Queries in FROM Clause.
We need to provide alias to the Nested Sub Queries in FROM Clause in Hive.
We use nested queries quite often over queries using Analytics/Windowing Functions

beeline -u jdbc:hive2://localhost:10000
impala-shell -i localhost:21000

WITH q AS (SELECT current_date AS date)
SELECT date FROM q;

SELECT * FROM (SELECT current_date AS date) q;

Let us see few more examples with respected to Nested Sub Queries.

USE training_retail;

WITH q AS
(SELECT order_date, COUNT(1) AS order_count
FROM orders
GROUP BY order_date)
SELECT * 
FROM q
LIMIT 10;

SELECT * FROM (
  SELECT order_date, count(1) AS order_count
  FROM orders
  GROUP BY order_date
) q
LIMIT 10;

WITH q AS(
SELECT order_date, COUNT(1) AS order_count
FROM orders
GROUP BY order_date)
SELECT * 
FROM q
WHERE order_count > 0;

SELECT * FROM (
  SELECT order_date, count(1) AS order_count
  FROM orders
  GROUP BY order_date
) q
WHERE q.order_count > 0;

-- We can achieve using HAVING clause (no need to be nested to filter)
````

### FILTERING DATA USING FIELDS DERIVED USING ANALYTICS OR WINDOWING FUNCTIONS
````text
impala-shell -i localhost:21000
beeline -u jdbc:hive2://localhost:10000

USE training_retail;

SELECT t.*,
RANK() OVER (PARTITION BY order_date ORDER BY revenue DESC) AS rnk
FROM daily_product_revenue t
ORDER BY order_date, revenue DESC
LIMIT 100;

WITH ranked AS (
SELECT t.*,
RANK() OVER (PARTITION BY order_date ORDER BY revenue DESC) AS rnk
FROM daily_product_revenue t
ORDER BY order_date, revenue DESC
LIMIT 100)
SELECT *
FROM ranked
WHERE rnk <= 5
ORDER BY order_date, revenue;
````
