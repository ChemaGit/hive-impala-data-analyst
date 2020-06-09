/*
I have two tables.

table1:

id    |   array1
1     |     ['a', 'b', 'c']
2     |     ['b', 'a', 'c']
3     |     ['c', 'b', 'a']

table2

id    |    value2
1     |     'b'
3     |     'a'


id    |    value3
1     |     'c'
2     |     'b'
3     |     'c'

I wish to get the following table:

Explanation:
what I want is that if the id in table1 does't exist in table2, then return the first element of array1.
if the id in table1 exists in table2, then return the next element of value2 in array1
(in this case if value2 is the last element in array1, return the first element of array1)

How can I achieve this goal?
*/

CREATE TABLE table1(
 id INT,
 array1 ARRAY<STRING>
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
COLLECTION ITEMS TERMINATED BY '|'
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/training/files_2/table1.csv' INTO TABLE table1;


CREATE TABLE table2(
 id INT,
 value2 STRING
)ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/training/files_2/table2.csv' INTO TABLE table2;

SELECT s.id, NVL(s.array1[pos], s.array1[0]) value3
FROM
(
SELECT s.id, s.array1, min(CASE WHEN t2.id IS NOT NULL THEN s.pos+1 END) pos
FROM
(
SELECT t.id, t.array1, a.pos, a.value1
  FROM table1 t
       LATERAL VIEW POSEXPLODE(t.array1) a AS pos, value1
)s LEFT JOIN table2 t2 on s.id = t2.id and s.value1 = t2.value2
GROUP BY s.id, s.array1
)s
ORDER BY id;

/*
Explode array using posexplode, join with table2, calculate position for joined rows, aggregate, extract array elements.
*/