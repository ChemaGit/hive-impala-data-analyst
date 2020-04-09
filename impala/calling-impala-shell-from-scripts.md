### CALLING IMPALA SHELL FROM SCRIPTS
````text
- Create email_results.sh, replacing the email address with your own
- Run the chmod command
- Run the script
- Note: Whether the email is sent depends on your configurations
- When invoking commands in a script:
	- Enter the commands as you would in the command line
		- Whether for Beeline or Impala Shell
	- Use Linux commands to process results

- email_results.sh
````
````shell script
#!/bin/bash
impala-shell \
--quiet \
--delimited \
--output_delimiter=',' \
--print_header \
-q 'SELECT * FROM fly.flights WHERE air_time = 0 LIMIT 20;' \
-o /home/training/assigments/UsingHiveAndImpalaInScriptsApplications/zero_air_time.csv
mail \
-a /home/training/assigments/UsingHiveAndImpalaInScriptsApplications/zero_air_time.csv \
-s 'Flights with zero air_time' \
my_email@gmail.com \
<<< 'Do you know why air_time is zero in these rows?'
````
````text
$ chmod 755 /home/training/assigments/UsingHiveAndImpalaInScriptsApplications/email_results.sh
$ cd /home/training/assigments/UsingHiveAndImpalaInScriptsApplications/
$ ./email_results.sh
````

### QUERYING IMPALA IN SCRIPTS AND APPLICATIONS
````shell script
# ODBC
# JDBC
# Apache THRIFT

# Example in Python code

from impala.dbapi import connect
conn = connect(host='localhost', port=21050)
cursor = conn.cursor()
cursor.execute('SELECT * FROM fun.games')
results = cursor.fetchall()
for row in results:
	print row
````