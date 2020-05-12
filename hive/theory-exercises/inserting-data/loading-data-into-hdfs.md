## LOADING FILES INTO HDFS

### REFRESH IMPALA'S METADATA CACHE AFTER LOADING DATA
````text
impala> REFRESH table_name;
impala> REFRESH employees;

- When there is a new table
impala> INVALIDATE METADATA new_table;
impala> INVALIDATE METADATA castles;
````

### LOADING FILES INTO HDFS WITH HUE'S TABLE BROWSER
````text
- When we create a new table

impala> INVALIDATE METADATA new_table;
impala> INVALIDATE METADATA castles;

- When we load data into an existing table

impala> REFRESH table_name;
impala> REFRESH games;
````

### LOADING FILES INTO HDFS WITH HUE'S FILE BROWSER
````text
REFRESH airlines;
````

### LOADING FILES INTO HDFS FROM THE COMMAND LINE
````text
$ hdfs dfs -ls to list the contenst of a directory
$ hdfs dfs -cat to print the contents of a file to the screen
$ hdfs dfs -get to download a file from HDFS to your local system
$ hdfs dfs -put to upload a file from your local system to HDFS

$ hdfs dfs -ls /user/hive/warehouse/fun.db/games/
$ hdfs dfs -rm /user/hive/warehouse/fun.db/games/ancient_games.csv
$ hdfs dfs -ls /user/hive/warehouse/fun.db/games/
$ hdfs dfs -cp /old/games/ancient_games.csv /user/hive/warehouse/fun.db/games/
$ hdfs dfs -ls /user/hive/warehouse/fun.db/games/
$ hdfs dfs -mv to move a file into HDFS
$ hdfs dfs -rm /user/hive/warehouse/fun.db/games/*
$ hdfs dfs -put /home/training/training_material/analyst/data/*games.csv /user/hive/warehouse/fun.db/games/
$ hdfs dfs -ls /user/hive/warehouse/fun.db/games/

impala> REFRESH games;
````

### MORE ABOUT HDFS SHELL COMMANDS
````text
This reading supplies some additional information about 
HDFS and the Hadoop File System Shell that you should know. 

The -mkdir Command
One useful command is hdfs dfs -mkdir, which can be used to create one or more directories in HDFS. 
This command expects that the parent directory of the directory you are creating already exists, 
so if you want to use this command to create nested directories, 
start first by creating the highest-level parent directory, 
then create the next-level child subdirectory, and so on. 
Alternatively, you can use the -p option (short for parent) to automatically 
create any necessary parent directories of the specified directory if they do not already exist.

More HDFS Command Options
Some of the commands that you did learn about in this course can take additional 
command-line options that were not described. 
For example, when using the hdfs dfs -rm command, you can specify the -r option (short for recursive) 
to delete the specified directory and all files and subdirectories under it. The syntax is:

hdfs dfs -rm -r /path/to/directory/

Be extremely careful when using this -r option! It is easy to inadvertently 
delete a huge amount of data by misspecifying the directory path.

Full List of HDFS Shell Commands, Options, and Arguments
You can see a complete list of the Hadoop File System Shell commands and 
the options and arguments they accept on this web page: 

[https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/FileSystemShell.html][hdfs command line]

Many of these you will never need to use, but this is a good resource to find ways to do things you do need. 
As you look through that page, remember that hdfs dfs is the same as hadoop fs — you can use either.

Some of the commands on that page relate to permissions and file ownership, 
which is beyond the scope of this course, 
but see the “HDFS Permissions” reading if you’re interested to learn more about that.

HDFS Paths
In this course, most of the HDFS paths you will see in hdfs dfs commands are in the 
form /path/to/directory/ (for a directory), or /path/to/directory/file.ext (for a file). 
This is known as an unqualified path because it does not specify what protocol 
to use and it does not specify what specific instance of HDFS to use. 
In most cases, it is sufficient to use unqualified HDFS paths, because the configuration 
of your big data environment will specify what protocol and what HDFS instance to use.

However, in some cases, depending on the configuration of your big data environment, 
it might be necessary to fully qualify your HDFS paths by specifying 
the hdfs:// protocol and a hostname indicating what instance of HDFS to use. 
To do this, use the form: hdfs://hostname/path/to/directory/file.ext 
or hdfs://hostname.domain/path/to/directory/file.ext. 
Ask your system administrator what hostname and what domain (if any) to use.

You can also specify the hdfs:// protocol without specifying a hostname, 
using the form: hdfs:///path/to/directory/file.ext. 
Notice the three slashes after hdfs: The first two slashes are part of the protocol, 
and the third slash is the start of the path.

HDFS Trash
Note that HDFS has a “trash” directory for recently deleted files, 
similar to the Trash on iOS or Windows systems. 
This trash is not always enabled, so you should check your system to see 
if it's enabled before assuming that you can recover any deleted files!

The hdfs dfs -rm command has a -skipTrash option that you can use to bypass 
the trash (if it's enabled) and delete the file immediately. 
When deleting large files to free up space in HDFS, consider using this option 
so that you do not need to perform the additional step of emptying the trash. 
But remember that when you use this option, the files you delete will not be recoverable.
````

### CHAINING AND SCRIPTING WITH HDFS COMMANDS
````text
When you work a lot with HDFS commands, there are two techniques 
that you will likely find very useful: chaining and scripting.

Chaining HDFS Commands
If you've worked much with the command line, you might be familiar with using pipes (|) to chain commands, 
or using redirection to push results to a different location (such as to a file instead of to the screen). 
You can do this with HDFS shell commands as well.

You can achieve many practical tasks by combining HDFS shell commands with piping or redirection. 
Two examples are described below.

Viewing the First Few Lines of a File
To view only the first few lines of a text file stored in HDFS, 
you can pipe the output of the hdfs dfs -cat command to the head command:

$ hdfs dfs -cat /path/to/file.txt | head

You can ignore the message that says "Unable to write to the output stream." 
This happens because the hdfs dfs -cat command outputs more data than the head command inputs.

Loading Data Without the Header Line
Instead of using the skip.header.line.count table property to ignore the header line in text files, 
you can copy everything except the header line when you put a file into HDFS:

$ tail -n +2 source_file.txt | hdfs dfs -put - /path/to/destination_file.txt

In the above command, the hyphen or dash character (-) after -put tells 
the HDFS shell application to take the output of the tail command before the pipe and load that into HDFS.

To remove the header line when copying a text file in the opposite direction 
(from HDFS to the local file system) you would run a different command, 
this time using the output redirection operator (>) to store the output of the tail command in a file:

$ hdfs dfs -cat /path/to/source_file.txt | tail -n +2 > destination_file.txt

Using Commands in Scripts
You can also use commands like this in scripts. 
This is particularly helpful when you automate tasks that involve managing files in HDFS. 
In shell scripts, you can use hdfs dfs commands just as you normally would other shell commands. 
Scripts for other languages, such as Python and R, 
typically can invoke shell commands using commands specific to the language. 
For example, in Python you can use the os or subprocess modules and use a call such as subprocess.call(). 
In R, you can use system().
````

### HDFS PERMISSIONS
````text
Security is an important consideration for any computer system, and big data systems are no exception. 
In the VM for this course, you have all the permissions you need to do the exercises and examples in this course, 
but at your company, you may not be able to do everything you're learning here. 
For example, the ability to create databases, or even tables, is often restricted so a company's system 
doesn't get overloaded with redundant or otherwise unnecessary items. 
Similarly, the ability to drop tables, or to delete or move files, may be restricted. 
Larger companies will only allow their data engineers, database administrators, or system administrators to do this work.

The following resources can provide additional information, if you're interested:

DWGeek's Hadoop Security – Hadoop HDFS File Permissions? is a quick overview of file permissions. 
This is a good place to start, and then you can decide if you want to dig deeper.
HDFS Commands, HDFS Permissions and HDFS Storage? is a chapter from a book, 
Expert Hadoop Administration: Managing, Tuning, and Securing Spark, YARN, and HDFS. 
The section "HDFS Users and Superusers" may be helpful if you are unfamiliar with the concept of a superuser.
The documentation on Hadoop includes the HDFS Permissions Guide, 
which likely has more detail than you'll ever want, 
but it's a great resource if there's a particular question you're looking to answer.
````













































































[hdfs command line]: https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/FileSystemShell.html