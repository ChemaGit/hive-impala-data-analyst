/*
I need to create a database normalizing some data I imported from a a csv file.
The import table (Table ImportA from now on) contains all the data from the model, such as: apartment_url, apartment_name, monthly_price, weekly_price, street, country, etc.

In this model, according to the imported data, the tables I want to create are:
table Apartment (will store apartment_url and apartment_name), table Price (will store monthly_price and weekly_price and table Place (street, country).

The 3 tables mentioned are created like this:

Table Price

create table Price ( id serial, monthly money, weekly money, primary key (id) );

Table Place

create table Place ( id serial, street varchar(255), country varchar(255), primary key(id) );

Table Apartment

create table Apartment ( id serial, url varchar(255), name varchar(255), id_price int references Price (id), id_place int references Place (id), primary key(id) );

Example of table ImportA data:

apartment_url    apartment_name    monthly_price    weekly_price     street    country
---------------------------------------------------------------------------------------
url1,name1,10,5,a,b
url2,name2,10,5,c,d
url3,name3,10,5,a,b
url4,name4,7,3,x,y

place table

id    street     country
--------------------------

1        a          b
2        c          d
3        x          y

price table

id    monthly     weekly
--------------------------

1        10          5
2        7           3

o... how can I insert the data to table Apartment properly using tables ImportA, Place and Price?
*/

-- SOLUTION:

CREATE TABLE apartment_temp(
apartment_url STRING,
apartment_name STRING,
monthly_price INT,
weekly_price INT,
street STRING,
country STRING
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/training/files_2/apartments.csv' INTO TABLE apartment_temp;

/*
The most probable fields to promote for being a  key on ImportA table  with the sample you are showing here
would be (apartment_url, apartment_name), though there are many questions in the air, but there isn't a fact that
(apartment_url, apartment_name) is not going to repeat along the table, we want want a normalized model in third normal shape at least
and give a sequential id to the apartment table.
 we could do as follow:

First we create price table with its key, we'll have to export this key to apartmentes table as a foreing key later on
*/
CREATE TABLE price AS SELECT ROW_NUMBER() OVER(ORDER BY monthly_price, weekly_price) AS id,monthly_price, weekly_price
                      FROM apartment_temp
                      GROUP BY monthly_price, weekly_price;

-- expected output

SELECT * FROM price;
/*
+-----------+----------------------+---------------------+--+
| price.id  | price.monthly_price  | price.weekly_price  |
+-----------+----------------------+---------------------+--+
| 1         | 7                    | 3                   |
| 2         | 10                   | 5                   |
+-----------+----------------------+---------------------+--+
*/

-- Second we create place table with its key, we'll have to export this key to apartmentes table as a foreing key later on

CREATE TABLE place AS SELECT ROW_NUMBER() OVER(ORDER BY street, country) AS id, street, country
                      FROM apartment_temp
                      GROUP BY street, country;

-- expected output

SELECT * FROM place;
/*
+-----------+---------------+----------------+--+
| place.id  | place.street  | place.country  |
+-----------+---------------+----------------+--+
| 1         | a             | b              |
| 2         | c             | d              |
| 3         | x             | y              |
+-----------+---------------+----------------+--+
*/

-- Now we are ready to export the keys from price and place tables to apartment table

CREATE TABLE apartment AS
WITH ap AS(
SELECT ROW_NUMBER() OVER(ORDER BY apartment_url) AS id,
       a.apartment_url AS au,a.apartment_name AS an, a.monthly_price AS mp,
       a.weekly_price AS wp,street,country, p.id AS id_price
FROM apartment_temp AS a
JOIN price AS p ON(a.monthly_price = p.monthly_price AND a.weekly_price = p.weekly_price))
SELECT ap.id AS id,au AS apartment_url, an AS apartment_name,mp as monthly_price, wp AS weekly_price, p.street, p.country,id_price, p.id AS id_place
FROM ap
JOIN place AS p ON(ap.street = p.street AND ap.country = p.country);

-- expected output

SELECT * FROM apartment;
/*
+---------------+--------------------------+---------------------------+--------------------------+-------------------------+-------------------+--------------------+---------------------+---------------------+--+
| apartment.id  | apartment.apartment_url  | apartment.apartment_name  | apartment.monthly_price  | apartment.weekly_price  | apartment.street  | apartment.country  | apartment.id_price  | apartment.id_place  |
+---------------+--------------------------+---------------------------+--------------------------+-------------------------+-------------------+--------------------+---------------------+---------------------+--+
| 1             | url1                     | name1                     | 10                       | 5                       | a                 | b                  | 2                   | 1                   |
| 2             | url2                     | name2                     | 10                       | 5                       | c                 | d                  | 2                   | 2                   |
| 3             | url3                     | name3                     | 10                       | 5                       | a                 | b                  | 2                   | 1                   |
| 4             | url4                     | name4                     | 7                        | 3                       | x                 | y                  | 1                   | 3                   |
+---------------+--------------------------+---------------------------+--------------------------+-------------------------+-------------------+--------------------+---------------------+---------------------+--+
*/