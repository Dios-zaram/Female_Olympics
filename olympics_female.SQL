--Create the Olympics_female
CREATE TABLE olympics_female(ID INT,
					 Name VARCHAR,
					 Sex VARCHAR,
					 Age VARCHAR,
					 Height INT,
					 Weight INT,
					 Team VARCHAR,
					 NOC VARCHAR,
					 Games VARCHAR,
					 Year INT,
					 Season VARCHAR,
					 City VARCHAR,
					 Sport VARCHAR,
					 Events VARCHAR,
					 Medal VARCHAR);

--insert values
COPY olympics_female FROM 'C:\Program Files\PostgreSQL\15\data\data_copy\dataset_olympics.csv'
DELIMITER ',' CSV HEADER;

--Getting all the values in the field
SELECT
	*
FROM
	olympics_female;

--Alter column teams to country
ALTER TABLE 
	olympics_female 
RENAME column 
	team 
TO country;

--Number of female athletic from 2006-2018
SELECT
	sex, COUNT(*) 
FROM 
	olympics_female
WHERE
	year>=2006
GROUP BY sex;

/*From the dataset, Female number is the least (5692) while male have 7882*/

--Compare Number of Sports from 2008-2016 and from 1896-2016
SELECT 
	COUNT(DISTINCT sport) after_year
FROM 
	olympics_female
WHERE year>=2006


SELECT 
	COUNT(DISTINCT sport) as before_year
FROM 
	olympics_female
WHERE 
	year IS NOT NULL
	
WITH AllSports AS (
    SELECT DISTINCT sport
    FROM olympics_female
)

, PlayedSports AS (
    SELECT DISTINCT sport
    FROM olympics_female
    WHERE year> 2006 
)

SELECT sport
FROM AllSports
WHERE sport NOT IN (SELECT sport FROM PlayedSports);

/*		OBSERVATION
Based on the analysis, it is observed that there are 65 sports recorded from
1896 to 2016. In contrast, from 2006 to 2016, there are records for 51 female 
sports. Consequently, there are 14 sports that are not played during the period 
of 2006-2016. 

Which include "Lacrosse", "Cricket", "Motorboating", "Basque Pelota",
"Roque", "Military Ski Patrol", "Racquets", "Rugby", "Alpinism", "Jeu De Paume",
"Polo", "Croquet", "Tug-Of-War", "Art Competitions"*/


-- Delete Null values, Female  and values less than 2006
DELETE FROM 
	olympics_female 
WHERE sex is null;

DELETE FROM
	olympics_female
WHERE sex != 'F';

DELETE FROM 
	olympics_female 
WHERE year<2006;

--Mode of Medals
SELECT
	MODE() WITHIN GROUP (ORDER BY medal)
FROM 
	olympics_female
/*Silver is the most gotten award given to female from 2006-2016*/

--Number of female athletic by season
SELECT 
	season, COUNT(*) 
FROM 
	olympics_female 
GROUP BY season;
/*Olympics games are mainly played in the summer(4518) from 2008-2016 than winter
(1174) */

--Number of female medalist athletic
SELECT 
	COUNT(medal) 
FROM 
	olympics_female 
WHERE sex='F' AND medal IS NOT NULL;
/*Number of female medalist from 2006-2016 are 844*/

--year with the highest female medalist
SELECT 
	year,COUNT(medal) as count 
FROM 
	olympics_female
WHERE 
	medal IS NOT null AND sex='F'
GROUP BY YEAR 
ORDER BY count DESC 
LIMIT 5;
/*Female have won more awards in 2016(246) the least was 2006 with (55)*/

/*Central tendency of female height and weight*/
-- Find sample mean, median, mode, max, min variance and staandard deviation 
-- for height
SELECT 
	ROUND(AVG(height)) mean, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY height)
	median, MODE() WITHIN GROUP (ORDER BY height), MAX(height), MIN(height),
	VAR_SAMP(height), STDDEV_SAMP(height)
FROM
	olympics_female
	
-- Find Standard error
SELECT
  (STDDEV_SAMP(height) / SQRT(COUNT(height))) standard_error
FROM olympics_female;

-- Find the upper and lower confidence interval
SELECT
  AVG(height) - 1.96 * (STDDEV_SAMP(height) / SQRT(COUNT(height))) AS lower_limit,
  AVG(height) + 1.96 * (STDDEV_SAMP(height) / SQRT(COUNT(height))) AS upper_limit
FROM
  olympics_female;
  
 /*      OBSERVATION
1. The tallest person in your dataset has a height of 203, while the shortest 
person has a height of 140.

2.The mean rating for the dataset is 169, and the calculated 95% confidence interval
for the mean is approximately [168.6,169.1]. This interval suggests that, with 
95% confidence, the true population mean rating is likely to fall within this 
range.

3.The standard error of the sample mean is 0.116, indicating the expected 
variability of the sample mean from the true population mean*/

-- Find sample mean, median, mode, max, min variance and staandard deviation 
-- for weight
SELECT 
	ROUND(AVG(weight)) mean, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY weight)
	median, MODE() WITHIN GROUP (ORDER BY weight), MAX(weight), MIN(weight),
	VAR_SAMP(weight), STDDEV_SAMP(weight)
FROM
	olympics_female
	
-- Find Standard error
SELECT
  (STDDEV_SAMP(weight) / SQRT(COUNT(weight))) standard_error
FROM olympics_female;

-- Find the upper and lower confidence interval
SELECT
  AVG(weight) - 1.96 * (STDDEV_SAMP(weight) / SQRT(COUNT(weight))) AS lower_limit,
  AVG(weight) + 1.96 * (STDDEV_SAMP(weight) / SQRT(COUNT(weight))) AS upper_limit
FROM
  olympics_female;
 
 /*      OBSERVATION
1.The individual in our dataset with the highest weight is recorded at 136 units, 
while the individual with the lowest weight has a measurement of 34 units.

2.The mean rating for the dataset is 61, and the calculated 95% confidence interval
for the mean is approximately [61.12,61.68]. This interval suggests that, with 
95% confidence, the true population mean rating is likely to fall within this 
range.

3.The standard error of the sample mean is 0.141, indicating the expected 
variability of the sample mean from the true population mean*/ 

--performance score of female by name
SELECT 
	name, COUNT(medal) AS performance_score 
FROM 
	olympics_female
GROUP BY name 
ORDER BY performance_score DESC
LIMIT 3;
-- Marit Bjrgen have the highest performing score of 9 least is 
-- Nataile Anne Coughlin with 7

--Total games played in cities
SELECT city, COUNT(games) AS total_games FROM olympics_female GROUP BY city ORDER BY
total_games;
/*Games have been mainly played in Rio de Janeiro, followed by Beijing. 
Vancouver has hosted the least number of games.*/
