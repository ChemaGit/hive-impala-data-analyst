/*
Julia conducted a 15 days of learning SQL contest.
The start date of the contest was March 01, 2016 and the end date was March 15, 2016.

Write a query to print total number of unique hackers who made at least 1
submission each day (starting on the first day of the contest), and find the hacker_id
and name of the hacker who made maximum number of submissions each day.
If more than one such hacker has a maximum number of submissions, print the lowest hacker_id.
The query should print this information for each day of the contest, sorted by the date.

Input Format

The following tables hold contest data:

- Hackers: The hacker_id is the id of the hacker, and name is the name of the hacker.

CREATE TABLE Hackers(
  hacker_id INTEGER,
  name VARCHAR(16)
);

- Submissions: The submission_date is the date of the submission,
submission_id is the id of the submission, hacker_id is
the id of the hacker who made the submission, and score is the score of the submission.

CREATE TABLE Submissions(
  submission_date DATE,
  submission_id INTEGER,
  hacker_id INTEGER,
  score INTEGER
);

Sample Input

For the following sample input, assume that the end date of the contest was March 06, 2016.

- Hackers Table:

INSERT INTO Hackers VALUES(15758,'Rose'),(20703,'Angela'),(36396,'Frank'),(38289,'Patrick'),
(44065,'Lisa'),(53473,'Kimberly'),(62529,'Bonnie'),(79722,'Michael');

- Submissions Table:

INSERT INTO Submissions VALUES('2016-03-01',8494,20703,0),('2016-03-01',22403,53473,15),('2016-03-01',23965,79722,60),('2016-03-01',30173,36396,70),
('2016-03-02',34928,20703,0),('2016-03-02',38740,15758,60),('2016-03-02',42769,79722,25),('2016-03-02',44364,79722,60),
('2016-03-03',45440,20703,0),('2016-03-03',49050,36396,70),('2016-03-03',50273,79722,5),
('2016-03-04',50344,20703,0),('2016-03-04',51360,44065,90),('2016-03-04',54404,53473,65),('2016-03-04',61533,79722,45),
('2016-03-05',72852,20703,0),('2016-03-05',74546,38289,0),('2016-03-05',76487,62529,0),('2016-03-05',82439,36396,10),('2016-03-05',90006,36396,40),
('2016-03-06',90404,20703,0);

Sample Output

2016-03-01 4 20703 Angela
2016-03-02 2 79722 Michael
2016-03-03 2 20703 Angela
2016-03-04 2 20703 Angela
2016-03-05 1 36396 Frank
2016-03-06 1 20703 Angela

Explanation

On March 01, 2016 hackers 20703, 36396, 53473, and 79722 made submissions.
There are 4 unique hackers who made at least one submission each day.
As each hacker made one submission, 20703 is considered to be the hacker
who made maximum number of submissions on this day. The name of the hacker is Angela.

On March 02, 2016 hackers 15758, 20703 and 79722 made submissions.
Now 20703 and 79722 were the only ones to submit every day, so there are 2 unique hackers
who made at least one submission each day. 79722 made 2 submissions, and name of the hacker is Michael.

On March 03, 2016 hackers 20703, 36396, and 79722 made submissions.
Now 20703 and 79722 were the only ones, so there are 2 unique hackers who made at least one submission each day.
As each hacker made one submission so 20703 is considered to be the hacker who made maximum number of submissions on this day.
The name of the hacker is Angela.

On March 04, 2016 hackers 20703, 44065, 53473, and 79722 made submissions.
Now 20703 and 79722 only submitted each day, so there are 2 unique hackers who made at least one submission each day.
As each hacker made one submission so 20703 is considered to be the hacker who made maximum number of submissions on this day.
The name of the hacker is Angela.

On March 05, 2016 hackers 20703, 36396, 38289 and 62529 made submissions.
Now 20703 only submitted each day, so there is only 1 unique hacker who made at least one submission each day.
36396 made 2 submissions and name of the hacker is Frank.

On March 06, 2016 only 20703 made submission, so there is only 1 unique hacker who made at least one submission each day.
20703 made 1 submission and name of the hacker is Angela.
*/

SELECT submission_date,
(SELECT COUNT(DISTINCT hacker_id)
 FROM Submissions sub2
 WHERE sub2.submission_date = sub1.submission_date AND (SELECT COUNT(DISTINCT sub3.submission_date) FROM Submissions sub3 WHERE sub3.hacker_id = sub2.hacker_id AND sub3.submission_date < sub1.submission_date) = DATEDIFF(sub1.submission_date , '2016-03-01')) AS cont,
(SELECT hacker_id  FROM Submissions sub2 WHERE sub2.submission_date = sub1.submission_date
GROUP BY hacker_id ORDER BY count(submission_id) DESC , hacker_id LIMIT 1) AS id_hacker,
(SELECT name FROM Hackers WHERE hacker_id = id_hacker) AS name
FROM (SELECT DISTINCT submission_date FROM Submissions) sub1
GROUP BY submission_date;