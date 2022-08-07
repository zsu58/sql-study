/*
ROLLUP is a GROUP BY subclause that includes extra rows for group-level aggregations
For Example GROUP BY Country, ROLLUP(Medal) will count
  1) all Country and Medal level totals
  2) only Countrylevel totals and fill in Medal with nulls

ROLL UP is hierarchial, de-aggregating from the leftmost provided column to the right-most 

CUBE is a non-hierarchial ROLL UP, generating all possible group-level aggregations

CONCLUSION
  USE ROLLUP when the data is hierarchial and don't wall all possible group-level aggregations
  USE CUBE when all possible group-level aggregations are wanted

cf. nulls in the rows indicate group totals, therefore COALESCE can be used to substitute null making it more easier to understand
*/

-- get three Scandinavian countries' earned gold medals per country and gender in the year 2004. 
-- also retrieve Country-level subtotals to get the total medals earned for each country, 
-- but Gender-level subtotals don't make much sense in this case, so disregard them.
SELECT
  Country,
  Gender,
  COUNT(*) AS Gold_Awards
FROM Summer_Medals
WHERE
  Year = 2004
  AND Medal = 'Gold'
  AND Country IN ('DEN', 'NOR', 'SWE'
)
-- Generate Country-level subtotals
GROUP BY Country, ROLLUP(Gender)
ORDER BY Country ASC, Gender ASC;

-- break down all medals awarded to Russia in the 2012 Olympic games per gender and medal type. 
-- Since the medals all belong to one country, it makes sense to generate all possible subtotals (Gender- and Medal-level subtotals), as well as a grand total.
SELECT
  Gender,
  Medal,
  COUNT(*) AS Awards
FROM Summer_Medals
WHERE
  Year = 2012
  AND Country = 'RUS'
-- Get all possible group-level subtotals
GROUP BY CUBE(Gender, Medal)
ORDER BY Gender ASC, Medal ASC;

-- --------
-- COALESCE
-- --------
SELECT
  -- Replace the nulls in the columns with meaningful text
  COALESCE(Country, 'All countries') AS Country,
  COALESCE(Gender, 'All genders') AS Gender,
  COUNT(*) AS Awards
FROM Summer_Medals
WHERE
  Year = 2004
  AND Medal = 'Gold'
  AND Country IN ('DEN', 'NOR', 'SWE')
GROUP BY ROLLUP(Country, Gender)
ORDER BY Country ASC, Gender ASC;

-- ----------
-- STRING_AGG
-- ----------
-- Return the top 3 countries by medals awarded as one comma-separated string.
WITH Country_Medals AS (
  SELECT
    Country,
    COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE Year = 2000
    AND Medal = 'Gold'
  GROUP BY Country
), Country_Ranks AS (
  SELECT
    Country,
    RANK() OVER (ORDER BY Medals DESC) AS Rank
  FROM Country_Medals
  ORDER BY Rank ASC
)
-- Compress the countries column into one row
SELECT STRING_AGG(Country, ', ')
FROM Country_Ranks
WHERE Rank <= 3;
