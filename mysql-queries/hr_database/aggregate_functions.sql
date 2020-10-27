/*
1. Write a query to list the number of jobs available in the employees table.
*/
SELECT COUNT(DISTINCT job_id) FROM employees;
/*
2. Write a query to get the total salaries payable to employees.
*/
SELECT SUM(salary) FROM employees;
/*
3. Write a query to get the minimum salary from employees table.
*/
SELECT MIN(salary) FROM employees;
/*
4. Write a query to get the maximum salary of an employee working as a Programmer.
*/
SELECT job_id, MAX(salary) AS max_salary FROM employees WHERE job_id = 'IT_PROG';
/*
5. Write a query to get the average salary and number of employees working the department 90
*/
SELECT department_id, ROUND(AVG(salary),2) AS avg_salary, COUNT(employee_id) AS number_employees
FROM employees
WHERE department_id = 90;
/*
7. Write a query to get the number of employees with the same job.
*/
SELECT job_id, COUNT(employee_id) AS number_employees
FROM employees
GROUP BY job_id
ORDER BY number_employees;
/*
8. Write a query to get the difference between the highest and lowest salaries.
*/
SELECT MAX(salary) - MIN(salary) AS difference FROM employees;
/*
9. Write a query to find the manager ID and the salary of the lowest-paid employee for that manager.
*/
SELECT manager_id, MIN(salary) lowest_salary , first_name, last_name
FROM employees
GROUP BY MANAGER_ID
ORDER BY lowest_salary;
/*
10. Write a query to get the department ID and the total salary payable in each department.
*/
SELECT department_id, SUM(salary) AS total_salary
FROM employees
GROUP BY DEPARTMENT_ID
ORDER BY total_salary DESC;
/*
11. Write a query to get the average salary for each job ID excluding programmer.
*/
SELECT job_id, AVG(salary) AS avg_salary
FROM employees
WHERE job_id <> 'IT_PROG'
GROUP BY job_id;
/*
12. Write a query to get the total salary, maximum, minimum, average salary of employees (job ID wise), for department ID 90 only.
*/
SELECT job_id, department_id, SUM(salary) AS total_salary, MAX(salary) max_salary, MIN(salary) AS min_salary, ROUND(AVG(salary),2) AS avg_salary
FROM employees
WHERE department_id = 90
GROUP BY job_id;
/*
13. Write a query to get the job ID and maximum salary of the employees where maximum salary is greater than or equal to $4000.
*/
SELECT job_id, MAX(salary)
FROM employees
GROUP BY job_id
HAVING MAX(salary) >= 4000;
/*
14. Write a query to get the average salary for all departments employing more than 10 employees.
*/
SELECT department_id, ROUND(AVG(salary),2) AS avg_salary, COUNT(employee_id) AS number_employees
FROM employees
GROUP BY DEPARTMENT_ID
HAVING COUNT(department_id) > 10;


