## How to Transpose Rows to Columns Dynamically in MySQL
````text
Sometimes, your data might stored in rows and you might want to report it as columns. 
In such cases, you will need to transpose rows into columns. 
Sometimes, even these rows can be variable. 
So you might know how many columns you need. 
In such cases, you need to transpose rows to columns dynamically. 
Since there is no built-in function to do that in MySQL, 
you need to accomplish it using an SQL query. 
Here’s an SQL query to dynamically transpose rows to columns in MySQL.
````

### Create dynamic pivot tables in MySQL
````text
Here’s how to create dynamic pivot tables in MySQL. 
Let’s say you have the following table
````
````mysql-sql
CREATE TABLE Meeting(
ID INT,
Meeting_id INT,
field_key VARCHAR(100),
field_value VARCHAR(100));

INSERT INTO Meeting(ID,Meeting_id,field_key,field_value)
VALUES (1, 1,'first_name' , 'Alec');
INSERT INTO Meeting(ID,Meeting_id,field_key,field_value)
VALUES (2, 1,'last_name' , 'Jones');
INSERT INTO Meeting(ID,Meeting_id,field_key,field_value)
VALUES (3, 1,'occupation' , 'engineer');
INSERT INTO Meeting(ID,Meeting_id,field_key,field_value)
VALUES (4,2,'first_name' , 'John');
INSERT INTO Meeting(ID,Meeting_id,field_key,field_value)
VALUES (5,2,'last_name' , 'Doe');
INSERT INTO Meeting(ID,Meeting_id,field_key,field_value)
VALUES (6,2,'occupation' , 'engineer');

+------+------------+------------+-------------+
| ID   | Meeting_id | field_key  | field_value |
+------+------------+------------+-------------+
|    1 |          1 | first_name | Alec        |
|    2 |          1 | last_name  | Jones       |
|    3 |          1 | occupation | engineer    |
|    4 |          2 | first_name | John        |
|    5 |          2 | last_name  | Doe         |
|    6 |          2 | occupation | engineer    |
+------+------------+------------+-------------+
````
````text
Let’s say you want to transpose rows to columns dynamically, 
such that a new column is created for each unique value in field_key column, 
that is (first_name, last_name, occupation)
````
````mysql-sql
+------------+-------------+-------------+-------------+
| Meeting_id | first_name  |  last_name  |  occupation |
+------------+-------------+-------------+-------------+
|          1 |       Alec  | Jones       | engineer    |
|          2 |       John  | Doe         | engineer    |
+------------+-------------+-------------+-------------+
````

### Transpose rows to columns dynamically
````text
f you already know which columns you would be creating beforehand, 
you can simply use a CASE statement to create a pivot table.

Since we don’t know which columns to be created, 
we will have to dynamically transpose rows to columns using GROUP_CONCAT function, as shown below
````
````mysql-sql
SET @sql = NULL;
SELECT
  GROUP_CONCAT(DISTINCT
    CONCAT(
      'max(case when field_key = ''',
      field_key,
      ''' then field_value end) ',
      field_key
    )
  ) INTO @sql
FROM
  Meeting;
SET @sql = CONCAT('SELECT Meeting_id, ', @sql, ' 
                  FROM Meeting 
                   GROUP BY Meeting_id');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
````
````text
GROUP_CONCAT allows you to concatenate field_key values from multiple rows into a single string. 
In the above query, we use GROUP_CONCAT to dynamically create CASE statements, 
based on the unique values in field_key column and store that string in @sql variable, 
which is then used to create our select query.
````
````mysql-sql
+------------+------------+-----------+------------+
| Meeting_id | first_name | last_name | occupation |
+------------+------------+-----------+------------+
|          1 | Alec       | Jones     | engineer   |
|          2 | John       | Doe       | engineer   |
+------------+------------+-----------+------------+
````
````text
This is how you can automate pivot table queries 
in MySQL and transpose rows to columns dynamically.

You can customize the above query as per your requirements 
by adding WHERE clause or JOINS.

If you want to transpose only select row values as columns, 
you can add WHERE clause in your 1st select GROUP_CONCAT statement.
````
````mysql-sql
SELECT
  GROUP_CONCAT(DISTINCT
    CONCAT(
      'max(case when field_key = ''',
      field_key,
      ''' then field_value end) ',
      field_key
    )
  ) INTO @sql
FROM
  Meeting
WHERE <condition>;
````
````text
If you want to filter rows in your final pivot table, 
you can add the WHERE clause in your SET statement.
````
````mysql-sql
SET @sql = CONCAT('SELECT Meeting_id, ', @sql, ' 
                  FROM Meeting WHERE <condition>
                  GROUP BY Meeting_id');
````
````text
Similarly, you can also apply JOINS in your SQL query 
while you transpose rows to columns dynamically in MySQL.
````