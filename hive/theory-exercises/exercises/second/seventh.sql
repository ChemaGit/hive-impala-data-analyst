/*

I have a hive table called bikeshare_trips with the following schema

+---------------------+------------+----------------------------------------------------+--+
|      col_name       | data_type  |                      comment                       |
+---------------------+------------+----------------------------------------------------+--+
| trip_id             | int        | Numeric ID of bike trip                            |
| duration_sec        | int        | Time of trip in seconds                            |
| start_date          | string     | Start date of trip with date and time, in PST      |
| start_station_name  | string     | Station name of start station                      |
| start_station_id    | int        | Numeric reference for start station                |
| end_date            | string     | End date of trip with date and time, in PST        |
| end_station_name    | string     | Station name for end station                       |
| end_station_id      | int        | Numeric reference for end station                  |
| bike_number         | int        | ID of bike used                                    |
| zip_code            | string     | Home zip code of subscriber (customers can choose to manually enter zip at kiosk however data is unreliable) |
| subscriber_type     | string     | Subscriber can be annual or 30-day member, Customer can be 24-hour or 3-day member |
+---------------------+------------+----------------------------------------------------+--+

and some data example

944732	2618	09/24/2015 17:22:00	Mezes	83	09/24/2015 18:06:00	Mezes	83	653	94063	Customer
984595	5957	09/24/2015 18:12:00	Mezes	83	10/25/2015 19:51:00	Mezes	83	52	nil	Customer
984596	5913	09/24/2015 18:13:00	Mezes	83	10/25/2015 19:51:00	Mezes	83	121	nil	Customer
1129385	6079	09/24/2015 10:33:00	Mezes	83	03/18/2016 12:14:00	Mezes	83	208	94070	Customer
1030383	5780	2015-09-30 10:52:00	Mezes	83	12/06/2015 12:28:00	Mezes	83	44	94064	Customer
1102641	801	02/23/2016 12:25:00	Mezes	83	02/23/2016 12:39:00	Mezes	83	174	93292	Customer
969490	255	2015-09-30 19:02:00	Mezes	83	10/13/2015 19:07:00	Mezes	83	650	94063	Subscriber
1129386	6032	03/18/2016 10:33:00	Mezes	83	03/18/2016 12:13:00	Mezes	83	155	94070	Customer
947105	1008	2015-09-30 12:57:00	Mezes	83	09/26/2015 13:13:00	Mezes	83	157	94063	Subscriber
1011650	60	11/16/2015 18:54:00	Mezes	83	11/16/2015 18:55:00	Mezes	83	35	94124	Subscriber

Each row of the table corresponds to a different bike trip, and I want to calculate the cumulative number of trips for each date in 2015.

the expected output would be

trip_date               num_trips                cumulative_trips
2015-09-24              4                        4
2015-09-30              3                        7
2015-11-16              1                        8

I'm trying this using analytic function and subqueries, but I don't get it, any help would be appreciate, thanks in advance

*/

CREATE TABLE bikeshare_trips (
  trip_id INT COMMENT 'Numeric ID of bike trip',
  duration_sec INT COMMENT 'Time of trip in seconds',
  start_date STRING COMMENT 'Start date of trip with date and time, in PST',
  start_station_name STRING COMMENT 'Station name of start station',
  start_station_id INT COMMENT 'Numeric reference for start station',
  end_date STRING COMMENT 'End date of trip with date and time, in PST',
  end_station_name STRING COMMENT 'Station name for end station',
  end_station_id INT COMMENT 'Numeric reference for end station',
  bike_number INT COMMENT 'ID of bike used',
  zip_code STRING COMMENT 'Home zip code of subscriber (customers can choose to manually enter zip at kiosk however data is unreliable)',
  subscriber_type STRING COMMENT 'Subscriber can be annual or 30-day member, Customer can be 24-hour or 3-day member')
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/training/files_2/bikeshare_trips.csv' INTO TABLE bikeshare_trips;

WITH trips_by_day AS
                  (
                  SELECT TO_DATE(FROM_UNIXTIME(UNIX_TIMESTAMP(start_date,'MM/dd/yyyy HH:mm:ss'))) AS trip_date,
                      COUNT(*) as num_trips
                  FROM bikeshare_trips
                  WHERE YEAR(FROM_UNIXTIME(UNIX_TIMESTAMP(start_date,"MM/dd/yyyy HH:mm"))) = 2015
                  GROUP BY TO_DATE(FROM_UNIXTIME(UNIX_TIMESTAMP(start_date,'MM/dd/yyyy HH:mm:ss')))
                  )
                  SELECT *,
                      SUM(num_trips)
                          OVER (
                               ORDER BY trip_date
                               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                               ) AS cumulative_trips
                      FROM trips_by_day
                      ORDER BY num_trips DESC;

-- another solution

select trip_date, num_trips, sum(cnt) over (order by trip_date) as cumulative_trips
from (select TO_DATE(FROM_UNIXTIME(UNIX_TIMESTAMP(start_date,'MM/dd/yyyy HH:mm:ss'))) as trip_date, count(*) as cnt
      from bikeshare_trips
      WHERE YEAR(FROM_UNIXTIME(UNIX_TIMESTAMP(start_date,"MM/dd/yyyy HH:mm"))) = 2015
      group by TO_DATE(FROM_UNIXTIME(UNIX_TIMESTAMP(start_date,'MM/dd/yyyy HH:mm:ss')))
     ) b
order by trip_date;