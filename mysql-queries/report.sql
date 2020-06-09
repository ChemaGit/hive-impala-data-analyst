/*
You are given two tables: Students and Grades. Students contains three columns ID, Name and Marks.

Column	Type
ID	Integer
Name	String
Marks	Integer

Grades contains the following data:

Column 		Type
Grade		Integer
Min_Mark	Integer
Max_Mark	Integer

Grade	Min_Mark	Max_Mark
1	0		9
2	10		19
3	20		29
4	30		39
5	40		49
6	50		59
7	60		69
8	70		79
9	80		89
10	90		100

Ketty gives Eve a task to generate a report containing three columns:
Name, Grade and Mark.
Ketty doesn't want the NAMES of those students who received a grade lower than 8.
The report must be in descending order by grade -- i.e. higher grades are entered first.
If there is more than one student with the same grade (8-10) assigned to them,
order those particular students by their name alphabetically.
Finally, if the grade is lower than 8, use "NULL" as their name and list them by their grades in descending order.
If there is more than one student with the same grade (1-7) assigned to them,
order those particular students by their marks in ascending order.

Sample Input
ID	Name		Marks
1	Julia	 	88
2	Samantha	68
3	Maria		99
4	Scarlet		78
5	Ashley		63
6	Jane		81

Write a query to help Eve.

Sample Output

Maria 10 99
Jane 9 81
Julia 9 88
Scarlet 8 78
NULL 7 63
NULL 7 68

Note

Print "NULL"  as the name if the grade is less than 8.

Explanation

Consider the following table with the grades assigned to the students:

ID	Name		Marks
1	Julia	 	88
2	Samantha	68
3	Maria		99
4	Scarlet		78
5	Ashley		63
6	Jane		81

So, the following students got 8, 9 or 10 grades:

Maria (grade 10)
Jane (grade 9)
Julia (grade 9)
Scarlet (grade 8)
*/
CREATE TABLE students (
  ID INTEGER,
  name VARCHAR(16),
  marks INTEGER
);

INSERT INTO students VALUES(1, 'Julia', 88),(2, 'Samantha', 68),(3, 'Maria', 99),
(4, 'Scarlet', 78),(5, 'Ashley', 63),(6, 'Jane', 81);

CREATE TABLE grades (
  grade INTEGER,
  min_Mark INTEGER,
  max_Mark INTEGER
);
INSERT INTO grades VALUES(1,0,9),(2,10,19),(3,20,29),(4,30,39),(5,40,49),
(6,50,59),(7,60,69),(8,70,79),(9,80,89),(10,90,100);

SELECT case when grade < 8 then 'NULL' else name end, grade, marks
FROM students, grades
WHERE marks between min_mark and max_mark
ORDER BY grade DESC, name;

+-----------------------------------------------+-------+-------+
| case when grade < 8 then 'NULL' else name end | grade | marks |
+-----------------------------------------------+-------+-------+
| Maria                                         |    10 |    99 |
| Jane                                          |     9 |    81 |
| Julia                                         |     9 |    88 |
| Scarlet                                       |     8 |    78 |
| NULL                                          |     7 |    63 |
| NULL                                          |     7 |    68 |
+-----------------------------------------------+-------+-------+




