# GETTING STARTED WITH HIVE

### Overview of Hive language manual
````text
- Take a look of the Hive Documentation
````

[https://cwiki.apache.org/confluence/display/Hive/LanguageManual][Hive Language Manual Documentation]

[Hive Language Manual Documentation]: https://cwiki.apache.org/confluence/display/Hive/LanguageManual

### Launching and using Hive CLI
````text
Let us understand how to launch Hive CLI.

- Logon to the gateway node of the cluster
- Launch Hive CLI using hive
- One can get help using hive --help
- There are several services under hive (default cli).
- hive is same ashive --service cli
- To get other options of Hive CLI, we can use hive --service cli --help
- For e. g.: we can use hive --service cli --database training_retail.
- Hive CLI will be launched and will be connected to training_retail database.
````
````shell script
$ hive --help

$ hive --service cli --help

$ hive -e 'select * from retail_db.orders limit 10'

$ hive

$ hive --silent

$ hive --service cli --database training
````
### OVERVIEW OF HIVE PROPERTIES - SET AND .HIVERC
````text
Let us understand details about Hive properties which control Hive run time environment.

- Review /etc/hive/conf/hive-site.xml
- Review properties using Management Tools such as Ambari or Cloudera Manager Web UI
- Hive run time behavior is controlled by Hadoop Properties files, YARN Properties files, Hive Properties files etc.
- If same property is defined in multiple properties files, then value in hive-site.xml will take precedence.
- Properties control run time behavior
- We can get all the properties using SET; in Hive CLI

Let us review some important properties in Hive. We will also see how properties can be reviewed using Hive CLI and how to overwrite them for the entire session using .hiverc.

- hive.metastore.warehouse.dir
- mapreduce.job.reduces

- We can review the current value using SET mapreduce.job.reduces;
- We can overwrite property by setting value using the same SET command, eg: SET mapreduce.job.reduces=2;
- We can overwrite the default properties by using .hiverc. It will be executed whenever Hive CLI is launched.
````
````shell script
$ hive

hive> SET;
hive> exit;

$ hive -e "SET" > hive_properties

$ hive
hive> set hive.execution.engine;

hive> set hive.execution.engine=tez;
hive> exit;

$ hive --hiveconf hive.execution.engine=tez
hive> SET hive.execution.engine;
hive> exit;

$ cd cd /usr/lib/hive/conf
$ view hive-site.xml
/hive.execution.engine
````
