/*
I have a relation

+-----+----+
| seq | id |
+-----+----+
|   1 | A1 |
|   2 | B1 |
|   3 | C1 |
|   4 | D1 |
+-----+----+
and want to join it in PostgreSQL with

+----+-------+
| id | alter |
+----+-------+
| B1 | B2    |
| D1 | D2    |
+----+-------+
so I get all possible combinations of replacement (i.e. the Cartesian product of replacing more or less).
So group 1 has no update,group 2 only B2, group 3 only D2 and group 4 both B2 and D2.

The end should look like this, but should be open to more (like an extra D3 for D1)

+-------+-----+----+
| group | seq | id |
+-------+-----+----+
|     1 |   1 | A1 |
|     1 |   2 | B1 |
|     1 |   3 | C1 |
|     1 |   4 | D1 |
|     2 |   1 | A1 |
|     2 |   2 | B2 |
|     2 |   3 | C1 |
|     2 |   4 | D1 |
|     3 |   1 | A1 |
|     3 |   2 | B1 |
|     3 |   3 | C1 |
|     3 |   4 | D2 |
|     4 |   1 | A1 |
|     4 |   2 | B2 |
|     4 |   3 | C1 |
|     4 |   4 | D2 |
+-------+-----+----+
*/

/*
I can only think of a brute force approach. Enumerate the groups and multiply the second table -- so one set of rows for each group.

The following then uses bit manipulation to choose which value:
*/
WITH a as (
      SELECT * FROM (values (1,'A1'),(2,'B1'), (3,'C1'), (4,'D1')   ) as a1(seq, id)
      ),
     b as (
      SELECT * FROM (values ('B1','B2'), ('D1','D2')) as b1(id,alter)
     ),
     bgroups as (
      SELECT b.*, grp - 1 as grp, ROW_NUMBER() OVER (PARTITION BY grp ORDER BY id) - 1 as seqnum
      FROM b CROSS JOIN
           GENERATE_SERIES(1, (SELECT POWER(2, COUNT(*))::int FROM b)) gs(grp)
     )
SELECT bg.grp, a.seq,
       COALESCE(MAX(CASE WHEN a.id = bg.id AND (POWER(2, bg.seqnum)::int & bg.grp) > 0 THEN bg.alter END),
                MAX(a.id)
               ) as id
FROM a CROSS JOIN
     bgroups bg
GROUP BY bg.grp, a.seq
ORDER BY bg.grp, a.seq;