/*
Julia asked her students to create some coding challenges.
Write a query to print the hacker_id, name, and the total number of challenges created by each student.
Sort your results by the total number of challenges in descending order.
If more than one student created the same number of challenges,
then sort the result by hacker_id.
If more than one student created the same number of challenges
and the count is less than the maximum number of challenges created,
then exclude those students from the result.

Input Format

The following tables contain challenge data:

Hackers: The hacker_id is the id of the hacker, and name is the name of the hacker.

CREATE TABLE Hackers(
  hacker_id INTEGER,
  name VARCHAR(16)
);

Challenges: The challenge_id is the id of the challenge, and hacker_id is the id of the student who created the challenge.

CREATE TABLE Challenges(
  challenge_id INTEGER,
  hacker_id INTEGER
);


Sample Input 0

INSERT INTO Hackers VALUES(5077,'Rose'),(21283,'Angela'),(62743,'Frank'),(88255,'Patrick'),(96196,'Lisa');

INSERT INTO Challenges VALUES(61654,5077),(58302,21283),(40587,88255),(29477,5077),(1220,21283),(69514,21283),(46561,62743),(58077,62743),(18483,88255),(76766,21283),
(52382,5077),(74467,21283),(33625,96196),(26053,88255),(42665,62743),(12859,62743),(70094,21283),(34599,88255),(54680,88255),(61881,5077);

Sample Output 0

21283 Angela 6
88255 Patrick 5
96196 Lisa 1

Sample Input 1

INSERT INTO Hackers VALUES(12299,'Rose'),(34856,'Angela'),(79345,'Frank'),(80491,'Patrick'),(81041,'Lisa');

INSERT INTO Challenges VALUES(63963,81041),(63117,79345),(28225,34856),(21989,12299),(4653,12299),(70070,79345),(36905,34856),(61136,80491),(17234,12299),(80308,79345),
(40510,34856),(79820,80491),(22720,12299),(21394,12299),(36261,34856),(15334,12299),(71435,79345),(23157,34856),(54102,34856),(69065,80491);

Sample Output 1

12299 Rose 6
34856 Angela 6
79345 Frank 4
80491 Patrick 3
81041 Lisa 1


Explanation

For Sample Case 0, we can get the following details:

hacker_id	name	challenges_created

Students 5077 and 62743 both created 4 challenges, but the maximum number of challenges created is 6 so these students are excluded from the result.

For Sample Case 1, we can get the following details:

hacker_id	name	challenges_created

Students 12299 and 34856 both created 6 challenges. Because 6 is the maximum number of challenges created, these students are included in the result.
*/

CREATE TABLE Hackers(
  hacker_id INTEGER,
  name VARCHAR(16)
);

CREATE TABLE Challenges(
  challenge_id INTEGER,
  hacker_id INTEGER
);

INSERT INTO Hackers VALUES(5077,'Rose'),(21283,'Angela'),(62743,'Frank'),(88255,'Patrick'),(96196,'Lisa');

INSERT INTO Challenges VALUES(61654,5077),(58302,21283),(40587,88255),(29477,5077),(1220,21283),(69514,21283),(46561,62743),(58077,62743),(18483,88255),(76766,21283),
(52382,5077),(74467,21283),(33625,96196),(26053,88255),(42665,62743),(12859,62743),(70094,21283),(34599,88255),(54680,88255),(61881,5077);

/*
Julia asked her students to create some coding challenges.
Write a query to print the hacker_id, name, and the total number of challenges created by each student.
Sort your results by the total number of challenges in descending order.
If more than one student created the same number of challenges,
then sort the result by hacker_id.
If more than one student created the same number of challenges
and the count is less than the maximum number of challenges created,
then exclude those students from the result.
*/

SET @max_challenges = (SELECT MAX(total) FROM(
SELECT c.hacker_id, name,COUNT(c.challenge_id) AS total
FROM Hackers h
JOIN Challenges c ON(h.hacker_id = c.hacker_id)
GROUP BY c.hacker_id, name) t);

SELECT p.hacker_id, p.name, p.total
FROM (SELECT c.hacker_id, name,COUNT(c.challenge_id) AS total
FROM Hackers h
JOIN Challenges c ON(h.hacker_id = c.hacker_id)
GROUP BY c.hacker_id, name
ORDER BY total DESC, c.hacker_id) p
JOIN (SELECT total, COUNT(total) AS num
FROM(
SELECT c.hacker_id, name,COUNT(c.challenge_id) AS total
FROM Hackers h
JOIN Challenges c ON(h.hacker_id = c.hacker_id)
GROUP BY c.hacker_id, name) t
GROUP BY total)j ON(j.total = p.total)
WHERE j.num = 1 OR (j.num > 1 AND p.total = @max_challenges)
ORDER BY p.total DESC, p.hacker_id;

/*
21283 Angela 6
88255 Patrick 5
96196 Lisa 1
*/