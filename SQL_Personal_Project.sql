
-- Inspect City data
SELECT *
FROM city;

DESCRIBE city;

-- Inspect Country data
SELECT *
FROM country;

DESCRIBE country;

-- Inspect Language data
SELECT *
FROM countrylanguage;

DESCRIBE countrylanguage;


-- See sum of populations by city within a given country
SELECT CountryCode,  SUM(Population)
FROM city
GROUP BY CountryCode;

-- USE CTE to see population differences between country and Sum of cities. 
WITH City_Sums AS
	(
	SELECT CountryCode,  SUM(Population) as citysums
	FROM city
	GROUP BY CountryCode
	)
SELECT `Code`, CountryCode, `Name`, Population, citysums, (Population - citysums) AS Diff
FROM country
JOIN City_Sums
	ON `Code` = CountryCode
ORDER BY Diff ASC;

-- Population and density by continent (Most populated continents)
SELECT Continent, 
SUM(Population) AS TotalPop, 
SUM(SurfaceArea) AS TotalArea, 
(SUM(SurfaceArea) / SUM(Population)) AS PersonPerArea
FROM country
GROUP BY Continent
ORDER BY PersonPerArea DESC;

SELECT *
FROM country;

-- Population and density by Region (Most populated regions)
SELECT Region, 
SUM(Population) AS TotalPop, 
SUM(SurfaceArea) AS TotalArea, 
(SUM(SurfaceArea) / SUM(Population)) AS PersonPerArea
FROM country
GROUP BY Region
ORDER BY PersonPerArea DESC;

-- Gross National Product By country
SELECT `Name`, GNP, GNPOld, (GNP - GNPOld) AS Diff
FROM country 
ORDER BY GNP DESC;

-- Types of giverments
SELECT DISTINCT GovernmentForm
FROM country;

-- Gross National Product by Government type
SELECT GovernmentForm, SUM(GNP)
FROM country 
GROUP BY GovernmentForm
ORDER BY SUM(GNP) DESC;

-- Life expextancy by country
SELECT `Name`, Population, GNP, LifeExpectancy
FROM country 
ORDER BY LifeExpectancy DESC;

-- The Motherland
SELECT *
FROM country
WHERE `Name` = 'Eritrea';

-- The Mothertongue
SELECT *
FROM countrylanguage
WHERE CountryCode = 'ERI';

-- The Mothercity
SELECT *
FROM city
WHERE CountryCode = 'ERI';

SELECT *
FROM city;

SELECT *
FROM countrylanguage;

SELECT *
FROM country;

-- Official languages
SELECT *
FROM countrylanguage
WHERE IsOfficial = 'T';

-- Multiple official languages
SELECT CountryCode, COUNT(CountryCode)
FROM countrylanguage
WHERE IsOfficial = 'T'
GROUP BY CountryCode
HAVING COUNT(CountryCode) > 1;

-- Select Higher precentage spoken official language
SELECT cl.*
FROM countrylanguage cl
WHERE IsOfficial = 'T'
  AND cl.Percentage = (
      SELECT MAX(Percentage)
      FROM countrylanguage
      WHERE CountryCode = cl.CountryCode
        AND IsOfficial = 'T'
  );

-- Country and capital city populations & Official Language (Double official languages selected by highest precentage
WITH PrimLanguage AS
	(
    SELECT *
	FROM countrylanguage AS C1
	WHERE IsOfficial = 'T'
		AND Percentage = (
			SELECT MAX(Percentage)
            FROM countrylanguage
            WHERE CountryCode = C1.CountryCode
            AND IsOfficial = 'T')
    ),
CountryCap AS
	(
    SELECT cnt.`Name` AS Country, 
	cnt.Population AS TotalPop, 
	cty.`Name` AS CapCity, 
	cty.Population AS CapPop,
    `Code`
	FROM country AS cnt
	JOIN city AS cty
	ON Capital = ID
    )
SELECT *
FROM CountryCap
JOIN PrimLanguage
	ON `Code` = CountryCode;

SELECT *
FROM countrylanguage
WHERE IsOfficial = 'T';

SELECT *
FROM country;



