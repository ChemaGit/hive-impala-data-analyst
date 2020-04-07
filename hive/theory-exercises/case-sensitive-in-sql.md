### CASE SENSITIVE IN SQL
````text
- In general, case sensitive means that case matters—a letter or group of letters 
  that are uppercase (capital, for example 'A' or 'FROM') is considered different 
  from the same letter or group of letters that are lowercase (for example, 'a' or 'from'). 

- Case insensitive means these things are the same—it doesn't matter if you write something 
  with uppercase letters, lowercase letters, or even a mix of cases. 
  For case insensitive matters, 'FROM' is the same as 'from'.

- In SQL, there are many different things that could be case sensitive or not: 
  keywords, function names, column and table references, strings (when comparing). 
  Unfortunately, it's difficult to be definitive, because different SQL engines have different behaviors. 
  
- For example:

- In PostgreSQL, Apache Hive, and Apache Impala, table and column names are always lowercase. 
  Even when you create a table, if you use uppercase, any results showing the table or column names will show them lowercase. 
  However, table and column references are essentially case insensitive, because you can still use uppercase or lowercase in your queries. 
  The engine will automatically convert them to lowercase. Results will show them using lowercase letters.
  In  MySQL, table and column names will retain how they are defined on creation (or for column names, however they might be altered later). 
  If you define them with uppercase, they will be stored as uppercase; if you define them with lowercase, they will be stored as lowercase. 
  However, the table names are case sensitive: You must match the case to get a result. 
  If the table is named TABLE_NAME, then FROM table_name will not match that table. 
  On the other hand, column names are case insensitive. Any references using the correct letters will match regardless of case. 
  The results will use the case you use for the query, so SELECT NAME will have NAME in the result header, 
  but SELECT name will have name in the result header. Otherwise the results will be the same.
  Even string comparisons can work differently:

- In PostgreSQL, Hive, and Impala, string comparisons are case sensitive. For example, 'this' = 'This' returns false.
  MySQL string comparisons are not case sensitive. For example, 'this' = 'This' returns 1(true), as does 'this'='THIS'. 
  (But 'this' = 'that' returns 0, or false.)

- In Hive and Impala, all keywords, function names, and identifiers are case insensitive. 
  Only string comparisons are case sensitive. However, we will use the following conventions. 
  These are merely conventions; although they are widely used, they are not essential:

  Keywords (like SELECT and FROM) are in uppercase.
  Most other things are all lowercase, including identifiers and most function names.
  Making keywords the only things uppercase makes it much easier to quickly identify the keywords.

  Other tools that access Hive or Impala, such as business intelligence applications, 
  might impose their own case conventions and might have their own rules for identifier names. 
  So if you’re using some tool like that, be sure to also consider its conventions and rules, 
  not only the conventions and rules imposed by Hive or Impala.
````