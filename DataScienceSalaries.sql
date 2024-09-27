-- Create Staging table
CREATE TABLE IF NOT EXISTS ds_sal AS
SELECT * 
FROM data_science_salaries;

-- View table
SELECT * 
FROM ds_sal;

-- View unique job types
SELECT DISTINCT job_title
FROM ds_sal;

-- View highest paid Data Science job in the US
SELECT job_title, AVG(salary)
FROM ds_sal
WHERE company_location = 'United States' AND salary_currency = 'USD'
GROUP BY job_title
ORDER BY AVG(salary) DESC;

-- View highest paid Data Science job in the US
SELECT job_title, AVG(salary)
FROM ds_sal
WHERE company_location = 'United States' 
AND salary_currency = 'USD' 
GROUP BY job_title
ORDER BY AVG(salary) DESC;


-- View highest paid Entry-level Full time Data Science job in the US by job type
SELECT job_title, work_models, AVG(salary)
FROM ds_sal
WHERE company_location = 'United States' 
AND salary_currency = 'USD' 
AND experience_level = 'Entry-level' 
AND employment_type = 'Full-time'
GROUP BY job_title, work_models
ORDER BY AVG(salary) DESC;

-- salaries by experience 
SELECT job_title, experience_level, AVG(salary)
FROM ds_sal
WHERE company_location = 'United States' 
AND salary_currency = 'USD' 
AND employment_type = 'Full-time'
GROUP BY job_title, experience_level
ORDER BY experience_level, AVG(salary) DESC;

-- Data Analyst Salaries by experience
SELECT experience_level, AVG(salary)
FROM ds_sal
WHERE company_location = 'United States' 
AND salary_currency = 'USD' 
AND job_title = 'Data Analyst'
GROUP BY experience_level
ORDER BY  AVG(salary) ASC;





