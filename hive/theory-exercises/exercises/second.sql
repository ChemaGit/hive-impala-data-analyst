/*
### Problem Scenario:
    You have given following table ,

# file oddEven.txt
value,property
1,odd
2,even
3,odd
4,even
5,odd
6,even
7,odd
8,even
9,odd
10,even
11,odd
12,even
13,odd
14,even
15,odd
16,even
17,odd
18,even
19,odd
20,even
21,odd
22,even
23,odd
24,even
25,odd
26,even

table_int (value int, property string);

1. Please transform all the values from value column in a single row , separated by '|'.
2. Please transform odd and even values (separately) from value column in a single row , separated by '|' also save this results in a table.
*/

$ hive --silent --database hadoopexamdb

CREATE EXTERNAL TABLE table_int(value int, property string)
        ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
        STORED AS TEXTFILE;
LOAD DATA INPATH '/user/cloudera/files/oddEven.txt' OVERWRITE INTO TABLE table_int;
SELECT * FROM table_int;

-- As this group_concat function accept only string as a first argument. Hence, we have to convert the same using cast function.

$ impala-shell

INVALIDATE metadata;

SELECT GROUP_CONCAT(CAST(value AS STRING),"|")
FROM table_int;

-- Remember in exam, you have to save result of your query. Hence, they asked you to create table and store data of your query in table.

CREATE TABLE HE1B(value1 string, value2 string);
INSERT OVERWRITE TABLE HE1B SELECT property, GROUP_CONCAT(CAST(value AS STRING),"|") FROM table_int GROUP BY property;

SELECT * FROM HE1B;