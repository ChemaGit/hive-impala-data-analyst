/*
I am using HiveQL and I need to calculate the age just by using the Date of birth column
but the issue is GetDate doesn’t work however Current_Date() does. The example I am trying is

Ex: datediff(yy,Dateofbirthcol,current_date()) As Age.

The DOB column looks like ex: 1988-12-14 just as side note.
*/

SELECT FLOOR(DATEDIFF(TO_DATE(FROM_UNIXTIME(UNIX_TIMESTAMP())), '1969-07-17') / 365.25) AS age;

SELECT FLOOR(DATEDIFF(CURRENT_DATE, '1969-07-17') / 365.25) AS age;
