-- Create Staging Table
CREATE TABLE IF NOT EXISTS work_mh AS
SELECT * 
FROM impact_of_remote_work_on_mental_health;

-- View Table
SELECT *
FROM work_mh;

# 
SELECT Job_Role, Work_Location, AVG(Hours_Worked_Per_Week) AS weekly
FROM work_mh
GROUP BY Job_Role, Work_Location
ORDER BY Job_Role, Work_Location, weekly DESC;

# Onsite job satisfaction by role
SELECT Job_Role, AVG(Work_Life_Balance_Rating) AS Happiness
FROM work_mh
WHERE Work_Location = "Onsite"
GROUP BY Job_Role
ORDER BY Happy ASC;





































