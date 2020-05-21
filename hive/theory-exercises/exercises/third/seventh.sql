/*
You have been given data as below.

ID,URL,DATE,PUBID,ADVERTISERID
1,http://hadoopexam.com/path1/p.php?keyword=hadoop&amp;country=india#Ref1,30/JUN/2016,PUBHADOOPEXAM,GOOGLEADSENSE
2,http://QuickTechie.com/path1/p.php?keyword=hive&amp;country=us#Ref1,30/JUN/2016,PUBQUICKTECHIE,GOOGLEADSENSE
3,http://training4exam.com/path1/p.php?keyword=spark&amp;country=india#Ref1,30/JUN/2016,PUBTRAINING4EXAM,GOOGLEADSENSE
4,http://hadoopexam.com/path1/p.php?keyword=pig&amp;country=us#Ref1,30/JUN/2016,PUBHADOOPEXAM,GOOGLEADSENSE
5,http://QuickTechie.com/path1/p.php?keyword=datascience&amp;country=india#Ref1,30/JUN/2016,PUBQUICKTECHIE,GOOGLEADSENSE
6,http://training4exam.com/path1/p.php?keyword=java&amp;country=us#Ref1,30/JUN/2016,PUBTRAINING4EXAM,GOOGLEADSENSE
7,http://hadoopexam.com/path1/p.php?keyword=jee&amp;country=india#Ref1,01/JUL/2016,PUBHADOOPEXAM,GOOGLEADSENSE
8,http://QuickTechie.com/path1/p.php?keyword=apache&amp;country=us#Ref1,01/JUL/2016,PUBQUICKTECHIE,GOOGLEADSENSE
9,http://training4exam.com/path1/p.php?keyword=hadoopexam&amp;country=india#Ref1,01/JUL/2016,PUBTRAINING4EXAM,GOOGLEADSENSE
10,http://hadoopexam.com/path1/p.php?keyword=hadooptraining&amp;country=us#Ref1,01/JUL/2016,PUBHADOOPEXAM,GOOGLEADSENSE
11,http://QuickTechie.com/path1/p.php?keyword=de575&amp;country=india#Ref1,01/JUL/2016,PUBQUICKTECHIE,GOOGLEADSENSE
12,http://training4exam.com/path1/p.php?keyword=cca175&amp;country=us#Ref1,01/JUL/2016,PUBTRAINING4EXAM,GOOGLEADSENSE

Accomplish following activities.

- Load this data in HDFS
- Define Hive Managed table which partitioned by Advertised Host and Advertised Country
- Table must containg following columns
ID,DATE,PUBID,ADVERTISERID,KEYWORD

1. Edit the file in gedit
$ gedit ads_web.csv $
$ hdfs dfs -mkdir /public/files/hadoopexam
$ hdfs dfs -put /home/training/CCA159DataAnalyst/data/files/hadoopexam/ads_web.csv /public/files/hadoopexam
*/
USE hadoopexamdb

-- ************WHIT STAGE TABLE AND PARSING THE URL FIELD********************

CREATE TABLE ads_web_stage (
 id STRING,
 url STRING,
 date_id STRING,
 pubid STRING,
 advertiserid STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

LOAD DATA LOCAL INPATH '/home/training/files/hadoopexam' INTO TABLE ads_web_stage;

CREATE TABLE ads_web(
  id INT,
  date STRING,
  pubid STRING,
  advertiserid STRING,
  keyword STRING)
PARTITIONED BY(host STRING, country STRING);

INSERT INTO ads_web PARTITION(host, country)
SELECT id, date_id AS date, pubid, advertiserid,
       SPLIT(SPLIT(SPLIT(SPLIT(url,'\\?')[1], '\\;')[0], '\\=')[1], '\\&')[0] AS keyword,
       SPLIT(SUBSTR(url,8,LENGTH(url)),'\\/')[0] AS host,
       SPLIT(SPLIT(SPLIT(SPLIT(url,'\\?')[1], '\\;')[1], '\\=')[1], '\\#')[0] AS country
FROM ads_web_stage;

SELECT *
FROM ads_web;

dfs -ls /user/hive/warehouse/hadoopexamdb.db/ads_web;
dfs -ls /user/hive/warehouse/hadoopexamdb.db/ads_web/host;
dfs -ls /user/hive/warehouse/hadoopexamdb.db/ads_web/host=hadoopexam.com;
dfs -ls /user/hive/warehouse/hadoopexamdb.db/ads_web/host=hadoopexam.com/country=us;

-- ***********WITH BUILT-IN FUNCTION parse_url_tuple*******************

SELECT t.*,parsed.host,parsed.keyword,
          SPLIT(SPLIT((SPLIT(url,'\\;')[1]),'=')[1],'\\#')[0] AS country
FROM ads_web_stage t
LATERAL VIEW parse_url_tuple(url,'HOST','QUERY:keyword') parsed AS host,keyword;
