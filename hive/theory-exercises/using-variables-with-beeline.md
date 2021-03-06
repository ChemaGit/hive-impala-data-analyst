## USING VARIABLES WITH BEELINE

### Script game_prices.sql - Example in HIVE
````text
-- set a variable containing the name of the game
SET hivevar:game=Monopoly;
-- return the list of the game
SELECT list_price FROM fun.games WHERE name = '${hivevar:game}';
-- return the prices of the game ate game shops
SELECT shop, price FROM fun.inventory WHERE game = '${hivevar:game}';

$ beeline -u jdbc:hive2://localhost:10000 -f /home/training/assigments/UsingHiveAndImpalaInScriptsApplications/game_prices.sql
````

### Script hex_color.sql - Example in HIVE
````text
SELECT hex FROM wax.crayons WHERE color = '${hivevar:color}';

$ beeline -u jdbc:hive2://localhost:10000 --hivevar color="Red" -f /home/training/assigments/UsingHiveAndImpalaInScriptsApplications/hex_color.sql
$ beeline -u jdbc:hive2://localhost:10000 --hivevar color="Orange" -f /home/training/assigments/UsingHiveAndImpalaInScriptsApplications/hex_color.sql
$ beeline -u jdbc:hive2://localhost:10000 --hivevar color="Yellow" -f /home/training/assigments/UsingHiveAndImpalaInScriptsApplications/hex_color.sql
````

### Script color_from_rgb.sql - Example in HIVE
````text
file.sql
SELECT color FROM ${hivevar:table}
WHERE red = ${hivevar:red} AND green = ${hivevar:green} AND blue = ${hivevar:blue};

$ beeline -u jdbc:hive2://localhost:10000 --hivevar red="238" \
                                          --hivevar green="32" \
                                          --hivevar blue="77" \
                                          --hivevar table="wax.crayons" \
-f /home/training/ModernBigDataAnalysisWithSQLCloudera/AnalyzingBigDataWithSQL/UsingHiveAndImpalaInScriptsApplications/color_from_rgb.sql

-- Example with ARRAY
my_file.sql
select '${hivevar:red}';
beeline -u jdbc:hive2://localhost:10000 --hivevar red=ARRAY['1','2','3'] -f my_sql.sql

my_file.sql
select SPLIT('${hivevar:red}',',');
beeline -u jdbc:hive2://localhost:10000 --hivevar red="rojo, amarillo, azul" -f my_sql.sql
````