/*
MSSQL 기준의 코드

CONVERT(data_type, [(length)], expression[, style])
  * postgres의 CAST와 같은 역할
DATEPART(datepart, date) -- returns int
  * postgres의 EXTRACT 함수와 같은 역할
DATENAME(datepart, date) -- returns nvarchar
  * postgres의 to_char과 같은 역할
DATEDIFF(datepart, startdate, enddate) -- returns int & can't use datepart weekday value
  * possible dateparts are 'year', 'quarter', 'month', 'dayofyear', 'day', 'week', 'weekday', 'hour', 'minute', 'second', 'microsecond', 'nanosecond'
*/

-- -------
-- CONVERT
-- -------
SELECT
  CONVERT(DATE, StartDate) as StartDate, -- StartDate는 Timestamp 형식(e.g. 2018-03-01 00:02:41)
  COUNT(ID) as CountOfRows 
FROM CapitalBikeShare 
GROUP BY CONVERT(DATE, StartDate)
ORDER BY CONVERT(DATE, StartDate);

-- --------
-- DATEPART
-- --------
SELECT
	COUNT(ID) AS Count,
    "StartDate" = CASE WHEN DATEPART(SECOND, StartDate) = 0 THEN 'SECONDS = 0'
					   WHEN DATEPART(SECOND, StartDate) > 0 THEN 'SECONDS > 0' END
FROM CapitalBikeShare
GROUP BY
	CASE WHEN DATEPART(SECOND, StartDate) = 0 THEN 'SECONDS = 0'
		   WHEN DATEPART(SECOND, StartDate) > 0 THEN 'SECONDS > 0' END

-- -------------------
-- DATENAME & DATEDIFF
-- -------------------
SELECT
	DATENAME(WEEKDAY, StartDate) as DayOfWeek,
	SUM(DATEDIFF(SECOND, StartDate, EndDate))/ 3600 as TotalTripHours 
FROM CapitalBikeShare 
GROUP BY DATENAME(WEEKDAY, StartDate)
ORDER BY TotalTripHours DESC

SELECT
  	SUM(DATEDIFF(SECOND, StartDate, EndDate))/ 3600 AS TotalRideHours,
  	CONVERT(DATE, StartDate) AS DateOnly,
  	DATENAME(WEEKDAY, CONVERT(DATE, StartDate)) AS DayOfWeek 
FROM CapitalBikeShare
WHERE DATENAME(WEEKDAY, StartDate) = 'Saturday' 
GROUP BY CONVERT(DATE, StartDate);