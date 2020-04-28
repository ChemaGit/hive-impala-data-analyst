## BROWSING FILES IN S3

### UNDERSTANDING S3 AND OTHER CLOUD STORAGE PLATFORMS

### USING S3 BUCKETS FROM THE COMMAND LINE
````shell script
$ hdfs dfs -ls /user/hive/warehouse/
$ hdfs dfs -ls s3a://training-bucket/

$ hdfs dfs -ls s3a://training-bucket/employees
$ hdfs dfs -cat s3a://training-bucket/employees/employees.csv

$ hdfs dfs -get s3a://training-bucket/employees/employees.csv /home/training/files
````
### AWS CLI
````shell script
$ aws s3 ls s3://training-coursera1/
````
### PRE => means DIRECTORIES
````shell script
$ aws s3 ls s3://training-bucket/
                           PRE employees/
                           PRE jobs/
                           PRE months/

$ aws s3 cp s3://training-coursera1/jobs/jobs.txt /home/training/files/
````
### to read the content in S3 files, we put a dash at the end of the line with a cp command
````shell script
$ aws s3 cp s3://training-coursera1/jobs/jobs.txt -
````