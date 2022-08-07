/*
Common Data Types
* Text
  * CHAR, VARCHAR, TEXT
* NUMERIC
  * INT, DECIMAL
* DATE/TIME
  * DATE, TIME, TIMESTAMP, INTERVAL
    * Postgres uses ISO 8601 format(yyyy-mm-dd  ) for TIMESTAMP
    * TIMESTAMP can include, or not include(default) timezone
* Arrays
*/

-- ----------
-- DATA TYPES
-- ----------
-- Select all columns from the TABLES system database where table schema is 'public'
SELECT * 
FROM INFORMATION_SCHEMA.TABLES
WHERE table_schema = 'public';


 -- Select all columns from the COLUMNS system database where table name is 'actor'
 SELECT * 
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_name = 'actor';

-- -----
-- ARRAY
-- -----
-- Select all films that have a special feature 'Trailers' as the first index of the special_features ARRAY
SELECT 
  title, 
  special_features 
FROM film
WHERE special_features[1] = 'Trailers';

-- Making a table containing an array column
CREATE TABLE grades (
  student_id int,
  email text[][],
  test_scores int[]
)

INSERT INTO grades VALUES (
  1, 
  '{{"work", "work@email.com"}, {"home", "home@email.com"}}',
  '{92, 80}'
)

SELECT 
  email[1][1] AS type,
  email[1][2] AS work_email_address,
  test_scores[1]
FROM grades;

-- ---
-- ANY
-- ---
-- The ANY function allows you to search for a value in any index position of an ARRAY
-- Match 'Trailers' in any index of the special_features ARRAY regardless of position
SELECT
  title, 
  special_features 
FROM film 
WHERE 'Trailers' = ANY (special_features);
-- WHERE special_features @> ARRAY['Trailers']; -- 위랑 같음
