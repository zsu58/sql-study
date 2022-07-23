/*
Paging is splitting data into (approximately) equal chuncks
Many APIS return data in "pages" to reduce data being sent
*/

-- ----
-- PAGE
-- ----
-- There are exactly 666 unique events in the Summer Medals Olympics dataset
-- Split the distinct events into exactly 111 groups, ordered by event in alphabetical order.
WITH Events AS (
  SELECT DISTINCT Event
  FROM Summer_Medals
)  
SELECT
  --- Split up the distinct events into 111 unique groups
  Event,
  NTILE(111) OVER (ORDER BY Event ASC) AS Page
FROM Events
ORDER BY Event ASC;

-- Split the athletes into top, middle, and bottom thirds based on their count of medals.
WITH Athlete_Medals AS (
  SELECT Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete
  HAVING COUNT(*) > 1
)
SELECT
  Athlete,
  Medals,
  -- Split athletes into thirds by their earned medals
  NTILE(3) OVER (ORDER BY Medals DESC) AS Third
FROM Athlete_Medals
ORDER BY Medals DESC, Athlete ASC;
