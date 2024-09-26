-- SELECT & FROM 

SELECT * 
FROM parks_and_recreation.employee_demographics;

SELECT first_name, 
last_name, 
birth_date, 
age, 
age + 10
FROM parks_and_recreation.employee_demographics;

SELECT DISTINCT gender, 
first_name
FROM parks_and_recreation.employee_demographics;

SELECt * 
FROM employee_salary
Where first_name = "Leslie";

SELECT *
FROM employee_salary
WHERE salary >= 50000;

-- AND OR NOT --  Logical Operators. 

SELECT *
FROM employee_demographics
WHERE gender != "female"
AND age >+ 25;


SELECT *
FROM employee_demographics
WHERE birth_date > "1985-01-01"
OR NOT gender = "male";

-- LIKE STATEMENTS
-- % = Anything
-- _ = Specific 

SELECT * 
from employee_demographics
WHERE first_name LIKE  "a__%";

-- Group By

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(gender)
FROM employee_demographics
GROUP BY gender
;

SELECT occupation, salary
FROM employee_salary
GROUP BY occupation, salary
;

-- ORDER BY

SELECT *
FROm employee_demographics
ORDER BY first_name ASC;

SELECT *
FROM employee_demographics
ORDER BY age DESC, gender
;

-- Having and Where

SELECT gender, AVG(age)
From employee_demographics
GROUP BY gender
HAVING AVG(age) > 40
;

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE "%manager%"
GROUP BY occupation
HAVING AVG(salary) > 50000 -- Aggregate funciton must be explicitly selected, non-aggregated terms cannot be included in selection
;

-- Limit & Aliasing

SELECT *
FROM employee_demographics
ORDER BY age DESC;

SELECT *
FROM employee_demographics
ORDER BY age DESC
lIMIT 3, 2; -- start at #3 and count 2 additional

SELECT gender, AVG(age) AS avg_age -- to rename an aggregated term (as it actually implied)
FROM employee_demographics 
GROUP BY gender
HAVING avg_age > 40
;

SELECT gender, AVG(age) avg_age -- to rename an aggregated term without "AS"
FROM employee_demographics 
GROUP BY gender
HAVING avg_age > 40
;

-- Joins

-- INNER JOIN: Returns only the rows where there is a match in both tables. 
	-- Rows that do not have matching values in the related columns are excluded.

SELECT DEM.employee_id, age, occupation
FROM employee_demographics AS DEM 
INNER JOIN employee_salary AS SAL
	ON DEM.employee_id = SAL.employee_id
; -- Ron swanson not in the combination table because he is missing from employee_demographics. 

-- LEFT JOIN (LEFT OUTER JOIN): Returns all rows from the left table and the matching rows from the right table. 
	-- If there is no match, NULL values are returned for the columns of the right table.

SELECT *
FROM employee_demographics AS DEM
LEFT OUTER JOIN employee_salary AS SAL
	ON DEM.employee_id = SAL.employee_id
    ;


-- RIGHT JOIN (RIGHT OUTER JOIN): Returns all rows from the right table and the matching rows from the left table. 
	-- If there is no match, NULL values are returned for the columns of the left table.

SELECT *
FROM employee_demographics AS DEM
RIGHT OUTER JOIN employee_salary AS SAL
	ON DEM.employee_id = SAL.employee_id
    ;

-- FULL OUTER JOIN: Returns all rows when there is a match in either the left or the right table. 
	-- Non-matching rows will have NULL values for the missing side.

SELECT *
FROM employee_demographics AS DEM
FULL OUTER JOIN employee_salary AS SAL
	ON DEM.employee_id = SAL.employee_id;


-- CROSS JOIN: Produces the Cartesian product of the two tables, meaning every row from the first table is combined with every row from the second table.


-- SELF JOIN: A table is joined with itself. This is typically used to compare rows within the same table, such as when working with hierarchical data.

SELECT SAL1.employee_id AS EMP_Santa, 
SAL1.first_name AS First_Santa, 
SAL1.last_name AS Last_Santa,
SAL2.employee_id AS EMP_Name, 
SAL2.first_name AS First_Name, 
SAL2.last_name AS Last_Name
FROM employee_salary as SAL1
JOIN employee_salary as SAL2
	ON SAL1.employee_id + 1 = SAL2.employee_id  -- to shift the assignment (ie: for secret santa)
    ;

-- Joining multiple tables together

SELECT *
FROM employee_demographics AS DEM
INNER JOIN employee_salary AS SAL
	ON DEM.employee_id = SAL.employee_id
INNER JOIN parks_departments AS PD
	ON SAL.dept_id = PD.department_id
    ;
    
-- Unions

SELECT first_name, last_name
FROM employee_demographics
UNION DISTINCT
SELECT first_name, last_name
FROM employee_salary
;


SELECT first_name, last_name
FROM employee_demographics
UNION ALL -- all the results without removing duplicates
SELECT first_name, last_name
FROM employee_salary
;


-- Combining multiple select statements with UNION

SELECT first_name, last_name, "Old Man" AS Label
FROM employee_demographics
WHERE age > 40 AND gender = "Male"
UNION 
SELECT first_name, last_name, "Old Woman" AS Label
FROM employee_demographics
WHERE age > 40 AND gender = "Female"
UNION
SELECT first_name, last_name, "High Earner" AS Label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name
;

-- String Functions

SELECT LENGTH('skyfall')
;

SELECT first_name, LENGTH(first_name) AS Len
FROM employee_demographics
ORDER BY Len
;

SELECT UPPER('skyfall')
;

SELECT LOWER('SKYfall')
;

SELECT first_name, UPPER(first_name) AS 'CAPS!!'
FROM employee_demographics
;

-- TRIM (LEFT & RIGHT)

SELECT TRIM('        Sky         ') AS CLEAN
;

SELECT LTRIM('        Sky         ') AS LEFT_CLEAN
;

SELECT RTRIM('        Sky         ') AS RIGHT_CLEAN
;


SELECT first_name, 
LEFT(first_name, 4),  -- select 4 characters from the left
RIGHT(first_name, 4), -- select 4 characters from the right
SUBSTRING(first_name, 3, 2), -- select 2 characters starting from the 3rd character
birth_date, 
SUBSTRING(birth_date, 6, 2) AS Birth_Month
FROM employee_demographics
;

SELECT first_name, REPLACE(first_name, 'a', 'z') -- Find lowercase "a" and replace it with "z"
FROM employee_demographics;

SELECT LOCATE('x', 'Alexander');  -- locate the x character

SELECT first_name, LOCATE('An', first_name) -- locate number of uccurances 
FROM employee_demographics
;

SELECT first_name, last_name,
CONCAT(first_name, ' ', last_name) AS full_name
FROM employee_demographics
;

-- CASE statements

SELECt first_name, 
last_name,
age, 
CASE
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 21 and 50 THEN 'Old'
    WHEN age >= 50 THEN 'Dead'
END AS Age_Bracket
FROM employee_demographics
;

-- Pay increase based on current income and department

SELECT DEM.first_name, DEM.last_name, PD.department_name, SAL.salary, 
CASE
	WHEN salary <= 50000 THEN salary + (salary * 0.05)  -- Salary increase can specified in two ways
    WHEN salary > 50000 THEN salary * 1.07
END AS New_Salary,
(CASE
	WHEN salary <= 50000 THEN salary + (salary * 0.05)  -- Salary increase can specified in two ways
    WHEN salary > 50000 THEN salary * 1.07
END - salary) AS Pay_Increase, 
CASE
	WHEN PD.department_name = 'Finance' THEN salary * 0.10
    ELSE 0
END AS Bonus
FROM employee_demographics AS DEM
INNER JOIN employee_salary as SAL
	ON DEM.employee_id = SAL.employee_id -- Overkill step to allow naming the specific deparmtne by joining the 3 datatables. 
INNER JOIN parks_departments as PD
	ON SAL.dept_id = PD.department_id  -- Overkill step to allow naming the specific department
;


-- Cleaner way of outputting the same result
WITH Salary_Calculations AS (
    SELECT DEM.first_name, DEM.last_name, PD.department_name, SAL.salary,
    -- Calculate the new salary in a CTE
    CASE
        WHEN SAL.salary <= 50000 THEN SAL.salary * 1.05  -- 5% increase for salaries <= 50,000
        WHEN SAL.salary > 50000 THEN SAL.salary * 1.07   -- 7% increase for salaries > 50,000
    END AS New_Salary
    FROM employee_demographics AS DEM
    INNER JOIN employee_salary AS SAL
        ON DEM.employee_id = SAL.employee_id
    INNER JOIN parks_departments AS PD
        ON SAL.dept_id = PD.department_id
)
-- Main query using the CTE result
SELECT first_name, last_name, department_name, salary, 
       New_Salary,
       (New_Salary - salary) AS Pay_increase,
       CASE
           WHEN department_name = 'Finance' THEN salary * 0.10  -- 10% bonus for Finance
           ELSE 0  -- No bonus for other departments
       END AS Bonus
FROM Salary_Calculations;

-- Determine current ages


INSERT INTO employee_demographics -- Include myself for confirmation
VALUES (13, 'Mikias', 'Woldetensae', 31, 'Male', '1992-10-30');

SELECT *
FROM employee_demographics;

SELECT CURDATE();

-- SELECT first_name, last_name, age, birth_date,
-- YEAR(CURDATE()) - YEAR(birth_date) - 
-- (CASE
	-- WHEN MONTH(CURDATE()) < MONTH(birth_date) 
    -- OR (MONTH(CURDATE()) = MONTH(birth_date) AND DAY(CURDATE()) < DAY(birth_date))
    -- THEN 1
    -- ELSE 0
-- END) AS Current_Age_Manual
-- FROM employee_demographics;


SELECT first_name, last_name, age, birth_date,
TIMESTAMPDIFF(YEAR, MONTH, DAY, birth_date, CURDATE()) as Current_Age
FROM employee_demographics;

SELECT first_name, last_name, age, birth_date,
       -- Calculate years
       TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS years,
       -- Calculate months, subtract years * 12 to get remaining months
       TIMESTAMPDIFF(MONTH, birth_date, CURDATE()) - (TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) * 12) AS months,
       -- Calculate days, get difference in days from birth_date to today, subtract years and months in days
       DATEDIFF(CURDATE(), birth_date) - 
       (TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) * 365) - 
       (TIMESTAMPDIFF(MONTH, birth_date, CURDATE()) - (TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) * 12)) * 30 AS days
FROM employee_demographics;


-- to fix some people have more than 31 days in their day column. 
SELECT first_name, last_name, birth_date,
       -- Calculate years
       TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS years,
       -- Calculate months by comparing the current date and birth date after adding the years
       TIMESTAMPDIFF(MONTH, DATE_ADD(birth_date, INTERVAL TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) YEAR), CURDATE()) AS months,
       -- Calculate days by comparing the current date and birth date after adding the years and months
       DATEDIFF(CURDATE(), DATE_ADD(DATE_ADD(birth_date, INTERVAL TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) YEAR), 
                    INTERVAL TIMESTAMPDIFF(MONTH, DATE_ADD(birth_date, INTERVAL TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) YEAR), CURDATE()) MONTH)) AS days
FROM employee_demographics
;


-- Describe data types

DESCRIBE employee_salary;

DESCRIBE employee_demographics;

-- Create & Save a table

CREATE TABLE employee_salary2024 AS
SELECT *, salary * 1.05 AS salary_2024
FROM employee_salary;

ALTER TABLE employee_salary2024
DROP COLUMN salary;

SELECT * 
FROM employee_salary2024;

DROP TABLE employee_salary2024;

-- Subqueries

SELECT *
FROM employee_demographics
WHERE employee_id IN 
				(SELECT employee_id
					FROM employee_salary
                    WHERE dept_id = 1)
;

SELECT first_name, salary, 
			(SELECT AVG(salary)
				FROM employee_salary) as Avg_salary
FROM employee_salary
;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;


SELECT AVG(`MAX(age)`)
FROM
			(SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
				FROM employee_demographics
				GROUP BY gender) AS Agg_table
GROUP BY gender
;

-- Window functions 

-- For comparison: GROUP BY
SELECT gender, AVG(salary)
FROM employee_demographics AS DEM
Join employee_salary AS SAL
	ON DEM.employee_id = SAL.employee_id
GROUP BY gender;

-- WINDOW
SELECT DEM.first_name, gender, AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics AS DEM
Join employee_salary AS SAL
	ON DEM.employee_id = SAL.employee_id
;

-- Another Example
SELECT DEM.first_name, gender, salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY DEM.employee_id) AS Rolling_Total
FROM employee_demographics AS DEM
Join employee_salary AS SAL
	ON DEM.employee_id = SAL.employee_id
;

-- Special functions

SELECT DEM.first_name, DEM.last_name, gender, salary, 
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS Row_num, -- row number will not duplicate
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS Rank_num, -- rank will allow duplicates for competing order values (Next number positionally, skips one)
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS Dense_Rank_num -- similar to rank but next number is numerical
FROM employee_demographics AS DEM
JOIN employee_salary AS SAL
	ON DEM.employee_id = SAL.employee_id;

-- ADVANCED SQL

-- CTE's (Similar to subqueries)
--  Common Table Expression

WITH CTE_Example AS
		(SELECT gender, 
        AVG(salary) AS avg_sal , 
        MAX(salary) AS max_sal, 
        MIN(salary) AS min_sal, 
        COUNT(salary) AS cnt_sal
        FROM employee_demographics AS DEM
        JOIN employee_salary AS SAL
			ON DEM.employee_id = SAL.employee_id
		GROUP BY gender)
SELECT AVG(avg_sal)
FROM CTE_Example
;

-- Additional functionality (Multiple CTE's)

WITH CTE_Example AS
		(SELECT employee_id, gender, birth_date
        FROM employee_demographics
        WHERE birth_date > '1985-01-01'
        ), 
CTE_Example2 AS
		(SELECT employee_id, salary
        FROM employee_salary
        WHERE salary > 50000
        )
SELECT *
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_id = CTE_Example2.employee_id
;


-- Temp Tables

CREATE TEMPORARY TABLE temp_table
	(first_name varchar(50), 
    last_name varchar(50), 
    favorite_movie varchar(100)
    );
    
SELECT *
FROM temp_table;

INSERT INTO temp_table
VALUES('Alex', 'Freberg', 'LOTR: Two Towers');

SELECT *
FROM temp_table;

SELECT *
FROM employee_salary;

CREATE TEMPORARY TABLE salary_over_50K
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary_over_50K;

-- Stored Procedure

SELECT * 
FROM employee_salary
WHERE salary >= 50000;


CREATE PROCEDURE large_salary()
SELECT * 
FROM employee_salary
WHERE salary >= 50000;

CALL large_salary();

-- using specified delimiter for layers procedures
-- Allowing for input values

 -- change delimiter (to allow multiple queries)
DELIMITER $$
CREATE PROCEDURE Call_Salaries(EMP_ID INT)
BEGIN
	SELECT salary
	FROM employee_salary
    WHERE employee_id = EMP_ID
    ;
END $$
DELIMITER ;
 -- change it back


CALL Call_Salaries(1)

-- Triggers

DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW 
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(14, 'Jean-Ralphio', 'Saperstein', 'Entertainement 720 CEO', 10000000, NULL);

SELECT *
FROM employee_salary;

SELECT * 
FROM employee_demographics;

-- EVENTS =scheduled automator

SELECT * 
FROM employee_demographics;

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO 
BEGIN
	 DELETE
     FROM employee_demographics
     WHERE age >= 60;
END $$
DELIMITER ;

-- for troubleshooting
SHOW VARIABLES LIKE 'event%';






















































