-- Create Staging Table
CREATE TABLE IF NOT EXISTS work_mh AS
SELECT * 
FROM impact_of_remote_work_on_mental_health;

-- View Table
SELECT *
FROM work_mh;

-- Weekly hours by role & site
SELECT Job_Role, Work_Location, AVG(Hours_Worked_Per_Week) AS weekly
FROM work_mh
GROUP BY Job_Role, Work_Location
ORDER BY Job_Role, Work_Location, weekly DESC;

-- Onsite job satisfaction by role
SELECT Job_Role,
MIN(Work_Life_Balance_Rating) AS min_modd,
AVG(Work_Life_Balance_Rating) AS avg_mood,
MAX(Work_Life_Balance_Rating) AS max_mood
FROM work_mh
WHERE Work_Location = "Onsite"
GROUP BY Job_Role
ORDER BY avg_mood DESC;

-- Age of career start 
SELECT Job_Role, 
MIN(Age - Years_of_Experience) AS min_start_age,
AVG(Age - Years_of_Experience) AS avg_start_age,
MAX(Age - Years_of_Experience) AS max_start_age
FROM work_mh
GROUP BY Job_Role
ORDER BY avg_start_age DESC;

-- Age distributions
SELECT Job_Role, 
MIN(Age),
AVG(Age),
MAX(Age) 
FROM work_mh
GROUP BY Job_Role
ORDER BY AVG(Age) DESC;

-- Experiance distributions
SELECT Job_Role, 
MIN(Years_of_Experience),
AVG(Years_of_Experience),
MAX(Years_of_Experience) 
FROM work_mh
GROUP BY Job_Role
ORDER BY AVG(Age) DESC;

-- Immposibly experienced
SELECT *
FROM work_mh
WHERE Years_of_Experience > Age;

-- Number that were born to compute
SELECT COUNT(*) AS invalid_rows_count
FROM work_mh
WHERE Years_of_Experience > Age;

-- How many started working before 18 years old
SELECT COUNT(*) AS rows_count
FROM work_mh
WHERE (Age - Years_of_Experience) > 18;


-- New at the job
SELECT *
FROM work_mh
WHERE Years_of_Experience <= 5;

-- New at the hob coun
SELECT COUNT(*) AS newbies
FROM work_mh
WHERE Years_of_Experience <= 5;

-- count all
SELECT COUNT(*)
FROM work_mh;
































