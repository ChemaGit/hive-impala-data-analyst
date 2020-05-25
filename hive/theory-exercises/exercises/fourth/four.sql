/*
In hive, I wish to sort an array from largest to smallest, and get the index array.

For example, the table is like this:

id  |  value_array
 1  |  {30, 40, 10, 20}
 2  |  {10, 30, 40, 20}
I with to get this:

id  |  value_array
 1  |  {1, 0, 3, 2}
 2  |  {2, 1, 3, 0}
The array in result are the index of the initial elements.
*/
SELECT id, collect_list(pos) AS result_array
FROM
(
SELECT s.id, a.pos, a.v
  FROM your_table s
       LATERAL VIEW posexplode(s.value_array) a as pos, v
DISTRIBUTE BY s.id SORT BY a.v DESC --sort by value
) s
GROUP BY id;

/*
id  result_array
1   [1,0,3,2]
2   [2,1,3,0]
*/
