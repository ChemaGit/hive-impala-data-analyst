-- USING IMPALA SHELL
-- $ impala-shell -h
-- $ impala-shell -d fun
SELECT *
FROM games;

SHOW tables;

-- to quit from the shell

ctrl + l
quit!

-- USING IMPALA-SHELL IN NON INTERACTIVE MODE
$ impala-shell -q 'SELECT * FROM fun.games'
$ impala-shell --quiet -q 'SELECT * FROM fun.games'
$ impala-shell --quiet -q 'USE fun; SELECT * FROM games'
$ impala-shell -f /home/training/assigments/UsingBeelineAndImpalaShellInNonIteractiveMode/myquery.sql
$ impala-shell --quiet -f /home/training/assigments/UsingBeelineAndImpalaShellInNonIteractiveMode/myquery.sql
$ impala-shell --quiet -q $'USE fun; SELECT name AS \'name_game\' FROM games'

-- COMMENTS IN IMPALA

-- FORMATTING THE OUTPUT OF IMPALA SHELL
$ impala-shell --quiet --delimited -q 'USE fun; SELECT * FROM games'
$ impala-shell --quiet --delimited --output_delimiter=',' -q 'USE fun; SELECT * FROM games'
$ impala-shell --quiet --delimited --output_delimiter='\t' -q 'USE fun; SELECT * FROM games'
$ impala-shell --quiet --delimited --print_header --output_delimiter='\t' -q 'USE fun; SELECT * FROM games'

-- SAVING IMPALA QUERY RESULTS TO A FILE
$ impala-shell --quiet --delimited --output_delimiter=',' --print_header -q 'USE fun; SELECT * FROM games' -o /home/training/assigments/UsingBeelineAndImpalaShellInNonIteractiveMode/impala_fun_games.csv
$ impala-shell --quiet --delimited --print_header --output_delimiter='\t' -q 'USE fun; SELECT * FROM games' -o /home/training/assigments/UsingBeelineAndImpalaShellInNonIteractiveMode/impala_fun_games.tsv
$ impala-shell -q 'SELECT * FROM fun.games' -o /home/training/assigments/UsingBeelineAndImpalaShellInNonIteractiveMode/impala_fun_games.txt
