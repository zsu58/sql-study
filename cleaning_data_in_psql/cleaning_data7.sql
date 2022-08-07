-- ---------
-- SUBSTRING
-- ---------
SELECT
  SUBSTRING(violation_time FROM 1 FOR 2) AS hour,
  -- Define minute column
   SUBSTRING(violation_time, 3, 2) AS minute
FROM
  parking_violation;


-- ------
-- STRPOS
-- ------
SELECT STRPOS('16-12', '-') -- 3

-- return the position in the house_number column where the first '-' location is found 
-- if the house_number does not contain '-' return 0
SELECT
  STRPOS(house_number, '-') AS dash_position
FROM
  parking_violation;

-- if the address is 86-16 60 Ave, the house number is 16
-- extract the number after '-'
SELECT
  house_number,
  -- Extract the substring after '-'
  SUBSTRING(
    house_number
    -- Calculate the position that is 1 beyond '-'
    FROM STRPOS(house_number, '-') + 1
    -- Calculate number characters from dash to end of string
    FOR LENGTH(house_number) - STRPOS(house_number, '-')
  ) AS new_house_number
FROM
  parking_violation;
