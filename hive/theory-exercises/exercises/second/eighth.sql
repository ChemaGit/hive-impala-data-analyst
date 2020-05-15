/*
I have the following data set

color_code   fav_color_code    color_code_name    fav_color_name
1|2            5                blue|white           black
3|4            7|9              green|red           pink|yellow
I need to join first value of color_code to first value of color_code_name and second value of color_code to second value of color_code_name etc..

code                color
1                    blue
2                    white
5                     black
3                     green
4                      red
7                      pink
9                     yellow
*/

CREATE TABLE colors(
color_code STRING,
fav_color_code STRING,
color_code_name STRING,
fav_color_name STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/training/files_2/colors.csv' INTO TABLE colors;

SELECT CONCAT(color_code,'|', fav_color_code) AS id_color, CONCAT(color_code_name, '|', fav_color_name) AS color
FROM colors;
/*
+-----------+------------------------+--+
| id_color  |          color           |
+-----------+------------------------+--+
| 1|2|5     | blue|white|black       |
| 3|4|7|9   | green|red|pink|yellow  |
+-----------+------------------------+--+
*/
CREATE TABLE tc1 AS
SELECT ROW_NUMBER() OVER() AS rownum, CAST(color_id AS INT) as color_id
FROM colors
LATERAL VIEW EXPLODE(SPLIT(CONCAT(color_code,'|', fav_color_code),'\\|')) a1 AS color_id;

CREATE TABLE tc2 AS
SELECT ROW_NUMBER() OVER() AS rownum, color_name
FROM colors
LATERAL VIEW EXPLODE(SPLIT(CONCAT(color_code_name,'|', fav_color_name),'\\|')) a1 AS color_name;

SELECT color_id, color_name
FROM tc1
JOIN tc2 ON(tc1.rownum = tc2.rownum)
ORDER BY color_id;
/*
+-----------+-------------+--+
| color_id  | color_name  |
+-----------+-------------+--+
| 1         | blue        |
| 2         | white       |
| 3         | green       |
| 4         | red         |
| 5         | black       |
| 7         | pink        |
| 9         | yellow      |
+-----------+-------------+--+
*/