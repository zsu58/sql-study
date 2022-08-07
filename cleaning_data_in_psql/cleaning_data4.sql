-- --------
-- COALESCE
-- --------
UPDATE
  parking_violation
SET
  -- Replace NULL vehicle_body_type values with `Unknown`
  vehicle_body_type = COALESCE(vehicle_body_type, 'Unknown');

-- ----
-- CAST
-- ----
-- CAST는 SQL Standard
-- ::는 Postgres에서만 사용 가능

SELECT
  -- Define the range_size from the max and min summons number
  MAX(summons_number::BIGINT) - MIN(summons_number::BIGINT) AS range_size
  -- MAX(CAST(summons_number AS BIGINT)) - MIN(CAST(summons_number AS BIGINT)) AS range_size -- 위와 같음
FROM
  parking_violation;
