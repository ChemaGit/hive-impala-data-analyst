## TABLE PARTITIONING

### WHEN TO USE TABLE PARTITIONING
````text
- Table partitioninig is good when:
	- Reading the entire dataset takes too long
	- Queries almost always filter on the partition columns
	- There are a reasonable number of different values for partition columns

- Data generation of ETL process splits data by file or directory names
- Partition column values are not in the data itself
- Don't partition on columns with many unique values
- Example: Partitioning customers by first name
````

### CREATING PARTITIONED TABLES
````text
To create a partitioned table, use the PARTITIONED BY clause in the CREATE TABLE statement. 
The names and types of the partition columns must be specified 
in the PARTITIONED BY clause, and only in the PARTITIONED BY clause. 
They must not also appear in the list of all the other columns.

CREATE TABLE customers_by_country 
        (cust_id STRING, name STRING) 
PARTITIONED BY (country STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

The example CREATE TABLE statement shown above creates the table customers_by_country, 
which is partitioned by the STRING column named country. 
Notice that the country column appears only in the PARTITIONED BY clause, 
and not in the column list above it. 
This example specifies only one partition column, but you can specify more than one by using 
a comma-separated column list in the PARTITIONED BY clause. 
Aside from these specific differences, this CREATE TABLE statement is the same 
as the statement used to create an equivalent non-partitioned table.

Table partitioning is implemented in a way that is mostly transparent 
to a user issuing queries with Hive and Impala. 
A partition column is what’s known as a virtual column, because its values are not stored within the data files. 
Following is the result of the DESCRIBE command on customers_by_country; 
it displays the partition column country just as if it were a normal column within the table. 
You can refer to partition columns in any of the usual clauses of a SELECT statement.

name	type	comment

cust_id	string	 
name	string	 
country	string	 

Note: In the previous lesson, you learned about using COMPUTE STATS in Impala 
and ANALYZE TABLE … COMPUTE STATISTICS in Hive. 
If the table is partitioned, Impala cannot use Hive-generated column statistics, 
so for partitioned tables, it's best to compute the statistics with the engine you'll be using to query the table.

- Try It!
Use the CREATE TABLE command above to create a customers_by_country table 
on your VM, then use DESCRIBE to show the columns. 
Notice that it's just as described above: there is no apparent difference 
between the partition column and the other columns.

You'll use this table in the next readings too, so don't drop it yet.
````

### LOADING DATA WITH DYNAMIC PARTITION
````text
One way to load data into a partitioned table is to use dynamic partitioning,
which automatically defines partitions when you load the data, using the values in the partition column.
(The other way is to manually define the partitions. 
See “Loading Data with Static Partitioning” for this method.) 

To use dynamic partitioning, you must load data using an INSERT statement. 
In the INSERT statement, you must use the PARTITION clause to list the partition columns. 
The data you are inserting must include values for the partition columns. 
The partition columns must be the rightmost columns in the data you are inserting, 
and they must be in the same order as they appear in the PARTITION clause.

INSERT OVERWRITE TABLE customers_by_country 
    PARTITION(country)
    SELECT cust_id, name, country FROM customers;

The example shown above uses an INSERT … SELECT statement 
to load data into the customers_by_country table with dynamic partitioning. 
Notice that the partition column, country, is included 
in the PARTITION clause and is specified last in the SELECT list. 

When Hive or Impala executes this statement, it automatically creates partitions 
for the country column and loads the data into these partitions based on the values in the country column. 
The resulting data files in the partition subdirectories do not include values for the country column. 
Since the country is known based on which subdirectory a data file is in, 
it would be redundant to include country values in the data files as well.

Note: Hive includes a safety feature that prevents users 
from accidentally creating or overwriting a large number of partitions. 
(See “Risks of Using Partitioning” for more about this.) 
By default, Hive sets the property hive.exec.dynamic.partition.mode to strict. 
This prevents you from using dynamic partitioning, though you can still use static partitions.

You can disable this safety feature in Hive by setting 
the property hive.exec.dynamic.partition.mode to nonstrict:

SET hive.exec.dynamic.partition.mode=nonstrict;

Then you can use the INSERT statement to load the data dynamically. 

Hive properties set in Beeline are for the current session only, 
so the next time you start a Hive session this property will be set back to strict. 
Your system administrator can configure properties permanently, if necessary.

- Try It!
If you did not create the customers_by_country table in the 
“Creating Partitioned Tables” reading, do so before continuing. 
If you did the exercises in the “Loading Data with Static Partitioning” 
reading before doing this one, drop the table and recreate it (without loading the data).

1. First, look at the contents of the customers_by_country table directory in HDFS. 
(Where this directory exists depends on which database holds the table.) 
You can use Hue or an hdfs dfs -ls command to list the contents of the directory. 
Since you haven't loaded any data, it should be empty.

2. If you want to use Hive, disable the partition safety feature by running 

SET hive.exec.dynamic.partition.mode=nonstrict;

If you want to use Impala for the rest of these exercises, you don't need to run that command.

3. The customers table has only four rows, and each has a different code in the country column. 
Use the following command to insert the data into the partitioned customers_by_country table:

INSERT OVERWRITE TABLE customers_by_country 
    PARTITION(country)
    SELECT cust_id, name, country FROM default.customers;

4. Look at the contents of the customers_by_country directory. 
It should now have one subdirectory for each value in the country column.

5. Look at the file in one (or more, if you like) of those directories, using Hue or an hdfs dfs -cat command. 
Notice that the file contains the row for the customer from that country, 
and no others; notice also that the country value is not included.

6. Run some SELECT queries on the partitioned table. 
Try one that does no filtering (like SELECT * FROM customers_by_country;) and one that filters on country. 
It's a small table so there won't be a significant difference in the time it takes to run; 
the point is to notice that you will not query the table any differently than you would query the customers table.
````

### LOADING DATA WITH STATIC PARTITIONING
````text
One way to load data into a partitioned table is to use static partitioning, 
in which you manually define the different partitions.
(The other way is to have the partitions automatically defined when you load the data. 
See “Loading Data with Dynamic Partitioning” for this method.) 

With static partitioning, you create a partition manually, using an ALTER TABLE … ADD PARTITION statement, 
and then load the data into the partition. 

For example, this ALTER TABLE statement creates the partition for Pakistan (pk):

ALTER TABLE customers_by_country
ADD PARTITION (country='pk');

Notice how the partition column name, which is country, and the specific value that defines this partition, 
which is pk, are both specified in the ADD PARTITION clause. 
This creates a partition directory named country=pk inside the customers_by_country table directory.

After the partition for Pakistan is created, you can add data into the partition using an INSERT … SELECT statement: 

INSERT OVERWRITE TABLE customers_by_country 
    PARTITION(country='pk')
    SELECT cust_id, name FROM customers WHERE country='pk'

Notice how in the PARTITION clause, the partition column name, which is country, 
and the specific value, which is pk, are both specified, just like in the ADD PARTITION command used to create the partition. 
Also notice that in the SELECT statement, the partition column is not included in the SELECT list. 
Finally, notice that the WHERE clause in the SELECT statement selects only customers from Pakistan.

With static partitioning, you need to repeat these two steps for each partition: 
first create the partition, then add data. 
You can actually use any method to load the data; you need not use an INSERT statement. 
You could instead use hdfs dfs commands or a LOAD DATA INPATH command. 
But however you load the data, it’s your responsibility to ensure that data is stored in the correct partition subdirectories. 
For example, data for customers in Pakistan must be stored in the Pakistan partition subdirectory, 
and data for customers in other countries must be stored in those countries’ partition subdirectories.

Static partitioning is most useful when the data being loaded 
into the table is already divided into files based on the partition column, 
or when the data grows in a manner that coincides with the partition column: 
For example, suppose your company opens a new store in a different country, 
like New Zealand ('nz'), and you're given a file of data for new customers, all from that country. 
You could easily add a new partition and load that file into it.

- Try It!
If you did not create the customers_by_country table in the 
“Creating Partitioned Tables” reading, do so before continuing. 
If you did the exercises in the “Loading Data with Dynamic Partitioning” 
reading before doing this one, drop the table and recreate it (without loading the data). 

1. First, look at the contents of the customers_by_country table directory in HDFS. 
(Where this directory exists depends on which database holds the table.) 
You can use Hue or an hdfs dfs -ls command to list the contents of the directory. 
Since you haven't loaded any data, it should be empty.

2. Add the partition for Pakistan (pk) using the ALTER TABLE command:

ALTER TABLE customers_by_country
ADD PARTITION (country='pk');

3. Check the contents of the customers_by_country table directory in HDFS 
and see that it now has a subdirectory for the partition you just created.

4. Now load only the customers from Pakistan into that partition:

INSERT OVERWRITE TABLE customers_by_country 
PARTITION(country='pk')
SELECT cust_id, name FROM default.customers WHERE country='pk';

5. Optional: Modify and run both commands to create a partition for one 
of the other countries (us, ja, or ug) and load the data from the customers table into that partition. 
You can do it for all three if you like. 
Check that the customers_by_country directory has one subdirectory for each partition you added.

ALTER TABLE customers_by_country
ADD PARTITION (country='us');

INSERT OVERWRITE TABLE customers_by_country 
PARTITION(country='us')
SELECT cust_id, name FROM default.customers WHERE country='us';

6. Look at the file in one (or more, if you like) of those directories, using Hue or an hdfs dfs -cat command. 
Notice that the file contains the row for the customer from that country, and no others; 
notice also that the country value is not included (because you didn't include it in the SELECT list).

7. Run some SELECT queries on the partitioned table. 
Try one that does no filtering (like SELECT * FROM customers_by_country;) 
and one that filters on country. 

SELECT * FROM customers_by_country WHERE country = 'us'

It's a small table so there won't be a significant difference in the time it takes to run; 
the point is just to notice that you will not query the table any differently than you would query the customers table.
````

### RISKS OF USING PARTITIONING
````text
A major risk when using partitioning is creating partitions that lead you into the small files problem. 
When this happens, partitioning a table will actually worsen query performance 
(the opposite of the goal when using partitioning) because it causes too many small files to be created. 
This is more likely when using dynamic partitioning, but it could still 
happen with static partitioning—for example if you added a new partition to a sales table 
on a daily basis containing the sales from the previous day, 
and each day’s data is not particularly big. 

When choosing your partitions, you want to strike a happy balance between too many partitions 
(causing the small files problem) and too few partitions (providing performance little benefit). 
The partition column or columns should have a reasonable number of values 
for the partitions—but what you should consider reasonable is difficult to quantify. 

Using dynamic partitioning is particularly dangerous because if you're not careful, 
it's easy to partition on a column with too many distinct values. 
Imagine a use case where you are often looking for data that falls within 
a time frame that you would specify in your query. 
You might think that it's a good idea to partition on a column that pertains to time. 
But a TIMESTAMP column could have the time to the nanosecond, so every row could have a unique value; 
that would be a terrible choice for a partition column! Even to the minute or hour could create 
far too many partitions, depending on the nature of your data; 
partitioning by larger time units like day, month, or even year might be a better choice.

As another example, consider the default.employees table on the VM. 
This has five columns: empl_id, first_name, last_name, salary, and office_id.
Before reading on, think for a moment, which of these might be reasonable for partitioning 
(assuming the table will eventually be much larger than the five rows in our sample table)? 

The column empl_id is a unique identifier. 
If that were your partition column, you would have a separate partition for each employee, 
and each would have exactly one row. 
In addition, it's not likely you'll be doing a lot of queries looking for a particular value, 
or even a particular range of values. This is a poor choice.
The column first_name will not have one per employee, but there will likely be many columns that have only one row. 
This is also true for last_name. 
Also, like empl_id, it's not likely you'll need filter queries based on these columns. These are also poor choices.
The column salary also will have many divisions 
(and even more so if your salaries go to the cent rather than to the dollar as our sample table does). 
While it may be that you'll sometimes want to query on salary ranges, 
it's not likely you'll want to use individual salaries. 
So salary is a poor choice. 
A more limited salary_grades specification, like the ones in the salary_grades table, 
might be reasonable if your use case involves looking at the data by salary grade frequently.
The office_id column identifies the office where an employee works. 
This will have a much smaller number of unique values, even if you have a large company with offices in many cities. 
It's imaginable that your use case might be to frequently filter 
your employee data based on office location, too. So this would be a good choice.
You also can use multiple columns and create nested partitions. 
For example, a dataset of customers might include country and state_or_province columns. 
You can partition by country and then partition those further by state_or_province, so customers from Ontario, 
Canada would be in the country=ca/state_or_province=on/ partition directory. 
This can be extremely helpful for large amounts of data that you want to access either by country or by state or province. 
However, using multiple columns increases the danger of creating too many partitions, so you must take extra care when doing so.

The risk of creating too many partitions is why Hive includes the property 
hive.exec.dynamic.partition.mode, set to strict by default, which must be reset to nonstrict before you can create a partition. 
(See the note about this, near the end of the “Loading Data Using Dynamic Partitioning” reading.) 
Rather than automatically and mechanically resetting that property when you're about to load data dynamically,
take it as an opportunity to think about the partitioning columns 
and maybe check the number of unique values you would get when you load the data.
````