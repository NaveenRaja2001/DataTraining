
select * from EMPLOYEE;




-- 1. Write a SQL query to remove the details of an employee whose first name ends in ‘even’

delete from EMPLOYEE
where first_name like '%even';


-- 2. Write a query in SQL to show the three minimum values of the salary from the table.

select first_name,last_name, salary from EMPLOYEES
where salary in(SELECT SALARY FROM EMPLOYEES
ORDER BY SALARY ASC
LIMIT 3)
order by salary;

-- 3. Write a SQL query to remove the EMPLOYEE table from the database

DROP TABLE EMPLOYEE; //run lastly

-- 4. Write a SQL query to copy the details of this table into a new table with table name as Employee table and to delete the records in EMPLOYEE table

//TRY 1
CREATE TABLE EMPLOYEE CLONE EMPLOYEES;
TRUNCATE EMPLOYEES;

//TRY 2
CREATE TABLE EMPLOYEE AS SELECT * FROM EMPLOYEES;
TRUNCATE EMPLOYEES;


-- 5. Write a SQL query to remove the column Age from the table


ALTER TABLE EMPLOYEE 
DROP COLUMN AGE;

-- 6. Obtain the list of EMPLOYEE (their full name, email, hire_year) where they have joined the firm before 2000

SELECT CONCAT(FIRST_NAME,LAST_NAME) AS FULLNAME,EMAIL,HIRE_DATE FROM EMPLOYEE
WHERE  YEAR (HIRE_DATE) <2000;

-- 7. Fetch the employee_id and job_id of those EMPLOYEE whose start year lies in the range of 1990 and 1999

 SELECT EMPLOYEE_ID,JOB_ID,YEAR(hire_date) AS YEARS FROM EMPLOYEE
 WHERE YEARS BETWEEN 1990 AND 1999;

-- 8. Find the first occurrence of the letter 'A' in each EMPLOYEE Email ID

-- Return the employee_id, email id and the letter position

SELECT EMPLOYEE_ID,EMAIL,CHARINDEX('A',EMAIL) AS countemail FROM EMPLOYEE where countemail > 0;
SELECT EMPLOYEE_ID,EMAIL,position('a' in EMAIL) AS countemail FROM EMPLOYEE where countemail > 0;


-- 9. Fetch the list of EMPLOYEE(Employee_id, full name, email) whose full name holds characters less than 12

SELECT EMPLOYEE_ID,CONCAT(FIRST_NAME,' ',LAST_NAME) AS FULLNAME,EMAIL FROM EMPLOYEE
WHERE LENGTH(FULLNAME)<12;

-- 10. Create a unique string by hyphenating the first name, last name , and email of the EMPLOYEE to obtain a new field named UNQ_ID
-- Return the employee_id, and their corresponding UNQ_ID;

SELECT EMPLOYEE_ID,CONCAT_ws('-',FIRST_NAME,LAST_NAME,EMAIL)AS UNQ_ID FROM EMPLOYEE;

-- 11. Write a SQL query to update the size of email column to 30

ALTER TABLE EMPLOYEE
ALTER COLUMN EMAIL VARCHAR(30);

-- desc table EMPLOYEE;

-- 12. Fetch all EMPLOYEE with their first name , email , phone (without extension part) and extension (just the extension)

-- Info : this mean you need to separate phone into 2 parts

-- eg: 123.123.1234.12345 => 123.123.1234 and 12345 . first half in phone column and second half in extension column

SELECT FIRST_NAME,EMAIL,REVERSE(SUBSTR(REVERSE(PHONE_NUMBER),charindex('.',REVERSE(PHONE_NUMBER))+1,LENGTH(PHONE_NUMBER))) as phone_num,SPLIT_PART(PHONE_NUMBER,'.',-1)
 AS PHONE FROM EMPLOYEE;

-- 13. Write a SQL query to find the employee with second and third maximum salary.

-- SPLIT_PART(PHONE_NUMBER,'.',-1)
SELECT * FROM EMPLOYEE WHERE SALARY IN (SELECT DISTINCT(SALARY) FROM EMPLOYEE
ORDER BY SALARY DESC
LIMIT 2 OFFSET 1);

-- 14. Fetch all details of top 3 highly paid EMPLOYEE who are in department Shipping and IT

-- approch 1
SELECT * FROM EMPLOYEE,DEPARTMENTS
WHERE EMPLOYEE.DEPARTMENT_ID=DEPARTMENTS.DEPARTMENT_ID
AND DEPARTMENT_NAME IN ('Shipping','IT')
ORDER BY EMPLOYEE.SALARY DESC
LIMIT 3;
-- approch 2
SELECT * FROM EMPLOYEE WHERE DEPARTMENT_ID IN(SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME IN ('Shipping','IT'))
ORDER BY EMPLOYEE.SALARY DESC
LIMIT 3;

-- 15. Display employee id and the positions(jobs) held by that employee (including the current position)

SELECT EMPLOYEE.EMPLOYEE_ID, JOBS.JOB_TITLE FROM EMPLOYEE,JOBS 
WHERE EMPLOYEE.JOB_ID=JOBS.JOB_ID
UNION
SELECT EMPLOYEE.EMPLOYEE_ID, JOBS.JOB_TITLE FROM EMPLOYEE,JOB_HISTORY,JOBS
WHERE EMPLOYEE.EMPLOYEE_ID=JOB_HISTORY.EMPLOYEE_ID AND JOB_HISTORY.JOB_ID=JOBS.JOB_ID
ORDER BY EMPLOYEE_ID;



-- 16. Display Employee first name and date joined as WeekDay, Month Day, Year

-- Eg :

-- Emp ID Date Joined

-- 1 Monday, June 21st, 1999


SELECT FIRST_NAME,CONCAT (DAYNAME(HIRE_DATE),',',MONTHNAME(HIRE_DATE),',',DAY(HIRE_DATE),decode(extract(day,hire_date),'1','st','21','st','31','st','2','nd','22','nd','3','rd','23','rd','th'),',',YEAR(HIRE_DATE)) AS DATE FROM EMPLOYEE;

-- 17. The company holds a new job opening for Data Engineer (DT_ENGG) with a minimum salary of 12,000 and maximum salary of 30,000 . The job position might be removed based on market trends (so, save the changes) . - Later, update the maximum salary to 40,000 . - Save the entries as well.

-- - Now, revert back the changes to the initial state, where the salary was 30,000
alter session set autocommit=False;
SELECT * FROM JOBS;
INSERT INTO JOBS
VALUES(
 'DT_ENGG',
 'Data Engineer',
 12000,
 30000
 );
COMMIT;
select * from jobs;
-- DELETE FROM JOBS
-- WHERE JOB_ID='DT_ENGG';
  UPDATE JOBS
  SET MAX_SALARY=40000
  WHERE JOB_ID='DT_ENGG';
  ROLLBACK;


-- 18. Find the average salary of all the EMPLOYEE who got hired after 8th January 1996 but before 1st January 2000 and round the result to 3 decimals

 SELECT ROUND(AVG(SALARY),3) FROM EMPLOYEE
 WHERE HIRE_DATE BETWEEN '1996-01-08' AND '2006-01-01';
 
    
-- 19. Display Australia, Asia, Antarctica, Europe along with the regions in the region table (Note: Do not insert data into the table)
-- A. Display all the regions
-- B. Display all the unique regions

    SELECT REGION_NAME FROM REGIONS
    UNION ALL
    SELECT 'Australia'
    UNION ALL
    SELECT 'Asia'
    UNION ALL
    SELECT 'Antarctica'
    UNION ALL
    SELECT 'Europe';

SELECT REGION_NAME FROM REGIONS
    UNION 
    SELECT 'Australia'
    UNION 
    SELECT 'Asia'
    UNION 
    SELECT 'Antarctica'
    UNION 
    SELECT 'Europe';