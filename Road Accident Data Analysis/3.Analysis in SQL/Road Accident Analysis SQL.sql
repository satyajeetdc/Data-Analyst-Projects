/* ------------------- checking the data ------------------- */

SELECT * FROM road_accident

/* ------------------- checking the CY Total casualties  ------------------- */

SELECT SUM(number_of_casualties) AS CY_Casualties
FROM road_accident 
WHERE YEAR(accident_date) = '2022'

/* ------------------- checking the CY Total accidents ------------------- */

SELECT COUNT(accident_index) AS CY_Total_Accidents
FROM road_accident
WHERE YEAR(accident_date) = '2022'

/* ------------------- checking the CY Fatal casualties ------------------- */

SELECT SUM(number_of_casualties) AS CY_Casualties
FROM road_accident 
WHERE YEAR(accident_date) = '2022' AND accident_severity = 'Fatal'

/* ------------------- checking the CY Serious casualties ------------------- */

SELECT SUM(number_of_casualties) AS CY_Casualties
FROM road_accident 
WHERE YEAR(accident_date) = '2022'AND accident_severity = 'Serious'

/* ------------------- checking the CY Slight casualties ------------------- */

SELECT SUM(number_of_casualties) AS CY_Casualties
FROM road_accident 
WHERE YEAR(accident_date) = '2022'AND accident_severity = 'Slight'

/* ------------------- checking the CY fatal casualties with dry road condition ------------------- */

SELECT SUM(number_of_casualties) AS CY_Casualties
FROM road_accident 
WHERE YEAR(accident_date) = '2022' AND accident_severity = 'Fatal' AND road_surface_conditions = 'Dry'

/* ------------------- checking the CY Total accidents in rainy weather conditions ------------------- */

SELECT COUNT(accident_index) AS Counts 
FROM road_accident 
WHERE YEAR(accident_date) = '2022' 
AND weather_conditions IN ('Raining no high winds','Raining + high winds')

/* ------------------- checking what percent of total casualties is fatal casualties  ------------------- */

SELECT CAST(CAST(SUM(number_of_casualties) AS DECIMAL(10,2))*100/
(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) 
FROM road_accident) AS NUMERIC(10,1)) AS pct_of_fatal_casualties
FROM road_accident 
WHERE accident_severity = 'Fatal'

/* ------------------- checking total casualties by vehicle type  ------------------- */

SELECT 
	CASE
		WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
		WHEN vehicle_type IN ('Car','Taxi/Private hire car') THEN 'Cars'
		WHEN vehicle_type IN ('Motorcycle 50cc and under','Motorcycle over 500cc','Pedal cycle','Motorcycle over 125cc and up to 500cc','Motorcycle 125cc and under') THEN 'Bike'
		WHEN vehicle_type IN ('Minibus (8 - 16 passenger seats)','Bus or coach (17 or more pass seats)') THEN 'Bus'
		WHEN vehicle_type IN ('Van / Goods 3.5 tonnes mgw or under','Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t') THEN 'Van'
		ELSE 'Other'
	END AS vehicle_group, 
	SUM(number_of_casualties) AS Total_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY 
	CASE
		WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
		WHEN vehicle_type IN ('Car','Taxi/Private hire car') THEN 'Cars'
		WHEN vehicle_type IN ('Motorcycle 50cc and under','Motorcycle over 500cc','Pedal cycle','Motorcycle over 125cc and up to 500cc','Motorcycle 125cc and under') THEN 'Bike'
		WHEN vehicle_type IN ('Minibus (8 - 16 passenger seats)','Bus or coach (17 or more pass seats)') THEN 'Bus'
		WHEN vehicle_type IN ('Van / Goods 3.5 tonnes mgw or under','Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t') THEN 'Van'
		ELSE 'Other'
	END
ORDER BY Total_Casualties DESC

/* ------------------- checking top 10 locations by total casualties  ------------------- */

SELECT TOP 10 local_authority AS locaton , SUM(number_of_casualties) AS no_of_casualties FROM road_accident
GROUP BY local_authority 
ORDER BY no_of_casualties DESC 

/* ------------------- checking CY casualties monthly trend  ------------------- */

SELECT DATENAME(MONTH, accident_date) AS Month, SUM(number_of_casualties) AS Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY DATENAME(MONTH, accident_date)

/* ------------------- checking PY casualties monthly trend  ------------------- */

SELECT DATENAME(MONTH, accident_date) AS Month, SUM(number_of_casualties) AS Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2021'
GROUP BY DATENAME(MONTH, accident_date)

/* ------------------- checking casualties by road type  ------------------- */

SELECT road_type, SUM(number_of_casualties) AS no_of_casualties FROM road_accident
GROUP BY road_type
ORDER BY no_of_casualties DESC

/* ------------------- checking casualties trend by urban/rural  ------------------- */

SELECT urban_or_rural_area, CAST(CAST(SUM(number_of_casualties) AS DECIMAL(10,2))*100/
(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident) AS NUMERIC(10,1)) AS pct
FROM road_accident
GROUP BY urban_or_rural_area

/* ------------------- checking CY casualties trend by urban/rural  ------------------- */

SELECT urban_or_rural_area, ROUND(CAST(CAST(SUM(number_of_casualties) AS DECIMAL(10,2))*100/
(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident 
WHERE YEAR(accident_date) = '2022') AS NUMERIC(10,1)), 0) AS pct
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY urban_or_rural_area

/* ------------------- checking total casualties by light conditions  ------------------- */

SELECT 
	CASE
		WHEN light_conditions IN ('Daylight') THEN 'Day Light'
		WHEN light_conditions IN ('Darkness - no lighting','Darkness - lights lit','Darkness - lights unlit','Darkness - lighting unknown') THEN 'Dark'
	END AS lighting_condition, 
ROUND(CAST(CAST(SUM(number_of_casualties) AS DECIMAL(10,2))*100/
(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident 
WHERE YEAR(accident_date) = '2022') AS NUMERIC(10,1)), 0) AS pct
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY
	CASE
		WHEN light_conditions IN ('Daylight') THEN 'Day Light'
		WHEN light_conditions IN ('Darkness - no lighting','Darkness - lights lit','Darkness - lights unlit','Darkness - lighting unknown') THEN 'Dark'
	END