## USING HIVE AND IMPALA TO LOAD DATA INTO TABLES

### SQL LOAD DATA STATEMENTS
````text
One way to load data into a table is by running a LOAD DATA INPATH statement with Hive or Impala. 
This moves the specified data files into the table’s storage directory in the file system (HDFS or S3).

The example shown below moves the file sales.txt from the HDFS directory 
/incoming/etl to the directory for the table named sales. 
Notice that this statement specifies the destination as a table name, not a directory; 
Hive or Impala uses metadata from the metastore to determine 
the table’s storage directory, and moves the file there.

LOAD DATA INPATH '/incoming/etl/sales.txt' INTO TABLE sales;

The source path can refer either to a file, as in this example, or to a directory, 
in which case Hive or Impala will move all the files within that directory into the table.

The LOAD DATA INPATH statement adds the source files to any existing files that are already 
in the table’s directory—that is, it does not remove existing files in the table’s directory, 
and if there are any filename collisions, then it automatically renames 
the new files so that no existing files are overwritten. 
In some cases, you may want to delete all existing data files in the table’s directory before loading new data files. 
To do this, use the OVERWRITE keyword, as shown in the example below. 
This option is useful when you need to do a complete reload of all the data in a table.

LOAD DATA INPATH '/incoming/etl/sales.txt' OVERWRITE INTO TABLE sales;

The LOAD DATA INPATH statement assumes that the files are already somewhere 
in a file system that is accessible to your instance of Hive or Impala (like HDFS or S3). 
If they are not, then you first need to load files from your local filesystem into HDFS or S3, 
for example by running an hdfs dfs -put command, or by using the Hue File Browser. 
Also, this method moves the files rather than copying them; 
the files will no longer exist in the source directory after the statement is executed. 

This probably sounds a lot like using hdfs dfs -mv — and it is, 
but there are a couple of advantages to using LOAD DATA INPATH. 

One is that, if you're running the LOAD DATA INPATH statement with Impala, 
the metadata cache is automatically updated. 
You do not need to execute a REFRESH command; your next query will include the new data.

The other advantage is that since the statement renames any files that are the same as files 
that already exist within the directory, you don't need to worry about what your files are named. 
If you use hdfs dfs -mv and there is an existing file with the same name, the command will fail 
and no changes will be made — you'll have to rename one of the files yourself, first.
````

### SQL INSERT STATEMENTS
````text
SQL INSERT statements, common for adding new rows of data 
to tables in RDBMSs, can be used with Hive and Impala. 
There are essentially two versions, INSERT INTO (which adds files without changing or deleting existing files) 
and INSERT OVERWRITE (which replaces existing files with new files). 

INSERT INTO tablename 
VALUES
    (row1col1value,row1col2value, … ),
    (row2col1value,row2col2value, … ),
    … ;

This can be helpful for testing a table, such as examining how it stores the data, 
especially with an unusual or edge case. 
However, as those exercises noted, in general this is an antipattern with Hive and Impala, 
and using it for data ingest in a production environment is a bad practice.

In general, files in HDFS are immutable—they cannot be directly modified. 
(A file in HDFS can be deleted, and it can be overwritten with a new version of the file, 
but in general a file in HDFS cannot be directly modified.) 
So, each time you run an INSERT statement, Hive or Impala creates a new file in 
the table’s storage directory to store the new data values given in the statement. 
So inserting data in small batches like this causes Hive or Impala to create many small 
files in the table’s storage directory. This is a problem.

The small files problem is a common problem in big data systems. 
Most of the tools and frameworks that run on a Hadoop cluster 
are designed to work with large files, not lots of small files. 
So if you have a lot of small files (anything less than about 64MB is considered small), 
operations such as queries in Hive and Impala become inefficient, and query performance is negatively affected. 
Each INSERT command creates a new file, and they will be quite small 
(for any amount of data that is reasonable to add using an INSERT command). 

One corrective solution for this, once you find you have a lot of small files, 
is to rewrite the whole dataset using this command:

INSERT OVERWRITE tablename SELECT * FROM tablename;

You'll learn more about INSERT … SELECT statements in the next reading.

Note that the small files problem can arise from other uses as well. 
For example, images are typically separate files, 
and there is no easy way to combine them into one file, 
so a large number of images will most likely be stored as a large number of files, 
potentially small ones depending on the resolution and size of the image. 
The corrective solution described above doesn't really help in that case; 
there are other ways to work around that problem, but this is beyond the scope of this course. 
If you're interested in reading more about the small files problem, 
see the Cloudera blog post, The Small Files Problem.

Note: You might see the syntax INSERT INTO TABLE or INSERT OVERWRITE TABLE. 
The TABLE keyword is optional. You can include it or not, as you like, 
but it's helpful to know that both syntaxes are valid, in case you see the one you decide not to use.

You can read more about using INSERT in Hive and Impala using these links:

Hive LanguageManual UDF, Inserting data into Hive Tables from queries
Cloudera's Impala documentation, INSERT Statement
````

### SQL INSERT SELECT AND CTAS STATEMENTS
````text
As you should know by now, the SELECT statement in SQL returns a result set. 
Typically, you either view this result set, or else store it in a file or in memory 
on your local computer where you might use it to generate a report or data visualization. 
However, you can do more with the SELECT statement than just view the results or store them locally. 
The result set from a SELECT statement has the same basic structure as a table, 
so you can use a result set to materialize a new table. 
As you’ll learn in this reading, it is possible to do this with a single command. 
This command allows you to save the result of a query to a table, 
so that you can later run another query to analyze or retrieve that result.

The way to do this is by combining together an INSERT and a SELECT into a single command. 
Using an INSERT statement, you can specify the name of the destination table, followed by a SELECT statement. 
This compound type of statement is known as an INSERT ... SELECT statement. 
Hive or Impala executes the SELECT statement then saves the results into the specified table. 
Note that the destination table must already exist. 
If you want to replace any existing data, use INSERT OVERWRITE; 
if you want to retain any existing data, use INSERT INTO.

For example, you might want to create a new table, chicago_employees,that contains 
only the rows of the employees table for employees in the Chicago office (office_id = 'b'). 
After you create this table (perhaps using LIKE employees in the CREATE TABLE command), 
the following command will populate the table with the desired rows. 
Any previously existing records in the chicago_employees table are deleted. 

INSERT OVERWRITE chicago_employees
SELECT * FROM employees WHERE office_id='b';

The line breaks and indentation used in these examples are all optional. 
The indentation serves to show that the SELECT statement is actually part of the INSERT statement.

As mentioned above, an INSERT … SELECT statement requires that the destination table already exists. 
But there is a different statement that does not require this: the CREATE TABLE AS SELECT (CTAS) statement. 
A CTAS statement creates a table and populates it with the result of a query, all in one command.

For example, the following CTAS statement creates the chicago_employees table and loads 
the same data as the INSERT … SELECT command above, but it does it all in one command.

CREATE TABLE chicago_employees AS
SELECT * FROM employees WHERE office_id='b';

CTAS effectively combines a CREATE TABLE operation and an INSERT … SELECT operation into a single step. 
The column names and data types for the newly created table are determined based 
on the names and types of the columns queried in the SELECT statement.

However, the other attributes of the newly created table, like the delimiter and storage format, 
are not based on the format of the table you’re querying; 
you must specify these attributes, or else the newly created table will use the defaults. 
So in the example here, since there is no ROW FORMAT clause, 
Hive or Impala will use the default field delimiter, which is the ASCII Control+A character. 
If you wanted comma-delimited files, you would need to include a ROW FORMAT clause. 
You must put this (and any other clauses that specify properties of the new destination table) 
before the AS keyword, as shown in the example below.

CREATE TABLE chicago_employees
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
AS
    SELECT * FROM employees WHERE office_id='b';

With both CTAS and INSERT … SELECT, you could select only some columns 
to include in the new table by listing only the desired columns in the SELECT list. 
For example, since all the records are in the same office, 
the office_id column isn't really needed. You could use:

CREATE TABLE chicago_employees AS
    SELECT empl_id, first_name, last_name, salary 
        FROM employees 
        WHERE office_id='b';

Note that if the data in the employees table is updated after the chicago_employees table is created, 
then the data in the chicago_employees table would be stale—any new employees in Chicago 
are not automatically added to the chicago_employees table. 
So if you are using a CTAS or INSERT … SELECT statement to create a derivative table 
that you want kept up to date with the original table, then you need to set up some process to keep it up to date. 
For example, you could schedule a job that runs an INSERT OVERWRITE … SELECT statement 
to repopulate the derivative table nightly, so the data there is never more than 24 hours stale.

Try It!
Use the information above to create the chicago_employees table in two steps—create the table using 
LIKE employees (so the office_id column will be included) and populate it with the INSERT … SELECT statement above. 
Verify that the new table has only two rows, for Virginia and Luzja.
Drop the chicago_employees table (deleting the data—delete it manually if you created the table as an EXTERNAL table), 
and then recreate it without the office_id column, using a CTAS statement. 
Again verify that the new table has the two rows.

1- CREATE TABLE IN TWO STEPS

CREATE TABLE chicago_employees LIKE employees;

INSERT OVERWRITE chicago_employees
    SELECT * FROM employees WHERE office_id='b';

DROP TABLE chicago_employees;

2- CREATE A TABLE IN ONE STEP

CREATE TABLE chicago_employees AS
SELECT empl_id, first_name, last_name, salary 
    FROM employees 
    WHERE office_id='b';

DROP TABLE chicago_employees;
````







































