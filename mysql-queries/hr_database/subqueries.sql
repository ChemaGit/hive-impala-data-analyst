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
      department_id IN(SELECT department_id FROM departments WHERE department_name LIKE('IT%'))

