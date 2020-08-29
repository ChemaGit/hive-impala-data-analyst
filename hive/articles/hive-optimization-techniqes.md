![alt text](hive-logo.png)

# HIVE OPTIMIZATION TECHNIQUES
````text
Apache Hive is a query and analysis engine which is built on top of Apache Hadoop and uses MapReduce Programming Model. 
It provides an abstraction layer to query big-data using the SQL syntax by implementing 
traditional SQL queries using the Java API. 
The main components of the Hive are as follows:

    - Metastore
    - Driver
    - Compiler
    - Optimizer
    - Executor
    - Client

While Hadoop/hive can process nearly any amount of data, but optimizations can lead to big savings, 
proportional to the amount of data, in terms of processing time and cost. 
There are a whole lot of optimizations that can be applied in the hive. 
Let us look into the optimization techniques we are going to cover:

    - Partitioning
    - Bucketing
    - Using Tez as Execution Engine
    - Using Compression
    - Using ORC Format
    - Join Optimizations
    - Cost-based Optimizer
````

### Partitioning
````text   
Partitioning divides the table into parts based on the values of particular columns. 
A table can have multiple partition columns to identify a particular partition. 
Using partition it is easy to do queries on slices of the data. 
The data of the partition columns are not saved in the files. 
On checking the file structure you would notice that it creates folders 
on the basis of partition column values. This makes sure that only relevant data is read 
for the execution of a particular job, decreasing the I/O time required by the query. 
Thus, increasing the query performance.
   
When we query data on a partitioned table, it will only scan the relevant partitions 
to be queried and skips irrelevant partitions. Now, assume that even on partitioning, 
the data in a partition was quite big, to further divide it into more manageable chunks we can use Bucketing.
````
````mysql-sql
CREATE TABLE table_name 
(column1 data_type, column2 data_type, …) 
PARTITIONED BY (partition1 data_type, partition2 data_type,….);
````
````text
- Partition Columns are not defined in the Column List of the table.
- In insert queries, partitions are mentioned in the start and 
  their column values are also given along with the values of the other columns but at the end.
````
````mysql-sql
INSERT INTO TABLE table_name PARTITION (partition1 = ‘partition1_val’, partition2 = ‘partition2_val’, …) 
VALUES (col1_val, col2_val, …, partition1_val, partition2_val, …);
````
````text
- Partitioning is basically of two types: Static and Dynamic. 
  Well, names are very much self-explanatory.

 * Static Partitioning
   This is practiced when we have knowledge about the partitions of data we are going to load. 
   It should be preferred when loading data in a table from large files. It is performed in strict mode:
````