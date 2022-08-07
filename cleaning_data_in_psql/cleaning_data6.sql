/*
CONCAT: 값이 NULL인 경우 무시, 해당 값만 무시하고 다른 값은 합침
||: 값 중 NULL이 있는 경우 최종 결과로 NULL을 반환
*/

-- --
-- ||
-- --
SELECT NULL || 'a' || NULL || ' b' -- NULL

-- Combine street_name, ' & ', and intersecting_street
SELECT
  -- 이 경우 street_name과 intersecting_street 중 하나라도 NULL인 경우 NULL을 반환
  street_name || ' & ' || intersecting_street  AS corner
FROM
  parking_violation;

-- ------
-- CONCAT
-- ------
SELECT CONCAT(NULL, 'a', NULL, ' b') -- a b

SELECT
  -- NULL이 경우 있는 
  CONCAT(issue_date, ' ', violation_time) AS violation_datetime
FROM
  parking_violation

select concat(' ', '  ', 'dd')
