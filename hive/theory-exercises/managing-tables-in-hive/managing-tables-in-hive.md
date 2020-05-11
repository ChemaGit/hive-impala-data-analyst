## MANAGING TABLES IN HIVE

### Create Tables In Hive

[https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-CreateTableCreate/Drop/TruncateTable][Hive Documentation]

[Hive Documentation]: https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-CreateTableCreate/Drop/TruncateTable

````text
Let us understand how to create table in Hive using orders as example.
````
````iso92-sql
CREATE TABLE orders (
  order_id INT,
  order_date STRING,
  order_customer_id INT,
  order_status STRING
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';
````
````shell script
$ beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail -e "DROP TABLE orders"

$ beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail
````
````iso92-sql
CREATE TABLE orders(
 order_id INT,
 order_date STRING,
 order_customer_id INT,
 order_status STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

SHOW tables;
DESCRIBE FORMATTED orders;
````

### Overview Of Data Types in Hive

[https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-CreateTableCreate/Drop/TruncateTable][Hive Documentation]

[Hive Documentation]: https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-CreateTableCreate/Drop/TruncateTable

### Adding Commments to Columns and Tables
````shell script
$ beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail
````
````iso92-sql
DROP TABLE orders;

CREATE TABLE orders(
order_id INT COMMENT 'Unique order id',
order_date STRING COMMENT 'Date on which order is placed',
order_customer_id INT COMMENT 'Customer id who placed the order',
order_status INT COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
````

### Loading Data Into Hive Tables From Local System
````iso92-sql
USE training_retail;
DROP TABLE orders;

CREATE TABLE orders (
  order_id INT COMMENT 'Unique order id',
  order_date STRING COMMENT 'Date on which order is placed',
  order_customer_id INT COMMENT 'Customer id who placed the order',
  order_status STRING COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INPATH '/data/retail_db/orders' INTO TABLE orders;

-- Once the data is loaded we can run these queries to preview the data.

SELECT * 
FROM orders 
LIMIT 10;

SELECT COUNT(1) 
FROM orders;

-- beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail

CREATE TABLE orders (
  order_id INT COMMENT 'Unique order id',
  order_date STRING COMMENT 'Date on which order is placed',
  order_customer_id INT COMMENT 'Customer id who placed the order',
  order_status STRING COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details'
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
 STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/cloudera/CCA159DataAnalyst/data/retail_db/orders' INTO TABLE training_retail.orders;

TRUNCATE TABLE orders;

LOAD DATA LOCAL INPATH '/home/cloudera/CCA159DataAnalyst/data/retail_db/orders' INTO TABLE training_retail.orders;

dfs -ls /home/cloudera/CCA159DataAnalyst/data/retail_db/orders;
````

### Loading Data Into Hive Tables From HDFS Location
````text
Let us understand how we can load data from HDFS location into Hive table.

We can use load command with out inpath to get data from HDFS location into Hive Table.
User running load command from HDFS location need to have write permissions 
on the source location as data will be moved (deleted on source and copied to Hive table)
Make sure user have write permissions on the source location.
First we need to copy the data into HDFS location where user have write permissions.

$ hdfs dfs -mkdir /user/training/retail_db
$ hdfs dfs -put /data/retail_db/orders /user/training/retail_db

Here is the script which will truncate the table and then load the data from HDFS location to Hive table.
````

````iso92-sql
USE training_retail;
TRUNCATE TABLE orders;

LOAD DATA INPATH '/user/training/retail_db/orders' 
  INTO TABLE orders;

-- $ beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail

TRUNCATE TABLE orders;
LOAD DATA INPATH '/user/cloudera/orders' INTO TABLE traning_retail.orders;
````

### Loading Data Into Hive Tables - Overwrite VS. Append
````text
Let us see how we can overwrite or append into Hive table.

INTO TABLE will append in the existing table
If we want to overwrite we have to specify OVERWRITE INTO TABLE
````
````iso92-sql
dfs -ls /apps/hive/warehouse/training_retail.db/orders

LOAD DATA LOCAL INPATH '/data/retail_db/orders' INTO TABLE orders;

dfs -ls /apps/hive/warehouse/training_retail.db/orders;

LOAD DATA LOCAL INPATH '/data/retail_db/orders' OVERWRITE INTO TABLE orders;

dfs -ls /apps/hive/warehouse/training_retail.db/orders;

$ beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail

SHOW tables;

TRUNCATE TABLE orders;

LOAD DATA LOCAL INPATH '/home/cloudera/CCA159DataAnalyst/data/retail_db/orders' INTO TABLE orders;

SELECT COUNT(*) 
FROM orders;

LOAD DATA LOCAL INPATH '/home/cloudera/CCA159DataAnalyst/data/retail_db/orders' OVERWRITE INTO TABLE orders;

SELECT *
FROM orders 
LIMIT 10;
````

### Creating external tables in Hive
````text
Let us understand how to create external table in Hive using orders as example. 
Also we will see how to load data into external table.

We just need to add EXTERNAL keyword in the CREATE clause.
If we do not specify EXTERNAL between CREATE and TABLE, then table is called as Managed Table.
We can use same LOAD commands to get data from either local file system or HDFS which we have used for Managed table.
Once table is created we can run DESCRIBE FORMATTED orders to check the metadata of the table 
and confirm whether it is managed table or external table.
````

````iso92-sql
USE training_retail;
DROP TABLE orders;

CREATE EXTERNAL TABLE orders (
  order_id INT COMMENT 'Unique order id',
  order_date STRING COMMENT 'Date on which order is placed',
  order_customer_id INT COMMENT 'Customer id who placed the order',
  order_status STRING COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INPATH '/data/retail_db/orders' 
  INTO TABLE orders;

-- $ beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail

hive> DESCRIBE FORMATTED orders;

DROP TABLE orders;

CREATE EXTERNAL TABLE orders (
  order_id INT COMMENT 'Unique order id',
  order_date STRING COMMENT 'Date on which order is placed',
  order_customer_id INT COMMENT 'Customer id who placed the order',
  order_status STRING COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details'
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INPATH '/home/cloudera/CCA159DataAnalyst/data/retail_db/orders' INTO TABLE orders;

SELECT * FROM orders LIMIT 10;
````

### Specifying Location For Hive Tables
````text
Let us understand how to specify the location while creating managed table or external table in Hive.

LOCATION can be specified for both Managed tables as well as external tables.
Default location is determined by hive.metastore.warehouse.dir, then sub directory with 
database name and then another sub directory with table name. 
In our case it is /apps/hive/warehouse/training_retail.db/orders
User creating table with LOCATION should be having write permission on that location.
Here is the script to drop the table and recreate with LOCATION, then load data into it.
````
````iso92-sql
dfs -rm -R /user/training/retail_db/orders;
dfs -mkdir /user/training/retail_db/orders;

USE training_retail;
DROP TABLE orders;

CREATE EXTERNAL TABLE orders (
  order_id INT COMMENT 'Unique order id',
  order_date STRING COMMENT 'Date on which order is placed',
  order_customer_id INT COMMENT 'Customer id who placed the order',
  order_status STRING COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/user/training/retail_db/orders';

LOAD DATA LOCAL INPATH '/data/retail_db/orders' INTO TABLE orders;


-- beeline -u jdbc:hive2://quickstart.cloudera:10000/training_retail

SHOW tables;
DESCRIBE FORMATTED orders;
dfs -rm -r /user/hive/warehouse/training_retail.db/orders;

DROP TABLE orders;

dfs -mkdir /user/cloudera/retail_db;
dfs -mkdir /user/cloudera/retail_db/orders;

CREATE EXTERNAL TABLE orders (
  order_id INT COMMENT 'Unique order id',
  order_date STRING COMMENT 'Date on which order is placed',
  order_customer_id INT COMMENT 'Customer id who placed the order',
  order_status STRING COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/cloudera/retail_db/orders';

LOAD DATA LOCAL INPATH '/home/cloudera/CCA159DataAnalyst/data/retail_db/orders' INTO TABLE training_retail.orders;

SELECT * FROM orders LIMIT 10;
````

### Managed Tables Vs External Tables
````text
Let us compare and contrast between Managed Tables and External Tables.

When we say EXTERNAL as part of CREATE TABLE, it makes the table EXTERNAL.
Rest of the syntax is same as Managed Table.
However, when we drop Managed Table, it will delete metadata from metastore as well as data from HDFS.
When we drop External Table, only metadata will be dropped, not the data.
Typically we use External Table when same dataset is processed by multiple 
frameworks such as Hive, Pig, Spark etc.
````

### Default Delimiters in Hive Tables Using Text File Format 
````iso92-sql
DESCRIBE FORMATTED orders;

DROP TABLE orders;

CREATE TABLE orders (
order_id INT COMMENT 'Unique order id',
order_date STRING COMMENT 'Date on which order is placed',
order_customer_id INT COMMENT 'Customer id who placed the order',
orders_status STRING COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details';

CREATE TABLE orders_stage (
order_id INT COMMENT 'Unique order id',
order_date STRING COMMENT 'Date on which order is placed',
order_customer_id INT COMMENT 'Customer id who placed the order',
orders_status STRING COMMENT 'Current status of the order'
) COMMENT 'Table to save order level details'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/cloudera/CCA159DataAnalyst/data/retail_db/orders' INTO TABLE orders_stage;

INSERT INTO TABLE orders SELECT * FROM orders_stage;

SELECT * 
FROM orders;

DROP TABLE orders_stage;
````

### Overview Of File Formats - Stored As Clause
````text
Let us go through the details about STORED AS Clause.

Go to this link 
````
[https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-CreateTableCreate/Drop/TruncateTable][Hive Documetation]

````text
and review supported file formats.

Supported File Formats
    TEXTFILE
    ORC
    PARQUET
    AVRO
    SEQUENCEFILE
    JSONFILE
    and more
We can even specify custom file formats
````

### Differences Between RDBMS And Hive
````text
Let us understand the differences between RDBMS and Hive.

RDBMS Tables are Schema on Write. For each and every write operation 
there will be validations such as Data Types, Scale, Precision, 
Check Constraints, Null Constraints, Unique Constraints performed.

RDBMS Tables are fine tuned for best of the performance for transactions (PoS, Bank Transfers etc) 
where as Hive is meant for heavy weight batch data processing.

We can create indexes which are populated live in RDBMS. 
In Hive, indexes are typically static and when ever we add the data, indexes have to be rebuilt.
Even though one can specify constraints in Hive tables, they are only informational. 
The constraints might not be enforced.
We don’t perform ACID Transactions in Hive Tables.
There are no Transaction based statements such as COMMIT, ROLLBACK etc. in Hive.
Metastore and Data are decoupled in Hive. Metastore is available in RDBMS and 
actual business data is typically stored in HDFS.
````
### Truncating And Dropping Tables in Hive
````text
Let us understand how to DROP tables in Hive.
````
We can use DROP TABLE command to drop the table… Let us drop tables orders as well as orders_stage.
````iso92-sql
DROP TABLE orders;
DROP TABLE orders_stage;
DROP DATABASE training_retail;
-- OR
DROP DATABASE training_retail CASCADE;
````
````text
DROP TABLE on managed table will delete both metadata in metastore as well as data in HDFS, 
while DROP TABLE on external table will only delete metadata in metastore.
We can drop database by using DROP DATABASE Command. 
However we need to drop all the tables in the database first.
Here is the example to drop the database training_retail - 
````
````iso92-sql
DROP DATABASE training_retail;
````

### Let us understand how to truncate tables.
````text
TRUNCATE works only for managed tables. Only data will be deleted, structure will be retained.
````
````iso92-sql
CREATE DATABASE training_retail;
CREATE TABLE orders (
  order_id INT,
  order_date STRING,
  order_customer_id INT,
  order_status STRING
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INPATH '/data/retail_db/orders'
INTO TABLE orders;

SELECT * 
FROM orders 
LIMIT 10;

TRUNCATE TABLE orders;

SELECT * 
FROM orders; 
````

### ADVANCED CREATE TABLE TECHNIQUES

# SPECIFYING TBLPROPERTIES

CREATE EXTERNAL TABLE dbname.tablename (col1 TYPE, col2 TYPE, ...)
	ROW FORMAT ...
	STORED AS ...
	LOCATION ...
	TBLPROPERTIES('skip.header.line.count'='1');

# USING HIVE SERDES
````text
Traditional data processing relies on data being stored in structured tables with well-defined rows and columns. 
However, data is often not structured this way. 
A lot of data exists in unstructured or semi-structured text files, such as log files, 
free-form notes in electronic medical records, different types of electronic messages, and product reviews. 
This kind of data can provide valuable insights, but working with it requires a different approach.

Hive provides features for working with unstructured text data, 
semi-structured data in formats like JSON, and data that lacks consistent delimiters. 
Note that the features discussed in this reading are supported only by Hive, not by Impala.

Recall that the clause ROW FORMAT DELIMITED is used when creating a table with data stored in text files. 
When you create a table using this clause, 
the data in the underlying text files must be organized into rows and columns with consistent delimiters.

**Hive SerDes**

Hive provides interfaces called SerDes that can read and write data that is not in a structured tabular format. 
SerDe stands for serializer/deserializer. 
Serializing is the process for converting data to bytes so it can be stored; 
deserializing is the reverse process—decoding when reading the stored file.

You can specify a table’s SerDe when you create the table. 
Actually, every table in Hive has a SerDe associated with it, whether you realize it or not. 
Typically, the SerDe is automatically set to the default for a given file format, 
based on the ROW FORMAT and STORED AS clauses. 

For a table stored as text files, the default SerDe is called LazySimpleSerDe. 
The LazySimpleSerDe gets its name because it uses a technique called lazy initialization for better performance. 
That means it does not instantiate objects until they’re needed.

In addition to LazySimpleSerDe, Hive includes several other built-in SerDes for working with data in text files. 
If you want to use one of these, you must explicitly specify the SerDe in the CREATE TABLE statement. 
The statement includes the clause ROW FORMAT SERDE followed by the 
fully qualified name of the Java class that implements the SerDe, enclosed in quotes.

For example, Hive includes the OpenCSVSerde, which can process data in comma-separated values (CSV) files.
But why does Hive need a special CSV SerDe when the default SerDe can handle comma-delimited text files 
(when you specify ROW FORMAT DELIMITED FIELDS TERMINATED BY ',')
Although Hive’s default SerDe can work with simple comma-delimited text data, 
the actual CSV format allows things like commas embedded within fields, quotes enclosing fields, and missing fields. 
Hive’s default SerDe does not support these, but the OpenCSVSerde does. 
The OpenCSVSerde also supports other delimiters such as the tab and pipe characters.

The Try It! section of “The ROW FORMAT Clause” reading presented an example where you incorrectly 
create a table from a comma-delimited file, because the delimiter was not specified. 
You corrected this by using a ROW FORMAT DELIMITED clause, but you also could have corrected it using the OpenCSVSerde: 

CREATE EXTERNAL TABLE default.investors
(name STRING, amount INT, share DECIMAL(4,3))
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde';

Two other examples are RegexSerDe, which identifies individual fields within each 
record based on a regular expression, and JsonSerDe, which processes data in JSON format. 
See the next reading for more on these SerDes.

In addition to using SerDes to read and write text data, Hive also uses SerDes to read to and write 
from binary and columnar formats like Avro and Parquet, but Hive does this automatically and hides the details from the user. 
Note, however, that the SerDe is not the same as the file type, but there is a close connection—file 
types require particular SerDes so Hive can read and write those file types. 
For now, just remember that SerDes define processes for reading data files. 

While OpenCSVSerde allows you to both read and write files using the specified formatting, 
some SerDes will only read files; you cannot use them to write. 
You should test your SerDes or read the documentation to determine if writing files is supported.

Try It!
Do the following to create a table named tunnels in the dig database.

1. Examine the data in the file training_materials/analyst/data/tunnels.csv 
on the local file system of the VM. Note that it's a comma-delimited text file.

2. In the Hive query editor, execute the following statement. 
Note that it uses the OpenCSVSerde rather than the ROW FORMAT DELIMITED syntax. 
Also you must use Hive, not Impala.

CREATE TABLE dig.tunnels
(terminus_1 STRING, terminus_2 STRING, distance SMALLINT)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde';

3. In a Terminal window, run the following statement (all on one line) 
   to move the tunnels.csv into the table directory. 

$ hdfs dfs -put ~/training_materials/analyst/data/tunnels.csv /user/hive/warehouse/dig.db/tunnels/

4. Use the data source panel or a Hive SELECT * statement to verify that the tunnels table has the data, 
    with values in the correct columns. 
	Remember that you can query this table only with Hive, not with Impala.
````
### WORKING WITH UNSTRUCTURED AND SEMI-STRUCTURED DATA
````text
The sections below describe two SerDes for working with unstructured and semi-structured data: 
JsonSerDe and RegexSerDe.

**JsonSerDe**

Hive's JsonSerDe is useful for semi-structured data stored in JSON (JavaScript Object Notation) format. 
To use the SerDe, the CREATE TABLE statement for the table should include the clause ROW FORMAT SERDE 
followed by the fully qualified name of the Java class that implements the JsonSerDe, enclosed in quotes. 

For example, a couple of records in a JSON file might look like this:

{"id":393930, "name":"Aleks Norkov", "city":"Berkeley", "state":"CA"}
{"name":"Christine Goldbaum", "city":"Boulder City", "state":"NV", "id":82800}

The CREATE TABLE statement might look like this:

CREATE TABLE dig.subscribers
(id INT, name STRING, city STRING, state STRING)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe';

The table would include the correct data, even though the records were not organized exactly the same.

**Example 1**

file.json

{"aa": {"a": "A","b": "B","c": "C","d": [{"d_1": "D-1","d_2": "D-2"}],"e": "E"}}
{"aa": {"a": "AA","b": "BB","c": "CC","d": [{"d_1": "DD-11","d_2": "DD-22"}],"e": "EE"}}

CREATE TABLE my_table(aa struct<
    a:string,
    b:string,
    c:string,
    d:array<struct<
        d_1:string,
        d_2:string>>,
    e:string>)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/user/training/json';

SELECT aa FROM my_table;
SELECT aa.a FROM my_table;

**Example 2**

file2.json
{ "purchaseid": { "ticketnumber": "23546852222", "location": "vizag", "Travelerhistory": { "trav": { "fname": "ramu", "lname": "gogi", "travelingarea": { "destination": { "stationid": "KAJKL", "stationname": "hyd" } }, "food": { "foodpref": [{ "foodcode": "CK567", "foodcodeSegment": "NOVEG" }, { "foodcode": "MM98", "foodcodeSegment": "VEG" } ] } } } } }

CREATE TABLE my_table2(
purchaseid STRUCT<ticketnumber:STRING,location:STRING,
  Travelerhistory:STRUCT<
    trav:STRUCT<fname:STRING,lname:STRING,
        travelingarea:STRUCT< destination :STRUCT<stationid:string,stationname:string>>,
    food :STRUCT<foodpref:ARRAY<STRUCT<foodcode:string,foodcodeSegment:string>>>
    >>>)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe' 
LOCATION '/user/training/json2/';

**RegexSerDe**

Hive’s RegexSerDe is useful for semi-structured or unstructured data. 
It identifies the fields within each record based on a regular expression (a way to describe patterns in text). 
For example, using the RegexSerDe, Hive can directly read a log file that lacks consistent delimiters. 
As with the other SerDes, the CREATE TABLE statement for the table should include the clause 
ROW FORMAT SERDE followed by the fully qualified name of the Java class that implements the RegexSerDe, enclosed in quotes. 
To specify the regular expression, use WITH SERDEPROPERTIES("input.regex"="regular expression"). 
(If you're unfamiliar with regular expressions, see this Regular Expressions Tutorial.)

For example, here are two sample records from a log file. 
The fields are separated by a space, but there are also spaces within the quoted comment string. 
This makes it difficult to use the usual ROW FORMAT DELIMITED clause, because it would not be able 
to distinguish the spaces within the quotes from the delimiting spaces.

05/23/2016 19:45:19 312-555-7834 CALL_RECEIVED ""

05/23/2016 19:48:37 312-555-7834 COMPLAINT "Item damaged"

You could do some processing of the data to convert it, but the 
RegexSerDe allows you to work directly with the raw data through Hive. 
(This could be helpful for log files that are constantly being generated, adding to the data you want to use.) 
To do this, use a CREATE TABLE statement like the following.

CREATE TABLE dig.calls (
event_date STRING, event_time STRING,
phone_num STRING, event_type STRING, details STRING)   
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES ("input.regex" =  "([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) \"([^\"]*)\"");

Inside the regular expression, the parentheses define capture groups. 
The value of each field is the text matched by the pattern within each pair of parentheses. 
The first four fields capture any number of non-space characters, with the fields separated by one space. 
The last field begins after the literal quote character and captures any number of non-quote characters, 
then ends before the following quote character. 
The quote characters must be escaped with backslashes because they are themselves within a quoted string.

The five captured fields become the five columns of the table: event_date, event_time, phone_num, event_type, and details. 
Although this example uses the data type STRING for all five columns, the RegexSerDe does support other data types.

Note that RegexSerDe is for deserialization (reading), but it doesn't support serialization (writing). 
You can use LOAD DATA to load an existing file, but INSERT will not work.

Try It!
In the VM, try creating a couple of tables using these SerDes.

First, do the following to create a table using a JSON file for its data.

1. Examine the file in /user/hive/warehouse/subscribers/. This is the same example data used above.

2. Create the subscribers table. In Hive, execute the following statement:

CREATE EXTERNAL TABLE default.subscribers        
(id INT, name STRING, city STRING, state STRING)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe';

3. Execute a SELECT * statement to verify that the table has been created with the correct values in each column. 
Note that although the two rows gave the column values in different orders, 
each row has the correct values (the two IDs are 39390 and 82800, for example).

4. Optional: You can drop the table if you like. 
If you used EXTERNAL as noted above, dropping the table will not delete the data, 
so you can come back and recreate it later, if you like.

Now use the RegExSerDe. The data (see the example below) has fields that are not delimited; instead they use fixed widths. 

1030929610759620160829012215Oakland             CA94618

Field	Length
cust_id	7
order_id	7
order_dt 	8
order_tm 	6
city 	20
state	2
zip 	5

5. Optional: The sample data is in /user/hive/warehouse/fixed. 
(It's just the one row provided above.) You can take a look if you like.

6. Take a look at the regular expression in this CREATE TABLE statement, 
and see how it will split the row of data into the seven fields. 
In a regular expression, \d matches any digit, a dot (.) matches any character, 
and \w matches any word character (letters, numbers, or the underscore character). 
The first \ in \\d and \\w is to escape the second \ character. 
This lets Hive know this second \ is part of the regular expression and not the 
start of an escape sequence representing a special character.

CREATE EXTERNAL TABLE fixed     
(cust_id INT, order_id INT, order_dt STRING, order_tm STRING,
city STRING, state STRING, zip STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES ("input.regex"="(\\d{7})(\\d{7})(\\d{8})(\\d{6})(.{20})(\\w{2})(\\d{5})");

7. In Hive, execute the statement above.

8. Verify the results using the data source panel or a SELECT * query.

9. Optional: You can drop the table if you like. 
   If you used EXTERNAL as noted above, dropping the table will not delete the table, 
   so you can come back and recreate it later, if you like.
````
[Hive Documetation]: https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-CreateTableCreate/Drop/TruncateTable