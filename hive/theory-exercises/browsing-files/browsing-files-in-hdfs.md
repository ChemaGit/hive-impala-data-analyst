### BROWSING HDFS FROM THE COMMAND LINE
````text
- Hive warehouse directory
  - The directory in HDFS where Hive and Impala store table data by default
  - Typically /user/hive/warehouse
````
````shell script
$ hdfs dfs -ls /user/hive/warehouse/
$ hdfs dfs -ls /user/hive/warehouse/orders/
$ hdfs dfs -cat /user/hive/warehouse/orders/orders.txt
$ hdfs dfs -get /user/hive/warehouse/orders/orders.txt /home/training

$ ls /home/training
$ cat /home/training/orders.txt


$ hadoop fs -ls /user/hive/warehouse
$ hdfs dfs -help <command>
$ hdfs dfs -help <ls>
````
