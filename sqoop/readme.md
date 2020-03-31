## What is Apache Sqoop?
````text
- Sqoop exchanges data between a DB and HDFS
- Can import all tables, a single table, or a partial table into HDFS
- Data can be imported in delimited text, SequenceFile, or Avro format
- Sqoop can also export data from HDFS to a DB
````

### Basic Syntax
````text
- Sqoop is a command-line utility with several subcommands, called tools
- There are tools for import, export, listing DB contents, and more
- Run sqoop help to see a list of all tools
- Run sqoop help tool-name for help on using a specific tool
````    
````shell script
# Basic syntax of a Sqoop invocation
sqoop tool-name [tool-options]
# This command will list all tables in the loudacre DB in MySQL
sqoop list-tables \
--connect jdbc:mysql://dev.loudacre.com/loudacre \
--username twheeler \
--password bigsecret
````

### Basic import and export
````text
- Imports are performed using Map-only jobs
- Sqoop begins by examining the table to be imported
- Determines the primary key, if possible
- Runs a boundary query to see how many records will be imported
- Divides the result of boundary query by the number of mappers
- Uses this to configure tasks so that they will have equal loads
- Sqoop also generates a Java source file each table being imported
````
````shell script
# Importing an Entire DB with Sqoop
# The import-all-tables tool imports an entire DB
# Stored as comma-delimited files below your HDFS home directory
# Data will be in subdirectories corresponding to the name of each table
sqoop import-all-tables \
--connect jdbc:mysql://dev.loudacre.com/loudacre \
--username twheeler \
--password bigsecret

# Use the --warehouse-dir option to specify a different base directory
sqoop import-all-tables \
--connect jdbc:mysql://dev.loudacre.com/loudacre \
--username twheeler --password bigsecret \
--warehouse-dir /loudacre
````

### Importing a Single Table with Sqoop
````shell script
# The import tool imports a single table
# This example imports the accounts table
# It stores the data in HDFS as comma-delimited fields
sqoop import --table accounts \
--connect jdbc:mysql://dev.loudacre.com/loudacre \
--username training --password training
# This variation writes tab-delimited fields instead
sqoop import --table accounts \
--connect jdbc:mysql://dev.loudacre.com/loudacre \
--username training --password training \
--fields-terminated-by "\t"
````

### Specifying the File Format for Imported Data
````shell script
# Sqoop can also store the imported data in Avro format
sqoop import --table accounts \
--connect jdbc:mysql://db.loudacre.com/loudacre \
--username training --password training \
--as-avrodatafile
# Use 
--as-sequencefile # instead for SequenceFile format
````

### Enabling Compression for imported Data
````text
- Sqoop does not compress imported data by default
- Add the -z option to enable compression (default: Gzip)
- Use --compression-codec option to specify an alternate codec
    Snappy --> org.apache.hadoop.io.compress.SnappyCodec
    BZip2 --> org.apache.hadoop.io.compress.BZip2Codec
````

### Incremental Imports
````text
- What if new records are added to the database?
- Could re-import all records, but this is inefficient
- Sqoop's incremental append mode imports only new records
- based on the value of the last record in the specified column
````
````shell script
sqoop import --table invoices \
--connect jdbc:mysql://db.loudacre.com/loudacre \
--username training --password training \
--incremental append \
--check-column id \
--last-value 9478306
````

### Exporting Data from Hadoop to an RDBMS with Sqoop
````text
- Sqoop's import tool pulls records from an RDBMS into HDFS
- It is sometimes necessary to push data in HDFS back to an RDBMS
- Good solution when you must do batch processing on large data sets
- Export results to a relational DB for access by other systems
- Sqoop suports this via the export tool
- The RDBMS table must already exist prior to export
````
````shell script
sqoop export \
--connect jdbc:mysql://dev.loudacre.com/loudacre \
--username training --password training \
--export-dir /loudacre/recommender_output \
--update-mode allowinsert   or updateonly
--table product_recommendations
````

### Customizing NULL Value Handling
````text
- Null values in the table are imported as null(literal four-character string)
- This can cause compatibility problems with Hive and Impala
- Use --null-string to specify an alternate value for string fields
- Use --null-non-string for alternate on non-string fields
````
````shell script
$sqoop import --table accounts \
--connect jdbc:mysql://dev.loudacre.com/loudacre \
--username training --password training \
--null-string "\\N" \
--null-non-string "\\N"
````
````
- The sqoop export command uses slightly different options
- Specify value for null strings with --input-null-string
- Use --input-null-non-string to specify it for non-string types
````

### Importing Partial Tables with Sqoop
````shell script
# Import only specified columns from accounts table
sqoop import --table accounts \
--connect jdbc:mysql://db.loudacre.com/loudacre \
--username training --password training \
--columns "id,first_name,last_name,state"
# Import only matching rows from accounts table
sqoop import --table accounts \
--connect jdbc:mysql://db.loudacre.com/loudacre \
--username training --password training \
--where "state='CA'"
````

### Using a Free-Form Query
````text
- You can also import the results of a query, rather than a single table
- Supply a complete SQL query using the --query option
- You must add the literal WHERE $CONDITIONS token
- Use --split-by to identify field used to divide work among mappers
- The --targe-dir option is required for free-form queries
````
````shell script
sqoop import \
--connect jdbc:mysql://db.loudacre.com/loudacre \
--username training --password training \
--target-dir /data/loudacre/payable \
--split-by accounts.id \
--query 'SELECT accounts.id, first_name, last_name, bill_amount 
         FROM accounts JOIN invoices ON (accounts.id = invoices.cust_id) 
         WHERE $CONDITIONS'
````

### Using a Free-Form Query with WHERE Criteria
````shell script
# The --where option is ignored in a free-form query
# You must specify your criteria using AND following the WHERE clause
$sqoop import \
--connect jdbc:mysql://db.loudacre.com/loudacre \
--username training --password training \
--target-dir /data/loudacre/payable \
--split-by accounts.id \
--query 'SELECT accounts.id, first_name, last_name, bill_amount 
         FROM accounts JOIN invoices ON (accounts.id = invoices.cust_id) 
         WHERE $CONDITIONS AND bill_amount >= 40'
````

## IMPROVING SQOOP'S PERFORMANCE
### Options for DB Connectivity
````text
- Generic (JDBC)
    -Compatible with nearly any db
    -Overhead impsed by JDBC can limit performance
- Direct Mode
    -Can improve performance through use of db-specific utilities
    -Currently supports MySQL and Postgres (use --direct option)
    -Not all Sqoop features are available in direct mode
````

### Controlling Parallelism
````text
- By default, Sqoop typically imports data using four Map tasks
    -Increasing the number of Map tasks might improve import speed
    -Caution: Each Map task adds load to your db server
- You can influence the number of Map tasks using the -m option
    -Sqoop views this only as a hint and might not honor it
````
````shell script
$sqoop import --table accounts \
--connect jdbc:mysql://db.loudacre.com/loudacre \
--username twheeler --password bigsecret \
-m 8
````

### Sqoop assumes all tables have an evenly-distributed numeric primary key
````text
-Sqoop uses this column to divide work among mappers
-You can use a different column with the --split-by option
````

### Hands-On Exercise: Importing Customer Account Data
````shell script
# In this exercise, you will import tables from MySQL with Sqoop

# 1) List the tables in the loudacre db
sqoop list-tables \
--connect jdbc:mysql://dev.loudacre.com/loudacre \
--username training --password training
			
# 2)Use Sqoop to import the accounts table in the loudacre db and save int in HDFS under /loudacre
sqoop import --table accounts \
--connect jdbc:mysql://dev.loudacre.com/loudacre \
--username training --password training \
--target-dir /loudacre/accounts \
--null-string '\\N' \
--null-non-string '\\N'
# The last two options tell Sqoop to represent null values as \N, which makes 
# the imported data compatible with Hive and Impala
	
# 3)List the contents of the accounts directory:
hdfs dfs -ls /loudacre/accounts
	
# 4)Use Haddop's tail command to view the last part of the file for each of the MapReduce part files:
hdfs dfs -tail /loudacre/accounts/part-m-00000
hdfs dfs -tail /loudacre/accounts/part-m-00001
hdfs dfs -tail /loudacre/accounts/part-m-00002
hdfs dfs -tail /loudacre/accounts/part-m-00003

### IMPORTING INCREMENTAL UPDATES
# 1)Incrementally import and append the newly added accounts to the accounts directory.
# Use Sqoop to import on the last value on the acct_num column largest account ID
sqoop import \
--connect jdbc:mysql://dev.loudacre.com/loudacre \
--username training --password training \
--incremental append \ 
--null-string '\\N' \
--null-non-string '\\N' \
--table accounts \
--target-dir /loudacre/accounts \
--check-column acct_num \
--last-value 97349
//--last-value <largest_acct_num>

# Note: replace<largest_acct_num> with the largest account number
sqoop eval \
--connect jdbc:mysql://dev.loudacre.com/loudacre \
--username training --password training \
--query 'SELECT MAX(acct_num) FROM accounts'
# result:  MAX(acct_num) 129764

# 2)List the contents of the accounts directory
hdfs dfs -ls /loudacre/accounts

# 3)You should see new files
hdfs dfs -cat /loudacre/accounts/part-m-00004
hdfs dfs -cat /loudacre/accounts/part-m-00005
hdfs dfs -cat /loudacre/accounts/part-m-00006
hdfs dfs -cat /loudacre/accounts/part-m-00007
````

### BONUS EXERCISE
````shell script
# 1)Import the accounts table, using the tab character as the delimiter, into a target directory named account-tabbed
sqoop import \
--connect jdbc:mysql://dev.loudacre.com/loudacre \
--username training --password training \
--table accounts \
--target-dir account-tabbed \
--fields-terminated-by "\t"

# 2)Import the accounts table in SequenceFile format to a target directory named account-seq
sqoop import \
--connect jdbc:mysql://dev.loudacre.com/loudacre \
--username training --password training \
--table accounts \
--target-dir account-seq \
--as-sequencefile

# 3)Import the accounts table in Avro format to a target directory named account-avro
sqoop import \
--connect jdbc:mysql://dev.loudacre.com/loudacre \
--username training --password training \
--table accounts \
--target-dir account-avro \
--as-avrodatafile

# 4)Use Sqoop to import only accounts where the person lives in California (state="CA") and has an active account(acct_close_dt IS NULL). 
# Specify a target directory of account-active-ca
sqoop import \
--connect jdbc:mysql://dev.loudacre.com/loudacre \
--username training --password training \
--table accounts \
--target-dir account-active-ca \
--where 'state = "CA" and acct_close_dt IS NULL'
````





