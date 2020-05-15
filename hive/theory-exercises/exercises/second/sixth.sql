/*
I have this table:

employee_id, last_name, first_name, birth_date,photo,notes
1,Davolio,Nancy,1968-12-08,f.png,Engineer

Task: show first name, last name and age of the three oldest employees.

how show 3 oldest employees?
*/

select first_name, last_name, current_date - birth_date as age
from (
  select first_name, last_name, birth_date,
         dense_rank() over (order by birth_date) as rnk
  from employees
) t
where rnk <= 3;