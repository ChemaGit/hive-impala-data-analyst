## FILE TYPES

### TEXT FILES
````text
Text files are the most basic file type. 
Virtually any programming language can read and write data in text files, 
and many applications that data analysts use can work with comma- and tab-delimited text files. 
They are also human-readable. 
Values are represented as plain text strings, so you can simply open a text editor and view the data. 
This is useful when you’re investigating a problem.

However, there are downsides to using text files. 
When used to store large amounts of data, text files are inefficient. 
Representing numeric values as strings wastes a great deal of storage space. 
It’s difficult to represent binary data like images in a text file; this requires using techniques like Base64 encoding. 
Converting data between text representations and their native data types 
requires serialization and deserialization, which slows performance.

Overall, text files offer excellent interoperability but poor performance.
````

### AVRO FILES
````text
Apache Avro is an efficient data serialization framework. 
Avro defines a file format that uses optimized binary encoding to store data efficiently. 
(For an explanation of binary encoding, see “What Is Binary Encoding” from wisegeek.com.) 
The Avro format is widely supported by big data tools, and it’s also designed to work across 
different programming languages and tools outside the typical big data system. 
Avro files are suitable for long-term data storage. 

An Avro data file includes an embedded schema definition, which makes the file 
self-describing —the file itself provides information about what's in the file. 
Avro is also built to handle schema evolution. 
This means that it’s possible to add, remove, or modify columns in a Hive or Impala table without 
needing to make changes to the existing data stored within Avro files. 
The Avro framework will accommodate these schema changes, so the table and the existing data files 
will continue to be compatible, even though their schemas do not perfectly match. 
(For more about schema evolution, see "How Schema Evolution Works" within the linked page 
(https://docs.oracle.com/cd/E26161_02/html/GettingStartedGuide/schemaevolution.html#schemaevolutionhow). 
Note that most of the details in that article pertain to Avro schemas in general, but some details are specific 
to the use of Avro within the Oracle NoSQL Database and so are not applicable to the big data systems presented in this reading.)

Overall, Avro offers excellent interoperability and excellent performance, 
making it a popular choice for general-purpose big data storage.
````

### PARQUET FILES
````text
Apache Parquet is a columnar file format originally developed by engineers at Cloudera and Twitter. 
Parquet was inspired by a project at Google called Dremel.

Columnar, or column-oriented, file formats organize data by column, rather than by row. 
This makes them more efficient when you need to process only one or a few columns. 
For example, see Figure 1 below. 
The rows (1, 2, 3) and columns (A, B, C) of the data are shown in a tabular structure on the left side. 
The images on the right side represent how this data could be stored 
in a row-oriented file format (top) and a column-oriented file format (bottom).

When the data is stored in a row-oriented format, the file organizes 
the data sequentially first by row (Row 1 consists of A1, B1, C1). 
When the data is stored like this, Hive and Impala must read each full row 
even if the query requires processing only one column.

When the data is stored in a column-oriented format, the file organizes the data sequentially 
first by column (Column A has values A1, A2, A3). 
When the data is stored like this, Hive and Impala can skip over the columns that are not part of the query, 
and quickly read only the values for the columns that are part of the query. 
This improves query performance, especially for tables with dozens or hundreds of columns.

Parquet is widely supported by big data tools, including Hive and Impala, 
and it’s designed to work across different programming languages. 
Like Avro, Parquet embeds a schema definition in the file, and it supports schema evolution.

Parquet uses advanced optimizations to store data more compactly and to speed up queries. 
It is most efficient when data is loaded all at once or in large batches; 
this enables Parquet to take advantage of repeated patterns in the data to store it more efficiently.

id	name	city
1	Alice	Palo Alto
2	Bob	Sunnyvale
3	Bob	Palo Alto
4	Bob	Berkeley
5	Carol	Berkeley

**Parquet also uses compression.** 
Compression encodes data in a way to take up less storage than an uncompressed file will, 
but there is a time cost when you read or write the file. 
That is, encoding for less storage means more time needed to compress (encode) the file before writing it, 
or to decompress (decode) the file after reading it.

Overall, Parquet offers excellent interoperability and excellent performance, 
making it a popular choice for columnar data storage.
````
### ORC FILES
````text
Apache ORC (Optimized Record Columnar) is a file format originally developed by engineers 
at Hortonworks and Facebook. (Hortonworks has since merged with Cloudera.)

ORC is very similar to Parquet. 
ORC and Parquet were designed to meet many of the same needs, 
and internally they use many of the same techniques to achieve excellent performance.

ORC is often used with Hive. 
To take advantage of certain features of Hive, you must store table data in the ORC file format. 
However, ORC is not widely supported by other tools. Impala cannot query tables whose data is stored in ORC files.

Overall, ORC offers excellent performance but limited interoperability. 
We recommend choosing ORC when you are using features of Hive that require it. 
Keep in mind that the Hive tables that use ORC files can not be queried using Impala.
````

### READING OTHER FILE TYPES
````text
Big data systems sometimes use other file formats in addition to text, Avro, Parquet, and ORC. 
Two common options are SequenceFiles and RCFiles. 
We generally do not recommend using these file formats, but they are briefly described below so that you will be aware of them.

**Sequence Files**
The SequenceFile format was developed for big data systems as an alternative to text files. 
SequenceFiles store key-value pairs in a binary container format. 
They store data more efficiently than text files, and they can store binary data like images. 

However, the SequenceFile format is closely associated with the Java programming language, 
and it is not widely supported outside the Hadoop ecosystem. 

Overall, SequenceFiles offer good performance but poor interoperability.

**RCFiles**
RCFile, which stands for Record Columnar File, is a columnar file format that was developed for use with Hive. 
RCFile is also supported by some other tools, including Impala, but this support is limited. 
The RCFile format stores all data as strings, which is inefficient.

Overall, RCFile offers poor performance and limited interoperability.

The ORC file format (described in the previous reading) is an improved version of RCFile with superior performance.
````
















