### How to Unpivot Table in MySQL
````text
Sometimes you need to transpose columns into rows, or unpivot table in MySQL. 
Since MySQL doesn’t have a function to UNPIVOT or REVERSE PIVOT a table, 
you need to write a SQL query to transpose columns into rows. Here’s how to unpivot table in MySQL.

Let’s say you have the following pivot table
````
````mysql-sql
create table data(id int, a varchar(255), b varchar(255), c varchar(255));
insert into data(id,a,b,c) values(1,'a1','b1','c1'),(2,'a1','b1','c1');
select * from data;

+------+------+------+------+
| id   | a    | b    | c    |
+------+------+------+------+
|    1 | a1   | b1   | c1   |
|    2 | a1   | b1   | c1   |
+------+------+------+------+
````
````text
Let’s say you want to unpivot table in MySQL to the following.
````
````mysql-sql
1 | a1 | a
1 | b1 | b
1 | c1 | c
2 | a2 | a
2 | b2 | b
2 | c2 | c
````
### Unpivot Table in MySQL
````text
Here’s the query to do unpivot in SQL. 
Since MySQL doesn’t offer an UNPIVOT function, 
You need to use UNION ALL clause in to reverse pivot a table in MySQL.
````
````mysql-sql
select id, 'a' col, a value
from data
union all
select id, 'b' col, b value
from data
union all
select id, 'c' col, c value
from data;
+------+-----+-------+
| id   | col | value |
+------+-----+-------+
|    1 | a   | a1    |
|    2 | a   | a1    |
|    1 | b   | b1    |
|    2 | b   | b1    |
|    1 | c   | c1    |
|    2 | c   | c1    |
+------+-----+-------+
````
````text
In the above query, we basically cut the original table into 3 smaller ones 
– one for each column a,b,c and then append them one below the other using UNION ALL.

If you want to filter rows, you can add a WHERE clause as shown below
````
````mysql-sql
select id, 'a' col, a value
from data
WHERE condition
union all
select id, 'b' col, b value
from data
WHERE condition
union all
select id, 'c' col, c value
from data
WHERE condition;
````
````text
Unfortunately, it is tedious but one of the only 2 ways to unpivot in MySQL. 
The other one involves doing a cross join, as shown below.
````
````mysql-sql
select t.id,
       c.col,
       case c.col
         when 'a' then a
         when 'b' then b
         when 'c' then c
       end as data
     from data t
     cross join
     (
       select 'a' as col
       union all select 'b'
       union all select 'c'
     ) c;
+------+-----+------+
| id   | col | data |
+------+-----+------+
|    1 | a   | a1   |
|    2 | a   | a1   |
|    1 | b   | b1   |
|    2 | b   | b1   |
|    1 | c   | c1   |
|    2 | c   | c1   |
+------+-----+------+
````