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
SELECT * FROM olympics_female;

--Alter column teams to country
ALTER TABLE olympics_female RENAME column team TO country;

--Number of female athletic 
SELECT COUNT(*) FROM olympics_female WHERE sex='F';

--Sports between 1896-2016 that are still being used
SELECT DISTINCT sport FROM olympics_female WHERE year BETWEEN 1896 AND 2016 
and sex='F';

--Number of female athletic by season
SELECT season, COUNT(*) FROM olympics_female WHERE sex='F' GROUP BY season;

--Number of female medalist athletic
SELECT COUNT(*) FROM olympics_female WHERE sex='F' AND medal IS NOT NULL;

--Number of female non medalist athletic
SELECT COUNT(*) FROM olympics_female WHERE sex='F' AND medal IS NULL;

--year with the highest female medalist
SELECT year,COUNT(medal) as count FROM olympics_female WHERE medal IS NOT null AND sex='F'
GROUP BY YEAR ORDER BY count DESC LIMIT 5;

--female medalist average height and weight similarities against female non medalist
WITH female_medalist AS(SELECT NAME, sport,country,medal, AVG(height)OVER(PARTITION BY sport 
ORDER BY name) AS avg_medalist_height, AVG(weight)OVER
(PARTITION BY sport ORDER BY name)AS avg_medalist_weight
FROM olympics_female WHERE sex='F' AND medal IS NOT null),

female_non_medalist AS (SELECT NAME,sport,country,medal, AVG(height)OVER(PARTITION BY sport 
ORDER BY name) AS avg_non_medalist_height, AVG(weight)OVER
(PARTITION BY sport ORDER BY name)AS avg_non_medalist_weight
FROM olympics_female WHERE sex='F' AND medal IS null)

SELECT o.name, o.sport, o.country,o.medal, AVG(o.height) OVER() AS avg_height
,AVG(o.weight) OVER() AS avg_weight FROM olympics_female AS o INNER JOIN 
female_medalist ON o.height= female_medalist.avg_medalist_height AND o.weight=
female_medalist.avg_medalist_weight INNER JOIN female_non_medalist
ON female_medalist.avg_medalist_height= female_non_medalist.avg_non_medalist_height AND
female_medalist.avg_medalist_weight= female_non_medalist.avg_non_medalist_weight WHERE sex='F'
ORDER BY name ASC;

--median height
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY height) AS median_value,
MAX(height), MIN(height) FROM olympics_female;

--median weight
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY weight) AS median_value, MAX(weight),
MIN(weight) FROM olympics_female;

--performance score of female by teams
SELECT name, country, sport, COUNT(medal) AS performance_score FROM olympics_female
WHERE sex='F' AND medal IS NOT null GROUP BY name,team,sport 
ORDER BY performance_score DESC LIMIT 10;

--performance score of female in swimming by teams
SELECT name, country, sport, COUNT(medal) AS performance_score 
FROM olympics_female WHERE sex='F' AND sport='Swimming'
AND medal IS NOT null GROUP BY name,country,sport ORDER BY performance_score DESC LIMIT 10;

--performance score of female by season
SELECT season, COUNT(medal) AS performance_score 
FROM olympics_female WHERE sex='F' AND season IS NOT null
AND medal IS NOT null GROUP BY season ORDER BY performance_score DESC LIMIT 10;

--Female max age with high performance_score
SELECT name,country,games, age, COUNT(medal) AS performance_score
FROM olympics_female WHERE medal IS NOT null AND sex='F' AND age< (SELECT MAX(age) FROM 
olympics_female) GROUP BY name,country,age,games HAVING COUNT(medal)<
(select COUNT(medal) FROM olympics_female) ORDER BY performance_score DESC LIMIT 11;

--Total games played in cities
SELECT city, COUNT(games) AS total_games FROM olympics_female GROUP BY city ORDER BY
total_games DESC LIMIT 20;

--top 10 year with the highest medalist
SELECT year, COUNT(medal) FROM olympics_female WHERE sex='F' GROUP BY year ORDER BY COUNT(medal)
DESC LIMIT 10;

--total height for female
SELECT season, SUM(height) FROM olympics_female GROUP BY ROLLUP(season);