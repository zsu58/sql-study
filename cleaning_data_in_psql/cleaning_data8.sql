-- ----------
-- SPLIT_PART
-- ----------
-- SPLIT_PART(source_string, delimiter_string, part_number)
SELECT SPLIT_PART('a / b', ' / ', 2) -- b

-- return the part of the house_number value after the dash character ('-') 
-- (if a dash character is present in the column value)
SELECT
  -- Split house_number using '-' as the delimiter
  SPLIT_PART(house_number, '-', 2) AS new_house_number
FROM
  parking_violation
WHERE
  violation_county = 'Q';

-- ---------------------
-- REGEXP_SPLIT_TO_TABLE
-- ---------------------
-- REGEXP_SPLIT_TO_TABLE(source, pattern)
SELECT REGEXP_SPLIT_TO_TABLE('a/b', '/') -- two rows (a, b)

-- Use REGEXP_SPLIT_TO_TABLE() with the empty-string ('') as a delimiter to split days_parking_in_effect into a single availability symbol
SELECT
    street_address,
    violation_county,
    REGEXP_SPLIT_TO_TABLE(days_parking_in_effect, '') AS daily_parking_restriction 
    -- days_parking_in_effect (e.g. 'BBBBB' 'YYYYY')
  FROM
    parking_restriction
