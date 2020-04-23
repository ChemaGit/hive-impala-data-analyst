### Introduction to Joins
````text
- Join Syntax

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT * FROM toy.toys JOIN toy.makers ON toys.maker_id = makers.id'
$ impala-shell -q 'SELECT * FROM toy.toys JOIN toy.makers ON toys.maker_id = makers.id'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT toys.id AS id,toys.name AS toy,price,maker_id,makers.name AS maker,city FROM toy.toys JOIN toy.makers ON toys.maker_id = makers.id'
$ impala-shell -q 'SELECT toys.id AS id,toys.name AS toy,price,maker_id,makers.name AS maker,city FROM toy.toys JOIN toy.makers ON toys.maker_id = makers.id'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT t.id AS id,t.name AS toy,price,maker_id,m.name AS maker,city FROM toy.toys t JOIN toy.makers m ON t.maker_id = m.id'
$ impala-shell -q 'SELECT t.id AS id,t.name AS toy,price,maker_id,m.name AS maker,city FROM toy.toys t JOIN toy.makers m ON t.maker_id = m.id'
````
````iso92-sql
SELECT DISTINCT fly.flights.carrier, fly.flights.tailnum,fly.planes.manufacturer, fly.planes.model, fly.planes.year
FROM fly.flights 
JOIN fly.planes ON fly.flights.tailnum = fly.planes.tailnum;

SELECT DISTINCT carrier, f.tailnum AS tailnum, manufacturer, model, p.year AS year
FROM fly.flights f 
JOIN fly.planes p ON f.tailnum = p.tailnum;

SELECT t.name AS game, m.name AS maker
FROM toy.toys t 
JOIN toy.makers m ON t.maker_id = m.id
ORDER BY t.name DESC;

SELECT m.name AS maker, COUNT(*) AS number_of_toys
FROM toy.toys t 
JOIN toy.makers m ON t.maker_id = m.id
GROUP BY maker;
````

### Inner Joins
````text
$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT t.name AS toy,m.name AS maker FROM toy.toys t JOIN toy.makers m ON t.maker_id = m.id'
$ impala-shell -q 'SELECT t.name AS toy,m.name AS maker FROM toy.toys t JOIN toy.makers m ON t.maker_id = m.id'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT t.name AS toy,m.name AS maker FROM toy.toys t INNER JOIN toy.makers m ON t.maker_id = m.id'
$ impala-shell -q 'SELECT t.name AS toy,m.name AS maker FROM toy.toys t INNER JOIN toy.makers m ON t.maker_id = m.id'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT first_name, last_name, city FROM employees e INNER JOIN offices o ON e.office_id = o.office_id'
$ impala-shell -q 'SELECT first_name, last_name, city FROM employees e INNER JOIN offices o ON e.office_id = o.office_id'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT m.name AS maker, COUNT(*) AS number_of_toys FROM toy.toys t JOIN toy.makers m ON t.maker_id = m.id GROUP BY m.name'
$ impala-shell -q 'SELECT m.name AS maker, COUNT(*) AS number_of_toys FROM toy.toys t JOIN toy.makers m ON t.maker_id = m.id GROUP BY maker'
````

### Outer Joins
````text
$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT empl_id,first_name,o.office_id AS office_id,city FROM employees e INNER JOIN offices o ON e.office_id = o.office_id'
$ impala-shell -q 'SELECT empl_id,first_name,o.office_id AS office_id,city FROM employees e INNER JOIN offices o ON e.office_id = o.office_id'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT empl_id,first_name,o.office_id AS office_id,city FROM employees e LEFT OUTER JOIN offices o ON e.office_id = o.office_id'
$ impala-shell -q 'SELECT empl_id,first_name,o.office_id AS office_id,city FROM employees e LEFT OUTER JOIN offices o ON e.office_id = o.office_id'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT empl_id,first_name,e.office_id AS office_id,city FROM employees e LEFT OUTER JOIN offices o ON e.office_id = o.office_id'
$ impala-shell -q 'SELECT empl_id,first_name,e.office_id AS office_id,city FROM employees e LEFT OUTER JOIN offices o ON e.office_id = o.office_id'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT empl_id,first_name,e.office_id AS office_id,city FROM employees e RIGHT OUTER JOIN offices o ON e.office_id = o.office_id'
$ impala-shell -q 'SELECT empl_id,first_name,e.office_id AS office_id,city FROM employees e RIGHT OUTER JOIN offices o ON e.office_id = o.office_id'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT empl_id,first_name,o.office_id AS office_id,city FROM employees e RIGHT OUTER JOIN offices o ON e.office_id = o.office_id'
$ impala-shell -q 'SELECT empl_id,first_name,o.office_id AS office_id,city FROM employees e RIGHT OUTER JOIN offices o ON e.office_id = o.office_id'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT empl_id,first_name,o.office_id AS office_id,city FROM employees e FULL OUTER JOIN offices o ON e.office_id = o.office_id'
$ impala-shell -q 'SELECT empl_id,first_name,o.office_id AS office_id,city FROM employees e FULL OUTER JOIN offices o ON e.office_id = o.office_id'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT empl_id,first_name,e.office_id AS office_id,city FROM employees e FULL OUTER JOIN offices o ON e.office_id = o.office_id'
$ impala-shell -q 'SELECT empl_id,first_name,e.office_id AS office_id,city FROM employees e FULL OUTER JOIN offices o ON e.office_id = o.office_id'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT city,COUNT(e.empl_id) AS num_employees FROM offices o LEFT OUTER JOIN employees e ON o.office_id = e.office_id GROUP BY city'
$ impala-shell -q 'SELECT city,COUNT(e.empl_id) AS num_employees FROM offices o LEFT OUTER JOIN employees e ON o.office_id = e.office_id GROUP BY city'
````
### Alternative Join Sytax
````text
This reading describes alternative ways of expressing joins in SQL. 
We do not recommend using the techniques described in this reading, 
but you should familiarize yourself with them so you can read and understand SQL queries that use them.

SQL-92-Style Joins and SQL-89-Style Joins

the following join syntax is used:

SELECT ...
FROM toys JOIN makers ON toys.maker_id = makers.id;

Notice the JOIN keyword between the table names, and the ON keyword followed by the join condition. 
This is called a SQL-92-style join, or explicit join syntax, 
and it is usually considered to be the best syntax to use for joins in SQL.

However, many SQL engines also support another join syntax, called the SQL-89-style join, or implicit join syntax. 
In this syntax, you use a comma-separated list of table names in the FROM clause, 
and you specify the join condition in the WHERE clause:

SELECT ...
FROM toys, makers
WHERE toys.maker_id = makers.id;

With most SQL engines, this join query returns exactly the same result as the previous one.

With both join styles, you can use table aliases (t and m in this example):

SELECT ...
FROM toys AS t JOIN makers AS m ON t.maker_id = m.id;

SELECT ...
FROM toys AS t, makers AS m
WHERE t.maker_id = m.id;

With both styles, the AS keyword before each table alias is optional.

When you use a SQL-89-style join, the SQL engine always performs an inner join. 
With this syntax, there is no way to specify any other type of join. 
If you want to use one of the other types of joins (left outer, right outer, full outer), 
then you must use a SQL-92-style join. 
Because of this limitation, and because the SQL-89-style join syntax makes it harder to understand 
the intent of the query, we recommend using SQL-92-style joins.

- Unqualified Column References in Join Condition
  In the join condition that comes after the ON keyword in a join query, 
  the references to the corresponding columns are typically qualified with table names or table aliases. 
  For example, when joining the toys table (alias t) and makers table (alias m), the join condition is specified as:

  ON t.maker_id = m.id

  However, in the case where a bare column name unambiguously identifies a column, 
  most SQL engines allow you to use a bare column name. 
  For example, since there is no column named maker_id in the makers table, 
  the table alias t is not required in this join condition. So you could specify the join condition as:

 ON maker_id = m.id

 But because there are columns named id in both tables, the table alias m is required in this join condition. 
 If you omit the table alias m, then the SQL engine will throw an error indicating that the column reference id is ambiguous.

In join conditions, we recommend always qualifying column names with table names 
or table aliases, whether or not they are strictly required. 
Doing this makes your queries safer and clearer.

- The USING Keyword
  In some join queries, the names of the two corresponding columns in the join condition are identical. 
  For example, in this query, the corresponding columns in the employees and offices table are both named office_id:

SELECT …
FROM employees e JOIN offices o
ON e.office_id = o.office_id;

  When the corresponding columns in the join condition have identical names, 
  some SQL engines allow you to use a shorthand notation to specify the join condition. 
  Instead of using the ON keyword and specifying the condition as an equality expression, 
  you use the USING keyword and specify the common join key column name in parentheses after USING:

SELECT …
FROM employees e JOIN offices o
USING (office_id);

- Natural Joins
  When the corresponding columns in the join condition have identical names, 
  some SQL engines will allow you to omit the join condition, 
  and will automatically join the tables on all the pairs of columns that have identical names in the left and right tables. 
  To make a SQL engine do this, you need to specify the keyword NATURAL before the other join keywords. For example:

SELECT …
FROM employees e NATURAL JOIN offices o;

  MySQL and PostgreSQL support natural joins, but Hive and Impala do not. 
  In the SQL engines that support it, you can use the keyword NATURAL with any type of join; 
  for example: NATURAL LEFT OUTER JOIN or NATURAL INNER JOIN.

- Omitting Join Conditions
  What happens if you attempt to perform a join without specifying the join condition, 
  and you do not specify NATURAL before the join keywords?

  For example, you might run a query like this:

SELECT * 
FROM toys JOIN makers;

  Notice that no join condition is specified. With some SQL engines (including PostgreSQL), this throws an error. 
  But with other SQL engines (including Impala, Hive, and MySQL) this performs what’s called a cross join. 
  In a cross join, the SQL engine iterates through each row in the table on the left side 
  and combines it with every row in the table on the right side. 
  So the result set includes every possible combination of the rows in the left table and the rows in the right table. 
  The number of rows in the result set is the product (multiplication) of the number 
  of rows in the left table and the number of rows in the right table (in this example, 3 x 3 = 9): 

id	name	price	maker_id	id	name	city
21	Lite-Brite	14.47	105	105	Hasbro	Pawtucket, RI
21	Lite-Brite	14.47	105	106	Ohio Art Company	Bryan, OH
21	Lite-Brite	14.47	105	107	Mattel	Segundo, CA
22	Mr. Potato Head	11.50	105	105	Hasbro	Pawtucket, RI
22	Mr. Potato Head	11.50	105	106	Ohio Art Company	Bryan, OH
22	Mr. Potato Head	11.50	105	107	Mattel	Segundo, CA
23	Etch A Sketch	29.99	106	105	Hasbro	Pawtucket, RI
23	Etch A Sketch	29.99	106	106	Ohio Art Company	Bryan, OH
23	Etch A Sketch	29.99	106	107	Mattel	Segundo, CA

  In most cases, the result of a cross join is meaningless. 
  The rows of the result contain values with no correspondence. 
  If you don’t realize that you have performed a cross join, you might be misled by the results. 
  In addition, when performed on large tables, a cross join can return a dangerously large number of rows.

  There are some specific cases when cross joins are useful, and in most SQL dialects, 
  you can explicitly specify CROSS JOIN in your SQL statement to make it clear that you are performing a cross join. 

  So unless you intend to perform a cross join, and you understand the risks of this and 
  how to interpret the output, we recommend specifying the join condition in every join query.
````
# Joining Thress or More Tables
````text
When you’re working as a data analyst, you will often need to use join queries to combine three or more tables. 
To do this, you use the same syntax as with two tables, but with more JOINs added at the end of the FROM clause. 
Each JOIN should have its own ON keyword and join condition.

For example, to join the customers, orders, and employees tables, you could use this query:
````
````iso92-sql
SELECT c.name AS customer_name,
       o.total AS order_total,
       e.first_name AS employee_name
FROM customers c
JOIN orders o ON c.cust_id = o.cust_id
JOIN employees e ON o.empl_id = e.empl_id;
````
````text
Notice how the final two lines of this query have the same structure: 
the JOIN keyword, a table reference, a table alias, the ON keyword, and a join condition. 
You can add arbitrarily many lines like this to the FROM clause, to join together arbitrarily many tables.

The result the above query is:

customer_name	order_total	employee_name
Arfa		28.54		Sabahattin
Brendon		48.69		Virginia
Brendon		-16.39		Virginia
Chiyo		24.78		Ambrosio

- The arrangement of the rows in the result is arbitrary. 
  Each result row represents an order, and gives the name of the customer who placed the order, 
  the total amount of the order, and the employee who recorded the order. 
  Because this is an inner join (the default type), all non-matching rows are excluded from the result. 
  You can specify other types of joins, in any combination. 
  For example, to include the order placed by the customer who is not in the customers table, 
  change the first JOIN to RIGHT OUTER JOIN.

  The sequence of the tables in a multi-table join does not matter, except with left and right outer joins, 
  where it affects which table’s non-matching rows are included. 
  Each join condition can refer to join key columns in any of the tables mentioned earlier in the FROM clause.

  Join queries are computationally expensive and can be slow, 
  especially when you’re joining three or more tables, or if you’re working with very large data. 
  One strategy that can be used to remedy this problem is to join the data in advance 
  and store the pre-joined result in a separate table, which you can then query.  
  This approach of pre-joining tables has some costs, but it can make analytic queries easier to write and faster to run. 

  Partitioning divides a table’s data into separate subdirectories based on the values from one or more partition columns, 
  which have a limited number of discrete values. 
  Hive also offers another way of subdividing data, called bucketing.
````
  
### HANDLING NULL VALUES IN JOIN KEY COLUMNS
````text
$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT c.cust_id, name, total FROM customers_with_null c JOIN orders_with_null o ON c.cust_id <=> o.cust_id'
$ impala-shell -q 'SELECT c.cust_id, name, total FROM customers_with_null c JOIN orders_with_null o ON c.cust_id <=> o.cust_id'
````

### NON EQUIJOINS
````text
$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT first_name, last_name, grade FROM employees e JOIN salary_grades g ON e.salary >= g.min_salary AND e.salary <= g.max_salary'
$ impala-shell -q 'SELECT first_name, last_name, grade FROM employees e JOIN salary_grades g ON e.salary >= g.min_salary AND e.salary <= g.max_salary'

$ impala-shell -q 'SELECT a.rank AS winning_card, b.rank AS losing_card FROM fun.card_rank a JOIN fun.card_rank b ON a.value > b.value'
$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT a.rank AS winning_card, b.rank AS losing_card FROM fun.card_rank a JOIN fun.card_rank b ON a.value > b.value'
````

### CROSS JOINS
````text
$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT rank, suit FROM fun.card_rank CROSS JOIN fun.card_suit'
$ impala-shell -q 'SELECT rank, suit FROM fun.card_rank CROSS JOIN fun.card_suit'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT rank, suit FROM fun.card_rank JOIN fun.card_suit'
$ impala-shell -q 'SELECT rank, suit FROM fun.card_rank JOIN fun.card_suit'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT t.name, t.maker_id, m.id, m.name FROM toy.toys t, toy.makers m'
$ impala-shell -q 'SELECT t.name, t.maker_id, m.id, m.name FROM toy.toys t, toy.makers m'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT t.name, t.maker_id, m.id, m.name FROM toy.toys t, toy.makers m WHERE t.maker_id = m.id'
$ impala-shell -q 'SELECT t.name, t.maker_id, m.id, m.name FROM toy.toys t, toy.makers m WHERE t.maker_id = m.id'
````

### LEFT SEMIJOINS
````text
$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT manufacturer, model FROM fly.planes p LEFT SEMI JOIN fly.flights f ON p.tailnum = f.tailnum AND f.distance > 4000 * 1.15'
$ impala-shell -q 'SELECT manufacturer, model FROM fly.planes p LEFT SEMI JOIN fly.flights f ON p.tailnum = f.tailnum AND f.distance > 4000 * 1.15'
````

### SPECIFYING TWO OR MORE CONDITIONS
````text
In all the examples of joins presented, it was possible to join 
two tables together by specifying a single join condition after the ON keyword. 
For example, to join the toys and makers tables together, the join condition was:

toys.maker_id = makers.id

However, in the real world, to join some pairs of tables together, 
you will need to specify two or more join conditions after the ON keyword. 
For example, imagine you have a table containing historical daily weather conditions data 
for all United States airports, 
and this table includes columns named year, month, day, and airport. 
To join this weather table (alias w) with the flights table (alias f), 
you would need to specify an expression with four join conditions, like this:

ON f.year = w.year
    AND f.month = w.month 
    AND f.day = w.day
    AND f.origin = w.airport

In this example, the four conditions are combined into a single expression using the AND operator, 
so the SQL engine checks for all four criteria to be true when it matches the rows from the flights table and the weather table.

Join conditions like this are called multiple join conditions or compound join conditions. 
It is common for joins to require conditions like this.

When the pairs of corresponding columns have identical names in the two tables, 
some SQL engines allow you to use the USING keyword to specify multiple join conditions. 
In the parentheses after the USING keyword, separate the column names with commas. 
For example, if you were joining together two tables using columns named city and state as the join key columns, 
you could use the following join syntax:

SELECT …
FROM table1 JOIN table2
USING (city, state);
````











