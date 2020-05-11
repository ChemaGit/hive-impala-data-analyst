## WORKING WITH DATA TYPES

### CHOOSING THE RIGHT DATA TYPES

### EXAMINING DATA TYPES
````text
If you're unsure what data types are assigned to a column—perhaps 
it's an existing table that someone else created, 
you think you might have made a mistake, or you just forgot 
how you defined it—there are different ways to get this information.

**Examine the Table Schema**
Of course, you can use Hue's Table Browser, or the data source panel on the left in Hue, to view the table's schema. 
You can view the names of the columns along with their data types. 
You can also use the DESCRIBE or DESCRIBE FORMATTED commands. 
Both show what columns are in the table, with their data types and sometimes comments. 
DESCRIBE FORMATTED provides a bit more information, including the format and location of the table’s data files.

The SHOW CREATE TABLE command can also be used to see a table's definition. 
You can read the resulting CREATE TABLE command to see what the columns are, 
including what their data types are.

**The typeof Function in Impala**
In Impala (but not Hive), you can also use the typeof function in a SELECT statement to get the data type:

SELECT typeof(colname) FROM tablename LIMIT 1;

If you don't use LIMIT 1 it will return one row for each row in the table.

This method also is useful to see what data type an expression returns. 
Directly examining a table, whether using Hue's graphical interface or by using a command, 
will not provide this information. 
Instead of colname in the query above, use the expression you're interested in. 
If the expression doesn't involve a column reference, 
Impala will allow you to leave off the FROM clause.

Try It!
Follow the steps below to practice using the typeof function with Impala. 

Use the typeof function to find the data type of the list_price column in the fun.games table. 
(Use the SELECT statement above, replacing colname and tablename.)
Some governments add a sales tax to purchases of items such as games. 
The amount of the tax is a percentage of the price paid. 
For example, a 7% sales tax would make the tax of a game 0.07 * list_price, 
and the final cost would be 1.07 * list_price. 
Find the data type of this expression, for the games in the fun.games table.
Impala will allow you to omit the FROM clause when there is no column reference. 
Use the typeof function in Impala to find the data type of the following expressions. 
(All you need is SELECT expression;)

SELECT TYPEOF(list_price) FROM fun.games LIMIT 1
a. 0.6	=> SELECT TYPEOF(0.6)
b. cos(0.6)	=> SELECT TYPEOF(COS(0.6))
c. ceil(cos(0.6)) => SELECT TYPEOF(CEIL(COS(0.6)))
d. ceil(cos(0.6))/3 => SELECT TYPEOF(CEIL(COS(0.6))/3)
````

### OUT-OF-RANGE VALUES
````text
Both Hive and Impala return NULL for DECIMAL values that are out of range 
for the target data type (such as 23.63 in a DECIMAL(3,2) column). 
They also both return -Infinity or Infinity for FLOAT and DOUBLE types when the value is too large, 
and zero when the value is close to zero but too small for the data type’s range. 
(These zero values may be rendered in slightly different ways, for example: 0, 0.0, -0, or -0.0.)

However, there’s an important difference between how Hive and Impala 
handle out-of-range values in integer columns: 
Hive returns NULL for out-of-range integer values, whereas Impala returns 
the minimum or maximum value for the column’s specific integer data type. 
The example shown below illustrates this.

NAME		AGE
Rashida		29
Hugo		17
Abigail
Esma		129
Kenji		-999

CREATE TABLE names_and_ages (
	name STRING,
	age  TINYINT
)
ROW FORMAT DELIMITED
	FIELDS TERMINATED BY '\t';

SELECT age FROM names_and_ages;

HIVE	IMPALA
age	    age
29	    29
17	    17
NULL	NULL
NULL	127
NULL	-128

In this example, there is a table that includes a column named age with data type TINYINT. 
The TINYINT data type can represent integer values from -128 to +127. 
But the data file for this table (represented by the yellow box) 
contains two erroneous age values that are outside this range. 
The age value for Esma is 129, which is above the maximum value for the TINYINT type. 
The age value for Kenji is -999, which is below the minimum value for the TINYINT type.

When you query this table with Hive, it returns NULL for these two out-of-range values, but Impala behaves differently. 
Impala returns 127 for Esma’s age (127 is the maximum value for the TINYINT type). 
And Impala returns -128 for Kenji’s age (-128 is the minimum value for the TINYINT type).

Why does Impala behave differently than Hive in this situation? 
Notice in the example shown here that Abigail’s age is missing in the data file in HDFS. 
The Impala query results allow you to distinguish between the missing value of Abigail’s 
age (NULL) and the out-of-range values of Esma’s and Kenji’s ages, 
whereas the Hive query results do not allow you to distinguish between these.

However, one implication of this is that you should choose a data type whose largest and smallest values do not occur in your data. 
For example, if your data contains integers ranging from -127 to +126, then it would be fine to use the TINYINT data type. 
In that case, a value of -128 or +127 in the query result will unambiguously indicate an out-of-range value. 
But if your data contains integers ranging from -128 to +127, then you should choose 
SMALLINT to avoid ambiguity between the actual values -128 and +127 and out-of-range values.
````





