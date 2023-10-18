/*
1. Write a query to find the name (first_name, last_name) and the salary of the employees who have a higher salary than the employee whose last_name='Bull'.
*/
SELECT em.first_name, em.last_name, em.salary
FROM employees em
WHERE em.salary > (SELECT e.salary FROM employees e WHERE e.last_name = 'Bull');
/*
2. Write a query to find the name (first_name, last_name) of all employees who works in the IT department.
*/
SELECT job_id, first_name, last_name
FROM employees e
JOIN departments d ON(e.DEPARTMENT_ID = d.DEPARTMENT_ID)
WHERE d.DEPARTMENT_NAME LIKE('IT');

SELECT job_id, first_name, last_name
FROM employees e
WHERE department_id IN (SELECT department_id FROM departments WHERE department_name LIKE('IT'));

/*
3. Write a query to find the name (first_name, last_name) of the employees who have a manager and worked in a USA based department.
*/
SELECT e.first_name, e.last_name
FROM employees e
JOIN employees ee ON(e.manager_id = ee.employee_id)
JOIN departments d ON(ee.department_id = d.department_id)
JOIN locations l ON(d.location_id = l.location_id)
WHERE l.country_id = 'US';

SELECT first_name, last_name FROM employees
WHERE manager_id IN (SELECT employee_id
                     FROM employees
                     WHERE department_id  IN (SELECT department_id
                                              FROM departments
                                              WHERE location_id IN (SELECT location_id
                                                                    FROM locations
                                                                    WHERE country_id ='US')));
/*
4. Write a query to find the name (first_name, last_name) of the employees who are managers.
*/
SELECT first_name, last_name
FROM employees
WHERE employee_id IN(SELECT DISTINCT manager_id
                     FROM employees);

SELECT DISTINCT e.first_name, e.last_name
FROM employees e
JOIN employees ee ON(e.employee_id = ee.manager_id);

/*
5. Write a query to find the name (first_name, last_name), and salary of the employees whose salary is greater than the average salary.
*/
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

/*
6. Write a query to find the name (first_name, last_name), and salary of the employees whose salary is equal to the minimum salary for their job grade.
*/
SELECT first_name, last_name, salary
FROM employees e
WHERE e.salary = (SELECT min_salary
                          FROM jobs
                          WHERE e.job_id = jobs.job_id);

SELECT first_name, last_name, salary
FROM employees e
JOIN jobs j ON(e.job_id = j.job_id)
WHERE e.salary = j.min_salary;

/*
7. Write a query to find the name (first_name, last_name), and salary of the employees who earns more than the average salary and works in any of the IT departments.
*/
SELECT first_name, last_name, salary
FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees) AND
      department_id IN(SELECT department_id FROM departments WHERE department_name LIKE('IT%'));

/*
8. Write a query to find the name (first_name, last_name), and salary of the employees who earns more than the earning of Mr. Bell.
*/
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (SELECT salary FROM employees WHERE last_name = 'Bell');
/*
9. Write a query to find the name (first_name, last_name), and salary of the employees who earn the same salary as the minimum salary for all departments.
*/
SELECT first_name, last_name, salary
FROM employees
WHERE salary =(SELECT MIN(salary)
                FROM employees);
/*
10. Write a query to find the name (first_name, last_name), and salary of the employees whose salary is greater than the average salary of all departments.
*/
SELECT first_name, last_name, salary
FROM employees
WHERE salary > ALL(SELECT AVG(salary) FROM employees GROUP BY department_id);
/*
11. Write a query to find the name (first_name, last_name) and salary of the employees
who earn a salary that is higher than the salary of all the Shipping Clerk (JOB_ID = 'SH_CLERK').
Sort the results of the salary of the lowest to highest.
*/
SELECT first_name, last_name,job_id, salary
FROM employees
WHERE salary > (SELECT MAX(salary) FROM employees WHERE job_id = 'SH_CLERK')
ORDER BY salary;

SELECT first_name,last_name, job_id, salary
FROM employees
WHERE salary >
ALL (SELECT salary FROM employees WHERE job_id = 'SH_CLERK') ORDER BY salary;

/*
12. Write a query to find the name (first_name, last_name) of the employees who are not supervisors.
*/
SELECT first_name, last_name
FROM employees
WHERE employee_id NOT IN(SELECT DISTINCT(manager_id) FROM employees);

SELECT b.first_name,b.last_name
FROM employees b
WHERE NOT EXISTS (SELECT 'X' FROM employees a WHERE a.manager_id = b.employee_id);

/*
13. Write a query to display the employee ID, first name, last name, and department names of all employees.
*/
SELECT employee_id, first_name, last_name, department_name
FROM employees e
JOIN  departments d ON(e.department_id = d.department_id)
ORDER BY department_name;

SELECT employee_id, first_name, last_name,
(SELECT department_name FROM departments d
 WHERE e.department_id = d.department_id) department
 FROM employees e ORDER BY department;
/*
14. Write a query to display the employee ID, first name, last name, salary of all employees whose salary is above average for their departments.
*/
SELECT employee_id, first_name, last_name, salary
FROM employees e
JOIN (SELECT department_id, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department_id) avg ON(e.department_id = avg.department_id)
WHERE e.salary > avg.avg_salary
ORDER BY e.employee_id;

SELECT employee_id, first_name
FROM employees AS A
WHERE salary > (SELECT AVG(salary) FROM employees WHERE department_id = A.department_id)
ORDER BY employee_id;

/*
15. Write a query to fetch even numbered records from employees table.
*/
SET @row_number = 0;
SELECT row_number, first_name, last_name, salary
FROM (SELECT @row_number := @row_number + 1 AS row_number, first_name, last_name, salary
     FROM employees) t
WHERE row_number MOD 2 = 0;

/*
16. Write a query to find the 5th maximum salary in the employees table.
*/
SET @row_number = 0;
SELECT row_number, first_name, last_name, salary, job_id
FROM (SELECT @row_number := @row_number + 1 AS row_number, first_name, last_name, salary, job_id
      FROM employees
      ORDER BY salary DESC) t
WHERE row_number = 5;

/*
17. Write a query to find the 4th minimum salary in the employees table.
*/
