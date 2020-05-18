/*
I have data set to look like this:-

working_hour.txt

id,working_hour
1005,2019-10-23 08:35:00
1006,2019-10-23 00:54:59
1007,2019-10-23 00:24:57
1008,2019-10-23 06:40:00
1009,2019-10-23 03:50:00
1010,2019-10-23 03:25:01
1005,2019-10-24 05:25:00
1006,2019-10-24 01:39:59
1007,2019-10-24 02:30:00
1008,2019-10-24 09:45:01
1009,2019-10-24 02:10:00
1010,2019-10-24 07:00:00

These are two days data set(23/10/2019 and 24/10/2019).
I want ro find the avg working hours(in hours or min) for each Id.

Like:-

 Id    in_hour  in_min
1005     7       420
1006    1.29    77.4835
*/

CREATE TABLE working_hour(
 id INT,
 working_hour TIMESTAMP
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/training/files_2/working_hour.txt' INTO TABLE working_hour;

WITH t AS(
SELECT id, working_hour, LEAD(working_hour) OVER(PARTITION BY id ORDER BY working_hour) AS nextDay
FROM working_hour
) SELECT id, working_hour, nextDay,
         ROUND((unix_timestamp(nextDay) - unix_timestamp(working_hour)) / 2, 2) AS in_secs, --AVG in seconds
         ROUND((unix_timestamp(nextDay) - unix_timestamp(working_hour)) / 60 / 2,2) AS in_mins, --AVG in minutes
         ROUND((unix_timestamp(nextDay) - unix_timestamp(working_hour)) / 60 / 60 / 2,2) AS in_hours --AVG in hours
FROM t
WHERE nextDay IS NOT NULL;

/*
output
+-------+------------------------+------------------------+----------+----------+-----------+--+
|  id   |      working_hour      |        nextday         | in_secs  | in_mins  | in_hours  |
+-------+------------------------+------------------------+----------+----------+-----------+--+
| 1005  | 2019-10-23 08:35:00.0  | 2019-10-24 05:25:00.0  | 37500.0  | 625.0    | 10.42     |
| 1006  | 2019-10-23 00:54:59.0  | 2019-10-24 01:39:59.0  | 44550.0  | 742.5    | 12.38     |
| 1007  | 2019-10-23 00:24:57.0  | 2019-10-24 02:30:00.0  | 46951.5  | 782.53   | 13.04     |
| 1008  | 2019-10-23 06:40:00.0  | 2019-10-24 09:45:01.0  | 48750.5  | 812.51   | 13.54     |
| 1009  | 2019-10-23 03:50:00.0  | 2019-10-24 02:10:00.0  | 40200.0  | 670.0    | 11.17     |
| 1010  | 2019-10-23 03:25:01.0  | 2019-10-24 07:00:00.0  | 49649.5  | 827.49   | 13.79     |
+-------+------------------------+------------------------+----------+----------+-----------+--+
*/