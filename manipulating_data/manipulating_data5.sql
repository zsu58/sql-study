/*
USER DEFINED TYPE
*/

-- -----------------
-- USER DEFINED TYPE
-- -----------------
CREATE TYPE dayofweek_german AS ENUM (
	'Montag',
	'Dienstag',
	'Mittwoch',
	'Donnerstag',
	'Freitag',
	'Samstag',
	'Sonntag'
)

-- confirm the created datatype
SELECT typname, typcategory
FROM pg_type
WHERE typname = 'dayofweek_german'

-- check out column information of table 'all_visits'
SELECT column_name, data_type, udt_name
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'all_visits'
