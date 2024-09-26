-- DATA CLEANING
SELECT *
FROM layoffs;

-- 0. Create Staging data
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;


-- 1. Remove duplicates

-- Add rownumbers per unique entry
SELECT *, 
ROW_NUMBER() OVER(
		PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Extract duplicates, usuing CTE to partition over all variables
WITH duplicate_cte AS
(
SELECT *, 
ROW_NUMBER() OVER(
		PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Confirm duplicates
SELECT *
FROM layoffs_staging
WHERE company = 'Yahoo';

-- To remove duplicates: Create secondary staging table
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL, 
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Copy partitioned data
INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER(
		PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Confirm duplicates
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Delete duplicates
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- Confirm again
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


-- 2. Standardize data
-- Trim whitespace
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
set company = TRIM(company);

-- Look at distrinct industry names
SELECT DISTINCT(industry)
FROM layoffs_staging2
ORDER BY 1;

-- Note variable Crypto names
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- Standardize Crypto companies
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Check other variables
SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- Fix United states error
SELECT * 
FROM layoffs_staging2
WHERE country LIKE '%United States%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Change date from text to date/time variable
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') -- define current settings of dates
FROM layoffs_staging2;

-- update table with new formating
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- upodate variable to date type
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- confirm
SELECT *
FROM layoffs_staging2;

-- 3. Null/Blank Values
-- Check for Null values
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Set blank values to NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- Note missing industry 
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- Join table to itself and populate missing values
SELECT *
FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL
;

-- update table
UPDATE layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

-- confirm
SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- 4. Remove unnecesary columns or rows
-- Check uninformative observations
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

-- Delete uninformative observations
DELETE 
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

-- Confirm
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

-- explore again
SELECT *
FROM layoffs_staging2;

-- drop row_num columns
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- confirm
SELECT *
FROM layoffs_staging2;

-- Remaining observations with missing values
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
OR percentage_laid_off IS NULL 
OR funds_raised_millions IS NULL
OR stage IS NULL;

-- ###############################################################
-- EXPLORATORY DATA ANALYSIS
-- ###############################################################

SELECT *
FROM layoffs_staging2;

SELECT company, MAX(total_laid_off)
FROM layoffs_staging2
GROUP BY company;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company ASC;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- CTE table top 5 companies with highers layoffs per year
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * 
FROM COMPANY_YEAR_RANK
WHERE ranking <= 5;



























