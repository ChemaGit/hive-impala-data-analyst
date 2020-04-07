$ beeline -u jdbc:hive2://localhost:10000 -n training -p training
hive> show databases;
hive> use fun;
hive> !q

$ beeline -u jdbc:hive2://localhost:10000/fun
hive-fun> show tables;
hive-fun> select * from games;
hive-fun> select name, list_price from games;
// to clear the screen ctrl + l
hive-fun> !q

-- USING BEELINE IN NON-INTERACTIVE MODE
$ beeline -u jdbc:hive2://localhost:10000 - training -p training  // interactive mode
$ beeline -u jdbc:hive2://localhost:10000 - training -p training -e 'SELECT * FROM fun.games' // non-interactive mode
$ beeline --silent=true -u jdbc:hive2://localhost:10000 - training -p training -e 'SELECT * FROM fun.games' // non-interactive mode
$ beeline --silent=true -u jdbc:hive2://localhost:10000 - training -p training -e 'use fun; SELECT * FROM games'
$ beeline -u jdbc:hive2://localhost:10000 - training -p training -f myquery.sql
$ beeline -u jdbc:hive2://localhost:10000 - training -p training -f /home/training/assigments/UsingBeelineAndImpalaShellInNonIteractiveMode/myquery.sql
$ beeline --silent=true -u jdbc:hive2://localhost:10000 - training -p training -f /home/training/assigments/UsingBeelineAndImpalaShellInNonIteractiveMode/myquery.sql

-- COMMENTS IN HIVE

-- FORMATTING THE OUTPUT OF BEELINE
$ beeline --silent=true -u jdbc:hive2://localhost:10000 - training -p training --outputformat=csv2 -e 'SELECT * FROM fun.games'
$ beeline --silent=true -u jdbc:hive2://localhost:10000 - training -p training --outputformat=tsv2 -e 'SELECT * FROM fun.games'
$ beeline --silent=true -u jdbc:hive2://localhost:10000 - training -p training --outputformat=tsv2 --showHeader=false -e 'SELECT * FROM fun.games'
$ beeline --silent=true -u jdbc:hive2://localhost:10000 - training -p training --outputformat=csv2 --showHeader=false -e 'SELECT * FROM fun.games'

-- SAVING HIVE QUERY RESULTS TO A FILE
$ beeline --silent=true -u jdbc:hive2://localhost:10000 - training -p training -e 'SELECT * FROM fun.games' > /home/training/assigments/UsingBeelineAndImpalaShellInNonIteractiveMode/fun_games.txt
$ beeline --silent=true -u jdbc:hive2://localhost:10000 - training -p training --outputformat=csv2 -e 'SELECT * FROM fun.games' > /home/training/assigments/UsingBeelineAndImpalaShellInNonIteractiveMode/fun_games.csv
$ beeline --silent=true -u jdbc:hive2://localhost:10000 - training -p training --outputformat=tsv2 -e 'SELECT * FROM fun.games' > /home/training/assigments/UsingBeelineAndImpalaShellInNonIteractiveMode/fun_games.tsv
