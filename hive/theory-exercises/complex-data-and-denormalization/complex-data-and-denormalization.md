## COMPLEX DATA AND DENORMALIZATION

### WHEN TO USE COMPLEX COLUMNS
````text
- Joins in Hive or Impala are expensive and complex.
- Can take a very long time
- We can denormalize the tables and build complex tables to eliminate joins.

- Complex types: Arrays, Maps and Structs
````

### COMPLEX DATA TYPES
````text
Recall that Hive and Impala support a number of simple data types, 
similar to the types found in relational databases. 
These simple data types represent a single value within a single row-column position. 

In addition, Hive and Impala also support several complex data types, 
which represent multiple values within a single row-column position. 
Complex types are also referred to by several other names, including nested types and collection types.

Hive and Impala both support three different complex data types: ARRAY, MAP, and STRUCT. 
````
#### ARRAY
````text
An ARRAY represents an ordered list of values, all having the same data type. 
For example, people often have multiple phone numbers, such as home (landline), work, and mobile. 
An array could hold several phone numbers. 
In the table below, the column phones is an ARRAY in which each element is a STRING:

name	phones
Alice	[555-1111, 555-2222, 555-3333]
Bob	[555-4444]
Carlos	[555-5555, 555-6666]

The elements of an ARRAY can be other simple data types, 
but all elements of an ARRAY must be of the same type.
````

#### MAP
````text
A MAP represents key-value pairs, with all keys having the same data type, 
and all values having the same type. 
With the phones example, this allows you to specify which phone number is 
for what purpose (such as home, work, or mobile):

name	phones
Alice	{home:555-1111, work:555-2222, mobile:555-3333}
Bob	{mobile:555-4444}
Carlos	{work:555-5555, home:555-6666}

Here the key is a STRING and the value is also a STRING. 
Each could be other simple data types; for example, if you don't use the dash 
in the phone numbers, you could make the key STRING and the value INT.
````

#### STRUCT
````text
A STRUCT represents named fields, which can have different data types. 
For example, you could use a STRUCT to store addresses, with each part of the address a different field:

name	address
Alice	{street:742 Evergreen Terrace, city:Springfield, state:OR, zipcode:97477}
Bob	{street:1600 Pennsylvania Ave NW,  city:Washington, state:DC, zipcode:20500}
Carlos	{street:342 Gravelpit Terrace, city:Bedrock}

Here, the STRUCT is defined to have four fields: street, city, and state are STRING types; 
zipcode is an INT type (though it could also be STRING). 
Notice that Carlos's address is missing the state and zipcode fields. 
When this table is queried (see the next readings), those fields would show as NULL.
````
#### Nested Complex Types
````text
It's also possible to nest complex types, for example, to have an ARRAY 
in which each element is an ARRAY, or a MAP for which the value is a STRUCT element. 
For the tables above, you might create a contacts column which is a STRUCT 
with two named fields: phones is a MAP and address is another STRUCT.

As you'll see in the next readings, working with a single layer of complex data can be difficult; 
working with a nested layer will be much more difficult. 
If you do need to use nested complex types, we recommend using no more than one nested layer. 
If you find yourself using more 
(for example, an ARRAY whose elements are MAPs, and the values of that MAP are themselves ARRAYs), 
consider whether a different schema design could provide the same information in a more digestible way.
````

### CREATING TABLES WITH COMPLEX DATA
````text
The syntax for creating tables that use complex data types is very similar 
in Hive and Impala, but mostly you will be creating tables in Hive. 
The reason for that is Impala only supports the use of complex data in Parquet files, 
and you cannot load complex data into a table using INSERT or LOAD statements in Impala. 
If you don't have the data file in Parquet format, you can create the table in Hive, 
then create a copy using CREATE TABLE … AS SELECT, with STORED AS PARQUET. 
You then can query the table in Impala.

The examples below assume you are using text files to store the data, 
so the delimiters are specified in the ROW FORMAT clause of the CREATE TABLE statement. 
For file formats such as Parquet and Avro, you do not use the ROW FORMAT clause; 
the details of how these formats represent complex values are determined by the file format, not by the user.

If you're using Impala to create the tables, you must be using Parquet files, 
so Impala will never use the ROW FORMAT clause for tables with complex data, 
and you will need to specify STORED AS PARQUET. 
The CREATE TABLE statements otherwise will be the same as the examples shown here.

(Querying data can be very different, though, so the next two readings 
will cover basic queries in both engines, one at a time.)
````

#### ARRAY
````text
An ARRAY type is declared in the column list of the CREATE TABLE statement using ARRAY<type>, 
where type is the simple data type that each element of the array will have.

The following shows the contents of a data file called customers_phones_array.csv 
with three columns: cust_id, name, and phones. 
This will be used as the data for a table using an ARRAY data type 
for phones using ARRAY<STRING> because the phone numbers are given as STRINGs.

a,Alice,555-1111|555-2222|555-3333
b,Bob,555-4444
c,Carlos,555-5555|555-6666

Commas separate the customer ID, the customer name, and a list of their phone numbers. 
The phone numbers themselves are separated using the pipe character (the vertical bar). 
Both delimiters need to be declared in the CREATE TABLE statement: 

CREATE TABLE customers_phones_array
        (cust_id STRING,
        name STRING,
        phones ARRAY<STRING>)
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY ','
        COLLECTION ITEMS TERMINATED BY '|';

Recall that if you omit the FIELDS TERMINATED BY subclause, 
Hive and Impala use the default delimiter, which is the ASCII Control-A character. 
For the COLLECTION ITEMS TERMINATED BY subclause, 
the default collection item terminator is the ASCII Control-B character. 

Remember: If you're creating the table using Parquet or Avro data files 
(and, again, Parquet is the only format Impala supports with complex data) 
omit the ROW FORMAT clause and the subclauses specifying the terminators, and include a STORED AS clause.
````

#### MAP
````text
A MAP type is declared in the column list of the CREATE TABLE statement using MAP<keytype, valuetype>. 
Notice that the keys—in the phones example, this would be home, work, 
and mobile—are not defined in the CREATE TABLE statement. 
This means new keys could be added to the data without updating the table definition.

The following shows the contents of a data file called customers_phones_map.csv 
with the same three columns as in the ARRAY example: cust_id, name, and phones. 
In this case, though, phones will use MAP<STRING,STRING> because both the key (type of number) 
and the value (the phone number itself) are both given as STRINGs.

a,Alice,home:555-1111|work:555-2222|mobile:555-3333
b,Bob,mobile:555-4444
c,Carlos,work:555-5555|home:555-6666

Again, as with the ARRAY example, commas separate the customer ID, 
the customer name, and the list of their phone numbers. 
The key-value pairs are separated using the pipe character (the vertical bar) again, 
and colons are used to separate the key from the value in each pair. 
All three delimiters need to be declared in the CREATE TABLE statement: 

CREATE TABLE customers_phones_map
        (cust_id STRING,
        name STRING,
        phones MAP<STRING,STRING>)
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY ','
        COLLECTION ITEMS TERMINATED BY '|'
        MAP KEYS TERMINATED BY ':';

The default terminators are the same as with ARRAY, but now you also have the MAP KEYS terminator. 
The default (if you omit the MAP KEYS TERMINATED BY subclause) is the ASCII Control-C character.

Remember: If you're creating the table using Parquet or Avro data files 
(and, again, Parquet is the only format Impala supports with complex data) 
omit the ROW FORMAT clause and the subclauses specifying the terminators, and include a STORED AS clause.
````

#### STRUCT
````text
A STRUCT type is declared in the column list of the 
CREATE TABLE statement using STRUCT<field1:TYPE1, field2:TYPE, …>. 
The order of the STRUCT fields in the table definition must match the order in the data files. 

The following shows the contents of a data file called 
customers_addr.csv with the three columns: cust_id, name, and address. 
Here, address will use a STRUCT type with four named fields: street, city, state, and zipcode. 
All are STRINGs except zipcode, which is an INT.

a,Alice,742 Evergreen Terrace|Springfield|OR|97477
b,Bob,1600 Pennsylvania Ave NW|Washington|DC|20500
c,Carlos,342 Gravelpit Terrace|Bedrock

A STRUCT contains a predefined number of named fields, but fields can be missing. 
In this example, Carlos’s address is missing the state and zipcode fields, 
so queries will return NULL for these missing fields.

Again, as with the ARRAY example, commas separate the columns. 
The fields in the STRUCT are separated using the pipe character (the vertical bar). 
Both delimiters need to be declared in the CREATE TABLE statement:

CREATE TABLE customers_addr
            (cust_id STRING,
            name STRING,
            address STRUCT<street:STRING,
                           city:STRING,
                           state:STRING,
                           zipcode:INT>)
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY ','
        COLLECTION ITEMS TERMINATED BY '|';

The default terminators are the same as with ARRAY.

Note that unlike MAPs, the “keys” of a STRUCT (the names of its fields) are not part of the actual data. 
So if we changed the name from zipcode to postalcode, 
we would not need to update the underlying data in the data file.

Remember: If you're creating the table using Parquet or Avro data files 
(and, again, Parquet is the only format Impala supports with complex data) 
omit the ROW FORMAT clause and the subclauses specifying the terminators, and include a STORED AS clause.
````

#### Try It!
````text
Do the following to create tables that you can query in the next readings.

Use Hive to create the example tables for each of the three types, and load the data with your preferred method. 
The data for each example is on the VM in /home/training/training_materials/analyst/data/. 
The data files are named customers_phones_array.csv, customers_phones_map.csv, and customers_addr.csv.
Use Hive to create a Parquet version of each table so you can also query the data with Impala. 
For each table, run a CTAS statement and use STORED AS PARQUET. 
To make things easier when you query these tables with Impala, 
name the tables phones_array_parquet, phones_map_parquet, and customers_addr_parquet. 
If you prefer to use something shorter, please do, but you'll need to make adjustments 
when you complete the exercises in the “Querying Complex Data with Impala” reading.

IN HIVE

CREATE TABLE customers_phones_array
        (cust_id STRING,
        name STRING,
        phones ARRAY<STRING>)
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY ','
        COLLECTION ITEMS TERMINATED BY '|';

CREATE TABLE customers_phones_map
        (cust_id STRING,
        name STRING,
        phones MAP<STRING,STRING>)
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY ','
        COLLECTION ITEMS TERMINATED BY '|'
        MAP KEYS TERMINATED BY ':';

CREATE TABLE customers_addr
            (cust_id STRING,
            name STRING,
            address STRUCT<street:STRING,
                           city:STRING,
                           state:STRING,
                           zipcode:INT>)
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY ','
        COLLECTION ITEMS TERMINATED BY '|';


For example:

CREATE TABLE phones_array_parquet
    STORED AS PARQUET
    AS SELECT * FROM customers_phones_array;

CREATE TABLE phones_map_parquet
    STORED AS PARQUET
    AS SELECT * FROM customers_phones_map;

CREATE TABLE addr_parquet
    STORED AS PARQUET
    AS SELECT * FROM customers_addr;
````

### QUERYING COMPLEX DATA WITH HIVE
````text
A Hive query can select a full complex column simply by including 
the bare name of the column in the SELECT list. 
For example, this query selects the full ARRAY column named phones. 
Hive displays the full phones column in the results, 
using square brackets and commas to represent the ARRAY structure:

SELECT name, phones FROM customers_phones_array;

name	phones
Alice	[555-1111, 555-2222, 555-3333]
Bob	[555-4444]
Carlos	[555-5555, 555-6666]

For access to the elements within the different complex data types, 
you have to use different syntax depending on the complex type. 

Note: The syntax in this reading is for Hive only. 
See “Querying Complex Data with Impala” for the syntax to use with Impala.

- Querying ARRAYs with Hive
To query an element within an ARRAY, use an array index number in square brackets. 
The array index starts at 0. For example, 
to get the first and second phone numbers in phones, use this query:

SELECT name, phones[0], phones[1]
FROM customers_phones_array;

Since Bob has only one phone number, the query returns NULL for Bob’s second phone number.

- Querying MAPs with Hive
Querying an element within a MAP is similar to querying the ARRAY element, 
except you use the key instead of the index. 
For example, to get the home phone numbers, use this query:

SELECT name, phones['home'] AS home
FROM customers_phones_map;

In this example, the MAP keys are strings, 
so you must quote the literal string within the square brackets. 
MAP keys are case-sensitive, so 'HOME' or 'Home' would not work in this case. 

Since Bob has only a mobile phone number, the query returns NULL for Bob’s home phone number.

- Querying STRUCTs with Hive
To query a field from a STRUCT column, use the column name, a dot, and the field name 
(similar to how you can use the database name, a dot, 
and the table name to refer to a table in a different database from the active one). 
For example, this query selects the name column, and the state and zipcode fields from the address column:

SELECT name, address.state, address.zipcode
FROM customers_addr;

In this example, Carlos’s address is missing the state and zipcode fields, 
so the query returns NULL for these missing fields.

- Try It!
Do the following to run two queries on each of the three (non-Parquet) 
tables you created in “Creating Tables with Hive and Impala.” 
Use Hive for these exercises.

First, run 
SELECT * FROM tablename; 
for each table and note how the complex column appears in the results.
Then, run each of the examples in the reading above. 
Notice the NULL fields in each case.
Optional: Try some other queries for each table.
````

### QUERYING COMPLEX DATA WITH IMPALA
````text
As noted previously, while Impala does support the use of 
complex data types in tables, it does so with some limitations. 
Remember, Impala supports the use of complex columns only in Parquet tables. 
Also, Impala does not support selecting a full complex column 
simply by including the bare name of the column in the SELECT list, as Hive does. 
If you issue SELECT * queries on a table with complex columns, 
the query will run but the complex columns will be omitted from the results. 

To access elements within a complex column using Impala, 
you have to use different syntax depending on the complex type. 
The syntax for accessing ARRAYs and MAPs also is different from Hive's syntax.

Note: The syntax in this reading is for Impala only. 
See “Querying Complex Data with Hive” for the syntax to use with Hive.

- Pseudocolumns
An important concept in working with complex data using Impala is pseudocolumns. 
To understand pseudocolumns, think of an ARRAY or MAP complex column as a table within a table. 
This inner table then has columns within it—those are the pseudocolumns. 
Every ARRAY has two columns named item and pos, and every MAP has two columns named key and value. 
As you'll see, you then treat the complex column as if it were a table, 
and use these pseudocolumns to access the elements within the column.

- Querying ARRAYs with Impala
To query an element within an ARRAY, treat the array as a table named 
tablename.arraynamewith the two pseudocolumns mentioned above: item and pos. 
The item pseudocolumn gives the value of each ARRAY element. 
The pos pseudocolumn gives the index of each element within the array. 
The array index starts at 0. 
For example, to get the first and second phone numbers in phones 
from the phones_array_parquet table, use this query:

SELECT item 
FROM phones_array_parquet.phones
WHERE pos = 0 OR pos = 1;

Notice that you can use the item and pos pseudocolumns in the WHERE clause as well as the SELECT clause. 
You can also use them in other clauses, just as if they were regular columns.

Just as if this phones column were a regular table, 
the query results for this example will include one row for each phone number. 
This is different than Hive's behavior, which uses a comma-separated list, enclosed in brackets. 
In the “Complex Data in Practice” reading, you'll see how to produce similar output for Hive.

You often will want your query results to include the values from other columns 
in the actual table (such as the name column in phones_array_parquet) along with the items in the ARRAY column. 
The list of phone numbers, without the person who has each number, will probably not be useful! 
You can use join notation to return ARRAY elements along with scalar column values from corresponding table rows. 
Typically you use implicit join notation (also called SQL-89-style join notation) as shown in the following example. 
It’s also possible to use explicit join notation and to specify different join types, 
such as LEFT OUTER JOIN, but that’s used less often and is not described here. 

SELECT name, phones.item AS phone
FROM phones_array_parquet, phones_array_parquet.phones;

In this example, the FROM clause includes the base table name, which is phones_array_parquet, 
and the qualified name of the ARRAY column, which is phones_array_parquet.phones. 
These are separated with a comma, which indicates an implicit join. 
Notice that no join condition is specified, because the join condition is implied: 
the ARRAY elements are joined with the rows they came from.

The SELECT list can then include any columns from the base table 
along with the item and pos pseudocolumns from the ARRAY column. 
This example includes the name column and the item pseudocolumn in the SELECT list. 
It’s a good practice to qualify the item and pos pseudocolumns with the ARRAY column name 
as shown here (phones.item) but this is not strictly required.

This may seem a bit complicated, but users often find Impala’s familiar join syntax to be more 
straightforward than what's needed with Hive to get a separate row 
for each ARRAY element (again, see the “Complex Data in Practice” reading).

- Querying MAPs with Impala
Querying a MAP column is similar to querying an ARRAY column, 
but the pseudocolumns are key and value, representing the keys and values of the MAP elements. 
For example, to get the home phone numbers, use this query:

SELECT value AS home
FROM phones_map_parquet.phones
WHERE key = 'home';

In this example, the Parquet table named phones_map_parquet contains a MAP column named phones. 
The MAP keys hold the label (home, work, or mobile) for each phone number, and the associated values hold the phone numbers themselves. 
To query this MAP column, you use the column name qualified with the table name in the FROM clause: FROM phones_map_parquet.phones. 
Then you can include one or both of the pseudocolumns in the SELECT list or in other clauses such as WHERE. 
This example returns the phone numbers (the values), and only phone numbers with the label 'home' will be returned.

As with ARRAY columns, use join notation to return MAP elements along with scalar column values from corresponding table rows. 

SELECT name, phones.value AS home
FROM phones_map_parquet, phones_map_parquet.phones
WHERE phones.key = 'home';

In this example, the FROM clause includes the base table name, which is phones_map_parquet, 
and the qualified name of the MAP column, which is phones_map_parquet.phones. 
They are separated with a comma to indicate an implicit join. 
The SELECT list includes the name column and the phones.value pseudocolumn. 
As with ARRAY, it's a good practice to qualify the value and key pseudocolumns with the name of the MAP column, phones.

- Querying STRUCTs with Impala
The Impala query syntax for STRUCT columns is exactly the same as Hive’s:

To select a field from a STRUCT column, use the column name, a dot, and the field name 
(similar to how you can use the database name, 
a dot, and the table name to refer to a table in a different database from the active one). 
For example, this query selects the name column, and the state and zipcode fields from the address column:

SELECT name, address.state, address.zipcode
FROM customers_addr_parquet;

- Try It!
Do the following to run two queries on each of the three Parquet tables 
you created in “Creating Tables with Hive and Impala.” 
Use Impala for these exercises.

First, recall that you created these tables using Hive, so there's something you need 
to do before you can query the tables with Impala. 
Do you remember what that is? Figure that out and do it. 
Try running SELECT * FROM tablename; for each table. 
Notice that the complex column is omitted from the results.
Then, run each of the examples in the reading above. 
Notice the NULL fields in each case. (Why does Bob have no row in the MAP example?)
Optional: Try some other queries for each table.
````

### COMPLEX DATA IN PRACTICE
````text
While there are several things you may want to do with complex data, 
here are three examples of practical applications. 
The techniques used for these applications are not immediately apparent from understanding basic queries, 
and they must be handled differently between Hive and Impala, so look for the new information provided here!

- Counting Items in a Collection
ARRAYs and MAPs can contain any number of items; 
they do not have a fixed size. 
You can use the size function in a Hive query to return the number of items in an ARRAY or MAP, 
but Impala does not have such a function. 
The examples here show how to find the number of items in both engines.

- Using Hive
Using the size function with Hive is fairly straightforward:

SELECT name, size(phones) AS num
FROM customers_phones_array;

For this example, the column named phones is an ARRAY column. 
Using our example data from the previous readings, 
the ARRAY in each row of this column contains a different number of items. 
In the row for Alice, the ARRAY has three items; 
in the row for Bob, the ARRAY has one item; and in the row for Carlos, the ARRAY has two items. 

The query uses the size function to return these numbers of items as a column with the alias num. 
Similarly, when you use the size function with a MAP column, it returns the numbers of key-value pairs. 
The size function is an example of what’s called a collection function, 
because it’s a function that operates on a collection type, which is another name for a complex type.

- Using Impala
As noted above, Impala does not have a size function, 
nor does Impala support any other collection functions. 
To count the number of elements in each ARRAY or MAP using Impala, 
you need to use join notation and a GROUP BY clause to group by a column or columns that have unique row values. 
You can then use the COUNT function, or indeed any other aggregation function, 
to aggregate the elements in each ARRAY or MAP.

SELECT name, COUNT(*) AS num
FROM phones_array_parquet, phones_array_parquet.phones
GROUP BY name;

In this example, the goal is to return each customer’s name and the number of phone numbers they have. 
In the SELECT list, the expression COUNT(*) AS num returns a column named num giving 
the number of records in each group, which is the number of phone numbers each customer has.

- ConvertingARRAYs and MAPs to Records with Hive
Recall that Impala's method of querying ARRAY and MAP types provides a separate row for each element in the complex column, 
and you must use a join to include values from the other columns in the table. 
Hive's behavior is very different, which may seem unusual, 
because typically Impala aims for a high degree of compatibility with Hive’s query syntax. 
In this case, Impala’s syntax is intended to provide greater flexibility.

If you want to use Hive to break the individual items within an ARRAY or MAP into a table of results 
with one item per row, you can do this using the explode function. 
The explode function is an example of what’s called a table-generating function; 
this is a class of functions that can transform a single input row into multiple output rows.

SELECT explode(phones) AS phone
FROM customers_phones_array;

In this example, the explode function is applied to the ARRAY column named phones, and it returns a column with the alias phone. 
It returns one output record for each item in the ARRAY column. 
Using the same example data as in the previous readings, there are a total of six phone numbers 
in the ARRAY column (three for Alice, one for Bob, and two for Carlos). 
This means the output contains six records. 

Since the MAP type has two parts to it, the key and the value, explode returns two values. 
You can use the same syntax except for the alias—if you use an alias, you must supply two values:

SELECT explode(phones) AS (type, number)
FROM customers_phones_map;

The result set would again have six rows, each with two columns: 
type and number. If you omit the alias, the columns would be called key and value.

When you use a table-generating function like explode, 
you cannot include any other columns in the SELECT list of your query. 
However, you can overcome this limitation by using a lateral view, 
which first applies the table-generating function to the ARRAY or MAP column, 
then joins the resulting output with the rows of the table. 
Lateral view syntax is similar to explicit join syntax; 
in the FROM clause, include the name of the base table, 
then the keywords LATERAL VIEW, followed by the explode function applied to the ARRAY or MAP column.

SELECT name, phone
FROM customers_phones_array
LATERAL VIEW
explode(phones) p AS phone;

In the example here, a lateral view is used to return values from the name column along with the individual phone numbers. 
The table alias, p in this example, is required, even if you don't use it anywhere else in the query.
The column alias, AS phone in this example, is optional.

For the MAP version, again you need two column aliases—but without parentheses in this case:

SELECT name, type, number
FROM customers_phones_map
LATERAL VIEW
explode(phones) p AS type, number;

- Denormalizing Tables Using Complex Data
A potential use for complex data is denormalizing tables with a one-to-many relationship. 
Normalized tables (using Third Normal Form) cannot have a repeating groups—that is, 
a single row should not have multiple values for one type of data. 
For example, a toy company likely has many products; 
a table listing different toy makers (like the makers table in the toy database) 
would not include all Hasbro's products in the same row.

Instead, you typically have a second table in which each row holds one of those values along with 
a foreign key that identifies which row in the first table that value belongs with. 
In the toy company in example, the toys table has one row for each toy, 
and the maker_id column identifies which company from the makers table makes that particular toy. 
Joining the columns using the maker's identification number allows you to identify all the toys made by a particular company.

The complex column types allow analysts to reshape tables into a denormalized form. 
The resulting revised data model can support queries of the combined data elements from one table, without any join required. 
In big data, you can expect a query that does not require 
a join to be significantly faster than one that does require a join. 

The rest of this section describes how to set up and query such a table, using the toy example. 
You don't need to memorize these steps or the functions involved.

- Creating the Denormalized Table
The makers_with_toys table defined below could hold each toy maker with its information, including a list of its toys 
(and the MSRP, manufacturer's suggested retail price) in the same row, 
using an ARRAY with STRUCTs as its elements. 
(The table uses Parquet files so you can query it with Impala. You can create this table in either Hive or Impala.) 

CREATE EXTERNAL TABLE toy.makers_with_toys (
    id INT,
    name STRING,
    city STRING,
    toys ARRAY<STRUCT <toy_name:STRING, price:DECIMAL(5,2)>>)
STORED AS PARQUET;

- Populating the Denormalized Table
The next step is to load the data into the table. 
Because Impala can't load data into Parquet files, 
this step must be completed with Hive.

Use the named_struct function to cast a row of the detail table (in this case, toys) into the STRUCT. 
Then use the collect_list function to collect multiple rows into the ARRAY. 

INSERT OVERWRITE TABLE toy.makers_with_toys
SELECT m.id, m.name, m.city,
        collect_list(named_struct('toy_name', t.name,'price', t.price))
    FROM toy.makers m LEFT OUTER JOIN toy.toys t
        ON (m.id = t.maker_id)
    GROUP BY m.id, m.name, m.city;

- Querying the Denormalized Table
You now can query the table with Hive or Impala, using the syntax for the engine you're using. 
For example, you can find the price of the most expensive toy for each maker using the following query with Impala. 
Remember to invalidate metadata before attempting to run this query with Impala:

SELECT name, MAX(toys.item.price) AS max_price
    FROM toy.makers_with_toys, toy.makers_with_toys.toys
    GROUP BY name;

Note that to query the elements in the ARRAY column (toys), you need to reference the pseudocolumn toys.item as the column, 
but that element is a STRUCT. So you then need to use .price to identify the element within that STRUCT.

Try It!
Try each of the examples above, using both the ARRAY and MAP tables when appropriate.
````