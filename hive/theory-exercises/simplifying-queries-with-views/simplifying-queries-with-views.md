## SIMPLIFYING QUERIES WITH VIEWS

### WHAT TO DO WHEN QUERIES ARE TOO COMPLEX
````text
SELECT f.carrier, name, origin, dest, type
	FROM flights f
		JOIN airlines a
			ON (f.carrier = a.carrier)
		JOIN planes p
			ON (f.tailnum = p.tailnum)
	WHERE origin = 'BOS' OR dest = 'BOS'

- Using views can simplify queries
````

### CREATING AND QUERYING VIEWS
````text
A view is a saved query, which then can be queried as if it were a table. 
The syntax for creating a view is the same as using 
CREATE TABLE AS SELECT (CTAS), but with VIEW instead of TABLE:

CREATE VIEW viewname AS
SELECT col1, col2, ... FROM tablename … ;

Views appear in lists of the tables within a database 
(in Hue interfaces and in the result of SHOW TABLES) exactly as if they were tables.

For example, this query to show information about the aircraft flying into 
or out of a particular airport might be something you want to explore for different airports:

SELECT f.carrier, name, origin, 
        dest, type, manufacturer, model,
        p.year, engines, seats, engine
    FROM flights f
        JOIN airlines a
            ON (f.carrier = a.carrier)
        JOIN planes p 
            ON (f.tailnum = p.tailnum)
    WHERE origin='BOS' OR dest='BOS';

Rather than running this every time you want to look at a different airport, 
you could save a view with all the information for all airports:

CREATE VIEW craft_information AS
    SELECT f.carrier, name, origin, 
            dest, type, manufacturer, model,
            p.year, engines, seats, engine
        FROM flights f
        JOIN airlines a
            ON (f.carrier = a.carrier)
        JOIN planes p 
            ON (f.tailnum = p.tailnum);

Then you can query the view:

SELECT * 
FROM craft_information 
WHERE origin='BOS' or dest='BOS';

Note that only the columns specified in the CREATE VIEW 
statement will be returned when you query the view. 
It’s also possible to limit which rows can be returned by using a WHERE clause in the view definition. 
By limiting which columns and rows can be returned, 
views can be used to prevent users from accessing sensitive information. 
So views can be used both for convenience and for security.

Try It!
Create the craft_information view described above.
Use SHOW TABLES; to get a list of tables in your active database. 
See if craft_information is included, and if it is, 
does it appear any differently from the actual tables in the list?
Use DESCRIBE craft_information; and then DESCRIBE FORMATTED craft_information; 
Note that there is nothing in the basic DESCRIBE results that indicates 
this is a view rather than a table, then find what there is in 
DESCRIBE FORMATTED that indicates this.
Run a query to return sample craft information for BOS (Logan International Airport in Boston), 
or another U.S. airport that you have flown from. 
(Not all airports will be included in the database, but you can certainly try! 
If you get 0 results, try a larger airport.) 
Note: Most airports are likely to return a large number of rows—BOS returns over 2 million rows, 
for example—so if you are using the command line, you should limit the number of rows returned. 
If you're interested, you could also limit the results by picking a particular carrier as well as 
the airport for your WHERE clause, but even then, you might get thousands of rows.
If this were a table, there would be a craft_information storage directory in the file system 
(for example, in /user/hive/warehouse/ or  /user/hive/warehouse/fly.db, 
depending on which database you had as your active database). 
Check HDFS for such a directory. (There should be none.) 
The view uses the same data as the source tables, so no storage directory is created.
Do not try dropping the view; you'll use it in the next reading.
````

### MODIFYING AND REMOVING VIEWS
````text
As with tables, you can modify and remove views—but there are 
distinct differences in what you can do, and in the results.

- Modifying Views
You can alter a table in several different ways: rename the table, move it to a different database, 
change column names or types, change column order (Hive only), 
add or remove columns (including replacing all columns at once), 
or change table properties such as whether the table is managed or unmanaged. 
The ways you can modify a view are quite different. 
In each case you use ALTER VIEW, with different additional clauses. 
Hive and Impala support different clauses, so please note which engine supports which modifications.

Here are two examples:

Associate with a different query (Hive or Impala): Using either Hive or Impala, 
you can keep the view name but change the underlying query. 
To do this, use this syntax:

ALTER VIEW viewname AS SELECT …;

Supply the new query in the SELECT statement after the AS keyword. 

Rename or move to a different database (Impala only): 
In Impala, you can rename the view or move it to a different database using this syntax:

ALTER VIEW db.name RENAME TO newdb.newname

To keep the view in the same database, repeat the same database name, 
or if the active database is the database which has the view, you can omit the database name entirely. 
To keep the same view name when changing the database, repeat the same view name.

- Dropping Views
You can drop a view in Hive or Impala simply by using DROP VIEW dbname.viewname; 
The dbname. is optional if the view is in the active database.

Dropping views makes no changes to any data in the file system. 
Any tables used for the underlying query will still have their data.

Try It!
Try modifying and then dropping the craft_information view 
you created in the previous reading, “Creating and Querying Views.” 
If you didn't do the activities with that reading, 
go back and use the instructions to create the view before preceding.

1. First try renaming the view using Impala. 
Be sure your active database is the one with the view, 
then use ALTER VIEW craft_information RENAME TO viewname. 
You can rename it whatever you like. 
Run a SHOW TABLES; command to see verify that the name has changed.

2. Change the underlying query, using either Impala or Hive (your choice). 
Make it something simple, such as ALTER VIEW viewname AS SELECT DISTINCT carrier FROM flights; 
Use DESCRIBE viewname; to verify that the underlying query has changed.

3. Finally drop the view. 
Check that the table you specified in the 
SELECT statement in the view definition in previous step still has its data!
````

### MATERIALIZED AND NON-MATERIALIZED VIEWS
````text
Views in Hive and Impala are typically non-materialized. 
This means that a view does not store or persist any data. 
It stores only a query.

When you query a view, Hive or Impala generates the result set on the fly 
by running the view’s stored query on the underlying tables, 
then running your query on the result of the stored query.* 
It does this each time you run the query. 
For a complicated and computationally expensive query, 
this can take some time—that’s the major disadvantage of non-materialized views. 
The major advantage is that whenever the data is changed in any 
of the underlying tables used in the stored query, the view will use the new data.

A materialized view, on the other hand, would store the data, 
so that the SQL engine does not need to run a query on the underlying tables every time the view is queried. 
This can save time. 
However, if the data is changed in any of the underlying tables, 
a materialized view will not use the new data; you would need to rebuild the view first.

At this time, Impala does not support materialized views, though this is something the developers are considering. 
(See [IMPALA-3446]? for updates on this.) 
Hive has recently added materialized views with Hive 3.0.0. 
(See [HIVE-10459]? and the Hive Materialized views page.) 
However, the VM provided for this course uses an older version of Hive, 
so you cannot create materialized views on the VM.

* This is essentially what happens, 
but in practice Hive and Impala might optimize this process by combining 
the operations in your query with the operations in the stored query 
into one single set of operations so that the result can be generated as efficiently as possible.
````

### THE ORDER BY CLAUSE IN VIEWS
````text
The stored query for a view can be any query—it can use any of the allowed clauses of a SELECT statement. 
However, using the ORDER BY clause in a view’s stored query is not recommended. 
Sorting (arranging) result rows in order is an action best performed 
in the query on the view, not in the view’s stored query.

To understand why this is, recall that Hive and Impala are designed 
to distribute query processing work across large clusters of computers. 
Some tasks (like filtering rows) can easily be performed in parallel 
on many rows distributed across these many computers. 
But the task of efficiently sorting many rows typically requires consolidating 
all the rows on just one or a few computers. 
This makes sorting rows a slow and inefficient operation; 
sorting is typically the bottleneck of any query that uses an ORDER BY clause. 
Furthermore, preserving the sort order through later query operations 
forces those later operations also to be slow and inefficient.

So if it is necessary to sort a result set, 
the sort operation should be performed last, 
after the other operations such as filtering. 
Because the queries on a view will often perform further operations, 
including filtering, the query stored in a view should not perform sorting; 
doing this would cause major inefficiencies.

Impala and newer versions of Hive (version 3.0.0 and higher,
 which is newer than the version on the course VM) prevent these inefficiencies 
 from occurring by ignoring the ORDER BY clause when it is used in a view’s stored query. 
Impala will issue a warning to inform you of this when 
you query a view that uses ORDER BY in its stored query. 
However, some applications do not display this warning. 
Impala Shell displays it prominently, but Hue’s Impala query editor does not; 
you need to click Show Logs to see it in Hue. 
Some other applications do not display the warning at all.

Newer versions of Hive will silently ignore the ORDER BY clause 
in a view’s stored query and will not issue any warning. 
Older versions of Hive (like the one on the VM) will respect the ORDER BY clause 
in a view’s stored query and will incur the associated inefficiencies.

The exception to all of this is when the ORDER BY clause is used together 
with the LIMIT clause in a view’s stored query. 
If a view’s stored query uses ORDER BY and LIMIT n, then the sorting operation 
is much less likely to be a bottleneck, because Hive and Impala can efficiently 
identify the top n or bottom n rows (if n is fairly small—and it typically is).

So if a view’s stored query uses ORDER BY together with LIMIT, 
then Impala and newer versions of Hive will not ignore the ORDER BY clause.

Try It!
1. Using Hive (either in Hue or using Beeline on the command line), 
make the fly database your active database.

2. Do a quick SELECT * FROM planes LIMIT 20; 
to see what the first 20 rows of the planes table looks like.

3. Create a view of the planes table with all the columns, ordering by year 
in descending order but without a LIMIT clause (and omitting any rows where year is NULL). 
You can name it whatever you like. Here's the syntax, just to remind you:

CREATE VIEW viewname AS
SELECT * FROM planes
    WHERE year IS NOT NULL
    ORDER BY year DESC;

4. Query the view just using:

SELECT * FROM viewname LIMIT 20;

Notice that the result set is indeed sorted by year (all the results should be from 2018). 
Also note how long it took to finish (this will matter in the next step). 
The time is reported in the top right of the query window, next to the active database.

5. Query the view again, but this time sort your query by tailnum:

    SELECT * FROM viewname ORDER BY tailnum LIMIT 20;

Notice that the results are not all from 2018, 
and the query took probably almost twice as long, because it had to sort twice!

6. Now try it in Impala. First, go to Impala in Hue or using Impala Shell on the command line, 
and make fly the active database. Then execute:

INVALIDATE METADATA viewname;

so Impala will see the view you created in Hive.

7. Query the view just using:

SELECT * FROM viewname LIMIT 20; 

a. When you did this in Hive, you got only planes from 2018; what are the results this time?

b. Can you see the warning message indicating that the ORDER BY clause in the view has no effect on the query result? 
If you are using Hue, click the Show Logs button on the upper right; 
the warning should be visible at the bottom of the logs.

8. You can drop the view if you like.
````