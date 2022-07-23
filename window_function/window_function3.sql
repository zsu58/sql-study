/*
RANKING
ROW_NUMBER() always assigns unique numbers, even if two row's values are the same
RANK() assigns the same number to rows with identical values, skipping over the next numbers in such case
DENSE_RANK() also assigns the same numbers to rows with identical values, but doesn't skip over the next numbers
*/

-- ----
-- RANK
-- ----
-- Rank each athlete by the number of medals they've earned 
-- the higher the count, the higher the rank 
-- with identical numbers in case of identical values.
WITH Athlete_Medals AS (
  SELECT
    Athlete,
    COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete
)

SELECT
  Athlete,
  Medals,
  -- Rank athletes by the medals they've won
  RANK() OVER (ORDER BY Medals DESC) AS Rank_N
FROM Athlete_Medals
ORDER BY Medals DESC;


-- ----------
-- DENSE_RANK
-- ----------
-- Rank each country's athletes by the count of medals they've earned 
-- the higher the count, the higher the rank 
-- without skipping numbers in case of identical values.
WITH Athlete_Medals AS (
  SELECT
    Country, Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country IN ('JPN', 'KOR')
    AND Year >= 2000
  GROUP BY Country, Athlete
  HAVING COUNT(*) > 1
)
SELECT
  Country,
  -- Rank athletes in each country by the medals they've won
  Athlete,
  DENSE_RANK() OVER (PARTITION BY Country
                ORDER BY Medals DESC) AS Rank_N
FROM Athlete_Medals
ORDER BY Country ASC, RANK_N ASC;
