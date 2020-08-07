/*
Draw The Triangle 1

P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):

* * * * *
* * * *
* * *
* *
*

Write a query to print the pattern P(20).
*/

CREATE TABLE my_table (
  ast VARCHAR(256)
);

INSERT INTO my_table VALUES ('* * * * * * * * * * * * * * * * * * * *'),
('* * * * * * * * * * * * * * * * * * *'),('* * * * * * * * * * * * * * * * * *'),
('* * * * * * * * * * * * * * * * *'),('* * * * * * * * * * * * * * * *'),
('* * * * * * * * * * * * * * *'),('* * * * * * * * * * * * * *'),
('* * * * * * * * * * * * *'),('* * * * * * * * * * * *'),('* * * * * * * * * * *'),
('* * * * * * * * * *'),('* * * * * * * * *'),('* * * * * * * *'),('* * * * * * *'),
('* * * * * *'),('* * * * *'),('* * * *'),('* * *'),('* *'),('*');

SELECT * FROM my_table;

/*
Draw The Triangle 2

P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):

*
* *
* * *
* * * *
* * * * *

Write a query to print the pattern P(20).
*/
SELECT * FROM my_table ORDER BY ast;