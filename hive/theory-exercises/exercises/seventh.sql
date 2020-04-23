/*
I have 2 Impala tables.

1st table T1 (additional columns are there but I am interested in only date and day type as weekday):

date       day_type
04/01/2020 Weekday
04/02/2020 Weekday
04/03/2020 Weekday
04/04/2020 Weekend
04/05/2020 Weekend
04/06/2020 Weekday
2nd table T2:

process date       status
A       04/01/2020 finished
A       04/02/2020 finished
A       04/03/2020 run_again

Using Impala queries I have to get the maximum date from second table T2 and get its status.
According to the above table 04/03 is the maximum date. If the status is finished on 04/03,
then my query should return the next available weekday date from T1 which is 04/06/2020. But if the status is run_again,
then the query should return the same date.
In the above table, 04/03 has run_again and when my query runs the output should be 04/03/2020 and not 04/06/2020.
*/

WITH T3 as (
  select t.date date, min(x.date) next_workday
  from T1 t join T1 x
  on t.date < x.date
  where x.day_type = 'Weekday'
  group by t.date
)
select T2.process, T2.date run_date, T2.status,
  case when T2.status = 'finished' then T3.next_workday
  else T3.date
  end next_run_date
from T2 join T3
on T2.date = T3.date
order by T2.process, T2.date;

/*
+---------+------------+-----------+---------------+
| process | run_date   | status    | next_run_date |
+---------+------------+-----------+---------------+
| A       | 2020-04-01 | finished  | 2020-04-02    |
| A       | 2020-04-02 | finished  | 2020-04-03    |
| A       | 2020-04-03 | run again | 2020-04-03    |
+---------+------------+-----------+---------------+
*/