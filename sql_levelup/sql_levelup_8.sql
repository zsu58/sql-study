/*
[UNION을 사용한 쓸데없이 긴 표현]
*/

CREATE TABLE items (
	item_id integer,
	"year" integer,
	item_name varchar(6),
	price_tax_ex integer,
	price_tax_in integer
);

INSERT INTO items VALUES 
(100, 2000, '머그컵', 500, 525),
(100, 2001, '머그컵', 520, 546),
(100, 2002, '머그컵', 600, 630),
(100, 2003, '머그컵', 600, 630),
(101, 2000, '티스푼', 500, 525),
(101, 2001, '티스푼', 500, 525),
(101, 2002, '티스푼', 500, 525),
(101, 2003, '티스푼', 500, 525);

-- 안 좋은 쿼리
SELECT
    item_name,
    year,
    price_tax_ex
FROM
    items
WHERE
    YEAR <= 2001
UNION ALL
SELECT
    item_name,
    year,
    price_tax_in AS prcie
FROM
    items
WHERE
    YEAR >= 2002;

-- 나은 쿼리
SELECT 
	CASE 
		WHEN YEAR <=2001 THEN price_tax_ex		
		WHEN YEAR >= 2002 THEN price_tax_in	
	END AS price
FROM 
	items;
