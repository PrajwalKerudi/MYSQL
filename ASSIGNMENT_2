create database employee1;

use employee1;

CREATE TABLE employee1_data (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    bonus DECIMAL(10,2),
    joining_date DATE,
    project_id INT,
    project_name VARCHAR(100),
    project_status VARCHAR(20)   -- e.g., 'Ongoing', 'Completed'
);

show tables;

INSERT INTO employee1_data 
(emp_id, first_name, last_name, department, salary, bonus, joining_date, project_id, project_name, project_status) 
VALUES
(1, 'Alice',   'Smith',    'IT',      60000, 5000, '2015-03-01', 101, 'AI System',          'Ongoing'),
(2, 'Bob',     'Johnson',  'IT',      55000, 4000, '2018-07-15', 102, 'Web App',            'Completed'),
(3, 'Charlie', 'Williams', 'HR',      50000, 3000, '2012-09-10', 103, 'Recruitment Portal', 'Ongoing'),
(4, 'David',   'Brown',    'HR',      65000, 6000, '2016-11-05', 104, 'Payroll System',     'Completed'),
(5, 'Eva',     'Taylor',   'Finance', 70000, 7000, '2014-01-20', 105, 'Finance Dashboard',  'Ongoing'),
(6, 'Frank',   'Anderson', 'Finance', 72000, 8000, '2019-06-30', 106, 'Audit Tool',         'Completed'),
(7, 'Grace',   'Lee',      'IT',      58000, 3500, '2020-02-15', 109, 'Security Upgrade',   'Completed');

select * from employee1_data;

#1. Find the total salary paid per department and rank them in descending order of total salary.
select 
	department,
    sum(salary) as total_salary
from 
    employee1_data
group by
    department
order by 
	total_salary desc;

#2. List employees who have worked on more than one project.
select
	emp_id,
	first_name,
	last_name,
	department,
	count(distinct project_id) as project_count
from
	employee1_data
group by
	emp_id,first_name,last_name,department
having 
	count(distinct project_id) >1;

#3.Find employees who are working on ongoing projects and order them by salary (highest first).

select
	emp_id,
    first_name,
    last_name,
    department,
    salary,
    project_name,
    project_status
from 
	employee1_data
where 
	project_status = 'Ongoing'
order by 
	salary desc;
    
#4.Find the most experienced employee in each department. 

select
	department,
    emp_id,
    first_name,
    last_name,
    joining_date
    
from
	employee1_data e
where joining_date = (
	select min(joining_date)
	from employee1_data
    where department = e.department
);

#5.  Find employees whose salary is above the average salary of their department.

select
	emp_id,
	first_name,
	last_name,
	department,
	salary
from 
	employee1_data e
where salary > (
	select avg(salary)
    from employee1_data
    where department = e.department
);
	
#6. Rank departments based on total salary + bonus, and rank employees within departments based on total compensation

# Rank Departments by Total Salary + Bonus

select 
	department,
    sum(salary + bonus) as total_compensation,
    rank() over (order by sum(salary+bonus) desc) as dept_rank
from 
	employee1_data
group by	
	department;

# Rank Employees Within Departments by Total Compensation

select
	department,
    emp_id,
    first_name,
    last_name,
    (salary+bonus) as total_compensation,
    rank() over (partition by department order by(salary+bonus) desc )as emp_rank
from
	employee1_data
order by
	department, emp_rank;
    
#7.  Rank employees based on number of projects + average project duration and rank departments based on average project duration 

# Rank employees

with emp_stats as(
	select
		emp_id,
        first_name,
        last_name,
        department,
        count(distinct project_id) as project_count,
        avg(datediff(project_end, project_start)) as avg_duration
	from employee1_data
	group by emp_id, first_name, last_name, department
)
select
	emp_id,
    first_name,
    last_name,
    department,
    project_count,
    avg_duration,
    rank() over (order by project_count desc, avg_duration desc) as emp_rank
from emp_stats;
		
# Rank departments

with dept_stats as(
	select 
		department,
        avg(datediff(project_end, project_start)) as dept_avg_duration
	from employee1_data
    group by department
)
select 
	department,
    dept_avg_duration,
    rank() over (order by dept_avg_duration desc) as dept_rank
from dept_stats;

#8. Rank project managers based on number of employees under them and rank employees within project based on salary

#Rank Project Managers by number of employees under them

with manage_stats as(
	select 
		manager_id,
        count(distinct emp_id) as emp_count
	from employee1_data
    group by manager_id
)
select
	m.manager_id,
    e.first_name as manager_first,
    e.last_name as manager_last,
    emp_count,
    rank() over (order by emp_count desc) as manager_rank
from manager_stats m
join employee1_data e on m.manager_id = e.emp_id;

#Rank Employees within each project by salary

select
	project_id,
    project_name,
    emp_id, 
    first_name,
    last_name,
    salary,
    rank() over (partition by project_id order by salary desc) as emp_rank_in_project
from employee1_data
order by project_id, emp_rank_in_project;
    
#9. Rank departments by total bonus distributed, and within each department, rank employees based on bonus received

#.Rank departments by total bonus

WITH dept_bonus AS (
    SELECT 
        department,
        SUM(bonus) AS total_bonus
    FROM employee1_data
    GROUP BY department
),
dept_ranked AS (
    SELECT
        department,
        total_bonus,
        RANK() OVER (ORDER BY total_bonus DESC) AS dept_rank
    FROM dept_bonus
)
SELECT * 
FROM dept_ranked;

#Rank employees within each department by bonus

select
	e.department,
    dr .total_bonus,
    dr .dept_rank,
    e.emp_id,
    e.first_name,
    e.last_name,
    e.bonus,
    rank() over (partition by e.department order by e.bonus desc) as emp_bonus_rank
from employee1_data e
join dept_ranked dr on e.department = dr.department
order by dr.dept_rank, emp_bonus_rank;

#10. Rank employees based on years of experience and project count, and rank departments based on average experience

# Rank Employees

with emp_stats as(
	select
		emp_id,
        first_name,
        last_name,
        department,
        timestampdiff(year, joining_date, curdate()) as year_experience,
        count(distinct project_id) as project_count
	from employee1_data
    group by emp_id, first_name, last_name, department, joining_date
)
select 
	emp_id,
    first_name,
    last_name,
    department,
    years_experience,
    project_count,
    rank() over (order by years_experience desc, project_count desc) as emp_rank
from emp_stats;

#Rank Departments by Avg Experience

with dept_exp as (
	select
		department,
        avg(timestampdiff(year, joining_date, curdate())) as avg_experience
        
	from employee1_data 
    group by department
)
select 
	department,
    avg_experience,
    rank() over (order by avg_experience desc) as dept_rank
from dept_exp;

#. CTEs Basic Problems 

#1. Write a CTE that retrieves employees along with their department and project details. 

with emp_project_cte as (
	select
		emp_id,
        first_name,
        last_name,
        department,
        salary,
        bonus,
        joining_date,
        project_id,
        project_name,
        project_status
	from employee1_data
)
select
		emp_id,
        first_name,
        last_name,
        department,
        project_id,
        project_name,
        project_status
from emp_project_cte
order by department, project_name 

#2. Use a CTE to find employees who have worked on more than one project

with emp_project_count AS (
	select
		emp_id,
        first_name,
        last_name,
        department,
        count(distinct project_id) as project_count
	from employee1_data
    group by emp_id, first_name, last_name, department
)
select
	emp_id,
    first_name,
    last_name,
    department,
    project_count
from emp_project_count
where project_count > 1;

#3. Create a CTE to find employees earning more than the average salary of their department

with dept_avg as (
	select
		department,
        avg(salary) as avg_salary
	from employee1_data
    group by department
)
select
	e.emp_id,
    e.first_name,
    e.last_name,
    e.department,
    e.salary,
    d.avg_salary
from employee1_data e
join dept_avg d
	on e.department = d.department
where e.salary > d.avg_salary
order by e.department, e.salary desc

#4. Use a CTE and JOINs to fetch employees who joined in the last two years along with their project names

with recent_emps as (
	select
		emp_id,
        first_name,
        last_name,
        department,
        joining_date,
        project_id
	from employee1_data
    where joining_date >= date_sub(curdate(), interval 2 year)
)
select
	r.emp_id,
    r.first_name,
    r.last_name,
    r.department,
    r.joining_date,
    p.project_name
from recent_emps r
join project p
	on r.project_id = p.project_id
order by r.joining_date desc;
    
#5. Create a CTE to calculate department-wise salary statistics (sum, avg, max). 

with dept_salary_stats as (
	select
		department,
        sum(salary) as total_salary,
        avg(salary) as avg_salary,
        max(salary) as max_salary
	from employee1_data
    group by department 
)
select
	department,
    total_salary,
    avg_salary,
    max_salary
from dept_salary_stats
order by total_salary desc;

#6.  Use a CTE with RANK() to find the top 5 highest-paid employees. 

with ranked_emps as(
	select
		emp_id,
        first_name,
        last_name,
        department,
        salary,
        rank() over (order by salary desc) as salary_rank
	from employee1_data
)
select
	emp_id,
    first_name,
    last_name,
    department,
    salary,
    salary_rank
from ranked_emps
where salary_rank <= 5
order by salary_rank;

#7.  Write a CTE to find employees who have the longest tenure in their department.

with ranked_emps as (
	select
		emp_id,
        first_name,
        last_name,
        department,
        joining_date,
	rank() over (partition by department order by joining_date asc) as tenure_rank
    from employee1_data
)
select
	emp_id,
    first_name,
    last_name,
    department,
    joining_date
from ranked_emps
where tenure_rank = 1
order by department;

#8. Use a CTE with GROUP BY to count employees by department and classify them as Small, Medium, or Large

with dept_count as (
	select
		department,
        count(emp_id) as emp_count
	from employee1_data
    group by department
)
select
	department,
    emp_count,
    case
		when emp_count <= 3 then "small"
        when emp_count between 4 and 6 then "medium"
        else "large"
	end as dept_size
from dept_count
order by emp_count desc;
    
#9. Create a recursive CTE to find employees with a reporting hierarchy.

with recursive emp_hirarchy as(
	select
		emp_id,
        first_name,
        last_name,
        department,
        manager_id,
        0 as level
	from employee1_data
    where manager_id is null

	union all
    
    select
		e.emp_id,
        e.first_name,
        e.last_name,
        e.department,
        e.manager_id,
        h.level + 1 as level
	from employee1_data e
	inner join emp_hirarchy h
		on e.emp_id = h.emp_id
)
select *
from emp_hirarchy
order by level, manager_id, emp_id;

#10. Write a query that uses a CTE, JOINs, and RANK() to find the second-highest-paid employee in each department.

with emp_ranked as (
	select
		emp_id,
        first_name,
        last_name,
        department,
        salary,
        rank() over (partition by department order by salary desc) as salary_rank
	from employee1_data
)
select
	emp_id,
    first_name,
    last_name,
    department,
    salary,
    salary_rank
from emp_ranked
where salary_rank = 2
order by department;

# Advanced CTE

#1. Find departments with total compensation (salary + bonus) > 300,000 and rank employees within those departments by compensation

#Calculate total department compensation

with dept_total_comp as (
	select
		department,
        sum(salary + bonus) as dept_comp
	from employee1_data
    group by department
    having sum(salary + bonus) > 300000
),
#Rank employees within these departments by total compensation
emp_ranked as (
	select
		e.emp_id,
        e.first_name,
        e.last_name,
        e.department,
        e.salary,
        e.bonus,
        (e.salary+e.bonus) as total_comp,
        rank() over (partition by e.department order by (e.salary + e.bonus) desc) as emp_rank
	from employee1_data e
    join dept_total_comp d
		on e.department = d.department
)
select * 
from emp_ranked
order by department, emp_rank;

#2. Find departments where average experience > 3 years and within those departments, rank employees by project count. 

#Calculate department average experience
with dept_avg_exp as (
	select
		department,
        avg(timestampdiff(year, joining_date, curdate())) as avg_exp
	from employee1_data
    group by department
    having avg(timestampdiff(year, joining_date, curdate())) > 3
),
#Count projects per employee in filtered departments and rank
emp_project_rank as (
	select
		e.emp_id,
        e.first_name,
        e.last_name,
        e.department,
        count(distinct e.project_id) as project_count,
        rank() over (partition by e.department order by count(distinct e.project_id) desc)as emp_rank
	from employee1_data e 
    join dept_avg_exp d
		on e.department = d.department
	group by emp_id, e.first_name, e.last_name, e.department
)
select * 
from emp_project_rank
order by department, emp_rank;
        
#3. Identify project managers (department heads) whose department's total bonus exceeds 50,000, rank departments and rank employees in those departments by bonus. 

with dept_bonus as (
	select
		department,
        manager_id,
        sum(bonus) as total_bonus
	from employee1_data
    group by department, manager_id
    having sum(bonus) > 50000
),
#Rank departments by total bonus
dept_ranked as (
	select	
		department,
		manager_id,
        total_bonus,
        rank() over (order by total_bonus desc) as dept_rank
	from dept_bonus
),
#Rank employees within these departments by bonus
emp_ranked as(
	select
		e.emp_id,
        e.first_name,
        e.last_name,
        e.department,
        e.manager_id,
        e.bonus,
        rank() over (partition by e.department order by e.bonus desc) as emp_rank
	from employee1_data e
    join dept_ranked d
     on e.department = d.department
)
select *
from emp_ranked
order by dept_rank, emp_rank;
        
#4. Find top 2 departments based on avg project duration and rank employees within departments based on joining date (experience). 

#Calculate average project duration per department
WITH dept_avg_duration AS (
    SELECT
        department,
        AVG(DATEDIFF(end_date, start_date)) AS avg_duration
    FROM projects
    GROUP BY department
),
#Rank departments and filter top 2
top_departments AS (
    SELECT
        department,
        avg_duration,
        RANK() OVER (ORDER BY avg_duration DESC) AS dept_rank
    FROM dept_avg_duration
    WHERE avg_duration IS NOT NULL
)
#Rank employees in those departments by joining_date (experience)
SELECT
    e.emp_id,
    e.first_name,
    e.last_name,
    e.department,
    t.avg_duration,
    t.dept_rank,
    e.joining_date,
    RANK() OVER (PARTITION BY e.department ORDER BY e.joining_date ASC) AS emp_experience_rank
FROM employee1_data e
JOIN top_departments t
    ON e.department = t.department
WHERE t.dept_rank <= 2
ORDER BY t.dept_rank, emp_experience_rank;

#5. Find employees who worked on more than one completed project, belong to departments with avg salary > 55k, and rank them by salary and project count. 

#Find departments with avg salary > 55k
WITH dept_high_salary AS (
    SELECT 
        department,
        AVG(salary) AS avg_salary
    FROM employee1_data
    GROUP BY department
    HAVING AVG(salary) > 55000
),
#Find employees who worked on completed projects and count them
emp_completed_projects AS (
    SELECT 
        e.emp_id,
        e.first_name,
        e.last_name,
        e.department,
        e.salary,
        COUNT(DISTINCT e.project_id) AS completed_project_count
    FROM employee1_data e
    JOIN projects p 
        ON e.project_id = p.project_id
    WHERE p.status = 'Completed'
    GROUP BY e.emp_id, e.first_name, e.last_name, e.department, e.salary
    HAVING COUNT(DISTINCT e.project_id) > 1
),
#Rank employees by salary and project count in valid departments
emp_ranked AS (
    SELECT 
        ep.emp_id,
        ep.first_name,
        ep.last_name,
        ep.department,
        ep.salary,
        ep.completed_project_count,
        RANK() OVER (ORDER BY ep.salary DESC, ep.completed_project_count DESC) AS emp_rank
    FROM emp_completed_projects ep
    JOIN dept_high_salary d
        ON ep.department = d.department
)
SELECT *
FROM emp_ranked
ORDER BY emp_rank;

#6. Find departments where total number of employees > 5 and rank employees by total compensation (salary + bonus) & experience.

#Find departments with more than 5 employees
WITH dept_large AS (
    SELECT 
        department,
        COUNT(*) AS emp_count
    FROM employee1_data
    GROUP BY department
    HAVING COUNT(*) > 5
),
#Add compensation and experience for employees
emp_comp_exp AS (
    SELECT
        e.emp_id,
        e.first_name,
        e.last_name,
        e.department,
        (e.salary + e.bonus) AS total_compensation,
        TIMESTAMPDIFF(YEAR, e.joining_date, CURDATE()) AS experience
    FROM employee1_data e
),
#Rank employees in valid departments
ranked_emps AS (
    SELECT
        ec.emp_id,
        ec.first_name,
        ec.last_name,
        ec.department,
        ec.total_compensation,
        ec.experience,
        RANK() OVER (
            PARTITION BY ec.department 
            ORDER BY ec.total_compensation DESC, ec.experience DESC
        ) AS emp_rank
    FROM emp_comp_exp ec
    JOIN dept_large d
        ON ec.department = d.department
)
-- Final Output
SELECT *
FROM ranked_emps
ORDER BY department, emp_rank;

#7. Identify employees who worked in more than 2 projects, belong to departments where the dept head name starts with 'M', and rank by salary & number of projects.

WITH emp_project_count AS (
#Count number of projects per employee
    SELECT
        emp_id,
        first_name,
        last_name,
        department,
        salary,
        COUNT(DISTINCT project_id) AS project_count
    FROM employee1_data
    GROUP BY emp_id, first_name, last_name, department, salary
),
filtered_depts AS (
#Keep only departments where dept head starts with 'M'
    SELECT DISTINCT department
    FROM employee1_data
    WHERE dept_head LIKE 'M%'
),
ranked_emps AS (
#Join & rank employees
    SELECT
        e.emp_id,
        e.first_name,
        e.last_name,
        e.department,
        e.salary,
        e.project_count,
        RANK() OVER (
            ORDER BY e.salary DESC, e.project_count DESC
        ) AS emp_rank
    FROM emp_project_count e
    JOIN filtered_depts d
        ON e.department = d.department
    WHERE e.project_count > 2
)
-- Final output
SELECT *
FROM ranked_emps
ORDER BY emp_rank;

#8. Find departments where total project count > 5, calculate average project duration, rank departments by duration, and rank employees within departments by number of completed projects

WITH dept_projects AS (
#Count projects per department and calculate average duration
    SELECT
        department,
        COUNT(DISTINCT project_id) AS total_projects,
        AVG(DATEDIFF(project_end, project_start)) AS avg_project_duration
    FROM employee1_data
    GROUP BY department
    HAVING COUNT(DISTINCT project_id) > 5
),
dept_ranked AS (
#Rank departments by average project duration
    SELECT
        department,
        total_projects,
        avg_project_duration,
        RANK() OVER (ORDER BY avg_project_duration DESC) AS dept_rank
    FROM dept_projects
),
emp_completed_projects AS (
#Count completed projects per employee
    SELECT
        emp_id,
        first_name,
        last_name,
        department,
        COUNT(DISTINCT project_id) AS completed_projects
    FROM employee1_data
    WHERE project_status = 'Completed'
    GROUP BY emp_id, first_name, last_name, department
),
emp_ranked AS (
#Rank employees within departments by completed projects
    SELECT
        e.emp_id,
        e.first_name,
        e.last_name,
        e.department,
        e.completed_projects,
        RANK() OVER (
            PARTITION BY e.department ORDER BY e.completed_projects DESC
        ) AS emp_rank
    FROM emp_completed_projects e
    JOIN dept_ranked d
        ON e.department = d.department
)
#Final Output
SELECT 
    d.department,
    d.total_projects,
    d.avg_project_duration,
    d.dept_rank,
    e.emp_id,
    e.first_name,
    e.last_name,
    e.completed_projects,
    e.emp_rank
FROM dept_ranked d
JOIN emp_ranked e
    ON d.department = e.department
ORDER BY d.dept_rank, e.emp_rank;

#9. Find employees who received bonuses greater than department average bonus, rank departments by total bonus, and rank employees by salary + bonus.

WITH dept_bonus_stats AS (
#Calculate dept avg and total bonus
    SELECT
        department,
        AVG(bonus) AS avg_bonus,
        SUM(bonus) AS total_bonus
    FROM employee1_data
    GROUP BY department
),
emp_above_avg AS (
#Find employees with bonus > dept avg
    SELECT
        e.emp_id,
        e.first_name,
        e.last_name,
        e.department,
        e.salary,
        e.bonus,
        (e.salary + e.bonus) AS total_comp
    FROM employee1_data e
    JOIN dept_bonus_stats d
        ON e.department = d.department
    WHERE e.bonus > d.avg_bonus
),
dept_ranked AS (
#Rank departments by total bonus
    SELECT
        department,
        total_bonus,
        RANK() OVER (ORDER BY total_bonus DESC) AS dept_rank
    FROM dept_bonus_stats
),
emp_ranked AS (
#Rank employees by salary + bonus
    SELECT
        e.emp_id,
        e.first_name,
        e.last_name,
        e.department,
        e.salary,
        e.bonus,
        e.total_comp,
        RANK() OVER (
            PARTITION BY e.department ORDER BY e.total_comp DESC
        ) AS emp_rank
    FROM emp_above_avg e
)
#Final Output
SELECT 
    d.department,
    d.total_bonus,
    d.dept_rank,
    e.emp_id,
    e.first_name,
    e.last_name,
    e.salary,
    e.bonus,
    e.total_comp,
    e.emp_rank
FROM dept_ranked d
JOIN emp_ranked e
    ON d.department = e.department
ORDER BY d.dept_rank, e.emp_rank;

#10. Find departments where the department head's name contains 'a', average employee experience > 4 years, and rank employees within those departments by project count and total compensation (salary + bonus)
WITH dept_experience AS (
#Calculate average experience per department
    SELECT
        department,
        dept_head,
        AVG(TIMESTAMPDIFF(YEAR, joining_date, CURDATE())) AS avg_experience
    FROM employee1_data
    GROUP BY department, dept_head
    HAVING dept_head LIKE '%a%'   -- filter dept heads containing 'a'
       AND AVG(TIMESTAMPDIFF(YEAR, joining_date, CURDATE())) > 4
),
emp_project_comp AS (
#Calculate project count and total compensation per employee
    SELECT
        emp_id,
        first_name,
        last_name,
        department,
        COUNT(DISTINCT project_id) AS project_count,
        (salary + bonus) AS total_comp
    FROM employee1_data
    GROUP BY emp_id, first_name, last_name, department, salary, bonus
),
emp_ranked AS (
#Rank employees within valid departments
    SELECT
        e.emp_id,
        e.first_name,
        e.last_name,
        e.department,
        e.project_count,
        e.total_comp,
        RANK() OVER (
            PARTITION BY e.department
            ORDER BY e.project_count DESC, e.total_comp DESC
        ) AS emp_rank
    FROM emp_project_comp e
    JOIN dept_experience d
        ON e.department = d.department
)
#Final Output
SELECT 
    d.department,
    d.dept_head,
    d.avg_experience,
    e.emp_id,
    e.first_name,
    e.last_name,
    e.project_count,
    e.total_comp,
    e.emp_rank
FROM dept_experience d
JOIN emp_ranked e
    ON d.department = e.department
ORDER BY d.avg_experience DESC, e.emp_rank;
