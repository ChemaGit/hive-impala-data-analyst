# UNION AND UNION ALL

### Combining Query Results with the UNION Operator
````text
$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT id, name FROM fun.games UNION ALL SELECT id, name FROM toy.toys'
$ impala-shell -q 'SELECT id, name FROM fun.games UNION ALL SELECT id, name FROM toy.toys'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT country FROM customers UNION ALL SELECT country FROM offices'
$ impala-shell -q 'SELECT country FROM customers UNION ALL SELECT country FROM offices'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT country FROM customers UNION DISTINCT SELECT country FROM offices'
$ impala-shell -q 'SELECT country FROM customers UNION DISTINCT SELECT country FROM offices'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT name, list_price AS price FROM fun.games UNION ALL SELECT name,price FROM toy.toys'
$ impala-shell -q 'SELECT name, list_price AS price FROM fun.games UNION ALL SELECT name,price FROM toy.toys'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT year FROM fly.flights UNION ALL SELECT CAST(year AS INT) AS year FROM fun.games'
$ impala-shell -q 'SELECT year FROM fly.flights UNION DISTINCT SELECT CAST(year AS INT) AS year FROM fun.games'
````

### Missing or Truncated Values from Type Conversion
````text
In queries that use UNION (and in other types of queries), you will sometimes need to use explicit type conversion 
(also called explicit casting) to convert a column (or a scalar value) from one data type to another. 
In most SQL dialects, this is done using the cast function. 
However, you need to be careful about a couple of things when using cast.

Review: Explicit Type Conversion
As you might recall, you can cast any numeric column to a character string column, like this:

SELECT cast(list_price AS STRING) FROM games;

If you have a character string column whose values represent numbers, 
then you can cast it to a numeric column, like this:

SELECT cast(year AS INT) FROM games;

Type Conversion Can Return Missing Values
Under some circumstances, the cast function will return missing (NULL) values. 
A common situation in which this happens is when you have a character string column whose values do not represent numbers, 
and you try to convert it to a numeric column.

For example, this query attempts to convert the character string values 
in the name column (values like Monopoly and Scrabble) to integer values:

SELECT cast(name AS INT) FROM games;

When you run this query with Hive or Impala, it returns a column of NULL values, 
because there is no way to cast these character string values to known integer values.

However, some other SQL engines have different ways of handling situations like this. 
If you use MySQL to cast a character string column as a numeric column, 
it returns zeros for the values that do not represent numbers (not NULLs like Hive and Impala). 
And PostgreSQL throws an error if you attempt to cast a character string that does not represent a number as a number. 
Also note that different SQL engines have different data types, 
so the data type name you use after the AS keyword in the cast function varies depending on the engine. 
For example, in MySQL you should use SIGNED INT instead of INT, 
and in MySQL and PostgreSQL you should use CHAR instead of STRING.

Type Conversion Can Return Truncated Values
Under some circumstances, the cast function will return truncated (cut off) values. 
A common situation in which this happens is when you convert decimal number values to integer values.

For example, this query converts the decimal numbers in the list_price column 
(which have two digits after the decimal) to integer values:

SELECT cast(list_price AS INT) FROM games;

When you run this query with Impala or Hive, it truncates (cuts off) the decimal point and the two digits after it. 
For example: 19.99 becomes 19.

However, in this situation, some other SQL engines round instead of truncating. 
When you run a query like this with MySQL or PostgreSQL, 
it rounds each decimal number value to the nearest integer value. For example: 19.99 becomes 20.
````

### Using ORDER BY and LIMIT with UNION
````text
You can use the SELECT, FROM, WHERE, GROUP BY, and HAVING clauses in each SELECT statement, 
but be careful about using the ORDER BY and LIMIT clauses. 
Check the documentation for the specific SQL engine you’re using, and run some simple tests to make sure 
you understand how it will interpret the ORDER BY and LIMIT clauses in UNION queries.

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT name, list_price AS price FROM fun.games UNION ALL SELECT name,price FROM toy.toys'
$ impala-shell -q 'SELECT name, list_price AS price FROM fun.games UNION ALL SELECT name,price FROM toy.toys'
````

### Using UNION to Combine Three or More Results
````text
You can use UNION ALL or UNION DISTINCT to combine three or more query results into a single result set. 
To do this, simply add another UNION operator after the final SELECT statement and add another SELECT statement after it. 
For example, the following query uses three SELECT statements, combined with two UNION ALL operators:
````
````iso92-sql
SELECT color, 'red' AS component, red AS value
FROM wax.crayons
WHERE color = 'Mauvelous'
UNION ALL
SELECT color, 'green' AS component, green AS value
FROM wax.crayons
WHERE color = 'Mauvelous'
UNION ALL
SELECT color, 'blue' AS component, blue AS value
FROM wax.crayons
WHERE color = 'Mauvelous';
````
````text
This query returns the three component values (red, green, blue) 
of the color named Mauvelous, in three separate rows.

Be sure to use a semicolon only at the very end.

When using three or more UNION operators in one query, 
it’s a good idea to make them all UNION ALL or all UNION DISTINCT. 
Mixing the two different types of UNION operators in a single query is likely to cause confusion.

The rules that apply when using a UNION to combine two results also apply in the case of three or more results:

The SELECT statements should have the same number of columns and the sets of 
corresponding columns should have the same names and the same high-level categories of data types. 
Use explicit casting and column aliases to ensure this.
````