/*
QUERY EXAMPLE - GET WORD COUNT

Let us see how we can perform word count using Hive QL.

    Create table by name wordcount.
    Insert data into the table.
*/

CREATE TABLE wordcount (s STRING);

INSERT INTO wordcount VALUES
  ('Hello World'),
  ('How are you'),
  ('Let us perform the word count'),
  ('The definition of word count is'),
  ('to get the count of each word from this data');

Now let us develop the logic to get the word count.

    Split the lines into array of words
    Explode them into records

SELECT split(s, ' ') FROM wordcount;
SELECT explode(split(s, ' ')) FROM wordcount;

-- Let us come up with the query to get word count.
-- We need to use nested subquery to get the count.
-- We will understand more about queries and nested queries later.

SELECT word, count(1) FROM (
  SELECT explode(split(s, ' ')) AS word FROM wordcount
) q
GROUP BY word;