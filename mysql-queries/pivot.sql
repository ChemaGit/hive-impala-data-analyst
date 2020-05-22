/*
Clean nulls from query pivot table in MySql

I have the following dataset as an example

+-----------+------------+
| name      | occupation |
+-----------+------------+
| Samantha  | Doctor     |
| Julia     | Actor      |
| Maria     | Actor      |
| Meera     | Singer     |
| Ashely    | Professor  |
| Ketty     | Professor  |
| Christeen | Professor  |
| Jane      | Actor      |
| Jenny     | Doctor     |
| Priya     | Singer     |
+-----------+------------+


I would like pivot the Occupation column in table so that each Name is sorted alphabetically and displayed underneath
its corresponding Occupation. The output column headers should be Doctor, Professor, Singer, and Actor, respectively.

Sample output

Doctor   Professor  Singer Actor
Jenny    Ashley     Meera  Jane
Samantha Christeen  Priya  Julia
NULL     Ketty      NULL   Maria
*/
SELECT MAX(CASE occupation WHEN 'Doctor' THEN name END) AS Doctor,
       MAX(CASE occupation WHEN 'Professor' THEN name END) AS Professor,
       MAX(CASE occupation WHEN 'Singer' THEN name END) AS Singer,
       MAX(CASE occupation WHEN 'Actor' THEN name END) AS Actor
FROM (SELECT o.*,
             (SELECT COUNT(*)
              FROM occupations o2
              WHERE o2.occupation = o.occupation AND
                    o2.name <= o.name
             ) as seqnum
      FROM occupations o
     ) o
GROUP BY seqnum;

set @r1=0, @r2=0, @r3=0, @r4=0;
select min(Doctor), min(Professor), min(Singer), min(Actor)
from(
  select case when Occupation='Doctor' then (@r1:=@r1+1)
            when Occupation='Professor' then (@r2:=@r2+1)
            when Occupation='Singer' then (@r3:=@r3+1)
            when Occupation='Actor' then (@r4:=@r4+1) end as RowNumber,
    case when Occupation='Doctor' then Name end as Doctor,
    case when Occupation='Professor' then Name end as Professor,
    case when Occupation='Singer' then Name end as Singer,
    case when Occupation='Actor' then Name end as Actor
  from occupations
  order by Name
) Temp
group by RowNumber;


