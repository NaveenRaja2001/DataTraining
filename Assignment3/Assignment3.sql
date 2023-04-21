SELECT * FROM regions;
Select * from locations
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENTS;
SELECT * FROM JOBS;

//Question1 
-- 1. Write a SQL query to find the total salary of employees who is in Tokyo excluding whose first name is Nancy
SELECT SUM(SALARY) FROM EMPLOYEE E
JOIN DEPARTMENTS D
ON  E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN LOCATIONS L
ON D.LOCATION_ID=L.LOCATION_ID
WHERE L.CITY='Seattle' AND E.FIRST_NAME!='Nancy';

//Question2
-- 2. Fetch all details of employees who has salary more than the avg salary by each department.
SELECT EMPLOYEE_ID,SALARY,AVG_SALARY,D.DEPARTMENT_ID FROM EMPLOYEE E
JOIN (SELECT DEPARTMENT_ID ,ROUND(AVG(SALARY)) AS AVG_SALARY FROM EMPLOYEE 
GROUP BY DEPARTMENT_ID) D  
ON EMPLOYEE.DEPARTMENT_ID=D.DEPARTMENT_ID
WHERE EMPLOYEE.SALARY>AVG_SALARY;

//Question3
-- 3. Write a SQL query to find the number of employees and its location whose salary is greater than or equal to 7000 and less than 10000
SELECT COUNT(EMPLOYEE_ID) AS EMPLOYEE_COUNT, CITY FROM  EMPLOYEE E
JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
JOIN LOCATIONS L
ON L.LOCATION_ID=D.LOCATION_ID
WHERE E.SALARY >= 7000 AND E.SALARY <10000
GROUP BY CITY;

//Question4 
-- 4. Fetch max salary, min salary and avg salary by job and department.
-- Info: grouped by department id and job id ordered by department id and max salary
SELECT MAX(SALARY) AS MAX_SALARY, MIN(SALARY), AVG(SALARY) ,department_id FROM EMPLOYEE
GROUP BY DEPARTMENT_ID,JOB_ID
ORDER BY DEPARTMENT_ID DESC, MAX_SALARY;

//Question5
-- 5. Write a SQL query to find the total salary of employees whose country_id is ‘US’ excluding whose first name is Nancy
SELECT SUM(SALARY) FROM EMPLOYEE E
JOIN DEPARTMENTS D
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
JOIN LOCATIONS L
ON L.LOCATION_ID=D.LOCATION_ID
WHERE FIRST_NAME!='Nancy' AND COUNTRY_ID='US';





//Question6
-- 6. Fetch max salary, min salary and avg salary by job id and department id but only for folks who worked in more than one role(job) in a department.
    SELECT MIN(SALARY),MAX(SALARY),AVG(SALARY),DEPARTMENT_ID,JOB_ID FROM EMPLOYEE 
    WHERE EMPLOYEE_ID IN
    (SELECT EMPLOYEE_ID FROM JOB_HISTORY 
    GROUP BY EMPLOYEE_ID 
    HAVING COUNT(EMPLOYEE_ID) >1)
    GROUP BY DEPARTMENT_ID,JOB_ID;
   
//Question7
-- Display the employee count in each department and also in the same result.
-- Info: * the total employee count categorized as "Total"
 -- the null department count categorized as "-" *
 
    SELECT COALESCE(CAST(DEPARTMENT_ID AS STRING),'-') AS DEPARTMENT_ID,COUNT(EMPLOYEE_ID) FROM EMPLOYEE E
    GROUP BY DEPARTMENT_ID
    UNION
    SELECT 'Total',COUNT(EMPLOYEE_ID) FROM EMPLOYEE
    ORDER BY DEPARTMENT_ID;



//Question8
-- Display the jobs held and the employee count.
-- Hint: every employee is part of at least 1 job
-- Hint: use the previous questions answer
-- Sample
-- JobsHeld EmpCount
-- 1 100
-- 2 4
SELECT JOBS_HELD, COUNT(S1.EMPLOYEE_ID) AS EMPLOYEE_COUNT FROM
(SELECT T1.EMPLOYEE_ID,COUNT(T1.EMPLOYEE_ID) AS JOBS_HELD FROM EMPLOYEE T1
LEFT OUTER JOIN JOB_HISTORY T2 
ON T1.EMPLOYEE_ID=T2.EMPLOYEE_ID 
GROUP BY T1.EMPLOYEE_ID) S1
GROUP BY S1.JOBS_HELD;


//Question 9
-- 9. Display average salary by department and country.
SELECT C.COUNTRY_NAME,D.DEPARTMENT_ID,AVG(E.SALARY) FROM employee e 
JOIN DEPARTMENTS D 
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN LOCATIONS L 
ON D.LOCATION_ID = L.LOCATION_ID
JOIN COUNTRIES C 
ON L.COUNTRY_ID = C.COUNTRY_ID
GROUP BY D.DEPARTMENT_ID,COUNTRY_NAME;

-- Question 10
-- . Display manager names and the number of employees reporting to them by countries (each employee works for only one department, and each department belongs to a country)


SELECT E2.FIRST_NAME,E2.LAST_NAME ,COUNT(E1.MANAGER_ID) AS EMPL_REPORTING, C.COUNTRY_NAME FROM EMPLOYEE E1
JOIN EMPLOYEE E2 
ON E1.MANAGER_ID=E2.EMPLOYEE_ID
JOIN DEPARTMENTS D 
ON D.DEPARTMENT_ID=E1.DEPARTMENT_ID
JOIN LOCATIONS L 
ON L.LOCATION_ID=D.LOCATION_ID
JOIN COUNTRIES C 
ON C.COUNTRY_ID=L.COUNTRY_ID
GROUP BY E2.FIRST_NAME,E2.LAST_NAME,C.COUNTRY_NAME;

//Question 11
-- 11. Group salaries of employees in 4 buckets eg: 0-10000, 10000-20000,.. (Like the previous question) but now group by department and categorize it like below.
-- Eg :
-- DEPT ID 0-10000 10000-20000
-- 50 2 10
-- 60 6 5
SELECT DEPARTMENT_ID,
COUNT(CASE WHEN SALARY >= 0 AND SALARY <= 10000 THEN 1 END) AS "0-10000",
COUNT(CASE WHEN SALARY > 10000 AND SALARY <= 20000 THEN 1 END) AS "10000-20000",
COUNT(CASE WHEN SALARY > 20000 AND SALARY <= 30000 THEN 1 END) AS "20000-30000",
COUNT(CASE WHEN SALARY > 30000 THEN 1 END ) AS "Above 30000"
FROM EMPLOYEE
GROUP BY DEPARTMENT_ID;

//Question 12
-- 12. Display employee count by country and the avg salary
-- Eg :
-- Emp Count Country Avg Salary
-- 10 Germany 34242.8

SELECT C.COUNTRY_NAME, COUNT(EMPLOYEE_ID) AS EMPLOYEE_COUNT, ROUND(AVG(SALARY),2) AS AVERAGE_SALARY
FROM EMPLOYEE E
JOIN DEPARTMENTS D 
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
JOIN LOCATIONS L 
ON D.LOCATION_ID=L.LOCATION_ID
JOIN COUNTRIES C 
ON L.COUNTRY_ID=C.COUNTRY_ID
GROUP BY C.COUNTRY_NAME;


//Question 13
-- 13. Display region and the number off employees by department
-- Eg :
-- Dept ID America Europe Asia
-- 10 22 - -
-- 40 - 34 -
-- (Please put "-" instead of leaving it NULL or Empty)
SELECT E.DEPARTMENT_ID,
COALESCE(NULLIF(CAST(COUNT(CASE WHEN REGION_NAME = 'Europe' THEN 1 END) AS STRING),'0'),'-') AS EUROPE,
COALESCE(NULLIF(CAST(COUNT(CASE WHEN REGION_NAME = 'Americas' THEN 1 END) AS STRING),'0'),'-') AS AMERICAS,
COALESCE(NULLIF(CAST(COUNT(CASE WHEN REGION_NAME = 'Asia' THEN 1 END) AS STRING),'0'),'-') AS ASIA,
COALESCE(NULLIF(CAST(COUNT(CASE WHEN REGION_NAME = 'Middle East and Africa' THEN 1 END ) AS STRING),'0'),'-') AS MIDDLE_EAST_AND_AFRICA
FROM EMPLOYEE E
JOIN DEPARTMENTS D 
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
JOIN LOCATIONS L 
ON D.LOCATION_ID=L.LOCATION_ID
JOIN COUNTRIES C 
ON L.COUNTRY_ID=C.COUNTRY_ID
JOIN REGIONS R 
ON C.REGION_ID=R.REGION_ID
GROUP BY E.DEPARTMENT_ID 
ORDER BY E.DEPARTMENT_ID;



//Question 14
-- 14. Select the list of all employees who work either for one or more departments or have not yet joined / allocated to any department

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME FROM EMPLOYEE E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

//Question 15
-- 15. write a SQL query to find the employees and their respective managers. Return the first name, last name of the employees and their managers
SELECT CONCAT(A.FIRST_NAME,' ',A.LAST_NAME) AS EMPLOYEE_NAME, CONCAT(B.FIRST_NAME,' ',B.LAST_NAME) AS MANAGER_NAME FROM EMPLOYEE A 
JOIN EMPLOYEE B 
ON A.MANAGER_ID= B.EMPLOYEE_ID;

//Question 16
-- 16. write a SQL query to display the department name, city, and state province for each department.
SELECT D.DEPARTMENT_NAME,L.CITY,L.STATE_PROVINCE FROM DEPARTMENTS D 
JOIN LOCATIONS L 
ON D.LOCATION_ID=L.LOCATION_ID;

-- Question 17

-- 17. write a SQL query to list the employees (first_name , last_name, department_name) who belong to a department or don't
SELECT FIRST_NAME,LAST_NAME,coalesce(D.DEPARTMENT_NAME,'Doesnot belong to any department')FROM EMPLOYEE E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID;

-- Question 18
18. The HR decides to make an analysis of the employees working in every department. Help him to determine the salary given in average per department and the total number of employees working in a department. List the above along with the department id, department name
SELECT EMPLOYEE.DEPARTMENT_ID ,DEPARTMENTS.DEPARTMENT_NAME, COUNT(EMPLOYEE.DEPARTMENT_ID)  AS TOTAL_EMPLOYEES , AVG(SALARY), SUM(SALARY) AS TOLAL_SALARY FROM EMPLOYEE E
JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY E.DEPARTMENT_ID ,D.DEPARTMENT_NAME 
ORDER BY DEPARTMENT_ID;


-- Question 19
-- 19. Write a SQL query to combine each row of the employees with each row of the jobs to obtain a consolidated results. (i.e.) Obtain every possible combination of rows from the employees and the jobs relation.
SELECT * FROM EMPLOYEE CROSS JOIN JOBS;

-- Question 20

-- 20. Write a query to display first_name, last_name, and email of employees who are from Europe and Asia
   SELECT E.FIRST_NAME,E.LAST_NAME,E.EMAIL FROM EMPLOYEE E
   JOIN DEPARTMENTS D 
   ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
   JOIN LOCATIONS L 
   ON D.LOCATION_ID=L.LOCATION_ID
   JOIN COUNTRIES C
   ON L.COUNTRY_ID=C.COUNTRY_ID
   JOIN REGIONS R 
   ON C.REGION_ID = R.REGION_ID
    WHERE R.REGION_NAME IN ('Europe', 'Asia');

 -- Question 21
 -- 21. Write a query to display full name with alias as FULL_NAME (Eg: first_name = 'John' and last_name='Henry' - full_name = "John Henry") who are from oxford city and their second last character of their last name is 'e' and are not from finance and shipping department.
    SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) AS FULL_NAME FROM EMPLOYEE E 
    JOIN DEPARTMENTS D 
    ON E.DEPARTMENT_ID= D.DEPARTMENT_ID
    JOIN LOCATIONS L 
    ON D.LOCATION_ID= L.LOCATION_ID 
    WHERE L.CITY='Oxford' AND SUBSTR(E.LAST_NAME,-2,1)='e'
    AND E.DEPARTMENT_ID NOT IN (
    SELECT DEPARTMENT_ID FROM DEPARTMENTS
    WHERE DEPARTMENT_NAME IN ('Finance', 'Shipping'));

    -- Question 22
    -- 22. Display the first name and phone number of employees who have less than 50 months of experience
    SELECT FIRST_NAME,PHONE_NUMBER FROM EMPLOYEE 
    JOIN (SELECT EMPLOYEE_ID, SUM(datediff(MONTH,START_DATE,END_DATE)) AS EXPERIENCE FROM JOB_HISTORY
     GROUP BY EMPLOYEE_ID 
     HAVING EXPERIENCE<50) E 
     ON EMPLOYEE.EMPLOYEE_ID=E.EMPLOYEE_ID;

-- Question 23
 -- Display Employee id, first_name, last name, hire_date and salary for employees who has the highest salary for each hiring year. (For eg: John and Deepika joined on year 2023, and john has a salary of 5000, and Deepika has a salary of 6500. Output should show Deepika’s details only).
 SELECT EMPLOYEE_ID , FIRST_NAME , LAST_NAME , HIRE_DATE , SALARY FROM EMPLOYEE 
 WHERE (YEAR(HIRE_DATE),SALARY) IN
(SELECT YEAR(HIRE_DATE) AS HIRE_YEAR, MAX(SALARY) FROM EMPLOYEE 
GROUP BY HIRE_YEAR) 
ORDER BY HIRE_DATE;



