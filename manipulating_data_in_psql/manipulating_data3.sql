/*
STRING DATA
*/

-- ------
-- CONCAT
-- ------
SELECT 
	CONCAT('ZSU', ' ', 'PARK', ' <', 'zsu58@icloud.com', '>'),
	'ZSU' || ' ' || 'PARK' || ' <' || 'zsu58@icloud.com' || '>'; -- 위와 같음

-- -----------------------
-- UPPER & LOWER & INITCAP
-- -----------------------
SELECT 
  UPPER('zsu'),
  LOWER('ZSU'),
  INITCAP('zsu');

-- -------
-- REPLACE
-- -------
SELECT 
	REPLACE('ZSU PARK', ' ', '_')

-- ------
-- LENGTH
-- ------
SELECT
	LENGTH('ZSU PARK'), -- 8
	CHAR_LENGTH('ZSU PARK') -- 8

-- ------------
-- LEFT & RIGHT
-- ------------
SELECT
	LEFT('ZSU PARK', 3), -- ZSU
	RIGHT('ZSU PARK', 4) -- PARK

-- --------
-- POSITION
-- --------
SELECT 
	POSITION('@' IN 'zsu58@icloud.com'), -- 6
	STRPOS('zsu58@icloud.com', '@') -- 6

-- ---------
-- SUBSTRING
-- ---------
SELECT 
	SUBSTRING('zsu58@icloud.com', 0, 6), -- zsu58
	SUBSTRING('zsu58@icloud.com' FROM 0 FOR 6), -- zsu58
	SUBSTRING('zsu58@icloud.com' FROM 0 FOR POSITION('@' IN 'zsu58@icloud.com')) -- zsu58

SELECT 
  -- Select only the street name from the address table
  -- address(e.g. 47 WELLBEING STREET)
  SUBSTRING(address FROM POSITION(' ' IN address)+1 FOR LENGTH(address))
FROM 
  address;

-- extract username and mail address from email
SELECT
  -- Extract the characters to the left of the '@'
  LEFT(email, POSITION('@' IN email)-1) AS username,
  -- Extract the characters to the right of the '@'
  SUBSTRING(email FROM POSITION('@' IN email)+1 FOR LENGTH(email)) AS domain
FROM customer;

-- ----
-- TRIM
-- ----
-- TRIM([leading | trailing | both(default)] [characters(default is all whitespaces)] from string)
SELECT TRIM('  all padded  ') -- all padded
SELECT LTRIM('  left padded  ') -- left padded  
SELECT RTRIM('  right padded  ') --   right padded

-- truncate the description to the first 50 characters and make sure there is no white space after truncating
SELECT 
  TRIM(LEFT(description, 50)) AS film_desc
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;

-- -----------
-- LPAD & RPAD
-- -----------
SELECT LPAD('padded', 10, '#') -- ####padded
SELECT LPAD('padded', 10) --     padded

SELECT RPAD('padded', 10, '#') -- padded####
SELECT RPAD('padded', 10) -- padded    

-- CONCAT 대신 RPAD 활용
SELECT 
	RPAD(first_name, LENGTH(first_name)+1) 
    || RPAD(last_name, LENGTH(last_name)+2, ' <') 
    || RPAD(email, LENGTH(email)+1, '>') AS full_email,
    -- 아래와 같은 결과 만들기
    CONCAT('ZSU', ' ', 'PARK', ' <', 'zsu58@icloud.com', '>')
FROM customer; 

-- -------
-- REVERSE
-- -------

SELECT REVERSE('ZSU PARK') -- KRAP USZ

-- 10음절 이하에서 단어를 모두 가져오되, 마지막 단어가 중간에 끊길 경우 앞 단어까지만 가져오며 white space도 모두 제거
SELECT
    LEFT(
        'ZSU PARK is in a park',
        10 - POSITION(' ' IN REVERSE(LEFT('ZSU PARK is in a park  ', 10)))
    )
