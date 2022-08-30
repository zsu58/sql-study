/*
[집계와 조건 분기]
*/

/* 1. 집계 대상으로 조건 분기 */
CREATE TABLE population (
	prefecture varchar(4),
	sex integer,
	pop integer
);

INSERT INTO population VALUES
('성남', 1, 60),
('성남', 2, 40),
('수원', 1, 90),
('수원', 2, 100),
('광명', 1, 100),
('광명', 2, 50),
('일산', 1, 100),
('일산', 2, 100),
('용인', 1, 20),
('용인', 2, 200);


SELECT 
	prefecture,
	SUM(CASE 
		WHEN sex = 1 THEN pop 
	END) AS pop_men,
	SUM(CASE 
		WHEN sex = 2 THEN pop
	END) AS pop_wom
FROM population
GROUP BY prefecture;


/* 2. 집약 결과로 조건 분기 */
CREATE TABLE employees (
	emp_id integer,
	team_id integer,
	emp_name varchar(5),
	team varchar(8)
);

INSERT INTO employees VALUES
(201, 1, 'Joe', '상품기획'),
(201, 2, 'Joe', '개발'),
(201, 3, 'Joe', '영업'),
(201, 2, 'Jim', '개발'),
(201, 3, 'Carl', '영업'),
(201, 1, 'Bree', '상품기획'),
(201, 2, 'Bree', '개발'),
(201, 3, 'Bree', '영업'),
(201, 4, 'Bree', '관리'),
(201, 1, 'Kim', '상품기획'),
(201, 2, 'Kim', '개발');

SELECT
    emp_name,
    CASE
        WHEN count(1) >= 3 THEN '3개 이상을 겸무'
        WHEN count(1) = 2 THEN '2개 이상을 겸무'
        ELSE max(team)
    END
FROM
    employees
GROUP BY
    emp_name;
