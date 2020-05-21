/*
You have been given below data format

FirstName,LastName,EMPID,LoggedInDate,JoiningDate,DeptId
Ajit,Singh,101,20131206,20131207,hadoopexamITDEPT
Arun,Kumar,102,20131206,20110607,hadoopexamPRODDEPT
Ajit,Singh,101,20131209,20131207,hadoopexamITDEPT
Ajit,Singh,101,201312011,20131207,hadoopexamITDEPT
Ajit,Singh,101,201312012,20131207,hadoopexamITDEPT
Ajit,Singh,101,201312013,20131207,hadoopexamITDEPT
Ajit,Singh,101,20131216,20131207,hadoopexamITDEPT
Ajit,Singh,101,20131217,20131207,hadoopexamITDEPT
Arun,Kumar,102,20131206,20110607,hadoopexamPRODDEPT
Arun,Kumar,102,20131209,20110607,hadoopexamPRODDEPT
Arun,Kumar,102,20131210,20110607,hadoopexamPRODDEPT
Arun,Kumar,102,20131211,20110607,hadoopexamPRODDEPT
Arun,Kumar,102,20131212,20110607,hadoopexamPRODDEPT
Arun,Kumar,102,20131213,20110607,hadoopexamMARKETDEPT
Arun,Kumar,102,20131214,20110607,hadoopexamMARKETDEPT

Remove duplicate records from this file ignoring LoggedInDate.
In output you can have any LoggedInDate, does not matter. And store final result in a Hive table.

# Solution
*/

CREATE TABLE emp_stage (
FirstName STRING,
LastName STRING,
EMPID INT,
LoggedInDate STRING,
JoiningDate STRING,
DeptId STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES("skip.header.line.count"="1");

LOAD DATA LOCAL INPATH '/home/training/CCA159DataAnalyst/data/files/emp_stage.csv' INTO TABLE emp_stage;

CREATE TABLE employee AS
SELECT FirstName,LastName,EMPID,JoiningDate AS LoggedInDate,JoiningDate,DeptId
FROM emp_stage
GROUP BY FirstName,LastName,EMPID,JoiningDate,JoiningDate,DeptId;