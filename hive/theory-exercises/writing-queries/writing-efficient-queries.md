## Writing Efficient Queries

````text
Sometimes it doesn't matter whether your query is efficient or not. 
For example, you might write a query you expect to run only once, and it might be working on a small dataset. 
In this case, anything that gives you the answer you need will do.

But what about queries that will be run many times, like a query that feeds data to a website? 
Those need to be efficient so you don't leave users waiting for your website to load.

Or what about queries on huge datasets? 
These can be slow and cost a business a lot of money if they are written poorly.

Most database systems have a query optimizer that attempts to interpret/execute 
your query in the most effective way possible. 
But several strategies can still yield huge savings in many cases.
````

## Strategies

### 1) Only select the columns you want.
````text
It is tempting to start queries with SELECT * FROM .... 
It's convenient because you don't need to think about which columns you need. 
But it can be very inefficient.

This is especially important if there are text fields that you don't need, 
because text fields tend to be larger than other fields.

SELECT * FROM bigquery-public-data.github_repos.contents;

Data processed: 2471.537 GB

SELECT size, binary FROM bigquery-public-data.github_repos.contents;

Data processed: 2.371 GB

In this case, we see a 1000X reduction in data being scanned to complete the query,
because the raw data contained a text field that was 1000X larger than the fields we might need.
````

### 2) Read less data.
````text
Both queries below calculate the average duration (in seconds) of one-way bike trips in the city of San Francisco.

SELECT MIN(start_station_name) AS start_station_name,
  MIN(end_station_name) AS end_station_name,
  AVG(duration_sec) AS avg_duration_sec
FROM bigquery-public-data.san_francisco.bikeshare_trips
WHERE start_station_id != end_station_id 
GROUP BY start_station_id, end_station_id
LIMIT 10;
Data processed: 0.076 GB


SELECT start_station_name,
  end_station_name,
  AVG(duration_sec) AS avg_duration_sec                  
FROM bigquery-public-data.san_francisco.bikeshare_trips
WHERE start_station_name != end_station_name
GROUP BY start_station_name, end_station_name
LIMIT 10

Data processed: 0.06 GB

Since there is a 1:1 relationship between the station ID and the station name, 
we don't need to use the start_station_id and end_station_id columns in the query. 
By using only the columns with the station IDs, we scan less data.
````

### 3) Avoid N:N JOINs
````text
- 1:1 JOINs. 
  In this case, each row in each table has at most one match in the other table.

- N:1 JOIN. 
  Here, each row in one table matches potentially many rows in the other table.

- N:N JOIN 
  is one where a group of rows in one table can match a group of rows in the other table. 
  Note that in general, all other things equal, this type of JOIN produces a table 
  with many more rows than either of the two (original) tables that are being JOINed.

- Both examples below count the number of distinct committers and the number of files 
  in several GitHub repositories.

SELECT repo,
 COUNT(DISTINCT c.committer.name) as num_committers,
 COUNT(DISTINCT f.id) AS num_files
FROM `bigquery-public-data.github_repos.commits` AS c,
 UNNEST(c.repo_name) AS repo
INNER JOIN `bigquery-public-data.github_repos.files` AS f
 ON f.repo_name = repo
WHERE f.repo_name IN ( 'tensorflow/tensorflow', 'facebook/react', 'twbs/bootstrap', 'apple/swift', 'Microsoft/vscode', 'torvalds/linux')
GROUP BY repo
ORDER BY repo

Time to run: 7.192 seconds

WITH commits AS
(
SELECT COUNT(DISTINCT committer.name) AS num_committers, repo
FROM `bigquery-public-data.github_repos.commits`,
   UNNEST(repo_name) as repo
WHERE repo IN ( 'tensorflow/tensorflow', 'facebook/react', 'twbs/bootstrap', 'apple/swift', 'Microsoft/vscode', 'torvalds/linux')
GROUP BY repo
),
files AS 
(
SELECT COUNT(DISTINCT id) AS num_files, repo_name as repo
FROM `bigquery-public-data.github_repos.files`
WHERE repo_name IN ( 'tensorflow/tensorflow', 'facebook/react', 'twbs/bootstrap', 'apple/swift', 'Microsoft/vscode', 'torvalds/linux')
GROUP BY repo
)
SELECT commits.repo, commits.num_committers, files.num_files
FROM commits 
INNER JOIN files
   ON commits.repo = files.repo
ORDER BY repo

Time to run: 5.245 seconds

The first query has a large N:N JOIN. By rewriting the query to decrease the size of the JOIN, we see it runs much faster.
````