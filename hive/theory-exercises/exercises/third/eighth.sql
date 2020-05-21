/*
My table looks like this, what I am trying to achieve
is to pull out all the records for one user for the product that have the earliest date

product |type_id| user | Date  |Desired ROW_NUMBER as output  |
-------+--------+------+-------+---------------------

 1      |   1  |   A   | 0101  |   1
 1      |   1  |   A   | 0102  |   1
 2      |   3  |   A   | 0105  |   2
 2      |   5  |   A   | 0105  |   2
 3      |   7  |   B   | 0101  |   1
 3      |   8  |   B   | 0104  |   1

So I want to pull all the records with "1" in the desired row_num column,
but I haven't figured out hot to get this without doing another group by. Any helps would be appreciated.
*/

select t.*
from (select t.*,
             rank() over (partition by user order by min_date) as seqnum
      from (select t.*,
                   min(date) over (partition by user, product) as min_date
            from t
           ) t
     ) t
where seqnum = 1;

-- Or, with only one subquery:

select t.*
from (select t.*,
             min(date) over (partition by user, product) as min_date_up,
             min(date) over (partition by user) as min_date_u
      from t
     ) t
where min_date_u = min_date_up;
