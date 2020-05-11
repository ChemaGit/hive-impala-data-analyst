# DATA TYPES

### INTEGER DATA TYPES
````text
Hive and Impala support four integer data types: 
TINYINT, SMALLINT, INT, and BIGINT. 
These represent whole numbers with no fractional parts.

Larger integer types allow you to represent larger ranges of numbers, 
as shown in the table below, but processing them requires more memory, 
so you should generally use the smallest integer type that accommodates the full range of values in your data.

Integer Type	Range
TINYINT		-128 to 127
SMALLINT	-32,768 to 32,767
INT		-2,147,483,648 to 2,147,483,647 (approximately 2.1 billion)
BIGINT	 	-9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 (approximately 9.2 quintillion)

Unlike in some relational databases, all integer types in Hive and Impala are signed; 
that is, they can represent positive or negative integer values. There are no unsigned integer types.
````
### DECIMAL DATA TYPES
````text
Hive and Impala support three decimal data types: FLOAT, DOUBLE, and DECIMAL. 
These types represent numbers that can include fractional parts.

The FLOAT and DOUBLE types represent floating-point numbers, 
which do not have a predetermined number of digits after the decimal point. 
DOUBLE offers greater range and precision than FLOAT, but processing DOUBLEs 
requires more memory than processing FLOATs, so in general, 
choose FLOAT unless you need the range or precision that DOUBLE offers.

Because of the binary system used to store numbers, both FLOAT and DOUBLE data types 
can produce unexpected inaccuracies, even with seemingly simple arithmetic like 0.1 + 0.2. 
(See The Floating Point Guide for more about this.)

DOUBLE is more accurate because DOUBLE uses 64 bits to store each number, while FLOAT uses only 32 bits. 
(So DOUBLE has double the number of bits.) 
This means FLOAT is typically accurate up to 7 digits, while DOUBLE is accurate up to 15 or maybe 16 digits. 

The DECIMAL type represents numbers with fixed precision and scale. 
When you create a DECIMAL column, you specify the precision, p, and scale, s. 
Precision is the total number of digits, regardless of the location of the decimal point. 
Scale is the number of digits after the decimal place. 
To represent the number 8.54 without a loss of precision, you would need a 
DECIMAL type with precision of at least 3, and scale of at least 2.

The table below illustrates the difference in precision using results for p. 
Note that the DECIMAL(17,16) type means there is a total of 17 digits, with 16 of them after the decimal point.

Data Type	Result for p (bold are accurate)
FLOAT		3.1415927410125732
DOUBLE		3.1415926535897931
DECIMAL(17,16)	3.1415926535897932

Using the DECIMAL type, it is possible to represent numbers with greater precision than the FLOAT or DOUBLE types can represent. 
The maximum allowed precision and scale of the DECIMAL type are both 38. 
(Hive can allow larger values of precision and scale, but Impala does not support them.)

The table below describes the range of DOUBLE, FLOAT, and DECIMAL(38,0). 
The ranges described below are the largest negative and largest positive number that each data type can represent. 

Data Type	Range
FLOAT		-3.40282346638528860 * 10^38 to 3.40282346638528860 * 10^38
DOUBLE		-1.79769313486231570 x 10^308 to 1.79769313486231570 x 10^308
DECIMAL(38,0)	-10^38 + 1 to 10^38 - 1

For representing currency, you should use DECIMAL instead of FLOAT or DOUBLE; 
this prevents loss of precision, which is typically of paramount importance with financial data. 
Another choice for currency is to use an integer type to represent, for example, 
the number of cents, instead of storing dollars with fractional parts.
````

### CHARACTER DATA TYPES
````text
Hive and Impala support three character data types: STRING, CHAR, and VARCHAR. 
These types represent alphanumeric text values.

The STRING data type represents a sequence of characters with no specified length constraint.*

If you’re familiar with relational databases, you are probably more accustomed 
to the character types CHAR and VARCHAR, which have a specified length. 

The CHAR type represents fixed-length character sequences, with a precise specified length. 
Values longer than the specified length are truncated. 
Values shorter than the specified length are padded with spaces. 
If you assign the 13-character value Impala rules! to a CHAR column with length 16, 
then Hive and Impala will pad that value with three spaces to make it 16 characters long: 
hiveQL rules!??? (The three symbols shown in this example represent spaces.)

The VARCHAR type represents character sequences with a maximum specified length.

Values longer than the maximum are truncated, but values shorter than the maximum are not padded with spaces. 
If you attempt to assign the 13-character value hiveQL rules! in a VARCHAR column with a maximum length of 10, 
then Hive and Impala will truncate that value to 10 characters, discarding the last three characters: 
hiveQL rul. However, if the maximum length is 13 or more, the stored value will be exactly Impala rules! 
(with no extra spaces as you would get with the CHAR type).

The table here summarizes these examples.

Data Type	Description			Value (attempting Impala rules!)
STRING		Any number of characters	hiveQL rules!
CHAR(10)	Exactly 10 characters		hiveQL rul
CHAR(16)	Exactly 16 characters		hiveQL rules!???
VARCHAR(10)	At most 10 characters		hiveQL rul
VARCHAR(16)	At most 16 characters		hiveQL rules!

With CHAR types, trailing spaces are ignored in comparisons. 
With VARCHAR and STRING values, any trailing spaces are considered in comparisons. 
(This makes sense, since neither is automatically padded—trailing 
spaces are not considered to be “padding” in these cases.)

You should generally choose STRING over CHAR or VARCHAR. 
STRING offers greater flexibility and ease of use, and in some cases Hive and Impala 
have better performance and compatibility when using STRING columns. 
But if you have a particular need for string values with precise lengths or with maximum lengths, 
then you could use CHAR or VARCHAR.

**Footnote**: 
**Actual String Limits**

There actually are practical limits to the length of strings, 
though in most real-world applications, it's unlikely you'll ever come up against them. 

For example, in Impala, these are the considerations for lengths of strings 
(taken from STRING Data Type? in Cloudera's Impala documentation):

The hard limit on the size of a STRING and the total size of a row is 2GB.
If a query tries to process or create a string larger than this limit, it will return an error to the user.
The limit is 1GB on STRING when writing to Parquet files.
Queries operating on strings with 32KB or less will work reliably and will not hit significant performance 
or memory problems (unless you have very complex queries, very many columns, and so on.)
Performance and memory consumption may degrade with strings larger than 32KB.
This varies somewhat according to which version of Impala you are using, 
so if you are working with exceptionally large strings, check the documentation.
````
### OTHER DATA TYPES
````text
Besides the integer, decimal, and character data types, Hive and Impala support several other simple data types.

The BOOLEAN type represents a Boolean value, that is, a true or false value. 

The TIMESTAMP type represents an instant in time. 
TIMESTAMPs can represent values with up to nanosecond precision. 
They are interpreted as being in UTC, or Coordinated Universal Time, 
but Hive and Impala provide functions for conversion to local timezones.

Hive (but not Impala) provides a DATE type, representing a particular day in the form YYYY-MM-DD, without a time of day. 
With Hive, a TIMESTAMP can be stripped of the time of day by casting to a DATE type.

There’s also the BINARY type, which can represent any sequence of raw bytes, and also is supported only by Hive, not by Impala. 
This is analogous to the VARBINARY type in some relational databases.

The table below summarizes these types.

Data Type		Description			Example Value
BOOLEAN			True or false			true
TIMESTAMP		Instant in time			2019-02-25 16:51:05
DATE (Hive only)	Date without time of day	2019-02-25
BINARY (Hive only)	Raw bytes			N/A

Hive and Impala also support complex types (ARRAY, MAP, and STRUCT)
````