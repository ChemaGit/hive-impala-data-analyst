## Examples in Sqoop
````text
    - Importing/exporting Relational Data with Apache Sqoop
    - Sqoop exchanges data between a database and HDFS
    - Sqoop is a command-line utility with several subcommands, called tools
    - imports are performed using Hadoop MapReduce jobs
    - sqoop also generates a Java source file for each table being imported
    - the file remains after import, but can be safely deleted
    - the import-all-tables tool imports an entire database
    	-stored as comma-delimited files
    	-default base location is your HDFS home directory
    	-data will be in subdirectories corresponding to name of each table
    - the import tool imports a single table(we can import only specified columns, or only matching rows from a single table)
    - we can specify a different delimiter(by default comma)
    - sqoop supports storing data in a compressed file
    - Sqoop supports importing data as Parquet or Avro files
    - Sqoop can export data from Hadoop to RDBMS
````
````text
- Sqoop (SQL-to-Hadoop) intercambia datos entre una base de datos y HDFS, utilizando MapReduce.
	- Puede importar todas las tablas, una única tabla o parte de una tabla.
	- Los datos pueden ser importados en varios formatos.
	- También puede exportar datos desde HDFS a una base de datos.
- Proceso de importación:
	1.- Examina los detalles de la tabla.
	2.- Crea y submite un job en el cluster.
	3.- Recupera los registros desde la tabla y escribe estos datos en HDFS.
- Sintaxis básica:
	- Es una utilidad de línea de comandos con varios subcomandos, llamadas herramientas:
		- Existen herramientas para importar, exportar, listar contenidos de una base de datos, etc.
		- sqoop help lista todas las herramientas.
		- sqoop help tool-name ofrece ayuda para una herramienta específica.
````
````shell script
# Sintaxis de un comando básico:
sqoop tool-name [tool-options]
# Lista de todas las tablas en un base de datos mysql:
sqoop list-tables \
--connect jdbc:mysql://dbhost/loudacre \
--username dbuser \
--password pw

# Ejecutar una consulta sobre una base de datos:
sqoop eval 
--query "SELECT * FROM my_table LIMIT 5" \
--connect jdbc:mysql://dbhost/loudacre \
--username dbuser \ 
--password pw 
````

````text
- Importando datos:
	- Utiliza Hadoop MapReduce.
	- Primeramente examina la tabla que se va a importar:
		- Determina la clave primaria si es posible.
		- Ejecuta un boundary query para ver cuántos registros serán importados.
		- Divide esta boundary query entre el número de mappers (por defecto son 4).
		- Genera un source file en Java por cada tabla importada, que se compila y usa durante el proceso de importación.
		- Este fichero permanece después de la importación, pero se puede borrar con seguridad.
````
````shell script
# Importar todas las tablas de una base de datos:
sqoop import-all-tables \
--connect jdbc:mysql://dbhost/loudacre \
--username dbuser \
--password pw

# Los ficheros importados están delimitados por comas.
# Por defecto se importan al directorio home de HDFS.
# Los datos estarán en subdirectorios correspondientes al nombre de cada tabla.

# Importar todas las tablas a un directorio base diferente:
sqoop import-all-tables \
--connect jdbc:mysql://dbhost/loudacre \
--username dbuser \
--password pw \
--warehouse-dir /loudacre

# Importar una única tabla:
sqoop import --table accounts \
--connect jdbc:mysql://dbhost/loudacre \
--username dbuser \
--password pw

# Importar parcialmente los datos de una tabla:
sqoop import \
--table accounts \
--connect jdbc:mysql://dbhost/loudacre \ 
--username dbuser \
--password pw \
--columns "id,first_name,last_name,state"

# Importar los datos de una tabla que cumplan condiciones:
sqoop import \
--table accounts \
--connect jdbc:mysql://dbhost/loudacre \
--username dbuser \
--password pw \
--where "state='CA'"

# Importar una tabla a un destino diferente al por defecto ( que es el home directory HDFS):
sqoop import \
--table accounts \
--connect jdbc:mysql://dbhost/loudacre \
--username dbuser \
--password pw \
--target-dir /loudacre/customer_accounts

# Generar un fichero de texto separado por tabuladores (por defecto lo hace por comas):
sqoop import \
--table accounts \
--connect jdbc:mysql://dbhost/loudacre \
--username dbuser \
--password pw \
--fields-terminated-by "\t" 

# Generar un fichero comprimido (formato Gzip):
sqoop import \
--table accounts \
--connect jdbc:mysql://dbhost/loudacre \
--username dbuser \
--password pw -z

# Generar un fichero comprimido (formato Snappy):
sqoop import \
--table accounts \
--connect jdbc:mysql://dbhost/loudacre \
--username dbuser \
--password pw \
--compression-codec org.apache.hadoop.io.compress.SnappyCodec

# Generar un fichero con formato parquetfile:
sqoop import \
--table accounts \
--connect jdbc:mysql://dbhost/loudacre \
--username dbuser \
--password pw \
--as-parquetfile

# Generar un fichero con formato avro:
sqoop import \
--table accounts \
--connect jdbc:mysql://dbhost/loudacre \
--username dbuser \
--password pw \
--as-avrodatafile

# Generar un fichero con formato SequenceFile:
sqoop import \
--table accounts \ 
--connect jdbc:mysql://dbhost/loudacre \ 
--username dbuser \
--password pw \
--as-sequencefile 

# Importaciones incrementales (se añaden sólo los nuevos registros):
# Basadas en el valor del último registro de la columna especificada.
# Ejemplo:
sqoop import --table invoices \
--connect jdbc:mysql://db.loudacre.com/loudacre \
--username training --password training \
--incremental append \
--check-column id \
--last-value 9478306	

# Manejando valores nulos en importaciones:
# Por defecto los nulos se importan con el literal "null".
# Por compatibilidad con Hive e Impala se usa:
sqoop import --table accounts \
--connect jdbc:mysql://dev.loudacre.com/loudacre \
--username training --password training \
# se especifica un valor alternativo
--null-string "\\N" \ 
--null-non-string "\\N" #valor alternativo para campos no strings.

# Limitando los resultados de la importación:
# Importar sólo las columnas especificadas:
sqoop import --table accounts \
--connect jdbc:mysql://db.loudacre.com/loudacre \
--username training --password training \
--columns "id,first_name,last_name,state"

# Importar sólo los filas que cumplan condiciones:
sqoop import --table accounts \
--connect jdbc:mysql://db.loudacre.com/loudacre \
--username training --password training \
--where "state='CA'"

# Importar los resultados de una query:
# opción --query option
# obligatorio añadir el literal WHERE $CONDITIONS
# opción --split-by para dividir el trabajo entre los mappers (ya que no existe clave primaria).
# opción --target-dir para indicar el directorio de destino.

# Ejemplo:
sqoop import \
--connect jdbc:mysql://db.loudacre.com/loudacre \
--username training --password training \
--target-dir /data/loudacre/payable \
--split-by accounts.id \
--query 'SELECT accounts.id, first_name, last_name,bill_amount 
         FROM accounts 
         JOIN invoices ON (accounts.id = invoices.cust_id)
         WHERE $CONDITIONS'

# En el caso de querer añadir condiciones (WHERE) a la query se especifican después de CONDITIONS:
# Ejemplo:
sqoop import \
--connect jdbc:mysql://db.loudacre.com/loudacre \
--username training --password training \
--target-dir /data/loudacre/payable \
--split-by accounts.id \
--query 'SELECT accounts.id, first_name, last_name,bill_amount 
         FROM accounts 
         JOIN invoices ON (accounts.id = invoices.cust_id) 
         WHERE $CONDITIONS AND bill_amount >= 40'

# Opciones para la conectividad con la base de datos:
# Genérica (JDBC), compatible con la mayoría de bases de datos, menor rendimiento.
# Direct Mode, actualmente compatible con MySQL y Postgres, mayor rendimiento pero no están disponibles todas las características de Sqoop.
# se usa la opción --direct.
# Protocolos nativos para determinadas bases de datos (Teradata, Oracle, etc.)
# Paralelismo en importaciones:
# Se puede indicar el número de mappers a utilizar, aunque Sqoop lo puede hacer o no.
# Ejemplo:
sqoop import --table accounts \
--connect jdbc:mysql://db.loudacre.com/loudacre \
--username twheeler --password bigsecret \
-m 8

# La repartición se hace en función de la clave primaria numérica, pero se puede indicar una columna diferente:
# se usa la opción --split-by
		
# Exportando datos:
# Pasa datos almacenados en HDFS a un RDBMS.
# La tabla RDBMS debe existir antes de hacer la exportación.
# Exportar una tabla:
sqoop export \
# destino de los datos
--connect jdbc:mysql://dev.loudacre.com/loudacre \ 
--username training --password training \
# origen de los datos
--export-dir /loudacre/recommender_output \ 
# modo de exportación (updateonly sólo actualiza cambios)
--update-mode allowinsert \ 
--table product_recommendations # tabla de destino

# Manejando valores nulos en exportaciones:
# se especifica un valor alternativo
--input-null-string "\\N" \ 
--input-null-non-string "\\N" # valor alternativo para campos no strings.

# Import table from MySQL to HIVE
sqoop import \
--table accounts \
--connect jdbc:mysql://localhost/loudacre \
--username training \
--password training \
--null-non-string '\\N' \
--split-by acct_num \
--fields-terminated-by "," \
--hive-import --create-hive-table --hive-table accounts_sqoop \
--target-dir /loudacre/accounts
````


    