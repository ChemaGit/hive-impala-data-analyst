/*
1.  Create a table region with following structure. However, underline file format should be parquet in HDFS.
r_regionkey smallint,
r_name      string,
r_comment   string,
r_nations   array<struct<n_nationkey:smallint,n_name:string,n_comment:string>>

2. Once table is created , load data in this table from region.csv
Data for region table : region.csv

r_regionkey|r_name|r_comment|r_nations &amp;lt;n_nationkey,n_name,n_comment>

1|AFRICA|Good Business Region for HadoopExam.com|0,Cameroon,Reference site http://www.QuickTechie.com
1|AFRICA|Good Business Region for Training4Exam.com|5,Egypt,Reference site http://www.HadoopExam.com
1|AFRICA|Good Business Region for HadoopExam.com|14,Namibia,Reference site http://www.QuickTechie.com
1|AFRICA|Good Business Region for Training4Exam.com|15,Zimbabwe,Reference site http://www.HadoopExam.com
1|AFRICA|Good Business Region for HadoopExam.com|16,Uganda,Reference site http://www.QuickTechie.com
2|AMERICA|Average Business Region for HadoopExam.com|1,United States,Reference site http://www.HadoopExam.com
2|AMERICA|Average Business Region for Training4Exam.com|2,Canada,Reference site http://www.HadoopExam.com
2|AMERICA|Average Business Region for HadoopExam.com|3,Cuba,Reference site http://www.QuickTechie.com
2|AMERICA|Average Business Region for Training4Exam.com|17,Costa Rica,Reference site http://www.HadoopExam.com
2|AMERICA|Average Business Region for HadoopExam.com|24,Panama,Reference site http://www.HadoopExam.com
3|ASIA|Best Business Region for Training4Exam.com|8,India,Reference site http://www.QuickTechie.com
3|ASIA|Best Business Region for HadoopExam.com|9,China,Reference site http://www.HadoopExam.com
3|ASIA|Best Business Region for Training4Exam.com|12,Japan,Reference site http://www.QuickTechie.com
3|ASIA|Best Business Region for HadoopExam.com|18,Russia,Reference site http://www.HadoopExam.com
3|ASIA|Best Business Region for Training4Exam.com|21,Israel,Reference site http://www.QuickTechie.com
4|EUROPE|Low sale Business Region for HadoopExam.com|6,Austria,Reference site http://www.HadoopExam.com
4|EUROPE|Low sale Business Region for Training4Exam.com|7,Bulgaria,Reference site http://www.QuickTechie.com
4|EUROPE|Low sale Business Region for HadoopExam.com|19,Belgium,Reference site http://www.HadoopExam.com
4|EUROPE|Low sale Business Region for Training4Exam.com|22,Croatia,Reference site http://www.QuickTechie.com
4|EUROPE|Low sale Business Region for HadoopExam.com|23,Denmark,Reference site http://www.HadoopExam.com
5|MIDDLE EAST|Ok Ok sale Business Region for HadoopExam.com|4,Saudi Arabia,Reference site http://www.QuickTechie.com
5|MIDDLE EAST|Ok Ok sale Business Region for Training4Exam.com|10,Yemen,Reference site http://www.HadoopExam.com
5|MIDDLE EAST|Ok Ok sale Business Region for HadoopExam.com|11,Oman,Reference site http://www.QuickTechie.com
5|MIDDLE EAST|Ok Ok sale Business Region for Training4Exam.com|13,Kuwait,Reference site http://www.HadoopExam.com
5|MIDDLE EAST|Ok Ok sale Business Region for HadoopExam.com|20,Qatar,Reference site http://www.QuickTechie.com

3. Now Calculate number of nation keys, total of nation keys, average of nation keys, minimum and maximum of nation name also find count of distinct nation.
This all calculation should be region specific.

$ gedit /home/cloudera/files/region.csv &
$ hdfs dfs -put /home/cloudera/files/region.csv /user/cloudera/files
$ hdfs dfs -ls -h /user/cloudera/files/region.csv
*/
CREATE DATABASE IF NOT EXISTS hadoopexamdb;
USE hadoopexamdb;
CREATE TABLE IF NOT EXISTS region(
  r_regionkey smallint,
  r_name      string,
  r_comment   string,
  r_nations   array<struct<n_nationkey:smallint,n_name:string,n_comment:string>>
)
  ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '|'
  COLLECTION ITEMS TERMINATED BY ','
  STORED AS PARQUET;

-- Now load data in this table.
-- Create a temp table first
CREATE TABLE IF NOT EXISTS tempregion(data string);

-- Now load data in this table
LOAD DATA INPATH '/user/cloudera/files/region.csv' INTO TABLE tempregion;

-- Now create a select statement, which will split the data for each row in requested format.

 SELECT split(data,'\\|')[0] r_regionkey
       , split(data,'\\|')[1] r_name
       , split(data,'\\|')[2] r_comment
       , split(split(data,'\\|')[3],",")[0] n_nationkey
       , split(split(data,'\\|')[3],",")[1] n_name
       , split(split(data,'\\|')[3],",")[2] n_comment
FROM tempregion;

-- Now create an insert statement, which load data in this table

INSERT OVERWRITE TABLE region
SELECT split(data,'\\|')[0] r_regionkey
       , split(data,'\\|')[1] r_name
       , split(data,'\\|')[2] r_comment
       , array(named_struct("n_nationkey",cast(split(split(data,'\\|')[3],",")[0] as smallint),
                            "n_name",split(split(data,'\\|')[3],",")[1],
                            "n_comment",split(split(data,'\\|')[3],",")[2]))
FROM tempregion;

-- Now use Impala
-- $ impala-shell

invalidate metadata;
USE hadoopexamdb;

SELECT *
FROM region, region.r_nations AS r_nations
LIMIT 10;

-- Now Calculate number of nation keys, total of nation keys, average of nation keys,
-- minimum and maximum of nation name also find count of distinct nation.
-- This all calculation should be region specific.

 SELECT
     r_name,
     COUNT(r_nations.item.n_nationkey) AS count,
     SUM(r_nations.item.n_nationkey) AS sum,
     AVG(r_nations.item.n_nationkey) AS avg,
     MIN(r_nations.item.n_name) AS minimum,
     MAX(r_nations.item.n_name) AS maximum,
     NDV(r_nations.item.n_nationkey) AS distinct_vals
FROM region, region.r_nations AS r_nations
GROUP BY r_name
ORDER BY r_name;