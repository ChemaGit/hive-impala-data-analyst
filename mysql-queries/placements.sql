/*
You are given three tables: Students, Friends and Packages.
Students contains two columns: ID and Name.
Friends contains two columns: ID and Friend_ID (ID of the ONLY best friend).
Packages contains two columns: ID and Salary (offered salary in $ thousands per month).

CREATE TABLE Students(
  ID INT,
  Name VARCHAR(16)
);

CREATE TABLE Friends(
  ID INT
  Friend_ID INT
);

CREATE TABLE Packages(
  ID INT,
  Salary FLOAT
);

Write a query to output the names of those students whose
best friends got offered a higher salary than them.
Names must be ordered by the salary amount offered to the best friends.
It is guaranteed that no two students got same salary offer.

Sample Input

INSERT INTO Students VALUES(1,'Ashley'),(2, 'Samantha'),(3, 'Julia'),(4, 'Scarlet');
INSERT INTO Friends VALUES(1, 2),(2, 3),(3, 4),(4, 1);
INSERT INTO Packages VALUES(1,15.20),(2, 10.06),(3, 11.55),(4, 12.12);

Sample Output

Samantha
Julia
Scarlet

Explanation

See the following table:

ID              1           2           3       4
Name            Ashley      Samantha    Julia   Scarlet
Salary          15.20       10.06       11.55   12.12
Friend_ID       2           3           4       1
Friend Salary   10.06       11.55       12.12   15.20

Now,
    - Samantha's best friend got offered a higher salary than her at 11.55
    - Julia's best friend got offered a higher salary than her at 12.12
    - Scarlet's best friend got offered a higher salary than her at 15.2
    - Ashley's best friend did NOT get offered a higher salary than her

The name output, when ordered by the salary offered to their friends, will be:
    - Samantha
    - Julia
    - Scarlet
*/

SELECT name FROM(
SELECT s.id, name,p.salary, f.friend_id, pp.salary
FROM Students s
JOIN Friends f ON(s.id = f.id)
JOIN Packages p ON(f.id = p.id)
JOIN Packages pp ON(f.friend_id = pp.id)
WHERE pp.salary > p.salary
ORDER BY pp.salary) aux;




