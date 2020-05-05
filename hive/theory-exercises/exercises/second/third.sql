/*
combine code and description from same table

I have a table called t_employee like this

id|name|profession
101|ava,julia,ann|beautician,musician,doctor
102|john,alice|doctor,singer
103|peter,philip,diane,lucy|teacher,police,teacher,dancer

and I want to transform t_employee table in t_worker table like

id|name|profession
101|ava|beutician
101|julia|musician
101|ann|doctor
102|john|doctor
102|alice|singer
103|peter|teacher
103|philip|police
103|diane|teacher
103|lucy|dancer

$ beeline -u jdbc:hive2://localhost:10000
*/

USE hadoopexamdb;

CREATE TABLE t_employee (
  id INT,
  name STRING,
  profession STRING
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
TBLPROPERTIES('skip.header.line.count'='1');

LOAD DATA LOCAL INPATH '/home/training/files_2/t_employee.csv' INTO TABLE t_employee;

CREATE TABLE t1 AS
SELECT id, tname,ROW_NUMBER() OVER() AS rownum
FROM t_employee
LATERAL VIEW EXPLODE(SPLIT(name, ',')) t1 AS tname;

CREATE TABLE t2 AS
SELECT id, tprof,ROW_NUMBER() OVER() AS rownum
FROM t_employee
LATERAL VIEW EXPLODE(SPLIT(profession, ',')) t1 AS tprof;

SELECT t1.id AS id, t1.tname AS name, t2.tprof AS profession
FROM t1
JOIN t2 ON(t1.id = t2.id AND t1.rownum = t2.rownum)
ORDER BY id;