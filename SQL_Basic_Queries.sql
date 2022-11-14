# Query to create a new database
CREATE DATABASE project_1;
USE project_1;

# Query to create new(Employees) table
CREATE TABLE employees (
  EMPLOYEE_ID int DEFAULT NULL,
  FIRST_NAME varchar(25),
  LAST_NAME varchar(25),
  EMAIL varchar(25),
  DEPARTMENT varchar(25),
  SALARY int DEFAULT NULL,
  HIRE_DATE datetime
);

# Query to insert records in a table(employees).
INSERT INTO employees (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, DEPARTMENT, SALARY, HIRE_DATE)
VALUES                (105, 'Pat', 'Fay','PFAY', 'TESTING', 6000, '2018-08-05');

# Query to fetch complete records from a table(employees).
SELECT * FROM employees;

# Write an SQL query to fetch “FIRST_NAME” from the employees table using the alias name as <WORKER_NAME>
SELECT FIRST_NAME AS WORKER_NAME FROM employees;

# Write an SQL query to fetch unique values of DEPARTMENT from the employees table.
SELECT DISTINCT DEPARTMENT FROM employees;

# Write an SQL query to show the last 5 records from a table.
(SELECT * FROM employees 
ORDER BY EMPLOYEE_ID DESC 
LIMIT 5)
ORDER BY EMPLOYEE_ID ASC;

# Write an SQL query to print the first three characters of FIRST_NAME from employees table
SELECT LEFT(FIRST_NAME,3) AS FIRST_NAME FROM employees;

# Write an SQL query to find the position of the alphabet (‘a’) in the first name
SELECT FIRST_NAME, POSITION("a" in FIRST_NAME) AS POSITION_OF_a FROM employees;

# Write an SQL query to print the name of employees who have the highest salary in each department
SELECT * FROM(
	SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT, SALARY,
	RANK() OVER(
    PARTITION BY DEPARTMENT
	ORDER BY salary DESC) AS HIGHEST_SALARY FROM employees) employees
WHERE HIGHEST_SALARY = 1;

# Write an SQL query to print the FIRST_NAME from the employees table after removing white spaces from the right side
SELECT RTRIM(FIRST_NAME) FROM employees;

# Write an SQL query that fetches the unique values of DEPARTMENT from the employees table and prints its length
SELECT DISTINCT DEPARTMENT, LENGTH(DEPARTMENT) AS LEN_DEPARTMENT FROM employees;

# Write an SQL query to fetch n max salaries from a table.
SELECT EMPLOYEE_ID,FIRST_NAME, LAST_NAME, SALARY FROM employees
ORDER BY SALARY DESC
LIMIT 5;

# Write an SQL query to print the FIRST_NAME from the Worker table after replacing ‘a’ with ‘A’.
SELECT FIRST_NAME, REPLACE(FIRST_NAME,'a','A') AS FIRST_NAME_A FROM employees;

# Write an SQL query to print all Worker details from the Worker table order FIRST_NAME Ascending and DEPARTMENT Descending.
SELECT * FROM employees
ORDER BY FIRST_NAME ASC, DEPARTMENT DESC;

# Write an SQL query to fetch the names of workers who earn the highest salary.
SELECT FIRST_NAME, LAST_NAME, SALARY FROM employees
ORDER BY SALARY DESC;

# Write an SQL query to print details of workers excluding first names, “Pat” and “Donald” from the employees table.
SELECT * FROM employees
WHERE FIRST_NAME NOT IN ('Pat','Donald');

# Write an SQL query to print details of the Workers whose FIRST_NAME ends with ‘a’ and contains six alphabets.
SELECT * FROM employees
WHERE FIRST_NAME LIKE ('%_____a');

# Write a query to validate Email of Employee (email should have first name last name and guvi.com example (first name=Kamal last name= raja and the mail id should be kamalraja@guvi.com).
SELECT * FROM employees_dup
WHERE (EMAIL REGEXP CONCAT(LOWER(RTRIM(FIRST_NAME)), LOWER(LAST_NAME), '@guvi.com')); 

# Write an SQL query to print details of the Workers who have joined in Aug’2002.
SELECT * FROM employees
WHERE HIRE_DATE BETWEEN '2002-08-01' AND  '2002-08-31';

# Write an SQL query to fetch duplicates that have matching data in some fields of a table.
SELECT * , COUNT(FIRST_NAME) AS COUNT_DUP FROM employees
GROUP BY FIRST_NAME
HAVING COUNT(FIRST_NAME) > 1;

# How to remove duplicate rows from the Employees table.
# Step1 - To fetch duplicate rows
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, DEPARTMENT, SALARY, COUNT(*) AS COUNT_DUPLICATE FROM employees_dup
GROUP BY FIRST_NAME, LAST_NAME, EMAIL, DEPARTMENT, SALARY
HAVING COUNT(*) > 1 ;

# Step2 - To delete duplicate rows
DELETE FROM employees_dup
WHERE EMPLOYEE_ID NOT IN(
	SELECT MAX(EMPLOYEE_ID) FROM (SELECT * FROM employees_dup) AS dup
    GROUP BY FIRST_NAME, LAST_NAME, EMAIL, DEPARTMENT, SALARY);

# Write an SQL query to show only odd rows from a table.
SELECT * FROM employees
WHERE MOD(EMPLOYEE_ID,2) != 0;


# Write an SQL query to clone a new table from another table.
CREATE TABLE emp_hiring_detail (
  EMPLOYEE_ID int DEFAULT NULL,
  FIRST_NAME varchar(25),
  LAST_NAME varchar(25),
  EMAIL varchar(25),
  DEPARTMENT varchar(25),
  SALARY int DEFAULT NULL,
  HIRE_DATE datetime
);
INSERT INTO emp_hiring_detail(
EMPLOYEE_ID,
  FIRST_NAME,
  LAST_NAME,
  EMAIL,
  DEPARTMENT, 
  SALARY, 
  HIRE_DATE)
SELECT * FROM employees;

# Write an SQL query to determine the nth (say n=10) highest salary from a table
SELECT * FROM
    (SELECT * FROM employees
    ORDER BY SALARY DESC
    LIMIT 10) as Nth_highest
ORDER BY SALARY ASC
LIMIT 1;

# Write an SQL query to determine the 8th highest salary without using TOP or LIMIT methods.
SELECT * FROM(
	SELECT EMPLOYEE_ID, FIRST_NAME, SALARY,
	DENSE_RANK() OVER(
	ORDER BY salary DESC) AS HIGHEST_SALARY FROM emp_salary) emp_salary
WHERE HIGHEST_SALARY = 8;

# Write an SQL query to fetch the list of employees with the same salary.
SELECT * , COUNT(SALARY) AS COUNT_DUP FROM emp_salary
GROUP BY SALARY
HAVING COUNT(SALARY) > 1;

# Write an SQL query to fetch intersecting records of two tables.
# Created 2 new tables
SELECT * FROM emp_salary;
SELECT * FROM emp_hiring_detail;

SELECT es.EMPLOYEE_ID, es.SALARY, eh.DEPARTMENT FROM emp_salary AS es
INNER JOIN emp_hiring_detail AS eh
ON es.EMPLOYEE_ID = eh.EMPLOYEE_ID;

# Write an SQL query to show records from one table that another table does not have.
SELECT eh.FIRST_NAME, es.SALARY FROM emp_salary AS es
RIGHT JOIN emp_hiring_detail AS eh
ON eh.EMPLOYEE_ID = es.EMPLOYEE_ID;