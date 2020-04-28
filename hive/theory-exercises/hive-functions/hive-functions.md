### OVERVIEW OF FUNCTIONS
````text
Let us get overview of functions in Hive.

We can get list of functions by running SHOW functions
We can use DESCRIBE command to get the syntax and symantecs of a function - DESCRIBE FUNCTION substr
Following are the categories of functions that are more commonly used.
    String Manipulation
    Date Manipulation
    Numeric Functions
    Type Conversion Functions
    CASE and WHEN
    and more
````
````iso92-sql
-- $ beeline -u jdbc:hive2://localhost:10000/

SHOW FUNCTIONS;

DESCRIBE FUNCTION substr;

DESCRIBE FUNCTION substring;
````