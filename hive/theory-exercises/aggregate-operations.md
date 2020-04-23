## INTRODUCTION TO AGGREGATE OPERATIONS
````text
- Counting
- Adding
- Computing the Average(mean)
- Finding the Maximum value
- Finding the Minimum value
````

### COMMON AGGREGATE FUNCTIONS
````text
- COUNT - COUNT(*)
- SUM - SUM(salary)
- AVG - AVG(salary)
- MIN - MIN(salary)
- MAX - MAX(salary)
````

## USING AGGREGATE FUNCTIONS IN THE SELECT STATEMENT
````shell script
$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT COUNT(*) AS num_rows FROM employees'
$ impala-shell -q 'SELECT COUNT(*) AS num_rows FROM FROM employees'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT SUM(salary) AS salary_total FROM employees'
$ impala-shell -q 'SELECT SUM(salary) AS salary_total FROM employees'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT AVG(list_price) AS avg_price FROM fun.games'
$ impala-shell -q 'SELECT AVG(list_price) AS avg_price FROM fun.games'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT MIN(salary) AS lowest_salary, MAX(salary) AS highest_salary FROM employees'
$ impala-shell -q 'SELECT MIN(salary) AS lowest_salary, MAX(salary) AS highest_salary FROM employees'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT MAX(salary) - MIN(salary) AS salary_spread FROM employees'
$ impala-shell -q 'SELECT MAX(salary) - MIN(salary) AS salary_spread FROM employees'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT round(SUM(salary) * 0.062, 2) AS total_tax FROM employees'
$ impala-shell -q 'SELECT round(SUM(salary) * 0.062, 2) AS total_tax FROM employees'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT round(AVG(list_price) * 66.75, 2) AS avg_price_rupees FROM fun.games'
$ impala-shell -q 'SELECT round(AVG(list_price) * 66.75, 2) AS avg_price_rupees FROM fun.games'

# Aggregate expressions: Combine values from multiple rows
# Non-aggregate or scalar expressions: Return one value per row
# Valid mixing of aggregate and scalar operations
round(AVG(list_price))
SUM(salary * 0.062)
# Invalid mixing of aggregate and scalar operations
SELECT salary - AVG(salary) FROM employees;
SELECT first_name, SUM(salary) FROM employees;

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT COUNT(*) AS row_count FROM employees WHERE salary > 30000'
$ impala-shell -q 'SELECT COUNT(*) AS row_count FROM employees WHERE salary > 30000'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT round(60 * AVG(distance/air_time)) AS speed FROM fly.flights WHERE air_time > 60'
$ impala-shell -q 'SELECT round(60 * AVG(distance/air_time)) AS speed FROM fly.flights WHERE air_time > 60'
````

### INTERPRETING AGGREGATES: POPULATIONS AND SAMPLES
````text
- When you compute aggregates of columns in a real-world dataset, you need to be mindful 
  of whether the dataset describes a population or a sample. 
- There are implications for your conclusions and how you might want to phrase them.

- The Difference Between Populations and Samples
  Some datasets have a row describing each and every item in a population. 
  An example of this is a table of customers, which has one row for each customer. 
  In a dataset like this, every customer is described in the data. 
  The population is all the business’s customers, so the dataset contains the full population.

- Other datasets describe a sample from a larger population. 
  An example of this is data collected from a survey or poll. 
  Typically, the respondents to a survey or poll comprise only a 
  small proportion of the population they are drawn from. 
  For example, if you took a survey of people in Brazil, you might have 1000 survey respondents (the sample), 
  but you'll use those 1000 respondents to represent the 200 million people who live in Brazil (the population).

- In many cases, it is impractical or impossible to collect data describing an entire population. 
  This is true even when the population is fairly small. 
  For example, a company that manufactures airplane wings needs to perform tests 
  to determine the amount of force that the wings can endure before breaking. 
  They cannot test every wing they manufacture, because testing a wing requires breaking it. 
  So they must test a small sample of the wings, and they must take care 
  to ensure that the sample is representative of the full population.

- Phrasing Conclusions Appropriately
  When you analyze a dataset that describes a sample, it’s important to phrase your observations appropriately. 
  In particular, you should make it clear whether a sample or a population is involved, 
  and you should describe that sample or population accurately so the results are not overgeneralized.

- Example Scenario
  Imagine you were querying a dataset that described 300 responses to a survey of North American air travelers. 
  Your query results showed that 79% of the 300 respondents would prefer traveling by high-speed rail over traveling by plane.

- Inappropriate Conclusions
  The following conclusion is inappropriate because it conflates the sample with the population:
  “79% of North American air travelers prefer traveling by high-speed rail over traveling by plane.”

- The following conclusion is even worse; it does not describe the population correctly and it overgeneralizes the results:
  “79% of North Americans prefer traveling by high-speed rail over traveling by plane.”

- Appropriate Conclusions

- The following conclusion is appropriate:
  “79% of respondents to a survey of North American air travelers said they prefer traveling by high-speed rail over traveling by plane.” 

- The following conclusion is appropriate if you are confident that the sample is representative of the population:
  “Our survey results suggest that 79% of North American air travelers prefer traveling by high-speed rail over traveling by plane.”

- Aggregate Functions for Samples
  Depending on what SQL engine you’re using, you might have noticed some built-in aggregate functions with “_samp” or “_pop” in their names. 
````

### THE LEAST AND GREATEST FUNCTIONS
````text
- Two built-in functions that often cause confusion are the least and greatest functions. 
  These are often confused with MIN and MAX.

- MIN and MAX are aggregate functions. 
  They return the minimum or maximum value within a column.

- least and greatest are non-aggregate functions. 
  They return the smallest or largest of the arguments that are passed to them.

- For example, the query:

SELECT MAX(red), MAX(green), MAX(blue) FROM crayons;

- aggregates the full crayons table (which has 120 rows) down to a result set with just one row. 
  The three columns in the result set give the largest value of red, the largest value of green, 
  and the largest value of blue that exist in the full table.

- Whereas the query:

$ impala-shell -q 'SELECT greatest(red, green, blue) FROM wax.crayons'

- returns a result with 120 rows. 
  Each row in the result set gives the largest of the three RGB values (red, green, blue) 
  that make up each crayon color.

- The least and greatest functions are available in many (but not all) SQL engines.

- One unusual aspect of the least and greatest functions is that they can take a very large number of arguments. 
  Recall that there are a few other functions like this (including concat,concat_ws, and coalesce).
````
### Count and Sum
````text
Some data analysts use the expression SUM(1) instead of COUNT(*). 
These two aggregate expressions do the same thing: they count the number of rows in a table.

This is because when you use a scalar argument (in this case, 1) to an aggregate function (in this case, SUM), 
then the aggregate function aggregates that same value over all the rows. 

For example, here is the toys table in the toy database:

id	name	price	maker_id
21	Lite-Brite	14.47	105
22	Mr. Potato Head	11.50	105
23	Etch A Sketch	29.99	106

Imagine executing SELECT SUM(price) FROM toys; 
You can think of this as running through the rows in the table, 
and for each row, add the value in price to a running total. 
So you would get 14.47, then 14.47 + 11.50, then 14.47 + 11.50 + 29.99.

If instead you execute SELECT SUM(1) FROM toys; 
the result would be like substituting the value 1 for each of those prices. 
Instead of 14.47 + 11.50 + 29.99, you would have 1 + 1 + 1. 
That is, each row contributes 1 to the sum. 
This is the same as counting the rows.
````

### Null Values in Grouping And Aggregations
````text
- In SQL, aggregate functions ignore NULL values

$ beeline -u jdbc:hive2://localhost:10000 -e 'describe fly.flights'
$ impala-shell -q 'describe fly.flights'

+----------------+----------+---------+
| name           | type     | comment |
+----------------+----------+---------+
| year           | smallint |         |
| month          | tinyint  |         |
| day            | tinyint  |         |
| dep_time       | smallint |         |
| sched_dep_time | smallint |         |
| dep_delay      | smallint |         |
| arr_time       | smallint |         |
| sched_arr_time | smallint |         |
| arr_delay      | smallint |         |
| carrier        | string   |         |
| flight         | smallint |         |
| tailnum        | string   |         |
| origin         | string   |         |
| dest           | string   |         |
| air_time       | smallint |         |
| distance       | smallint |         |
+----------------+----------+---------+

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT AVG(distance/ (air_time / 60)) AS avg_speed FROM fly.flights'
$ impala-shell -q 'SELECT AVG(distance/ (air_time / 60)) AS avg_speed FROM fly.flights'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT AVG(distance / nullif(air_time, 0) * 60) AS avg_speed FROM fly.flights LIMIT 10'
$ impala-shell -q 'SELECT AVG(distance / nullif(air_time, 0) * 60) AS avg_speed FROM fly.flights'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT aisle, COUNT(*) FROM fun.inventory GROUP BY aisle'
$ impala-shell -q 'SELECT aisle, COUNT(*) FROM fun.inventory GROUP BY aisle'

- Why Aggregate Expressions ignore NULL Values?

This reading describes the reasons for how aggregate expressions handle NULL values differently 
than non-aggregate (scalar) expressions, and warns about how it can cause misinterpretations.

For a scalar expression, it would be misleading to report anything except NULL 
in individual row values containing NULLs in the operands or arguments of the expression. 

However, for aggregate expressions, if NULLs were not ignored, then just one NULL value in 
a large group of rows would cause the query to return a NULL result as the aggregate for the whole group. 
By ignoring the NULL values, aggregate expressions are able to return meaningful results 
even when there are NULL values in the groups.

But sometimes this behavior can lead to misinterpretations, especially with sparse data. 
For example, if you compute the average of a column in a table with ten million rows, 
but only three of those rows have a non-NULL value in the column you’re averaging, 
then the query would return a non-NULL average in the result. 
This might mislead you into thinking that this average provides meaningful information about all ten million rows, 
when it reality the average comes from only three rows, 
and there is probably no reason to believe it is representative of all ten million rows.

Therefore, it is important to explicitly checkfor NULL values and handle them in your queries, 
instead of just relying on aggregate expressions to ignore them.

One way to do this is to use an aggregate expression like:

SUM(column IS NOT NULL)

to return the number of rows in which column is non-NULL. 
In this expression, column IS NOT NULL evaluates to true (1) or false (0) for each row, 
and the SUM function adds these 1s and 0s up and returns the number of rows in which column IS NOT NULL.

For example, when you run the following query, 
the second column in the result tells you exactly how many non-NULL values were used 
to compute each of the averages in the third column:

SELECT shop, SUM(price IS NOT NULL), AVG(price) FROM inventory GROUP BY shop;

shop	SUM(price IS NOT NULL)	AVG(price)
Dicey	2	13.99
Board 'Em	2	30.00
````

### The Count Function
````text
-  The count function counts the null values
$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT shop, COUNT(*) FROM fun.inventory GROUP BY shop'
$ impala-shell -q 'SELECT shop, COUNT(*) FROM fun.inventory GROUP BY shop'

-  The count function doesn't count the null values
$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT shop, COUNT(price) FROM inventory GROUP BY shop'

- Aggregate functions ignore NULL values, the one exception for that rule is when you use COUNT(*)

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT AVG(price) AS avg_price FROM fun.inventory'
$ impala-shell -q 'SELECT AVG(price) AS avg_price FROM fun.inventory'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT SUM(price) / COUNT(price) AS avg_price FROM fun.inventory'
$ impala-shell -q 'SELECT SUM(price) / COUNT(price) AS avg_price FROM fun.inventory'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT COUNT(DISTINCT aisle) FROM inventory'
$ impala-shell -q 'SELECT COUNT(DISTINCT aisle) FROM inventory'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT COUNT(DISTINCT red, green, blue) FROM wax.crayons'
$ impala-shell -q 'SELECT COUNT(DISTINCT red, green, blue) FROM wax.crayons'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT COUNT(DISTINCT red), COUNT(DISTINCT green), COUNT(DISTINCT blue) FROM wax.crayons'
$ impala-shell -q 'SELECT COUNT(DISTINCT red), COUNT(DISTINCT green), COUNT(DISTINCT blue) FROM wax.crayons' # This query gives you an ERROR in IMPALA

$ impala-shell -q 'SELECT COUNT(DISTINCT year, month, day) FROM fly.flights'

$ impala-shell -q 'SELECT COUNT(tz) AS time_zones FROM fly.airports'
$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT COUNT(tz) AS time_zones FROM fly.airports'

$ impala-shell -q 'SELECT COUNT(*) AS time_zones FROM fly.airports WHERE tz IS NOT NULL'
$ impala-shell -q 'SELECT COUNT(DISTINCT tz) AS time_zones FROM fly.airports'

- You can use DISTINCT with all aggregate functions
This is a rarely helpul except with COUNT
With MIN or MAX, DISTINCT would have no effect

- COUNT is the only aggregate function often used with character strings
````
### Tips For Applying Grouping And Aggregation
````text
- Run querys in the SQL engine first, than in the BI application
- This approach is called pushdown
- pushdown gives you the result you're looking for much faster
- CATEGORICAL: Containing a limited number of possible values, which typically represent categories.
- The number of unique values in it must be limited. 
- CATEGORICAL COLUMNS would be suitable for use as grouping columns.

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT year, month,day, COUNT(*) AS num_flights FROM fly.flights GROUP BY year, month, day'
$ impala-shell -q 'SELECT year, month,day, COUNT(*) AS num_flights FROM fly.flights GROUP BY year, month, day'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT dep_time, arr_time, COUNT(*) AS num_flights FROM flights GROUP BY dep_time, arr_time'
$ impala-shell -q 'SELECT dep_time, arr_time, COUNT(*) AS num_flights FROM flights GROUP BY dep_time, arr_time'

- BINNING
````
````iso92-sql
SELECT MIN(dep_time), MAX(dep_time), COUNT(*) FROM fly.flights
GROUP BY CASE WHEN dep_time IS NULL THEN 'missing'
	      WHEN dep_time < 500 THEN 'night'
	      WHEN dep_time < 1200 THEN 'morning'
	      WHEN dep_time < 1700 THEN 'afternoon'
	      WHEN dep_time < 2200 THEN 'evening'
	      ELSE 'night' END;
````
### Shorcuts for Grouping
````text
This reading describes two techniques you can use to save time and make your SQL 
queries more concise when you’re using the GROUP BY clause.

For example, consider this query from the “Tips for Applying Grouping and Aggregation”:
````
````iso92-sql
SELECT MIN(dep_time), MAX(dep_time), COUNT(*)
    FROM flights
    GROUP BY CASE WHEN dep_time IS NULL then 'missing'
                    WHEN dep_time < 500 then 'night'
                    WHEN dep_time < 1200 THEN 'morning'
                    WHEN dep_time < 1700 THEN 'afternoon'
                    WHEN dep_time < 2200 THEN 'evening'
                    ELSE 'night'
        END;
````
````text
Note that this query doesn’t actually include the grouping column in the output:

Results

min(dep_time)	max(dep_time)	count(*)
1200	1659	18366410
500	1159	24513240
NULL	NULL	961944
1 	2400	2067458
1700	2159	15483770

Instead it uses MIN(dep_time) and MAX(dep_time) as a way 
to indicate which of these time bins reach row in the result set represents. 

This results in a curious row that appears to encompass all values 
from 1 to 2400; this is actually the group defined by 
WHEN dep_time < 500 then 'night' (including values from 0 to 499) and the ELSE 'night' 
(including values from 2200 to 2400).

To include the grouping column in the output with Hive and some other SQL engines, you would have to do this:
````
````iso92-sql
SELECT CASE WHEN dep_time IS NULL then 'missing'
             WHEN dep_time < 500 then 'night'
             WHEN dep_time < 1200 THEN 'morning'
             WHEN dep_time < 1700 THEN 'afternoon'
             WHEN dep_time < 2200 THEN 'evening'
             ELSE 'night'
        END AS dep_time_category,
            COUNT(*)
    FROM flights
    GROUP BY CASE WHEN dep_time IS NULL then 'missing'
             WHEN dep_time < 500 then 'night'
             WHEN dep_time < 1200 THEN 'morning'
             WHEN dep_time < 1700 THEN 'afternoon'
             WHEN dep_time < 2200 THEN 'evening'
             ELSE 'night'
        END;
````
````text
Results

dep_time_category	count(*)
afternoon	18366410
morning	24513240
missing	961944
night	2067458
evening	15483770
That gives a result that's more easily understood, but it's a long, repetitive query!

Using an Alias in the SELECT List
With Impala, MySQL, and PostgreSQL, you can use an alias in the SELECT list and then refer to it in the GROUP BY clause. 
That is, you can use this query instead:
````
````iso92-sql
SELECT CASE WHEN dep_time IS NULL then 'missing'
             WHEN dep_time < 500 then 'night'
             WHEN dep_time < 1200 THEN 'morning'
             WHEN dep_time < 1700 THEN 'afternoon'
             WHEN dep_time < 2200 THEN 'evening'
             ELSE 'night'
        END AS dep_time_category,
        COUNT(*)
    FROM flights
    GROUP BY dep_time_category;
````
````text
This produces the same results, but in a more concise query.

- Using Positional References
Another way to do this with Impala, MySQL, PostgreSQL, 
and newer versions of Hive (but not in older versions of Hive and not in some other SQL engines) 
is to use an integer (1, 2, and so on) as the grouping expression, 
and the engine will use the corresponding column in the SELECT list as the grouping column. 
If you use GROUP BY 3, then the third column you specify in your SELECT list will be the grouping column.

This means you could also use this query to get the same results for the departure time category:
````
````iso92-sql
SELECT CASE WHEN dep_time IS NULL then 'missing'
             WHEN dep_time < 500 then 'night'
             WHEN dep_time < 1200 THEN 'morning'
             WHEN dep_time < 1700 THEN 'afternoon'
             WHEN dep_time < 2200 THEN 'evening'
             ELSE 'night'
    END AS dep_time_category,
    COUNT(*)
    FROM flights
    GROUP BY 1;
````
````text
Since dep_time_category is the first column in the SELECT list, 
GROUP BY 1 directs the SQL engine to group by that column.

NOTE: In general, this shortcut method is less preferable, 
because it's harder to see what your query does,
 and it could cause trouble if you changed your SELECT list but forgot to change your ORDER BY clause.

Another Example
The tables in the fly database are not available to the MySQL and PostgreSQL engines in the VM. 
If you want to test this on the VM using either of those databases, you can try these queries:

Using an alias:
````
````iso92-sql
SELECT CASE 
             WHEN price <= 10 THEN 'inexpensive' 
             WHEN price > 10 THEN 'expensive'
             ELSE 'unknown' 
        END AS price_category, 
        COUNT(*) 
    FROM inventory 
    GROUP BY price_category;

-- Using positional reference:

SELECT CASE 
             WHEN price <= 10 THEN 'inexpensive' 
             WHEN price > 10 THEN 'expensive'
             ELSE 'unknown' 
        END AS price_category, 
            COUNT(*) 
    FROM inventory 
    GROUP BY 1;  
````

### How Grouping And Aggregation Can Mislead
````text
Care must be taken when grouping. 
It's possible to produce misleading results, or even results that seem contradictory.

In the fly.flights table, if you compare average on-time performance, AVG(arr_delay), 
over all flights for the carriers Virgin America (carrier code VX) and 
SkyWest Airlines Inc. (carrier code OO), then SkyWest has a better average delay 
(approximately 5.7 minutes) than Virgin (approximately 6.5 minutes). 
You might conclude, then, that Virgin is worse than SkyWest in terms of delays, 
and when given a choice for a particular trip between two cities, choose SkyWest. 

However, Virgin would actually be a slightly better choice in that case 
(and if arrival delay is your only criterion)! 
If you limit the data to the airports where both airlines have flights, 
then Virgin looks slightly better than SkyWest (9.5 minutes for Virgin and 9.7 minutes for SkyWest). 
It might not be a problem with Virgin being worse than SkyWest, then, in terms of delays. 
Instead, the problem could be with the airports where they operate. 
The airports where Virgin operates overall have worse delays than the airports where SkyWest operates, 
so Virgin's average on-time performance over all flights looks worse than SkyWest. 

(Note: The queries for these comparisons require some techniques you haven't learned yet, 
but they are included at the end of this reading in case you want to try them.)

In this case, the airports is a confounding variable—an underlying variable 
that affects each of the other variables that you are examining. 
The airports themselves can be a source of delay (San Francisco often has delays on account of fog, for example), 
and the carriers work with different airports. 
This underlying variable makes a difference, so a good comparison needs to accommodate that variable.

Another example is Simpson's Paradox, in which grouping in one way can provide 
one conclusion for every single group, but when taken as a whole, the opposite conclusion is reached. 
This is often because of a significant difference in sample size for the groups. 
For example, a study of kidney stone treatment found that while one treatment appeared 
to be more effective for both small stones and for large stones, 
when you looked at all the cases together, the other treatment appeared to be more effective. 
(See the Wikipedia page, Simpson's paradox, for this and other examples.  
“Simpson's Paradox: How to Prove Opposite Arguments with the Same Dataset”  also explains this phenomenon well.)

Treatment A	Treatment B
Small stones	Group 1 93% (81/87)	Group 2 87% (234/270)
Large stones	Group 3 73% (192/263)	Group 4 69% (55/80)
Both	78% (273/350)	83% (289/350)

Notice that treatment A was provided about three times as much for large stones as for small stones, 
while treatment B was provided about three times as much for small stones as for large stones. 
The severity (size) of the stones is the confounding variable. 

To avoid making conclusions from misleading data, you might:

Use different levels of aggregation, including the highest aggregation 
and no aggregation at all, if possible, when looking at the data;
Try different ways to group your data, to be sure your choice of groups isn't 
causing an effect that disappears or reverses for different choices; and
Include counts in your results so you can see when one group has 
a significantly different number of contributions than others.

Queries Used to Compare Carriers
These queries use some techniques you haven't learned yet, but they are included here in case you want to try them.

Comparing Virgin to SkyWest, all flights:
````
````iso92-sql
SELECT carrier, AVG(arr_delay), COUNT(arr_delay) 
FROM fly.flights 
WHERE carrier='VX' OR carrier='OO' 
GROUP BY carrier 
ORDER BY avg(arr_delay);
````
````text
+---------+-------------------+------------------+
| carrier | avg(arr_delay)    | count(arr_delay) |
+---------+-------------------+------------------+
| OO      | 5.685446716780021 | 5926697          |
| VX      | 6.484657383617123 | 367408           |
+---------+-------------------+------------------+

Comparing Virgin to SkyWest, identical origins and destinations:

SELECT f.carrier, avg(f.arr_delay), count(f.arr_delay)  FROM fly.flights f JOIN (SELECT DISTINCT origin, dest FROM fly.flights WHERE carrier='VX') vx  ON (f.origin=vx.origin AND f.dest=vx.dest)
JOIN (SELECT DISTINCT origin, dest FROM fly.flights WHERE carrier='OO') oo ON (f.origin=oo.origin AND f.dest=oo.dest) WHERE carrier='VX' OR carrier='OO' GROUP BY f.carrier ORDER BY avg(f.arr_delay);

Note that this query uses the JOIN keyword to combine tables; 
you'll learn about this in Week 6 of this course. 
It also uses subqueries to isolate the origin/destination pairs for each carrier; 
you'll learn about subqueries if you continue to the fourth course in this specialization. 

+---------+-------------------+--------------------+
| carrier | avg(f.arr_delay)  | count(f.arr_delay) |
+---------+-------------------+--------------------+
| VX      | 9.546630527151848 | 180043             |
| OO      | 9.72568710815216  | 231914             |
+---------+-------------------+--------------------+
````
### The Group By Clause
````text
- When using GROUP BY, the SELECT list can have only:
	- Aggregate expressions
	- Expressions used in GROUP BY
	- Literal values
- Use SELECT DISTINCT instead of using GROUP BY with no aggregation
- Some SQL engines (like MySQL) do not enforce these rules

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT min_age, MAX(list_price) FROM fun.games GROUP BY min_age'  
$ impala-shell -q  'SELECT min_age, MAX(list_price) FROM fun.games GROUP BY min_age' 

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT min_age, ROUND(AVG(list_price),2) AS avg_list_price, 0.21 AS tax_rate, ROUND(AVG(list_price) * 1.21,2) AS avg_w_tax FROM fun.games GROUP BY min_age'  
$ impala-shell -q  'SELECT min_age, ROUND(AVG(list_price),2) AS avg_list_price, 0.21 AS tax_rate, ROUND(AVG(list_price) * 1.21,2) AS avg_w_tax FROM fun.games GROUP BY min_age'
````

### Filtering On Aggregates
````text
SELECT shop, SUM(price * qty) FROM fun.inventory GROUP BY shop;

SELECT shop, SUM(price * qty) FROM fun.inventory GROUP BY shop WHERE SUM(price * qty) > 300; // NOT WORK

- The HAVING clause is the solution.
````
### The Having Clause
````iso92-sql
SELECT shop, SUM(price * qty) FROM fun.inventory GROUP BY shop HAVING SUM(price * qty) > 300;

SELECT shop, SUM(price * qty) FROM fun.inventory GROUP BY shop HAVING (SUM(price * qty) > 300 AND COUNT(*) >= 3);

SELECT shop, SUM(price * qty) FROM fun.inventory WHERE shop = 'Dicey' GROUP BY shop HAVING (SUM(price * qty) > 300 AND COUNT(*) >= 3);

SELECT shop, COUNT(*) FROM fun.inventory WHERE price < 20 GROUP BY shop HAVING (COUNT(*) >= 2);

SELECT shop FROM fun.inventory GROUP BY shop HAVING SUM(price * qty) > 300;

SELECT shop, COUNT(*) FROM fun.inventory GROUP BY shop HAVING SUM(price * qty) > 300;

SELECT shop, SUM(price * qty), MIN(price), MAX(price), COUNT(*) FROM fun.inventory GROUP BY shop HAVING SUM(price * qty) > 300;

SELECT carrier, COUNT(*), AVG(air_time) FROM fly.flights WHERE air_time >= 7 * 60 GROUP BY carrier HAVING COUNT(*) > 5000;
````
### Using an alias in the HAVING clause
````iso92-sql
SELECT shop, SUM(price * qty) as trv FROM fun.inventory GROUP BY shop HAVING trv > 300;

SELECT origin, dest,AVG(distance/(nullif(air_time,0)/60)) AS avg_flight_speed,COUNT(*) AS num_flights FROM fly.flights GROUP BY origin, dest HAVING avg_flight_speed > 575;

SELECT origin, dest,AVG(distance/(nullif(air_time,0)/60)) AS avg_flight_speed,COUNT(*) AS num_flights FROM fly.flights GROUP BY origin, dest HAVING avg_flight_speed > 575;
/*
+--------+------+-------------------+-------------+
| origin | dest | avg_flight_speed  | num_flights |
+--------+------+-------------------+-------------+
| TUS    | RNO  | 594.6422043232158 | 219         |
| SLC    | SYR  | 584.4444444444445 | 1           |
| MCO    | JAX  | 1251.25           | 2           |
| SLC    | BDL  | 579.1428571428571 | 1           |
+--------+------+-------------------+-------------+
*/
SELECT distance, air_time, origin, dest FROM fly.flights WHERE origin = 'MCO' AND dest = 'JAX';
````