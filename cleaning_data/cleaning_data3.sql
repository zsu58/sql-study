-- In order to use fuzzy string matching functions like SOUNDEX() in Postgres
CREATE EXTENSION fuzzystrmatch;

-- -------
-- SOUNDEX
-- -------
/*
SOUNDEX(input_string): returns 4 character code in reference to the pronunciation
*/

-- 철자가 달라도 비슷한 소리일 경우 알고리즘에 의해 같은 값의 4자리 숫자 반환
SELECT 
  SOUNDEX('Fountainbleau'), -- 'F535'
  SOUNDEX('Fountainbleau'), -- 'F535'
  SOUNDEX('Fountainblue') -- 'F535'

-- ----------
-- DIFFERENCE
-- ----------
/*
DIFFERENCE(string1, string2): returns the number of position in which their Soundex codes match
* Since SOUNDEX always return 4 character codes the result of DIFFERENCE is always between 0 ~ 4
*/

--  return records that contain a vehicle_color value that closely matches the string 'GRAY'
SELECT
  summons_number,
  vehicle_color
FROM
  parking_violation
WHERE
  -- Match SOUNDEX codes of vehicle_color and 'GRAY'
  DIFFERENCE(vehicle_color, 'GRAY') = 4;


SELECT 
	summons_number,
    vehicle_color,
	DIFFERENCE(vehicle_color, 'RED') AS "red",
	DIFFERENCE(vehicle_color, 'BLUE') AS "blue",
	DIFFERENCE(vehicle_color, 'YELLOW') AS "yellow"
FROM
	parking_violation
WHERE
	(
		DIFFERENCE(vehicle_color, 'RED') = 4 OR
		DIFFERENCE(vehicle_color, 'BLUE') = 4 OR
		DIFFERENCE(vehicle_color, 'YELLOW') = 4
    -- Exclude records with 'BL' and 'BLA' vehicle colors
	) 
  AND vehicle_color NOT SIMILAR TO 'BLA?'
  -- AND vehicle_color ~! 'BLA?' -- same as above
