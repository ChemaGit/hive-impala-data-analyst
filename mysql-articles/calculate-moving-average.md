### How to Calculate Moving Average in MySQL
````text
Many times you might need to calculate moving average in MySQL, 
also known as Simple Moving Average. E.g, average sales for past 5 days. In MySQL, 
there is no function to calculate moving average. 
So let’s see how to calculate moving average in MySQL using SQL query.

Here are the steps to calculate moving average in MySQL. 
Let’s say you have the following table that contains daily sales data
````

````mysql-sql
 create table sales(order_date date,sale int);

 insert into sales values('2020-01-01',20),
('2020-01-02',25),('2020-01-03',15),('2020-01-04',30),
('2020-01-05',20),('2020-01-10',20),('2020-01-06',25),
('2020-01-07',15),('2020-01-08',30),('2020-01-09',20);

 select * from sales;
+------------+------+
| order_date | sale |
+------------+------+
| 2020-01-01 |   20 |
| 2020-01-02 |   25 |
| 2020-01-03 |   15 |
| 2020-01-04 |   30 |
| 2020-01-05 |   20 |
| 2020-01-10 |   20 |
| 2020-01-06 |   25 |
| 2020-01-07 |   15 |
| 2020-01-08 |   30 |
| 2020-01-09 |   20 |
+------------+------+
````

````text
Let’s say you want to calculate the moving average sales for past 5 days. 
Here’s how you can do it using SQL query in MySQL.
````
````mysql-sql
SELECT
       a.order_date,
       a.sale,
       Round( ( SELECT SUM(b.sale) / COUNT(b.sale)
                FROM sales AS b
                WHERE DATEDIFF(a.order_date, b.order_date) BETWEEN 0 AND 4
              ), 2 ) AS '5dayMovingAvg'
     FROM sales AS a
     ORDER BY a.order_date;
+------------+------+---------------+
| order_date | sale | 5dayMovingAvg |
+------------+------+---------------+
| 2020-01-01 |   20 |         20.00 |
| 2020-01-02 |   25 |         22.50 |
| 2020-01-03 |   15 |         20.00 |
| 2020-01-04 |   30 |         22.50 |
| 2020-01-05 |   20 |         22.00 |
| 2020-01-06 |   25 |         23.00 |
| 2020-01-07 |   15 |         21.00 |
| 2020-01-08 |   30 |         24.00 |
| 2020-01-09 |   20 |         22.00 |
| 2020-01-10 |   20 |         22.00 |
+------------+------+---------------+
````

````text
In the above query, we do a self-join of our sales table with itself, 
and for each order_date value, we calculate the average based on sales data for its preceding 5 days. 
In our SQL query, the inner query does the average calculation, 
based on the sales data collected for each a.order_date’s time window(preceding 5 days) using datediff function.

If you want to change your time window, just change the part in bold (BETWEEN 0 and 4)in above query.
You can also add more filters by updating WHERE clause in the nested query.
You can customize the above query to calculate moving average in MySQL, as per your requirements.
````