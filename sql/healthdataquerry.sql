use health;
select * from healthdata;

SELECT 
	LOCATION, 
	COUNT(DISTINCT TIME) AS YEARS_COUNT
FROM healthdata
GROUP BY LOCATION
ORDER BY YEARS_COUNT DESC;


SELECT 
	LOCATION, 
	ROUND(SUM(TOTAL_SPEND), 2) as TOTAL_HEALTHSPEND
FROM healthdata
GROUP BY LOCATION
ORDER BY TOTAL_HEALTHSPEND DESC;


SELECT
	TIME,
    COUNT(distinct LOCATION) as TOTAL_COUNTRY
from healthdata
where TIME between 1980 and 2010
group by 1
order by TIME;


SELECT 
	TIME, 
	round(AVG(TOTAL_SPEND), 2) AS AVG_SPEND_PER_YEAR
FROM healthdata
GROUP BY 1
ORDER BY 1;


WITH GlobalAvg AS (
	SELECT 
		ROUND(AVG(USD_CAP),2) AS AVG_USD_CAP
	FROM healthdata
	WHERE TIME between 1980 and 2010
)
SELECT 
	LOCATION, 
	USD_CAP
FROM healthdata, GlobalAvg
WHERE TIME between 1980 and 2010 AND USD_CAP > AVG_USD_CAP
ORDER BY USD_CAP DESC;


SELECT 
	LOCATION, 
	MIN(TIME) AS FIRST_YEAR, 
	MAX(TIME) AS LAST_YEAR
FROM healthdata
GROUP BY LOCATION
ORDER BY LOCATION;


SELECT 
	TIME,
	COUNT(CASE WHEN USD_CAP > 200 THEN 1 END) AS Above_200,
	COUNT(CASE WHEN USD_CAP <= 200 THEN 1 END) AS Below_Or_Equal_200
FROM healthdata
GROUP BY TIME
ORDER BY TIME;


with AvghealthXP as (
		select 
			TIME,
        	round(avg(PC_HEALTHXP), 2) as AVG_HEALTHXP
		from healthdata
    	group by TIME
    	)
	select 
		H.TIME,
    	round(sum(case when H.PC_HEALTHXP > A.AVG_HEALTHXP then H.TOTAL_SPEND else 0 end), 2) as TOTAL_SPEND_ABOVE_AVG
	from healthdata H
	join AvghealthXP A on H.TIME = A.TIME
	group by H.TIME
	order by H.TIME;
    
