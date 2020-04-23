### Ordering by String columns
````text
You can control the sort order of SQL query results using the ORDER BY clause. 
When sorting on a numeric column, the resulting order typically makes intuitive sense, 
but when sorting on a string column, you might be surprised by the resulting order. 
This is especially true when the strings include numbers, 
or a mix of numbers and letters or other characters within a value.

Unfortunately, there isn't a simple explanation to tell you how SQL will sort your results, 
because it depends on what collation you are using. 

A DBMS uses a collating sequence, or collation, to determine the order in which characters are sorted. 
The collation defines the order of precedence for every character in your character set. 
Your character set depends on the language that you’re using—European languages (a Latin character set), 
Hebrew (the Hebrew alphabet), or Chinese (ideographs), for example. 
The collation also determines case sensitivity (is ‘A’ < ‘a’?), accent sensitivity (is ‘A’ < ‘À’), 
width sensitivity (for multibyte or Unicode characters), and other factors such as linguistic practices. 
The SQL standard doesn’t define particular collations and character sets, 
so each DBMS uses its own sorting strategy and default collation… Search your DBMS documentation for collation or sort order. (1)
Collations have different options associated with them, and many can be customized depending on the system you are using. 
For English, case sensitivity is a major one to consider—should "A" and "a" be considered the same character for the purposes of ordering
Others include accent sensitivity (for example, should "a" and "á" be considered the same), 
Kana sensitivity (which distinguishes between the two types of Japanese characters), 
and script order (for example, which should be ordered first: Hebrew, Greek, or Cyrillic). 
See "Customization" (2) and "Collation" (3) for more examples of these and other options.

When using Unicode—an industry standard that assigns a number to each character or symbol— 
SQL will most likely follow the Unicode ordering to distinguish the order of two characters, 
while taking customizations into account. Non-Unicode data may have a different order:

When you use a SQL collation you might see different results for comparisons of the same characters, 
depending on the underlying data type. For example, if you are using the SQL collation "SQL_Latin1_General_CP1_CI_AS", 
the non-Unicode string 'a-c' is less than the string 'ab' because the hyphen ("-") is sorted as a separate character 
that comes before "b". However, if you convert these strings to Unicode and you perform the same comparison, 
the Unicode string N'a-c' is considered to be greater than N'ab' because the Unicode sorting rules use a "word sort" that ignores the hyphen. (4)
When it comes to numbers represented within strings, you must remember than string sorting is done on a character-by-character basis. For example:

'42' < '71'	This compares only the first characters: '4'<'7'. 
The order is now established and any other remaining characters can be ignored.
'42' < '45'	The first characters are the same, '4' = '4', 
so the sort then compares the next characters, '2'<'5'. So '42' < '45'.
'42' < '7'	Although numerically 42 > 7, the sort compares the first characters, '4' and '7'. Since '4' < '7', 
the order is established and any other remaining characters are ignored. 
For this string sort, '42' < '7'.
You can sometimes find ways to customize the sort, when necessary. For example, 
"Use SQL Server to Sort Alphanumeric Values" (5) provides a method, usable with Microsoft SQL Server, 
to sort values with a mixture of letters and numerals that would consider '7' < '42'.

Spaces, especially leading spaces, often cause confusion as well. 
The space character is typically considered to come before any number or letter, and some punctuation as well. 
Again, sort order is done character by character. For example: 

'no one' < 'nobody'	The first characters are equivalent, 'n' = 'n', so the sort would move to the second characters.
These are also equivalent, 'o' = 'o', so the sort moves to the third characters. 
These are ' ' and 'b', and ' ' < 'b', so 'no one' < 'nobody'.
' start' < 'begin'	Notice that the first character in the string on the left is a space. 
While 'begin' < 'start' because 'b' < 's', these string sort as ' start' < 'begin' because ' ' < 'b'.
For more detail on these points, see the referenced articles.

(1) Fehily, Chris. SQL VIsual QuickStart Guide, 3rd Edition.Retrieved from http://www.peachpit.com/articles/article.aspx?p=1276352&seqNum=4? on May 25, 2018.

(?2) Unicode® Technical Standard #10: Unicode Collation Algorithm. Retrieved from http://unicode.org/reports/tr10/#Customization? on May 25, 2018.

(?3) Collation and Unicode Support. Retrieved from https://docs.microsoft.com/en-us/sql/relational-databases/collations/collation-and-unicode-support?view=sql-server-2017#Collation_Defn? on May 25, 2018.

(?4) Comparing SQL collations to Windows collations. Retrieved from https://support.microsoft.com/en-us/help/322112/comparing-sql-collations-to-windows-collations? on May 25, 2018.

(?5) Use SQL Server to Sort Alphanumeric Values. Retrieved from https://www.essentialsql.com/use-sql-server-to-sort-alphanumeric-values/ on May 25, 2018.
````
### Missing Values in Ordered Results
````text
$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT shop, game, price FROM fun.inventory ORDER BY price'
$ impala-shell -q 'SELECT shop, game, price FROM fun.inventory ORDER BY price' 

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT shop, game, price FROM fun.inventory ORDER BY price DESC'
$ impala-shell -q 'SELECT shop, game, price FROM fun.inventory ORDER BY price DESC'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT shop, game, price FROM fun.inventory ORDER BY price IS NULL ASC, price'
$ impala-shell -q 'SELECT shop, game, price FROM fun.inventory ORDER BY price NULLS FIRST'  

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT shop, game, price FROM fun.inventory ORDER BY price IS NULL DESC, price DESC'
$ impala-shell -q 'SELECT shop, game, price FROM fun.inventory ORDER BY price DESC NULLS LAST'

$ beeline -u jdbc:hive2://localhost:10000 -e 'SELECT shop, game,aisle, price FROM fun.inventory ORDER BY aisle DESC, price ASC'
$ impala-shell -q 'SELECT shop, game,aisle, price FROM fun.inventory ORDER BY aisle DESC NULLS LAST, price ASC NULLS FIRST'
````