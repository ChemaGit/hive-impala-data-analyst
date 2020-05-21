/*
I have a logs table. look like this:-

user_name,idle_hours,working_hours,start_time,stop_time
sahil24c@gmail.com,2019-10-24 05:05:00,2019-10-24 05:50:00,2019-10-24 08:30:02,2019-10-24 19:25:02
magadum@gmail.com,2019-10-24 02:15:00,2019-10-24 08:39:59,2019-10-24 08:30:02,2019-10-24 19:25:01
yathink3@gmail.com,2019-10-24 01:30:00,2019-10-24 09:24:59,2019-10-24 08:30:02,2019-10-24 19:25:01
shelkeva@gmail.com,2019-10-24 00:30:00,2019-10-24 09:10:01,2019-10-24 08:45:01,2019-10-24 18:25:02
puruissim@gmail.com,2019-10-24 03:15:00,2019-10-24 07:19:59,2019-10-24 08:50:02,2019-10-24 19:25:01
sangita.awa@gmail.com,2019-10-24 01:55:00,2019-10-24 08:40:00,2019-10-24 08:50:01,2019-10-24 19:25:01
vaishusawan@gmail.com,2019-10-24 00:35:00,2019-10-24 09:55:00,2019-10-24 08:55:01,2019-10-24 19:25:01
you@example.com,2019-10-24 02:35:00,2019-10-24 08:04:59,2019-10-24 08:45:02,2019-10-24 19:25:01
samadhanma@gmail.com,2019-10-24 01:10:00,2019-10-24 08:39:59,2019-10-24 09:00:02,2019-10-24 18:50:01

I want to find the average working hours.
to perform the following query

select * from workinglogs where unix_timestamp(working_hours) < AVG(unix_timestamp(working_hours));
*/

CREATE TABLE workinglogs(
 user_name STRING,
 idle_hours TIMESTAMP,
 working_hours TIMESTAMP,
 start_time TIMESTAMP,
 stop_time TIMESTAMP
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

LOAD DATA LOCAL INPATH '/home/training/files_2/workinglog.csv' INTO TABLE workinglogs;

WITH t AS(
SELECT ROUND(AVG(unix_timestamp(working_hours)),2) as average
FROM workinglogs)
SELECT w.user_name,w.idle_hours,w.working_hours,w.start_time,w.stop_time
FROM workinglogs AS w,t
WHERE unix_timestamp(w.working_hours) < t.average;

/*
+------------------------+------------------------+------------------------+------------------------+------------------------+--+
|      w.user_name       |      w.idle_hours      |    w.working_hours     |      w.start_time      |      w.stop_time       |
+------------------------+------------------------+------------------------+------------------------+------------------------+--+
| magadum@gmail.com      | 2019-10-24 02:15:00.0  | 2019-10-24 08:39:59.0  | 2019-10-24 08:30:02.0  | 2019-10-24 19:25:01.0  |
| puruissim@gmail.com    | 2019-10-24 03:15:00.0  | 2019-10-24 07:19:59.0  | 2019-10-24 08:50:02.0  | 2019-10-24 19:25:01.0  |
| sangita.awa@gmail.com  | 2019-10-24 01:55:00.0  | 2019-10-24 08:40:00.0  | 2019-10-24 08:50:01.0  | 2019-10-24 19:25:01.0  |
| you@example.com        | 2019-10-24 02:35:00.0  | 2019-10-24 08:04:59.0  | 2019-10-24 08:45:02.0  | 2019-10-24 19:25:01.0  |
| samadhanma@gmail.com   | 2019-10-24 01:10:00.0  | 2019-10-24 08:39:59.0  | 2019-10-24 09:00:02.0  | 2019-10-24 18:50:01.0  |
+------------------------+------------------------+------------------------+------------------------+------------------------+--+
*/