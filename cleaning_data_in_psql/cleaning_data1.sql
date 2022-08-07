-- ------------------------
-- LPAD & REPLACE & INITCAP
-- ------------------------
/*
LPAD([column_name], [total_length], [character_that_will_be_filled])
REPLACE([column_name], [character_that_will_be_replace], [character_to_replace])
INITCAP([column_name])
*/
SELECT
  -- Add 0s to ensure violation_location is 4 characters in length
  LPAD(violation_location, 4, '0') AS violation_location,
  -- Replace 'P-U' with 'TRK' in vehicle_body_type column
  REPLACE(vehicle_body_type, 'P-U', 'TRK') AS vehicle_body_type,
  -- Ensure only first letter capitalized in street_name
  INITCAP(street_name) AS street_name
FROM
  parking_violation;

-- REGEXP_REPLACE는 cleaning_data2.sql 참고
SELECT 
  -- event_id is always 10 digits in length with preceding 0s added for any event_id less than 10 digits.
	LPAD(event_id, 10, '0') as event_id, 
  -- Fix capitalization in parking_held column
  INITCAP(parking_held) as parking_held
  -- one or more consecutive space characters in the parking_held column are replaced with a single space
  REGEXP_REPLACE(INITCAP(parking_held), ' +', ' ', 'g')  as parking_held
FROM 
    film_permit;
