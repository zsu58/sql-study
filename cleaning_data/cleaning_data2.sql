-- ----------
-- SIMILAR TO
-- ----------
/*
regex can be used in Postgres by using SIMILAR TO or ~
*/

-- When summons_number match the pattern '\d\d\d\dA' assign 1 otherwise assign 0
SELECT 
	summons_number, 
    CASE WHEN 
    	summons_number IN (
          SELECT 
  			summons_number 
  		  FROM 
  			parking_violation 
  		  WHERE 
  			violation_time SIMILAR TO '\d\d\d\dA'
        -- violation_time ~ '\d\d\d\dA' -- same as above
    	)
        THEN 1 
        ELSE 0 
    END AS morning 
FROM 
	parking_violation;

-- returns records containing a plate_type that does not match three consecutive uppercase letters.
SELECT
  summons_number,
  plate_id,
  plate_type
FROM
  parking_violation
WHERE
  -- Define the pattern to use for matching
  plate_type NOT SIMILAR TO '[A-Z]{3}]';

-- return records with a vehicle_make not including an uppercase letter, a forward slash (/), or a space (\s)
SELECT
  summons_number,
  plate_id,
  vehicle_make
FROM
  parking_violation
WHERE
  -- Define the pattern to use for matching
  vehicle_make NOT SIMILAR TO '[A-Z][/][\s]]';

-- --------------
-- REGEXP_REPLACE
-- --------------
/*
REGEXP_REPLACE(source, pattern, replace, flags)
cf. flags is an optional string used to control matching.
*/
-- Replace uppercase letters in plate_id with dash
SELECT 
	summons_number,
	REGEXP_REPLACE(plate_id, '[A-Z]', '-', 'g') -- 'g': stands for global, ensuring every match is replaced.
FROM 
	parking_violation;
