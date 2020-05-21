/*
You have been given below patient data information in a file called patient.csv

First Name|Last Name|Address|Mobile|Phone|ZipCode
Amit|Jain|A-646, Cheru Nagar, Chennai|999999999|98989898|600020
Sumit|Saxena|D-100, Connaught Place, Delhi|1111111111|82828282|110001
Ajit|Chaube|M-101, Dwarka puri, Jaipur|2222222222|32323232|302016
Ramu|Mishra|P-101,Ahiyapur, Patna|4444444444|12121212|801108

Please accomplish following activities
1. Load this csv file in hdfs.
2. Create database in Hive named as "PatientInfo"
3. Create a Hive table in following format name PatientDetail

Name &amp;lt; First Name, Last Name>
Address&amp;lt; HouseNo, LocalityName, City, Zip>
Phone &amp;lt; Mobile,Landline>

4. Make sure hive table store data in a Sequence File format.
5. Location of data , file created should be
/user/hive/warehouse/patient_info.db/patient_detail/

$ hdfs dfs -put CCA159DataAnalyst/data/files/patient.csv /public/files/

$ beeline -u jdbc:hive2://localhost:10000/
*/

CREATE DATABASE patient_info;
USE patient_info;

CREATE TABLE patient_stage(
 fname STRING,
 lname STRING,
 address STRUCT<house_no: STRING, town: STRING, city: STRING>,
 mobile STRING,
 phone STRING,
 zip_code STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
COLLECTION ITEMS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/training/CCA159DataAnalyst/data/files/patient.csv' INTO TABLE patient_stage;

SELECT fname, lname, address.house_no,address.town,address.city,mobile,zip_code,phone
FROM patient_stage;

CREATE TABLE patient_detail(
 name STRUCT<first_name: STRING, last_name: STRING>,
 address STRUCT<house_no: STRING, locality_name: STRING, city: STRING, zip: STRING>,
 phone STRUCT<mobile: STRING, landline: STRING>
) STORED AS SEQUENCEFILE;

INSERT INTO TABLE patient_detail
SELECT named_struct('first_name',fname,'last_name',lname),
       named_struct('house_no',address.house_no,'locality_name',address.town,'city',address.city,'zip',zip_code),
       named_struct('mobile',mobile,'landline',phone)
FROM patient_stage;