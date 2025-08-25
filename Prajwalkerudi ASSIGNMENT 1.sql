# 1.create a new data base

create database employee3;
use employee3;

# 1].create employee table with primary key?

create table employee_data
(
employee_id int primary key,
first_name varchar(50),
last_name varchar(50),
salary decimal,
gender varchar(20),
department varchar(50),
joined_date date
);

# 2.insert sample data into table?

insert into employee_data values (94, 'Ram', 'K', 45000,'M','IT', '2021-06-05');
insert into employee_data values (132, 'Roma', 'R', 33000,'F','Developer', '2020-08-15');
insert into employee_data values (24, 'Max', 'V', 30000, 'M','Account', '2023-12-18');
insert into employee_data values (149, 'Georgia', 'R', 50000,'F', 'Analyst', '2021-07-20');
insert into employee_data values (138, 'Lando', 'N', 48000,'M', 'IT', '2022-05-25');

# 3.write a query to create a clone of an exixting table using create command?

# 4.write a query to get all the details of employee table?

select * from employee_data;

# 5.select only top 1 record from employee table?

select * from employee_data order by employee_id limit 1;

# 6.select only bottom 1 record from employee table?

select * from employee_data order by employee_id desc limit 1;

# 7.how to select a random record from a table?

select * from employee_data
order by rand()
limit 1;

# 8.Write a query to get
# 1]“first_name” in upper case as "first_name_upper"

select upper(first_name) as first_name_upper
from employee_data;

# 2]‘first_name’ in lower case as ‘first_name_lower”

select lower(first_name) as first_name_lower
from employee_data;

# 3] Create a new column “full_name” by combining “first_name” & “last_name” with space as a separator.

select concat(first_name, ' ', last_name) as full_name
from employee_data;

# 4]Add 'Hello ' to first_name and display result

select concat('Hello', ' ', first_name) as greeting
from employee_data;

# 9.Select the employee details 
# 1] Whose “first_name” is 'MAX'

select * from employee_data
where first_name = 'MAX';

#2]Whose “first_name” present in 'Ram', 'Roma', 'Max

select * from employee_data
where first_name in('Ram', 'Roma', 'Max');

#3] Whose “first_name” not present in 'Ram', 'Raj', 'Max

select * from employee_data
where first_name not in('Ram', 'Roma', 'Max');

#4] Whose “first_name” starts with “g

select * from employee_data
where first_name like'g%';

#5] Whose “first_name” ends with “x”

select * from employee_data
where first_name like '%x';

#6]  Whose “first_name” contains “n”

select * from employee_data
where first_name like '%n%';

#7]  Whose "first_name" start with any single character between 'm-v'

select * from employee_data 
where first_name like '[m-l]%';

#8]  Whose "first_name" not start with any single character between 'm-v'

select * from employee_data
where first_name not like '[m-l]%';

#9] Whose "first_name" start with 'M' and contain 3 letters

select * from employee_data 
where first_name like 'm__';

# 10.  Write a query to get all unique values of"department" from the employee table.

select distinct department
from employee_data;

#11.  Query to check the total records present in a table

select count(*) as tot_record
from employee_data;

#12. Write down the query to print first letter of a Name in Upper Case and all other letter in Lower Case.

select concat(
upper(left(first_name, 1)),
lower(substring(first_name, 2))
) as formatted_name
from employee_data;

#13.  Write down the query to display all employee name in one cell separated by ','
 
 select group_concat(first_name separator ',') as all_employees
 from employee_data;
 
#14. Query to get the below values of "salary" from employee tableQuery to get the below values of "salary" from employee table,Lowest salary,Highest salary,Average salary,Highest salary - Lowest salary as diff_salary,% of difference between Highest salary and lowest salary. (sample output,format: 10.5%)

select 
min(salary) as lowest_salary,
max(salary) as highest_salary,
avg(salary) as average_salary,
(max(salary) - min(salary)) as diff_salary,
concat(round(((max(salary) - min(salary)) / min(salary)) * 100, 1), '%') as diff_percentage
from employee_data;

#15. Select “first_name” from the employee table after removing white spaces from Right side spaces Left side spaces Both right & left side spaces

select rtrim(first_name) as right_trimmed
from employee_data;

select ltrim(first_name) as left_trimmed
from employee_data;

select trim(first_name) as both_trimmed
from employee_data

#16. Query to check no.of records present in a table where employees having 50k salary

select 
count(*) as no_of_records
from employee_data
where salary = 45000;

#17.  Find the most recently hired employee in each department

SELECT department, first_name, joined_date
FROM (
    SELECT 
        department,
        first_name,
        joined_date,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY joined_date DESC) AS rn
    FROM employee_data
) t
WHERE rn = 1;

#Case When Then End Statement Queries

#1. Display first_name and gender as M/F

select
	first_name,
    case
    when gender = 'Male' then 'M'
    when gender = 'Female' then 'F'
    else gender
    end as gender_short
    from employee_data;
    
#2.  Display first_name, salary, and a salary category. (If salary is below 30,000, categorize as 'Low'; between 30,000 and 40,000 as 'Medium'; above 40,000 as 'High')

select 
	first_name,
    salary,
    case
    when salary < 30000 then 'low'
    when salary between 30000 and 40000 then 'medium'
    when salary > 40000 then 'high'
    end as salary_category
    from employee_data;
    
#3. Display first_name, department, and a department classification. (If department is'IT', display 'Technical'; if 'Account', display 'Finance'; if 'Developer', 'software engineer'; otherwise, display 'Other')

select 
	first_name,
    department,
    case
    when department = 'IT' then 'Technical'
    when department = 'Account' then 'Finance'
    when department = 'Developer' then 'Software Engineer'
    else 'other'
    end as department_classifiaction 
    from employee_data;
    
#4. Display first_name, salary, and eligibility for a salary raise. (If salary is less than 30,000, mark as 'Eligible for Raise'; otherwise, 'Not Eligible'

select 
	first_name,
    salary,
    case
    when salary < 40000 then 'eligible for rise'
    else 'not eligible for rise'
    end as salary_status
    from employee_data;
    
#5.  Display first_name, joining_date, and employment status. (If joining date is before '2022-01-01', mark as 'Experienced'; otherwise, 'New Hire')

select 
	first_name,
    joined_date,
    case 
    when joined_date < '2022-01-01' then 'experienced'
    else 'new hire'
    end as employee_status
    from employee_data;
    
#6.  Display first_name, salary, and bonus amount. (If salary is above 60,000, add10% bonus; if between 50,000 and 60,000, add 7%; otherwise, 5%)

select 
	first_name,
    salary,
    case
    when salary > 40000 then salary * 0.10
    when salary between 30000 and 40000 then salary * 0.07
    else 'salary' * 0.05
    end as bonus_ammount
    from employee_data;
    
#7. Display first_name, salary, and seniority level. 8. (If salary is greater than 60,000, classify as 'Senior'; between 50,000 and 60,000 as'Mid-Level'; below 50,000 as 'Junior')
 

select 
	first_name,
    salary,
    case
    when salary < 35000 then 'junior'
    when salary between 35000 and 40000 then 'mid-level'
    else 'senior'
    end as seniority_level
    from employee_data;
    
#11. Display first_name, department, and job level for IT employees. (If department is 'IT'and salary is greater than 45,000, mark as 'Senior IT Employee'; otherwise, 'Other').

select
	first_name,
    department,
    case
    when department = 'IT' and salary > 45000 then 'Senior IT Employee'
    else 'other'
    end as job_level
    from employee_data
    where department = 'IT';
    
#12. Display first_name, joining_date, and recent joiner status. (If an employee joined after '2023-01-01', label as 'Recent Joiner'; otherwise, 'Long-Term Employee')

select 
	first_name,
    joined_date,
    case
    when joined_date > '2023-01-01' then 'recent joiner'
    else 'long term employee'
    end as recent_joiner_status
    from employee_data;
    
#13.  Display first_name, joining_date, and leave entitlement. (If joined before '2021-0101', assign '10 Days Leave'; between '2021-01-01' and '2023-01-01', assign '20 DaysLeave'; otherwise, '25 Days Leave')

select
	first_name,
    joined_date,
    case
    when joined_date < '2021-01-01' then '10 days leave'
    when joined_date between '2021-01-01' and '2023-01-01' then '20 days leave'
    else '25 days leave'
    end as leave_entitlement
    from employee_data;
    
#14. Display first_name, salary, department, and promotion eligibility. (If salary is above 40,000 and department is 'IT', mark as 'Promotion Eligible'; otherwise, 'Not Eligible')

select 
	first_name,
    salary,
    department,
    case 
    when salary > 40000 and department = 'IT' then 'Promotion eligible'
    else 'not eligible'
    end as promotion_eligibility
    from employee_data;
    
#15.  Display first_name, salary, and overtime pay eligibility. (If salary is below 35,000, mark as 'Eligible for Overtime Pay'; otherwise, 'Not Eligible')

select 
	first_name,
    salary,
    case
    when salary < 35000 then 'eligible for overtime pay'
    else 'not eligible'
    end as over_time_eligibility
    from employee_data;
    
#16. Display first_name, department, salary, and job title. (If department is 'Analyst' and salary is above 45,000, mark as 'Senior Analyst'; if department is 'Account' and salary is above 35,000, mark as 'Finance Manager'; otherwise, 'Regular Employee')

select	
	first_name,
    department,
    salary,
    case 
    when department = 'Analyst' and salary > 45000 then 'Senior Analyst'
    when department = 'Account' and salary > 35000 then 'Finance Manager'
    else 'Regular employee'
    end as job_title
    from employee_data;
    
#17. Display first_name, salary, and salary comparison to the company average. (If salary is above the company’s average salary, mark as 'Above Average'; otherwise, 'BelowAverage')
	
select
	first_name,
    salary,
    case
    when salary > ( select avg(salary) from employee_data) then 'Above average'
    else 'below average'
    end as salary_comparison
    from employee_data;
    
# Group by

#1. Write the query to get the department and department wise total(sum) salary,display it in ascending and descending order according to salary.

select
department,
sum(salary) as total_salary
from employee_data
group by department 
order by total_salary asc;

select
department,
sum(salary) as total_salary
from employee_data
group by department
order by total_salary desc;

#2. Write down the query to fetch Project name assign to more than one Employee

#3. Write the query to get the department, total no. of departments, total(sum) salary with respect to department from "employee table" table. 

select 
department,
count(*) as total_employees,
sum(salary) as total_salary
from employee_data
group by department;

#4. Get the department-wise salary details from the "employee table" table: 4.
 #What is the average salary? (Order by salary ascending)
 #What is the maximum salary? (Order by salary ascending)
 
 select 
 department,
 avg(salary) as avg_salary
 from employee_data
 group by department
 order by avg_salary asc;
 
 select 
 department,
 max(salary) as max_salary
 from employee_data
 group by department
 order by max_salary asc;
 
 #5. Display department-wise employee count and categorize based on size. (If a department has more than 2 employees, label it as 'Large'; between 1 and 2 as 'Medium'; otherwise, 'Small')
 
 select
 department,
 count(*) as employee_count,
 case 
 when count(*) > 2 then 'large'
 when count(*) between 1 and 2 then 'medium'
 else 'small'
 end as dep_size
 from employee_data
 group by department;
 
 #6.  Display department-wise average salary and classify pay levels. (If the average salary in a department is above 40,000, label it as 'High Pay'; between 30,000 and 40,000 as 'Medium Pay'; otherwise, 'Low Pay')
 
 select
 department,
 avg(salary) as avg_salary,
 case
 when avg(salary) > 40000 then 'high pay'
 when avg(salary) between 30000 and 40000 then 'medium pay'
 else 'low pay'
 end as pay_level
 from employee_data
 group by department;
 
 #7. Display department, gender, and count of employees in each category. (Group by department and gender, showing total employees in each combination)
 
 select
 department,
 gender,
 count(*) as employee
 from employee_data
 group by department, gender
 order by department, gender;
 
 #8. Display the number of employees who joined each year and categorize hiring trends. (If a
    #year had more than 5 hires, mark as 'High Hiring'; 3 to 5 as 'Moderate Hiring'; otherwise,
     #'Low Hiring'

select
year(joined_date) as joining_year,
count(*) as total_hiers,
case
when count(*) > 2 then 'high hiring'
when count(*) between 1 and 2 then 'medium hiring'
else 'low hiring'
end as hiring_trend 
from employee_data
group by year(joined_date)
order by joining_year;

#9. Display department-wise highest salary and classify senior roles. (If the highest salary in a
    #department is above 45,000, label as 'Senior Leadership'; otherwise, 'Mid-Level')

select
department,
max(salary) as highest_salary,
case 
when max(salary) > 45000 then 'senior leadership'
else 'mid-level'
end as role_classification
from employee_data
group by department
order by highest_salary;

#10. Display department-wise count of employees earning more than 40,000. (Group employees by department and count those earning above 40,000, labeling departments with more than 2 such employees as 'High-Paying Team')

select
department,
count(*) as employees_above_40k,
case
when count(*) > 2 then 'high-paying-team'
else 'regular team'
end as team_category
from employee_data
where salary > 40000
group by department
order by employees_above_40k;

# Date time related queries

#1. Query to extract the below things from joining_date column. (Year, Month, Day, Current Date

select 
first_name,
year(joined_date) as join_year,
month(joined_date) as join_month,
day(joined_date) as join_day,
curdate() as cur_date
from employee_data;

#2.  Create two new columns that calculate the difference between joining_date and the
 #current date. One column should show the difference in months, and the other should show the difference in days
 
 select
 first_name,
 joined_date,
 timestampdiff(month, joined_date, curdate()) as diff_in_months,
 datediff(curdate(), joined_date) as diff_in_days
 from employee_data;
 
 #3. Get all employee details from the employee table whose joining year is 2020
 
 select * from employee_data
 where year(joined_date) = 2020;
 
 #4.Get all employee details from the employee table whose joining month is Feb
 
 select * from employee_data
 where month(joined_date) = 2;
 
 #5.  Get all employee details from employee table whose joining date between "2021-01-01" and "2021-12-01"
 
 select * from employee_data
 where joined_date between '2021-01-01' and '2021-12-01';