/*
STRING DATA
*/

-- -----------
-- TO_TSVECTOR
-- -----------
-- TSVECTOR는 python의 .split()과 유사
WITH cte AS (
    SELECT
        column1 AS sentence
    FROM
        (
            VALUES
                ('zsu is in a park'),
                ('my name is ZSU'),
                ('arm is my girlfriend')
        ) AS foo
)
SELECT
	TO_TSVECTOR(sentence), -- 'zsu', 'is', 'in', 'a', 'park'/ 'my', 'name', 'is', 'zsu'
	sentence
FROM
    cte
WHERE 
	TO_TSVECTOR(sentence) @@ TSQUERY('zsu') -- zsu가 있는 문장(1,2번만 선택됨), ILIKE처럼 대소문자에 insensitive함
