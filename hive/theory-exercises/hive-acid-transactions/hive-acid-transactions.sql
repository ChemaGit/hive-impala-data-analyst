/*
# Hive ACID Transactions to Insert, Update and Delete Data

Let us understand Hive ACID Transactions to Insert, Update and Delete Data. We will also understand pre-requisites and limitations of ACID Transactions in Hive.

You can review this article:

https://www.cloudera.com/tutorials/using-hive-acid-transactions-to-insert-update-and-delete-data/.html#operational-tools-for-acid

for more information on Hive Transactions.

Pre -Requisites

Hive Transactions Manager should be set to DbTxnManager SET hive.txn.manager=org.apache.hadoop.hive.ql.lockmgr.DbTxnManager;
We need to enable concurrency SET hive.support.concurrency=true;
Once we set the above properties, we should be able to insert data into any table.
For updates and deletes, table should be bucketed and file format need to be ORC or any ACID Compliant Format.
We also need to set table property transactions to true TBLPROPERTIES ('transactional'='true');

# REVIEW PROPERTIES
$ cd /etc/hive/conf
$ grep -i txn hive-site.xml

$ hive -e "SET;" | grep -i txn

$ beeline -u jdbc:hive2://localhost:10000/training_retail
*/

SET hive.txn.manager;
hive.txn.manager=org.apache.hadoop.hive.ql.lockmgr.DummyTxnManager;

SET hive.txn.manager=org.apache.hadoop.hive.ql.lockmgr.DbTxnManager;

SET hive.support.concurrency=true;

SET hive.enforce.bucketing;
SET hive.enforce.bucketing=true;

SET hive.exec.dynamic.partition.mode;
hive.exec.dynamic.partition.mode=strict

SET hive.exec.dynamic.partition.mode=nonstrict;

SET hive.compactor.initiator.on;
SET hive.compactor.initiator.on=true;
-- A positive number
SET hive.compactor.worker.threads;
SET hive.compactor.worker.threads=1;

CREATE TABLE orders_transactional (
  order_id INT,
  order_date STRING,
  order_customer_id INT,
  order_status STRING
) CLUSTERED BY (order_id) INTO 8 BUCKETS
STORED AS ORC
TBLPROPERTIES("transactional"="true");

INSERT INTO orders_transactional VALUES
(1, '2013-07-25 00:00:00.0', 1000, 'COMPLETE');

INSERT INTO orders_transactional VALUES
(2, '2013-07-25 00:00:00.0', 2001, 'CLOSED'),
(3, '2013-07-25 00:00:00.0', 1500, 'PENDING'),
(4, '2013-07-25 00:00:00.0', 2041, 'PENDING'),
(5, '2013-07-25 00:00:00.0', 2031, 'COMPLETE');

UPDATE orders_transactional
  SET order_status = 'COMPLETE'
WHERE order_status = 'PENDING';

DELETE FROM orders_transactional
WHERE order_status <> 'COMPLETE';

SELECT *
FROM orders_transactional;