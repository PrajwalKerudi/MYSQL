# MYSQL
MySQL Employee Database Operations
This repository contains a collection of SQL queries demonstrating various operations on an employee table in MySQL. It covers database creation, table management, data insertion, selection, manipulation, and advanced querying techniques using built-world examples.

Table of Contents
Prerequisites

Database Setup

Data Insertion

Table Management

Data Selection & Filtering

String & Character Functions

Aggregate Functions

Troubleshooting

1. Prerequisites
To run these SQL queries, you will need:

A MySQL server installed and running.

A MySQL client (e.g., MySQL Workbench, DBeaver, or the MySQL command-line client).

2. Database Setup
These commands set up the database and create the employee table.

-- Create a new database named 'assignment1'
CREATE DATABASE assignment1;

-- Switch to the newly created database
USE assignment1;

-- Create the 'employee' table with specified columns and data types
CREATE TABLE employee (
    emp_id INT(3) PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    salary DECIMAL,
    joining_date DATE,
    department VARCHAR(20),
    gender VARCHAR(20),
    job_title VARCHAR(20)
);

-- Verify the table structure (optional)
DESCRIBE employee;

3. Data Insertion
After creating the table, it's initially empty. Use the following INSERT statements to populate it with sample data, which is necessary for the subsequent queries to return results.

-- Insert sample data into the 'employee' table
INSERT INTO employee (emp_id, first_name, last_name, salary, joining_date, department, gender, job_title) VALUES
(101, 'John', 'Doe', 60000.00, '2023-01-15', 'Sales', 'Male', 'Sales Manager'),
(102, 'Jane', 'Smith', 75000.00, '2022-03-20', 'Marketing', 'Female', 'Marketing Specialist'),
(103, 'Peter', 'Jones', 50000.00, '2024-02-01', 'HR', 'Male', 'HR Assistant'),
(104, 'Mary', 'Johnson', 90000.00, '2021-08-10', 'Sales', 'Female', 'Senior Sales Rep'),
(105, 'Malli', 'G', 50000.00, '2020-09-20', 'IT', 'Male', 'Software Engineer'),
(106, 'Anjali', 'Sharma', 62000.00, '2022-11-05', 'HR', 'Female', 'HR Specialist'),
(107, 'Vikas', 'Kumar', 80000.00, '2021-06-25', 'IT', 'Male', 'Project Lead'),
(108, 'Nikita', 'Singh', 70000.00, '2023-04-12', 'Marketing', 'Female', 'Marketing Analyst'),
(109, 'Ashish', 'Verma', 55000.00, '2024-01-01', 'Sales', 'Male', 'Sales Associate'),
(110, 'Meena', 'Patel', 68000.00, '2022-09-18', 'Finance', 'Female', 'Accountant');

4. Table Management
These commands demonstrate how to clone a table and add a new column.

-- Create a clone of the 'employee' table (structure and data if 'employee' has data)
-- Note: If 'employee' is empty, 'employee_clone' will also be empty.
CREATE TABLE employee_clone AS SELECT * FROM employee;

-- View all records in the cloned table
SELECT * FROM employee_clone;

-- Add a new column 'full_name' to the 'employee' table
ALTER TABLE employee ADD COLUMN full_name VARCHAR(30);

-- Temporarily disable MySQL's safe update mode to allow updates without a WHERE clause on a key column.
-- Use with caution, as it allows mass updates/deletes.
SET SQL_SAFE_UPDATES = 0;

-- Update the 'full_name' column by concatenating 'first_name' and 'last_name'
UPDATE employee SET full_name = CONCAT(first_name, ' ', last_name);

-- Re-enable MySQL's safe update mode for safety
SET SQL_SAFE_UPDATES = 1;

5. Data Selection & Filtering
These queries show various ways to select and filter data from the employee table.

-- View all records in the 'employee' table
SELECT * FROM employee;

-- Select only the first record from the 'employee' table
SELECT * FROM employee LIMIT 1;

-- Select the last record from the 'employee' table (assuming emp_id is sequential)
SELECT * FROM employee ORDER BY emp_id DESC LIMIT 1;

-- Select a random record from the 'employee' table (can be slow on large tables)
SELECT * FROM employee ORDER BY RAND() LIMIT 1;

-- Select all employees with salary greater than 50000
SELECT * FROM employee WHERE salary > 50000;

-- Select employees whose first name is 'malli'
SELECT * FROM employee WHERE first_name = 'Malli';

-- Select employees whose first name is 'malli', 'meena', or 'anjali'
SELECT * FROM employee WHERE first_name IN ('Malli','Meena','Anjali');

-- Select employees whose first name starts with 'v'
SELECT * FROM employee WHERE first_name LIKE 'V%';

-- Select employees whose first name ends with 'i'
SELECT * FROM employee WHERE first_name LIKE '%i';

-- Select employees whose first name contains 'o'
SELECT * FROM employee WHERE first_name LIKE '%o%';

-- Select employees whose first name starts with 'm' and has exactly 5 characters
SELECT * FROM employee WHERE first_name LIKE 'M____';

-- Select all unique department names
SELECT DISTINCT(department) FROM employee;

-- **Note on incomplete query:**
-- The query `select * from employee where joining_date;` is incomplete.
-- To filter by joining date, you would typically use comparison operators.
-- Example: Select employees who joined after a specific date:
-- SELECT * FROM employee WHERE joining_date > '2022-01-01';

6. String & Character Functions
These queries demonstrate the use of various string manipulation functions.

-- Convert first_name and last_name to uppercase
SELECT UPPER(first_name) AS first_name_upper, UPPER(last_name) AS last_name_upper
FROM employee;

-- Concatenate 'hello ' with first_name for each employee
SELECT CONCAT('hello ', first_name) AS greeting
FROM employee;

-- Extract the first character and concatenate with the rest of the first_name
-- This effectively returns the original first_name.
SELECT CONCAT(SUBSTRING(first_name, 1, 1), SUBSTRING(first_name, 2, LENGTH(first_name))) AS full_first_name
FROM employee;

-- Demonstrate TRIM functions (RTRIM, LTRIM, TRIM)
-- Note: For these to show a difference, your data would need leading/trailing spaces.
SELECT
    RTRIM(first_name) AS right_trimmed,
    LTRIM(first_name) AS left_trimmed,
    TRIM(first_name) AS fully_trimmed
FROM employee;

7. Aggregate Functions
These queries perform calculations across groups of rows.

-- Count the total number of employees
SELECT COUNT(*) AS total_employees FROM employee;

-- Display all employee names in one cell separated by ', '
SELECT GROUP_CONCAT(first_name SEPARATOR ', ') AS all_employee_names
FROM employee;

-- Calculate min, max, average salary, absolute salary difference, and percentage difference
SELECT
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    ROUND(AVG(salary), 2) AS average_salary,
    ABS(MIN(salary) - MAX(salary)) AS salary_difference,
    CONCAT(ROUND((ABS(MIN(salary) - MAX(salary))) / 100, 2), '%') AS salary_diff_percentage
FROM employee;

8. Troubleshooting
Error Code: 1175. You are using safe update mode...: This error occurs in MySQL Workbench's "safe update mode" when you try to UPDATE or DELETE records without a WHERE clause that uses a key column. To bypass it for a full table update, run SET SQL_SAFE_UPDATES = 0; before your UPDATE statement, and then SET SQL_SAFE_UPDATES = 1; afterwards.

Error Code: 1054. Unknown column 'column_name' in 'field list': This typically means you forgot to include the FROM table_name clause in your SELECT or UPDATE statement, or the column name is misspelled.

SELECT ... CONCAT('hello' + first_name) returns 0: In MySQL, + is for arithmetic. For string concatenation, you must use CONCAT('hello ', first_name).
