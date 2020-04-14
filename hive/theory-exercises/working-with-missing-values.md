### MISSING VALUES IN STRING COLUMNS
````text
When working with character string columns, a couple of misconceptions often arise around the issue of missing values.

- An empty string, also called a zero-length string, is not the same thing as a NULL value. 
  A literal empty string is written in a SQL expression as a pair of opening and closing quotes with nothing between them (''). 

- When working with real-world data, 
  watch out for string columns in which the absence of a known value is represented by an empty string instead of a NULL. 

- The expressions required to find and handle empty strings are different than the expressions to find and handle NULLs. 
  For example, to filter out the rows that have an empty string in the column named string_column, 
  you would use: WHERE string_column != '' or WHERE length(string_column) > 0 instead of: WHERE string_column IS NULL 

- When you are working with real-world data, always inspect the data to determine how missing values are represented. 
  If necessary, ask the person responsible for maintaining the data to tell you how missing values are represented.

- The literal string 'NULL' is also not the same as NULL. 
  This literal string is not a missing value, it's a four-character string composed of the letters N, U, L, and L. 
  The letters could also be in other cases: 'null' or 'Null' for example. 

- Imagine being the technology journalist Christopher Null, whose last name (not a pseudonym!) 
  often is not recognized by applications that don't distinguish between the literal string and the missing value NULL! 
  (Read about it in "Hello, I'm Mr. Null. My Name Makes Me Invisible to Computers.")

  Be mindful of these issues when you work with character string columns.
````

### MISSING VALUES WITH LOGICAL OPERATORS
````text
- This reading describes how the three logical operators—AND, OR, 
  and NOT—work when one or both of their operands are NULL.

- Many misunderstandings about NULLs in Boolean logic arise when you confuse NULL with false. 
  So remember: NULL does not mean false; it means “unknown.”

- The examples below use this sample table:

name	age	siblings
Anne	8	1
Belinda	NULL	3
Chand	3	NULL
Delmar	NULL	NULL
Enise	1	2

- The AND Operator
  For an AND expression to return true, the operands on both sides must be true. 
  On the other hand, if either expression is false, then the expression returns false.

- This means, if one operand is NULL and the other is true, then the AND expression returns NULL. 
  If one operand is NULL and the other is false, then it returns false. 
  If both operands are NULL, it returns NULL.

Expression	Value
true AND NULL	NULL
false AND NULL	false
NULL AND NULL	NULL

- Look in the example table above for children that you know are under the age of two 
  and have more than one sibling. Which can you say definitely do or do not match the criteria? 

- Here are the results:

name	age < 2	siblings > 1	age < 2 AND siblings > 1
Anne	false	false	false
Belinda	NULL	true	NULL
Chand	false	NULL	false
Delmar	NULL	NULL	NULL
Enise	true	true	true

- The OR Operator
  For an OR expression to return true, only one of the operands needs to be true. 
  It is only false if both operands are false.

- If one operand is NULL and the other is true, then the OR expression returns true. 
  If one operand is NULL and the other is false, then it returns NULL. 
  If both operands are NULL, it returns NULL.

Expression	Value
true OR NULL	true
false OR NULL	NULL
NULL OR NULL	NULL

- For example, look in the table above for children who are under the age of two or have more than one sibling. 
  Which can you say definitely do or do not match the criteria? 

- Here are the results:

name	age < 2	siblings > 1	age < 2 OR siblings > 1
Anne	false	false	false
Belinda	NULL	true	true
Chand	false	NULL	NULL
Delmar	NULL	NULL	NULL
Enise	true	true	true

- The NOT Operator
  When the unary operator NOT is applied to a NULL operand, the result remains NULL.

Expression	Value
NOT NULL	NULL

- The expression NOT NULL in the table above does not represent the IS NOT NULL operator; 
  it is simply the unary operator NOT applied to the literal Boolean value NULL.

- Once again, look in the table, this time for children who are not under the age of two. 
  Which can you say definitely do or do not match the criterion?

- Here are the results:

name	age < 2	NOT age < 2
Anne	false	true
Belinda	NULL	NULL
Chand	false	true
Delmar	NULL	NULL
Enise	true	false

- Try It!

 For this table of data, what would be the result of each expression, for each row in the table?

title	year	length
If	1993	4:31
Security	1969	NULL
Coming Around Again	NULL	3:41
Seasons of Love	1996	2:52
Love So Soft	2017	2:52

1. year < 2000 AND length > 4:00 

title	year	length
If	1993	4:31 ==> TRUE
Security	1969	NULL ==> NULL
Coming Around Again	NULL	3:41 ==> NULL
Seasons of Love	1996	2:52 ==> FALSE
Love So Soft	2017	2:52 ==> FALSE

2. year < 2000 OR length > 4:00 

title	year	length
If	1993	4:31 ==> TRUE
Security	1969	NULL ==> TRUE
Coming Around Again	NULL	3:41 ==> NULL
Seasons of Love	1996	2:52 ==> TRUE
Love So Soft	2017	2:52 ==> FALSE

3. NOT(year < 2000 OR length > 4:00)

title	year	length
If	1993	4:31 ==> FALSE
Security	1969	NULL ==> FALSE
Coming Around Again	NULL	3:41 ==> NULL
Seasons of Love	1996	2:52 ==> TRUE
Love So Soft	2017	2:52 ==> FALSE

````

###  UNDERSTANDING MISSING VALUES
````shell script
$ beeline -u jdbc:hive2://localhost:10000 -e $'SELECT * FROM fly.flights WHERE year = 2009 AND month = 1 AND day = 15 AND carrier = \'US\' AND flight = 1549 AND origin = \'LGA\''
$ impala-shell -q $'SELECT * FROM fly.flights WHERE year = 2009 AND month = 1 AND day = 15 AND carrier = \'US\' AND flight = 1549 AND origin = \'LGA\''

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT * FROM fun.inventory WHERE price < 10'
$ impala-shell -q 'SELECT * FROM fun.inventory WHERE price < 10'
````

### HANDLING MISSING VALUES
````text
- Use column IS NULL to check for NULL values
- Or use column IS NOT NULL to check for non-NULL values
- IS DISTINCT FROM
- IS NOT DISTINCT FROM
- <=> Is an special operator meaning IS NOT DISTINCT FROM
````
````shell script
$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT * FROM fun.inventory WHERE price IS NULL'
$ impala-shell -q 'SELECT * FROM fun.inventory WHERE price IS NULL'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT * FROM fun.inventory WHERE price IS NOT NULL'
$ impala-shell -q 'SELECT * FROM fun.inventory WHERE price IS NOT NULL'

$ beeline -u jdbc:hive2://localhost:10000 -e $'SELECT * FROM fly.flights WHERE year = 2009 AND month = 1 AND day = 15 AND dep_time IS NOT NULL AND arr_time IS NULL'
$ impala-shell -q $'SELECT * FROM fly.flights WHERE year = 2009 AND month = 1 AND day = 15 AND dep_time IS NOT NULL AND arr_time IS NULL'

$ beeline -u jdbc:hive2://localhost:10000 -e $'SELECT * FROM offices WHERE state_province != \'Illinois\''
$ impala-shell -q $'SELECT * FROM offices WHERE state_province != \'Illinois\''

$ beeline -u jdbc:hive2://localhost:10000 -e $'SELECT * FROM offices WHERE state_province IS DISTINCT FROM \'Illinois\''
$ impala-shell -q $'SELECT * FROM offices WHERE state_province IS DISTINCT FROM \'Illinois\''

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT * FROM fly.flights WHERE dep_delay <=> arr_delay'
$ impala-shell -q 'SELECT * FROM fly.flights WHERE dep_delay <=> arr_delay'
````

### CONDITIONALS FUNCTIONS - IF
````shell script
$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT shop, game,if(price IS NULL,8.99,price) AS correct_price FROM fun.inventory'
$ impala-shell -q 'SELECT shop, game,if(price IS NULL,8.99,price) AS correct_price FROM fun.inventory'

$ beeline -u jdbc:hive2://localhost:10000 -e $'SELECT shop, game, if(price > 10, \'high price\',\'low or missing price\') AS price_category FROM fun.inventory'
$ impala-shell -q $'SELECT shop, game, if(price > 10, \'high price\',\'low or missing price\') AS price_category FROM fun.inventory'

$ beeline -u jdbc:hive2://localhost:10000 -e $'SELECT shop, game, price, CASE WHEN price IS NULL THEN \'missing price\' WHEN price > 10 THEN \'high price\' ELSE \'low price\' END AS price_category FROM fun.inventory'
$ impala-shell -q $'SELECT shop, game, price, CASE WHEN price IS NULL THEN \'missing price\' WHEN price > 10 THEN \'high price\' ELSE \'low price\' END AS price_category FROM fun.inventory'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT distance / nullif(air_time, 0) * 60 AS avg_speed FROM fly.flights LIMIT 10'
$ impala-shell -q 'SELECT distance / nullif(air_time, 0) * 60 AS avg_speed FROM fly.flights LIMIT 10'

$ beeline -u jdbc:hive2://localhost:10000 -e $'SELECT ifnull(air_time, 340) AS air_time_no_nulls FROM fly.flights WHERE origin = \'EWR\' AND dest = \'SFO\' LIMIT 10'
$ impala-shell -q $'SELECT ifnull(air_time, 340) AS air_time_no_nulls FROM fly.flights WHERE origin = \'EWR\' AND dest = \'SFO\' LIMIT 10'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT coalesce(arr_time, sched_arr_time) AS real_or_sched_arr_time FROM fly.flights LIMIT 10'
$ impala-shell -q 'SELECT coalesce(arr_time, sched_arr_time) AS real_or_sched_arr_time FROM fly.flights LIMIT 10'
````