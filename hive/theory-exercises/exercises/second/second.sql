/*
Create a table emp as below.
 empno    int,
  ename    string,
  job      string,
  mgr      int,
  hiredate timestamp,
  sal      double,
  coMM     double,
  deptno   int

Once table is created as insert statment as below.

7698,'BLAKE','MANAGER',7839,'01-05-1981',2850,null,30
7782,'CLARK','MANAGER',7839,'09-06-1981',2450,null,10
7566,'JONES','MANAGER',7839,'02-04-1981',2975,null,20
7788,'SCOTT', 'ANALYST',7566,'13-07-1987,3000,null,20
7902,'FORD','ANALYST',7566,'03-12-1981',3000,null,20
7369,'SMITH','CLERK',7902,'17-12-1980',800,null,20
7499,'ALLEN','SALESMAN',7698,'20-02-1981',1600,300,30
7521,'WARD','SALESMAN',7698,'22-02-1981',1250,500,30
7654,'MARTIN','SALESMAN',7698,'28-09-1981',1250,1400,30
7844,'TURNER','SALESMAN',7698,'08-09-1981',1500,0,30
7876,'ADAMS','CLERK',7788,'13-07-1987',1100,null,20
7900,'JAMES','CLERK',7698,'03-12-1981',950,null,30
7934,'MILLER','CLERK',7782,'23-01-1982',1300,null,10

Create a dept table as below:

deptno     int,
dname      string,
loc        string

Insert below data in the table.

10,'ACCOUNTING','NEW YORK'
20,'RESEARCH','DALLAS'
30,'SALES','CHICAGO'
40,'OPERATIONS','BOSTON'

Now accomplish following activities.
1. Please denormalize data between DEPT and EMP tables based on the for the dame DEPTNO.
2. Count the number of employees in each department, and pring depart name and its count.
*/

-- $ hdfs dfs -put -f /home/cloudera/files/Employee/employee.csv /user/cloudera/files/Employee
-- $ hdfs dfs -put -f  /home/cloudera/files/Employee/department.csv /user/cloudera/files/Employee

-- $ beeline -u jdbc:hive2://quickstart.cloudera:10000/hadoopexamdb

CREATE TABLE aux_employee (
empno INT COMMENT "Id of the employee",
ename STRING COMMENT "Name of the employee",
job STRING COMMENT "An employee does some things from time to time",
mrg INT COMMENT "I don\'t know what is this",
hiredate STRING COMMENT "The date I hired an employee",
sal DOUBLE COMMENT "Part of my money is for my employees",
coMM DOUBLE COMMENT "and some Bonus too, if they are doing well",
deptno INT COMMENT "Office Id where an employee is working on something"
) COMMENT "Table of employees of my great company"
ROW FORMAT DELIMITED FIELDS TERMINATED BY ","
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH "/home/cloudera/files/Employee/employee.csv" INTO TABLE aux_employee;

CREATE TABLE employees LIKE aux_employee;

INSERT OVERWRITE TABLE employee SELECT empno,ename,job,mrg,CAST(from_unixtime(unix_timestamp(hiredate,"dd-MM-yyyy")) AS timestamp) AS hiredate,sal,coMM,deptno
FROM aux_employee;

DROP TABLE aux_employee;

CREATE TABLE department (
deptno INT COMMENT "Departement ID where the employee does something",
dname STRING COMMENT "Name of the department",
loc STRING COMMENT "Town or city or country where the department is placed")
ROW FORMAT DELIMITED FIELDS TERMINATED BY ","
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH "/home/cloudera/files/Employee/department.csv" INTO TABLE department;

CREATE TABLE emp_dept AS
SELECT e.*,d.dname,d.loc
FROM employee e
RIGHT OUTER JOIN department d ON(e.deptno = d.deptno);
-- same result as above
INSERT OVERWRITE TABLE emp_dept
SELECT e.empno,e.ename,e.job,e.mrg,e.hiredate, e.sal,e.coMM,d.deptno,d.dname,d.loc
FROM employee e
RIGHT OUTER JOIN department d ON(e.deptno = d.deptno);

SELECT deptno, dname, COUNT(empno) AS num_employees
FROM emp_dept
GROUP BY deptno, dname;