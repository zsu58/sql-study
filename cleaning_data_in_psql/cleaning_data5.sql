-- -------------
-- NULLIF & DATE
-- -------------
SELECT
  -- -- Replace '0' with NULL then Convert date_first_observed into DATE
  DATE(NULLIF(date_first_observed, '0')) AS date_first_observed
FROM
  parking_violation;

-- -------
-- TO_CHAR
-- -------
SELECT
  summons_number,
  -- Display issue_date using the YYYYMMDD format
  TO_CHAR(issue_date, 'YYYYMMDD') AS issue_date,
  -- Display date_first_observed using the YYYYMMDD format
  TO_CHAR(date_first_observed, 'YYYYMMDD') AS date_first_observed
FROM (
  SELECT
    summons_number,
    DATE(issue_date) AS issue_date, -- issue_date e.g. 06/14/2019 
    DATE(date_first_observed) AS date_first_observed
  FROM
    parking_violation
) sub



-- ------------
-- TO_TIMESTAMP
-- ------------
/*
patterns
'HH24', 'HH12', 'HH24:MI', 'MI:SS', 'HH12:MIPM', 'HH12:MIAM'
*/
SELECT
  -- Convert violation_time to a TIMESTAMP
  TO_TIMESTAMP(violation_time, 'HH12MIPM')::TIME AS violation_time -- violation_time e.g. 0301PM
FROM
  parking_violation
WHERE
  -- Exclude NULL violation_time
  violation_time IS NOT NULL;

-- -------
-- EXTRACT
-- -------
/*
extractable
'year', 'month', 'day', 'hour', 'minute', 'second'
*/
SELECT
  -- Populate column with violation_time hours
  EXTRACT('hour' FROM violation_time) AS hour,
  COUNT(*)
FROM (
    SELECT
      TO_TIMESTAMP(violation_time, 'HH12MIPM')::TIME as violation_time
    FROM
      parking_violation
    WHERE
      violation_time IS NOT NULL
) sub
GROUP BY
  hour
ORDER BY
  hour

/*
More about Postgres date format: https://www.postgresql.org/docs/12/functions-formatting.html
*/