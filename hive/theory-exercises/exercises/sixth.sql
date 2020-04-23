/*
I have two tables.
for each date and category pair in the table2
I want to calculate the past week and two-week record counts for that category calculated from that day.

table1
| DATE         |Category |
|--------------|---------|
|2018-10-01    |ABC1     |
|2018-10-03    |ABC1     |
|2018-10-07    |ABC1     |
|2018-10-08    |ABC1     |
|2018-10-16    |ABC1     |
|2018-10-20    |ABC1     |
|2018-10-30    |ABC1     |
|2018-10-22    |ABC2     |
|2018-10-19    |ABC2     |
|2018-10-11    |ABC2     |
|2018-10-05    |ABC2     |

table2
| Category     |DATE           |
|--------------|---------------|
|ABC1          |2018-10-30     |
|ABC1          |2018-10-23     |
|ABC2          |2018-10-24     |
|ABC2          |2018-10-21     |

Final result should look something like this

| Category     |DATE           |past_week  | past_2_weeks  |
|--------------|---------------|-----------|---------------|
|ABC1          |2018-10-30     |1          |3              |
|ABC1          |2018-10-23     |2          |2              |
|ABC2          |2018-10-24     |1          |1              |
|ABC2          |2018-10-21     |1          |1              |
*/

-- hdfs dfs -put /home/training/files_2/table_1.csv /public/files/hadoopexam/
-- hdfs dfs -put /home/training/files_2/table_2.csv /public/files/hadoopexam/

CREATE EXTERNAL TABLE table_uno(
 date string,
 category string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
  STORED AS TEXTFILE;

dfs -cp /public/files/hadoopexam/table_1.csv /user/hive/warehouse/hadoopexamdb.db/table_uno/;

CREATE EXTERNAL TABLE table_dos(
 category string,
 date string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
  STORED AS TEXTFILE;

dfs -cp /public/files/hadoopexam/table_2.csv /user/hive/warehouse/hadoopexamdb.db/table_dos/;

WITH t AS(
SELECT t2.category AS category, t2.date AS date, COUNT(*) AS past_week
FROM table_dos t2
JOIN table_uno t1 ON(t2.category = t1.category)
WHERE t2.date >= t1.date AND
      CEIL(DATEDIFF(to_date(t2.date),to_date(t1.date)) / 7) <= 1
GROUP BY t2.category, t2.date)
SELECT t.category AS category, t.date AS date ,t.past_week AS past_week, t2.past_2_weeks AS past_2_weeks
FROM t
JOIN (SELECT t2.category AS category, t2.date AS date, COUNT(*) AS past_2_weeks
FROM table_dos t2
JOIN table_uno t1 ON(t2.category = t1.category)
WHERE t2.date >= t1.date AND
      CEIL(DATEDIFF(to_date(t2.date),to_date(t1.date)) / 7) <= 2
GROUP BY t2.category, t2.date) AS t2
ON(t.category = t2.category)
WHERE t.date = t2.date
ORDER BY category, date DESC;

/*
+-----------+-------------+------------+---------------+--+
| category  |    date     | past_week  | past_2_weeks  |
+-----------+-------------+------------+---------------+--+
| ABC1      | 2018-10-30  | 1          | 3             |
| ABC1      | 2018-10-23  | 2          | 2             |
| ABC2      | 2018-10-24  | 2          | 3             |
| ABC2      | 2018-10-21  | 1          | 2             |
+-----------+-------------+------------+---------------+--+
*/