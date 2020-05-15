/*
I have a dataset that look like this

doc    date     value
2345    201902  470942
2345    201903  470044
2345    201904  470
2345    201905  35000 ...

And I want to transform like this

doc    date    value    value_1m    value_2m    value_3m
2345    201905  35000   470         470044      470942
2345    201904  470     470044      470942      ...

as you can see the new columns value_1m, value_2m, value_3m are the values of the previous months 201904, 201903, 201902 and so on.

I have tried with the (CASE WHEN key ) but my variable "date" is a number and goes for every month so I cant use it.

I am new in this forum so please sorry if it is not too clear and Thanks in advance.
*/

CREATE TABLE doc_date_value (
 doc int,
 date int,
 value int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;


LOAD DATA LOCAL INPATH '/home/training/files_2/docdatevalue.txt' INTO TABLE doc_date_value;

ALTER TABLE doc_date_value CHANGE date cdate INT;

/*
+---------------------+-----------------------+-----------------------+--+
| doc_date_value.doc  | doc_date_value.cdate  | doc_date_value.value  |
+---------------------+-----------------------+-----------------------+--+
| 2345                | 201902                | 470942                |
| 2345                | 201903                | 470044                |
| 2345                | 201904                | 470                   |
| 2345                | 201905                | 35000                 |
+---------------------+-----------------------+-----------------------+--+
*/

WITH t2 AS(
WITH t AS(
SELECT *, LEAD(value,1,0) OVER(PARTITION BY doc ORDER BY cdate DESC) as value_1m
FROM doc_date_value
ORDER BY cdate DESC)
SELECT doc, cdate,value, value_1m,
       LEAD(value_1m,1,0) OVER(PARTITION BY doc ORDER BY cdate DESC) as value_2m
FROM t)
SELECT doc, cdate,value, value_1m, value_2m,
       LEAD(value_2m,1,0) OVER(PARTITION BY doc ORDER BY cdate DESC) as value_3m
FROM t2;

/*
+------+--------+--------+----------+----------+----------+
| doc  | cdate  | value  | value_1m | value_2m | value_3m |
+------+--------+--------+----------+----------+----------+
| 2345 | 201905 | 35000  | 470      | 470044   | 470942   |
| 2345 | 201904 | 470    | 470044   | 470942   | 0        |
| 2345 | 201903 | 470044 | 470942   | 0        | 0        |
| 2345 | 201902 | 470942 | 0        | 0        | 0        |
+------+--------+--------+----------+----------+----------+
*/