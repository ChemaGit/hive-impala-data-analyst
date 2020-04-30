## THE CREATE TABLE STATEMENT

### INTRODUCTION TO THE CREATE TABLE STATEMENT
````text
CREATE TABLE dbname.tablename(col1 TYPE, col2 TYPE, ....);

CREATE EXTERNAL TABLE dbname.tablename(col1 TYPE, col2 TYPE, ....);

CREATE TEMPORARY TABLE dbname.tablename(col1 TYPE, col2 TYPE, ....);
	ROW FORMAT ...
	STORED AS ...
	LOCATION ...;
````

### THE ROW FORMAT CLAUSE
````text
As you're probably aware, data files can come in different formats. 
For example, a file might be comma-delimited, which means the comma (,) 
is used to mark (delimit) when one column's value ends and the next column's value begins. 
The tab character is often used instead, giving a tab-delimited file.

As part of the CREATE TABLE statement, you can specify how the data is delimited in its files. 
This is done using the ROW FORMAT clause. The syntax for this clause is:

    ROW FORMAT DELIMITED FIELDS TERMINATED BY character

For example, consider this row from a data file:

    1,Data Analyst,135000,2016-12-21 15:52:03

There are four fields here, separated by commas: 
an ID, a job title, a salary, and a timestamp when the data was recorded. 
The following statement will create the table:

    CREATE TABLE jobs (id INT, title STRING, salary INT, posted TIMESTAMP)
        ROW FORMAT DELIMITED
        FIELDS TERMINATED BY ',';


The ROW FORMAT DELIMITED portion of this clause specifies that you are using a delimiter. 
You also need the FIELDS TERMINATED BY portion, to specify which delimiter you are using. 
In this case, the delimiter is the comma (,). 
If the delimiter were the tab character, the clause would use \t in quotes 
(because \t is the escape sequence representing the tab character):

    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'

The FIELDS TERMINATED BY portion is a part of the ROW FORMAT clause. 
It must be preceded by ROW FORMAT DELIMITED. 
The line break and indentation used in these examples is optional.

If you omit the ROW FORMAT clause, Hive and Impala will use 
the default field delimiter, which is the ASCII Control+A character. 
This is a non-printing character, so when you attempt to view this character using 
a text editor or a cat command, it might render as a symbol (such as a rectangle with 0s and 1s in it) 
and other characters might overlap with it.

Try It!
In the following exercises, you can see how the ROW FORMAT clause dictates storage of new data for a table, 
and how it tells Hive and Impala how to correctly read a table in existing data files.

On the VM:

1. Log in to Hue and go to the Impala query editor.
2. Do the following to create a comma-delimited table, 
fill it with one row of data, and look at the resulting file on HDFS:

a. Execute the CREATE TABLE statement: 

CREATE TABLE jobs (id INT, title STRING, salary INT, posted TIMESTAMP)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

b. Load one row of data by executing the following statement. 
(Note: This statement is not a good way to add a lot of data to a table in a big data system.
 Here, we're only adding one row for demonstration purposes.)

INSERT INTO jobs VALUES (1,'Data Analyst',135000,'2016-12-21 15:52:03');

c. Use the File Browser or the data source panel on the left side 
(choosing the files icon rather than the database icon) and find the /user/hive/warehouse/jobs directory. 
If you don't see the jobs subdirectory, refresh the display by clicking the refresh button (two curved arrows). 
Find a file with a name that's just a string of letters and numbers, and click that file.

d. You can see the contents of the file in the main panel. 
   Notice that you have a comma-delimited row of data.

e. Notice that the string and timestamp values stored in this file are not enclosed in quotes. 	
Quotes were used in the INSERT statement to enclose the literal string and timestamp values, 
but Hive and Impala do not store these quotation marks in the table’s data files.

3. Now go back to the Impala query editor and create a tab-delimited table, 
fill it with the same data, and compare the resulting file on HDFS to what you had for the comma-delimited file:

a. Execute the CREATE TABLE statement (the only differences are the table name and the delimiting character): 

CREATE TABLE jobs_tsv (id INT, title STRING, salary INT, posted TIMESTAMP)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

b. Load one row of data by executing the following statement. 
(Note: This statement is not a good way to add a lot of data to a table in a big data system
. Here, we're only adding one row for demonstration purposes.)

INSERT INTO jobs_tsv VALUES (1,'Data Analyst',135000,'2016-12-21 15:52:03');

c. Use the File Browser or the data source panel on the left side 
(choosing the files icon rather than the database icon) and find the /user/hive/warehouse/jobs_tsv directory. 
If you don't see the jobs_tsv subdirectory, refresh the display by clicking the refresh button (two curved arrows). 
Find a file with a name that's just a string of letters and numbers, and click that file.

d. You can see the contents of the file in the main panel. 
Notice that this time, you have a tab-delimited row of data.

e. Notice that the string and timestamp values stored in this file are not enclosed in quotes. 
Quotes were used in the INSERT statement to enclose the literal string and timestamp values, 
but Hive and Impala do not store these quotation marks in the table’s data files.

4. Drop the jobs and jobs_tsv tables. 

DROP TABLE jobs_tsv;

5. When you're creating a table for existing files, you'll want to specify how the file is already delimited. 
	Do the following steps to see this at work.

a. First, examine the data in the /user/hive/warehouse/investors directory. 
This will be the default location for a table named default.investors. 
There is no table for this data yet, so you will create one. 
Notice that the file is comma-delimited.

b. Create an externally managed investors table using the following statement 
(which purposefully does not specify the delimiter). 
It's important to use the EXTERNAL keyword, so you can drop the table without deleting the data.

CREATE EXTERNAL TABLE default.investors(name STRING, amount INT, share DECIMAL(4,3));

c. Use Hue to look at the table. It only has a few rows, so you can use 
SELECT * FROM investors; 
in the query editor, or you can use the data source panel to view the sample data. 
Notice that the entire row ended up in the name column! 
This is because the command used the default delimiter, Control+A, rather than the comma.

d. Drop the table by entering and executing the command 
DROP TABLE investors; 
Check that the /user/hive/warehouse/investors directory still exists and has a file in it. 

e. Now, create another investors table using the ROW FORMAT clause to specify the delimiter:

CREATE EXTERNAL TABLE default.investors(name STRING, amount INT, share DECIMAL(4,3))
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

f. Use Hue to look at the table. Now each column should have values. Keep this table, you will use it again later.

If you accidentally deleted your data:
Open a Terminal window. 
(You can do this by clicking the icon in the menu bar that looks like a computer.) 
Enter and run the following command (on one line), which will copy the file from your local disk to the proper place in HDFS. 
Do not include the $; that's the prompt to indicate this is a command-line shell command.

$ hdfs dfs -put ~/training_materials/analyst/scripts/static_data/default/investors  /user/hive/warehouse/
````

### THE STORED AS CLAUSE
````text
The data for each table is stored in files. 
The ROW FORMAT clause specifies the delimiters between column values in those files, 
but there are different file formats you can use. 

The STORED AS clause in the CREATE TABLE statement allows you to specify what file format you want a new table to use. 
To create a table that uses existing data files, you need to match the format of the file.

The syntax for this clause is simply:

   STORED AS filetype

For example, a table creation statement might look like this:

CREATE TABLE jobs (id INT, title STRING, salary INT, posted TIMESTAMP)
STORED AS TEXTFILE;

The default file format is TEXTFILE—simple text format, 
which is human readable—so in this example, the STORED AS clause is optional. 
Without it, Hive or Impala would still use TEXTFILE for the file format. 
However, other file formats (which will often look like gibberish if you try to view the files directly) 
must be specified explicitly.

Try It!
On the VM:

1. Log in to Hue and go to the Impala query editor.
2. Do the following to create a table, fill it with one row of data, and look at the resulting file on HDFS:

a. Execute the following CREATE TABLE statement:

CREATE TABLE jobs_txt(id INT, title STRING, salary INT, posted TIMESTAMP)
STORED AS TEXTFILE;

b. Load one row of data by executing the following statement.

INSERT INTO jobs_txt VALUES (1,'Data Analyst',135000,'2016-12-21 15:52:03');

c. Use the File Browser or the data source panel and find the /user/hive/warehouse/jobs_txt directory.  
If you don't see the jobs_txt subdirectory, refresh the display by clicking the refresh button (two curved arrows). 
Find a file with a name that's just a string of letters and numbers, and click that file.

d. You can see the contents of the file in the main panel. 
Notice that you can clearly see each of the values you added to the table.

3. Now create another table using a different format, and see that the resulting file looks different:

a. Execute the following CREATE TABLE statement, which configures the table to store data in PARQUET format:

CREATE TABLE jobs_parquet (id INT, title STRING, salary INT, posted TIMESTAMP)
STORED AS PARQUET;

b. Load one row of data by executing the following statement.

INSERT INTO jobs_parquet VALUES (1,'Data Analyst',135000,'2016-12-21 15:52:03');

c. Use the File Browser or the data source panel and find the /user/hive/warehouse/jobs_parquet directory.  
If you don't see the jobs_parquet subdirectory, refresh the display by clicking the refresh button (two curved arrows). 
Find a file with a name that's just a string of letters and numbers, and click that file. 
You'll get an error message that says Hue can't read the file.

d. Open a Terminal window. 
Enter and run the following command, which will show the contents of the Parquet file. 
Notice that the output includes a lot of non-ASCII characters, so you can't really read most of it.

$ hdfs dfs -cat /user/hive/warehouse/jobs_parquet/*

4. Drop both tables (jobs_txt and jobs_parquet) since you won't need either again.

5. Now try creating a table using data from an existing Parquet file. 
When you're done, keep this table, because you'll use it again later. 
(If you use the EXTERNAL keyword as directed below, then dropping the table will not delete the data, 
so you could drop it now and come back and recreate the table later if you wish.)

a. A Parquet version of the investors data is also stored in HDFS, at /user/hive/warehouse/investors_parquet 
(which will be the default location for a table named default.investors_parquet). 
Examine the file in the same way as you examined the jobs Parquet file: 
In the Terminal window, issue the command hdfs dfs -cat /user/hive/warehouse/investors_parquet/investors.parquet. 
Again you'll see it's not really in human-readable format.

b. Now create the table from the query editor:

CREATE EXTERNAL TABLE default.investors_parquet(name STRING, amount INT, share DECIMAL(4,3))
STORED AS PARQUET;

c. Use the data source panel or run a SELECT * query to verify that the contents of the new table are correct. 
(It should look identical to the other investors table you created in "The ROW FORMAT Clause" reading.)
````
### THE LOCATION CLAUSE
````text
Unless otherwise specified, Hive and Impala store table data under the warehouse directory, 
which is by default the HDFS directory /user/hive/warehouse/. 
However, this may not be where you want to store some table data. 
For example, the data may already exist elsewhere in HDFS, and you may not have permission to move or copy it. 
If there’s a lot of data, copying it into the warehouse directory would be inefficient compared to querying it in its current location. 
Even if there’s not a lot of data, moving a copy to the warehouse directory means 
that the copy will be outdated as soon as changes are made to the original version.

The LOCATION clause allows you to create a table whose data is stored at a specified directory, 
which can be outside the warehouse directory. 
The syntax is simply:

    LOCATION 'path/to/location/'

The example shown below creates a new table named jobs_training whose data resides in the HDFS directory /user/training/jobs/. 
The specified storage directory may already exist, but if it does not, Hive or Impala will create it.

CREATE TABLE jobs_training(id INT, title STRING, salary INT, posted TIMESTAMP)
LOCATION '/user/training/jobs_training/';

To specify a storage directory outside of HDFS, you will need a fully qualified path in the LOCATION clause, 
including a protocol at the beginning of the path. 
For example, to specify a storage directory in Amazon S3, you will typically need to use 
LOCATION 's3a://bucket/folder/'.

Do Not Confuse This with the EXTERNAL Keyword
In practice, the EXTERNAL keyword is often used in conjunction with the LOCATION clause 
to specify a storage directory outside the warehouse directory. 
But when you use the keyword EXTERNAL, that does not necessarily mean 
that the data is stored outside the warehouse directory. 
In fact, if you use the keyword EXTERNAL, but you do not specify a directory with the LOCATION clause, 
then Hive and Impala will store the table data under the warehouse directory. 
On the other hand, if you use the LOCATION clause without the keyword EXTERNAL, 
dropping the table could delete the data, even if it's stored outside the warehouse directory.

So think of EXTERNAL as meaning externally managed (that is, managed by some software other than Hive or Impala) and not meaning externally stored. 
Remember that the LOCATION clause, not the EXTERNAL keyword, determines where the table data is stored.

Try It!
1. If you haven't already, use the Hue File Browser or the data source panel to examine the /user/hive/warehouse directory.  
You should see directories for databases (with .db at the end) and for any test tables 
that you've created in the default database and didn't drop. 
(If you haven't created any tables yet, you should still see some directories 
corresponding to tables in the default database, such as customers and employees.) 
Look inside one of these table directories and note whether there is a file inside. 
If the table has data, it will have at least one file here.

Next, do the following to create and examine a table whose data does not go into that default directory. 

2. Go to the Impala query editor, select default as the active database, and execute the following statement:

CREATE TABLE jobs_training (id INT, title STRING, salary INT, posted TIMESTAMP)
LOCATION '/user/training/jobs_training/';

3. Use the data source panel (so you can leave the query editor in the main panel) 
to find the table directory for this new table. Note that it's not in /user/hive/warehouse/ 
as the other tables in the default database are. It should be under /user/training/ instead. 
Check that the new jobs_training directory is empty, since the table was created without data and none has been inserted.

4. Insert some data into the new table using the following statement in the query editor:

INSERT INTO jobs_training VALUES (1,'Data Analyst',135000,'2016-12-21 15:52:03');

5. Look again inside the jobs_training directory and verify that a new file has been added. 
	You might need to click the refresh button to refresh the display. 
	You can take a look at the file to see that it's the data you just inserted.

6. Drop the table.
DROP TABLE jobs_training;

Now create a table to query some existing data that’s located in an S3 bucket. 
We've created a bucket and given read-only access to the VM. 
The same row of data you have been using in these tests is saved in a delimited text file 
in the S3 bucket named training-coursera, in a folder named jobs. 
The file uses the default delimiter (Control+A) so you do not need a ROW FORMAT clause.

7. Execute the following statement:

CREATE EXTERNAL TABLE jobs_s3 (id INT, title STRING, salary INT, posted TIMESTAMP)
LOCATION 's3a://training-coursera1/jobs/';

8. Verify that the table has one row of data, either using the data source panel or by executing a SELECT * query.

9. Drop the table. Note: Typically you need to use the EXTERNAL keyword 
to ensure you don't accidentally delete data when you drop the table. 
In this case, because you don't have write access to the bucket, 
you will not delete the data even if you forgot the EXTERNAL keyword. 
Still, it's a good practice to use EXTERNAL for data that other people might be relying on, 
too, so you don't risk destroying their work as well as your own!
````

### CREATE TABLE SHORTCUTS
````text
Following are two tips for creating databases and tables.

Using IF NOT EXISTS

If you try to create a database or table using a name for one that already exists, Hive or Impala will throw an error. 
To avoid this, you can add the keywords IF NOT EXISTS to your CREATE DATABASE or CREATE TABLE statement. 
The syntax is as follows:

CREATE DATABASE IF NOT EXISTS database_name;

CREATE TABLE IF NOT EXISTS table_name;

When you use IF NOT EXISTS, then Hive or Impala will not throw an error if that name is already in use. 
They will instead do nothing.

This is particularly helpful if you're using a script to create a database or table. 
If the script is run multiple times, using IF NOT EXISTS will let the script create the database or 
table on the first run, and it will also complete without error on subsequent runs.

You can also use IF NOT EXISTS together with the EXTERNAL keyword, 
and together with the other optional CREATE TABLE clauses described in this week of the course.

Cloning a Table with LIKE

If you need a new table defined with exactly the same structure as an existing table, 
then Hive and Impala make it very easy to create the new table. 
This is called cloning a table, and it’s done using the LIKE clause. 
The new table will have the same column definitions and other properties as the existing table, but no data. The syntax is

CREATE TABLE new_table_name LIKE existing_table_name;

The example shown below creates a new empty table named jobs_archived 
with the same structure and properties as the existing table named jobs.

CREATE TABLE jobs_archived LIKE jobs;

It is possible to specify a few of the table properties for the new table 
by including the appropriate clauses in the CREATE TABLE … LIKE statement. 
Of the clauses covered in this course, currently only the LOCATION and STORED AS clauses can be used. 
If you need to change other properties, use ALTER TABLE after creating the table to set those properties. 

Try It!
Try how things work if you create a database using IF NOT EXISTS. 
You'll create a database named dig; 

1. First, create a database named dig by executing the command: 

CREATE DATABASE IF NOT EXISTS dig;

Verify that you now have a database named dig.

2. Now try creating the database again using CREATE DATABASE dig;
(without the IF NOT EXISTS phrase). What happens?

3. Now try the original command again, and notice how the response is different:

CREATE DATABASE IF NOT EXISTS dig;

Now try cloning.

4. Clone one of the tables in the default database using the LIKE clause—any of the tables will do, 
just be sure to use a slightly different name for the new table. 
(For example, you might clone the customers table in the default database and name it customers_clone.)

CREATE TABLE dig.employees LIKE default.employees;

5. Verify that the structure (column names with their data types) is the same as the table you cloned. 
Also verify that the new table has no data in it, and the original table still has its data.

6. Drop the cloned table.

DROP TABLE dig.employees;
````

### USING DIFFERENT SCHEMAS ON THE SAME DATA
````shell script
$ hdfs dfs -ls s3a://training-coursera1/months
$ hdfs dfs -cat s3a://training-coursera1/months/months.txt
````
````iso92-sql
CREATE EXTERNAL TABLE months_a (
	number INT,
	name_and_days STRING
)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY '>'
	STORED AS TEXTFILE
	LOCATION 's3a://training-coursera1/months';

CREATE EXTERNAL TABLE months_b (
	number_and_name STRING,
	days INT
)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ','
	STORED AS TEXTFILE
	LOCATION 's3a://training-coursera1/months';

SELECT number,
	split_part(name_and_days,',',1) AS name,
	cast(split_part(name_and_days,',',2) AS INT) AS name
	FROM months_a;

$ hdfs dfs -cat s3a://training-coursera2/company_email/company_email.txt

CREATE EXTERNAL TABLE company_email (
	id INT,
	name STRING,
	email STRING
)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ','
	STORED AS TEXTFILE
	LOCATION 's3a://training-coursera2/company_email/';

SELECT * FROM company_email;

CREATE EXTERNAL TABLE company_email_raw (
	line STRING
)
	STORED AS TEXTFILE
	LOCATION 's3a://training-coursera2/company_email/';

SELECT regexp_extract(line,'^([0,9]+),',1) AS id,
	if(regexp_like(line, '"'),
           regexp_extract(line,'"(.+)"', 1),
	   regexp_extract(line,'^[0-9]+,([^,]+)', 1)
        ) AS name,
	regexp_extract(line, '^[0-9]+,(".+"|[^,]+),(.*)',2) AS email
FROM company_email_raw;
````