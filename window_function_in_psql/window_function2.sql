/*
Relative
LAG(column, n) returns the column's value at the row 'n' rows before the current row
LEAD(column, n) returns the column's value at the row 'n' rows after the current row

Absolute
FIRST_VALUE(column) returns the first value in the table or partition
LAST_VALUE(column) returns the last value in the table or partition
*/

-- ---
-- LAG
-- ---
-- get the current and previous (olympic) year's champion for each year.
WITH Weightlifting_Gold AS (
  SELECT
    -- Return each year's champions' countries
    Year,
    Country AS champion
  FROM Summer_Medals
  WHERE
    Discipline = 'Weightlifting' AND
    Event = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold'
)
SELECT
  Year, Champion,
  -- Fetch the previous (olympic) year's champion
  LAG(Champion, 1) OVER -- 만약 2인 경우 2회 전의 champion 가져올 수 있음(즉, 2번째 전의 row의 value 가져올 수 있음)
    (order by "year") AS Last_Champion
FROM Weightlifting_Gold
ORDER BY Year ASC;

-- Return the previous champions's country of each year's event by gender.
WITH Tennis_Gold AS (
  SELECT DISTINCT
    Gender, Year, Country
  FROM Summer_Medals
  WHERE
    Year >= 2000 AND
    Event = 'Javelin Throw' AND
    Medal = 'Gold'
)
SELECT
  Gender, Year,
  Country AS Champion,
  -- Fetch the previous year's champion by gender
  LAG(Country, 1) OVER (PARTITION BY gender
            ORDER BY year ASC) AS Last_Champion
FROM Tennis_Gold
ORDER BY Gender ASC, Year ASC;

-- Return the previous champions's country of each year's events by gender and event.
WITH Athletics_Gold AS (
  SELECT DISTINCT
    Gender, Year, Event, Country
  FROM Summer_Medals
  WHERE
    Year >= 2000 AND
    Discipline = 'Athletics' AND
    Event IN ('100M', '10000M') AND
    Medal = 'Gold'
)
SELECT
  Gender, Year, Event,
  Country AS Champion,
  -- Fetch the previous year's champion by gender and event
  LAG(country, 1) OVER (PARTITION BY gender, event
            ORDER BY Year ASC) AS Last_Champion
FROM Athletics_Gold
ORDER BY Event ASC, Gender ASC, Year ASC;


-- For each year, fetch the current gold medalist and the gold medalist 3 competitions ahead of the current row
-- ----
-- LEAD
-- ----
WITH Discus_Medalists AS (
  SELECT DISTINCT
    Year,
    Athlete
  FROM Summer_Medals
  WHERE Medal = 'Gold'
    AND Event = 'Discus Throw'
    AND Gender = 'Women'
    AND Year >= 2000
)
SELECT
  -- For each year, fetch the current and future medalists
  year,
  Athlete,
  LEAD(Athlete, 3) OVER (ORDER BY Year ASC) AS Future_Champion
FROM Discus_Medalists
ORDER BY Year ASC;

-- ------------------
-- FIRST & LAST VALUE
-- ------------------
-- Return all athletes and the first athlete ordered by alphabetical order.
WITH All_Male_Medalists AS (
  SELECT DISTINCT
    Athlete
  FROM Summer_Medals
  WHERE Medal = 'Gold'
    AND Gender = 'Men'
)
SELECT
  -- Fetch all athletes and the first athlete alphabetically
  Athlete,
  FIRST_VALUE(Athlete) OVER (
    ORDER BY Athlete ASC
  ) AS First_Athlete
FROM All_Male_Medalists;

-- Return the year and the city in which each Olympic games were held 
-- and the last city in which the Olympic games were held.
WITH Hosts AS (
  SELECT DISTINCT Year, City
    FROM Summer_Medals
)
SELECT
  Year,
  City,
  -- Get the last city in which the Olympic games were held
  LAST_VALUE(City) OVER (
   ORDER BY year ASC
   RANGE BETWEEN
     UNBOUNDED PRECEDING AND
     UNBOUNDED FOLLOWING
  ) AS Last_City
FROM Hosts
ORDER BY Year ASC;

/* 
왜 LAST_VALUE는 RANGE BETWEEN이 필요할까?
왜냐하면 WINDOW FUNCTION은 항상 FRAME(RANGE/ROWS BETWEEN으로 정의되는 구간)를 필요로하며 DEFAULT FRAME가 아래와 같음
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
따라서 FIRST_VALUE의 경우 FRAME에 대한 정의가 반드시 필요하지 않을 수도 있으나, LAST_VALUE는 왠만하면 FRAME을 특정해줘야 함
FRAME은 window_function6.sql에 더 자세하게 정의되어 있음
*/
