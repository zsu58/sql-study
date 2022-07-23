/*
FRAME의 정의: RANGE/ROWS BETWEEN [START] AND [END]
ROWS: ROWS does not treat duplicates in OVER's ORDER BY subclause as a single entity
RANGE: RANGE treats duplicates in OVER'S ORDER BY subclause as a single entity
이러한 특성 때문에 보통 ROWS가 많이 쓰임

START/END: n PRECEDING, CURRENT ROW, n FOLLOWING 중 하나
  1. n PRECEDING: n rows before the current row
  2. CURRENT ROW: current row
  3. n FOLLOWING: n rows after the current row
  EX)
    1. ROWS BETWEEN 3 PRECEDING AND CURRENT ROW: 4 rows
    2. ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING: 3 rows
    3. ROWS BETWEEN 5 PRECEDING AND 1 PRECEDING: 5 rows
*/

-- Return the year, medals earned, and the maximum medals earned, 
-- comparing only the current year and the next year.
WITH Scandinavian_Medals AS (
  SELECT
    Year, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country IN ('DEN', 'NOR', 'FIN', 'SWE', 'ISL')
    AND Medal = 'Gold'
  GROUP BY Year
)
SELECT
  -- Select each year's medals
  Year,
  Medals,
  -- Get the max of the current and next years' medals
  MAX(Medals) OVER (ORDER BY Year ASC
             ROWS BETWEEN CURRENT ROW
             AND 1 FOLLOWING) AS Max_Medals
FROM Scandinavian_Medals
ORDER BY Year ASC;

-- Return the athletes, medals earned, and the maximum medals earned, 
-- comparing only the last two and current athletes, ordering by athletes' names in alphabetical order.
WITH Chinese_Medals AS (
  SELECT
    Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'CHN' AND Medal = 'Gold'
    AND Year >= 2000
  GROUP BY Athlete
)
SELECT
  -- Select the athletes and the medals they've earned
  Athlete,
  Medals,
  -- Get the max of the last two and current rows' medals 
  MAX(Medals) OVER (ORDER BY Athlete ASC
            ROWS BETWEEN 2 PRECEDING
            AND CURRENT ROW) AS Max_Medals
FROM Chinese_Medals
ORDER BY Athlete ASC;

-- Calculate the 3-year(including current year) moving average of medals earned.
WITH Russian_Medals AS (
  SELECT
    Year, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'RUS'
    AND Medal = 'Gold'
    AND Year >= 1980
  GROUP BY Year
)
SELECT
  Year, Medals,
  --- Calculate the 3-year moving average of medals earned
  AVG(Medals) OVER
    (ORDER BY Year ASC
     ROWS BETWEEN
     2 PRECEDING AND CURRENT ROW) AS Medals_MA
FROM Russian_Medals
ORDER BY Year ASC;

-- Calculate the 3-year moving sum of medals earned per country.
WITH Country_Medals AS (
  SELECT
    Year, Country, COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Year, Country
)
SELECT
  Year, Country, Medals,
  -- Calculate each country's 3-game moving total
  SUM(Medals) OVER
    (PARTITION BY Country
     ORDER BY Year ASC
     ROWS BETWEEN
     2 PRECEDING AND CURRENT ROW) AS Medals_MA
FROM Country_Medals
ORDER BY Country ASC, Year ASC;

