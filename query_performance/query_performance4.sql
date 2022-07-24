/*
가능하면 조인하기 전에 데이터를 축소할 것
*/

-- 조인하고 통계지표를 산출하는게 아니라, 통계지표 산출후 조인
WITH athletes as (
  SELECT country_code, year, COUNT(athlete_id) AS no_athletes
  FROM athletes
  GROUP BY country_code, year
)
SELECT demos.country, ath.year, ath.no_athletes
    , demos.gdp_rank
    , demos.population_rank
FROM athletes ath
INNER JOIN demographics_rank demos  
  ON ath.country_code = demos.olympic_cc
  AND ath.year = demos.year
ORDER BY ath.no_athletes DESC;
