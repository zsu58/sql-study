/*
TIME DATA
* DATE -/ + DATE returns INTEGER
* DATE -/ + INTEGER returns DATE
* TIMESTAMP -/ + TIMESTAMP returns INTERVAL
* TIMESTAMP -/ + INTERVAL returns TIMESTAMP
  * SELECT timestamp '2021-08-21' + (21 * INTERVAL '1 day');
* AGE(TIMESTAMP, TIMESTAMP) returns INTERVAL
*/

-- --------
-- INTERVAL
-- --------
SELECT
 	-- Select the rental and return dates
	rental_date,
	return_date,
 	-- Calculate the expected_return_date
	rental_date + INTERVAL '3 day' AS expected_return_date
FROM rental;

-- ---
-- AGE
-- ---
SELECT 
    f.title, f.rental_duration,
    -- Calculate the number of days rented
    r.return_date - r.rental_date AS days_rented
    -- AGE(r.return_date, r.rental_date) AS days_rented -- 위와 같음
FROM film AS f
     INNER JOIN inventory AS i ON f.film_id = i.film_id
     INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY f.title;

-- ------------------
-- ARITHMETIC in DATE
-- ------------------
SELECT
    f.title,
	  r.rental_date,
    f.rental_duration,
    -- Add the rental duration(integer) to the rental date
    -- INTERVAL * INTEGER해서 DATE에 더할 수 있게 함
    (INTERVAL '1' day * f.rental_duration) + r.rental_date AS expected_return_date,
    r.return_date
FROM film AS f
    INNER JOIN inventory AS i ON f.film_id = i.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY f.title;

/*
* NOW() -- returns current date and time as a timestamp with timezone
* CURRENT_TIMESTAMP -- returns current date and time as a timestamp with timezone
* CURRENT_DATE -- returns current date without timezone
* CURRENT_TIME -- returns current time with timezone
*/

-- ------------
-- CURRENT TIME
-- ------------
SELECT NOW();
SELECT CURRENT_TIMESTAMP;
SELECT CURRENT_TIMESTAMP(0)::TIMESTAMP, -- TIMESTAMP를 통해 TIMEZONE 제외 가능
SELECT CURRENT_TIMESTAMP(1)::TIMESTAMP -- ms n번째 자리에서 반올림
SELECT CURRENT_DATE;
SELECT CURRENT_TIME;


-- -------------------
-- EXTRACT & DATE_PART
-- -------------------
SELECT EXTRACT('year' FROM '2019-05-31 18:00:00'::TIMESTAMP) --2019
SELECT DATE_PART('year', '2019-05-31 18:00:00'::TIMESTAMP) --2019

SELECT EXTRACT('month' FROM '2019-05-31 18:00:00'::TIMESTAMP) --5
SELECT DATE_PART('month', '2019-05-31 18:00:00'::TIMESTAMP) --5

SELECT EXTRACT('day' FROM '2019-05-31 18:00:00'::TIMESTAMP) --31
SELECT DATE_PART('day', '2019-05-31 18:00:00'::TIMESTAMP) --31

-- SUN: 0, MON: 1, TUE: 2, WED: 3, THU: 4, FRI: 5, SAT: 6
SELECT EXTRACT('dow' FROM '2022-08-01 18:00:00'::TIMESTAMP) --1
SELECT DATE_PART('dow', '2022-08-01 18:00:00'::TIMESTAMP) --1

-- ----------
-- DATE_TRUNC
-- ----------
-- 앞의 파라미터를 기준으로 그 뒤의 시간은 가장 초기의 값이 옴
SELECT DATE_TRUNC('year', '2019-05-31 18:00:00'::TIMESTAMP); --'2019-01-01 00:00:00
SELECT DATE_TRUNC('month', '2019-05-31 18:00:00'::TIMESTAMP); --'2019-05-01 00:00:00
SELECT DATE_TRUNC('day', '2019-05-31 18:00:00'::TIMESTAMP); --'2019-05-31 00:00:00


-- 통합 예시
SELECT 
  c.first_name || ' ' || c.last_name AS customer_name,
  f.title,
  r.rental_date,
  EXTRACT(dow FROM r.rental_date) AS dayofweek,
  AGE(r.return_date, r.rental_date) AS rental_days,
  -- 총 빌린 일수가(시간은 버림), 해당 비디오의 대여 가능한 일짜보다 더 긴 시간(즉, 연체)일 경우 true, 그 외 false
  -- AGE를 통해 INTERVAL를 가져온뒤, DATE_TRUNC을 통해 시간을 버림
  -- 이 값을 rental_duration(INTEGER가 비교하기 위해 rental_duration에 INTERVAL '1' day와 곱함
  CASE WHEN DATE_TRUNC('day', AGE(r.return_date, r.rental_date)) > 
    f.rental_duration * INTERVAL '1' day 
  THEN TRUE 
  ELSE FALSE END AS past_due 
FROM 
  film AS f 
  INNER JOIN inventory AS i 
  	ON f.film_id = i.film_id 
  INNER JOIN rental AS r 
  	ON i.inventory_id = r.inventory_id 
  INNER JOIN customer AS c 
  	ON c.customer_id = r.customer_id 
WHERE 
  -- DATE간 비교, 5월 1일부터 이후 90일 사이에 rental한 기록 가져오기
  r.rental_date BETWEEN CAST('2005-05-01' AS DATE) 
  AND CAST('2005-05-01' AS DATE) + INTERVAL '90 day';
