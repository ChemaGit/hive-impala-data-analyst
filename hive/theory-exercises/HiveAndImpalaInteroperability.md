## APACHE HIVE AND APACHE IMPALA INTEROPERABILITY

### HIVE AND IMPALA INTEROPERABILITY
````text
- Some expressions works in HIVE but not in IMPALA

ALTER TABLE employees CHANGE salary salary INT AFTER office_id;
CREATE EXTERNAL TABLE ALTER default.investors (name STRING, amount INT, share DECIMAL(4,3))
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde';

- Some expressions works in IMPALA but not in HIVE

ALTER TABLE employees DROP COLUMN office_id;
CREATE TABLE ...... LIKE PARQUET;
````
### IMPALA METADATA REFRESH
````
- External Metadata Change
1) Table schema modified or new data added to a table: REFRESH tablename;
    * Reloads the metadata for one table immediately; reloads storage block locations for new data files only.

2) New table added, or data in table extensively altered, such as by HDFS balancing: INVALIDATE METADATA tablename;
    * Marks the metadata for a single table as state; when the metadata is needed, all storage block locations are retrieved.

3) Caution: INVALIDATE METADATA;	with no table name affects all users.
    - Marks the entire cache as stale, to be rebuilt completely when needed
    - Can be time-consuming with large tables or lots of tables
    - Use only when needed

'/user/hive/warehouse/mydatabase.db'
````
