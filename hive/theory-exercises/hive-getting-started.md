# GETTING STARTED WITH HIVE

### Overview of Hive language manual
````text
- Take a look of the Hive Documentation
````

[https://cwiki.apache.org/confluence/display/Hive/LanguageManual][Hive Language Manual Documentation]

[Hive Language Manual Documentation]: https://cwiki.apache.org/confluence/display/Hive/LanguageManual

### Launching and using Hive CLI
````text
Let us understand how to launch Hive CLI.

- Logon to the gateway node of the cluster
- Launch Hive CLI using hive
- One can get help using hive --help
- There are several services under hive (default cli).
- hive is same ashive --service cli
- To get other options of Hive CLI, we can use hive --service cli --help
- For e. g.: we can use hive --service cli --database training_retail.
- Hive CLI will be launched and will be connected to training_retail database.
````
````shell script
$ hive --help

$ hive --service cli --help

$ hive -e 'select * from retail_db.orders limit 10'

$ hive

$ hive --silent

$ hive --service cli --database training
````
### OVERVIEW OF HIVE PROPERTIES - SET AND .HIVERC
````text
Let us understand details about Hive properties which control Hive run time environment.

- Review /etc/hive/conf/hive-site.xml
- Review properties using Management Tools such as Ambari or Cloudera Manager Web UI
- Hive run time behavior is controlled by Hadoop Properties files, YARN Properties files, Hive Properties files etc.
- If same property is defined in multiple properties files, then value in hive-site.xml will take precedence.
- Properties control run time behavior
- We can get all the properties using SET; in Hive CLI

Let us review some important properties in Hive. We will also see how properties can be reviewed using Hive CLI and how to overwrite them for the entire session using .hiverc.

- hive.metastore.warehouse.dir
- mapreduce.job.reduces

- We can review the current value using SET mapreduce.job.reduces;
- We can overwrite property by setting value using the same SET command, eg: SET mapreduce.job.reduces=2;
- We can overwrite the default properties by using .hiverc. It will be executed whenever Hive CLI is launched.
````
````shell script
$ hive

hive> SET;
hive> exit;

$ hive -e "SET" > hive_properties

$ hive
hive> set hive.execution.engine;

hive> set hive.execution.engine=tez;
hive> exit;

$ hive --hiveconf hive.execution.engine=tez
hive> SET hive.execution.engine;
hive> exit;

$ cd cd /usr/lib/hive/conf
$ view hive-site.xml
/hive.execution.engine
````

### HIVE CLI HISTORY AND .hiverc
````text
Let us understand how to get the history of commands using Hive CLI.

We can go back to the history by hitting up arrows
All the commands executed using Hive CLI will be written to .hivehistory
````
````shell script
$ hive
hive>exit;

$ cd ~
$ ls -al|grep history
$ view .hivehistory
$ view .beeline/history
$ view .impalahistory

$ ls -al | grep hive
# edit the file with hive expressions. Start hive CLI and the file will be executed. Useful!!!
$ gedit .hiverc & 
````
````sqlite-sql
SET hive.execution.engine=tez;
USE hadoopexamdb;
SELECT * FROM orders LIMIT 10;
````
````shell script
$ hive
SET hive.execution.engine
````

### Running HDFS Commands Using Hive CLI
````text
Let us understand how to run HDFS commands using Hive CLI.

From Linux Terminal, we typicall run commands using hadoop fs or hdfs dfs
In Hive, we have dfs
For e. g.: dfs -ls /user/training; is the command to list files.

All hive commands end with ;

$ hdfs dfs
$ hdfs dfs -ls /public

$ hive

 dfs;
 dfs -ls /public;
 dfs -ls -R /public;
 dfs -help;
````

### Understanding Warehouse Directory
````text
Let us go through the details related to Hive Warehouse Directory.

A Database in Hive is nothing but HDFS Directory
A Table in Hive is nothing but HDFS Directory
A Partition in Hive is nothing but HDFS Directory
Warehouse Directory is the base directory where directories related to databases, tables go by default.
It is controlled by hive.metastore.warehouse.dir. You can get the value by saying SET hive.metastore.warehouse.dir;

Do not overwrite this property in Hive CLI

HDFS directory for a database will have .db extension.
````

````shell script
$ hive -e "SET;" | grep warehouse

$ hdfs dfs -ls /user/hive/warehouse

$ hive -e "SET hive.metastore.warehouse.dir;"

$ hive
 SET hive.metastore.warehouse.dir;
hive.metastore.warehouse.dir=/user/hive/warehouse
````
### Creating Database in Hive and Switching to the Database
````text
Let us undestand how to create databases in Hive.

Make a habit of reviewing Language Manual.
We can create database using CREATE DATABASE Command.
For e. g.: CREATE DATABASE training_retail;
If the database exists it will fail. If you want to ignore with out throwing error you can use IF NOT EXISTS
e. g.: CREATE DATABASE IF NOT EXISTS training_retail;
Hive is multi tenant database. To switch to a database, you can use USE Command. e. g.: USE training_retail;
````
````shell script
$ hive
 CREATE DATABASE IF NOT EXISTS training_retail;
 USE training_retail;

$ hdfs dfs -ls /user/hive/warehouse | grep -w training_retail
````

### Creating First Table in Hive and list the tables
````text
Let us create our first table in Hive. We will also have a look into how to list the tables.

We will get into details related to DDL Commands at a later point in time.
For now we will just create our first table.

CREATE TABLE orders (
  order_id INT,
  order_date STRING,
  order_customer_id INT,
  order_status STRING
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

    We can list the tables using SHOW tables;
````

````sqlite-sql
-- $ hive
USE training_retail;

CREATE TABLE orders (
       order_id INT,
       order_date STRING,
       order_customer_id INT,
       order_status STRING
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

dfs -ls /user/hive/warehouse/training_retail.db;

SHOW tables;

SHOW CREATE TABLE orders;
````

### Retrieve metadata of Hive tables using DESCRIBE (EXTENDED AND FORMATTED)
````text
As the table is created, let us understand how to get the metadata of a table.

We can get metadata of Hive Tables using several commands.
````
````shell script
# DESCRIBE - e.g.: 
DESCRIBE orders;
# DESCRIBE EXTENDED - e.g.: 
DESCRIBE EXTENDED orders;
# DESCRIBE FORMATTED - e.g.: 
DESCRIBE FORMATTED orders;
# DESCRIBE will give only field names and data types.
# DESCRIBE EXTENDED will give all the metadata, but not in readable format.
# DESCRIBE FORMATTED will give metadata in readable format.

use training_retail;
DESCRIBE orders;
DESCRIBE EXTENDED orders;
DESCRIBE FORMATTED orders;
````

### Role of Hive Metastore
````text
Let us understand details related to Metadata Generated in Hive.

When we create a Hive table, there is metadata associated with it.
    Table Name
    Column Names and Data Types
    Location
    File Format
    and more
This metadata has to be stored some where so that Hive Engine can access the information to serve our queries.

Let us understand where the metadata is stored.

Information is typically stored in relational database and it is called as metastore.
It is extensively used by Hive engine for syntax and semantics check as well as execution of Hive Queries.
In our case it is stored in MySQL Database. Let us review the metastore tables.
````
````shell script
$ mysql -u root -p
SHOW databases;

USE metastore;

SHOW tables;

SELECT * 
FROM  TBLS;

$ cd /usr/lib/hive/conf
$ view hive-site.xml
````

### Overview of Beeline-Alternative to Hive CLI
````text
Let us understand another CLI which can be used to run Hive Queries.

There is no authentication and authorization for Hive CLI
Hive CLI is being deprecated and it is recommended to use beeline.
Beeline uses JDBC and connects to Hive via HiveServer2
We can integrate Beeline with Sentry for authentication and authorization.
You can get help over beeline using beeline --help

Let us see some important beeline commands

!help
!sh
!script
!connect

Example to connect to Hive
!connect jdbc:hive2://nn01.itversity.com:10000/training_retail

Enter OS username as username for now and hit enter for the password as we have not integrated with sentry.
````
````shell script
$ beeline --help
$ beeline -u jdbc:hive2://quickstart.cloudera:10000/

beeline> !help
beeline> !history
# Linux shell command
beeline> !sh ls -ltr
# Hadoop shell command
beeline> dfs -ls /user;
````

### Running Hive Queries Using Beeline
````text
Let us understand how we can use beeline to run Hive Queries.

Once connected we can run all the Hive commands in beeline.
Switch to database
Create tables
List tables
and more
````
````iso92-sql
USE training_retail;
SHOW tables;
DESCRIBE FORMATTED orders;
````
````shell script
$ beeline --help

$ beeline -u jdbc:hive2://quickstart.cloudera:10000/

$ beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail -e "SELECT COUNT(1) AS count FROM orders"
````
