/*
[SQL에서는 반복을 어떻게 표현할까?]
*/

/* 1. 포인트는 CASE와 WINDOW 함수 */
CREATE TABLE Sales (
  company varchar(5), "year" integer, 
  sale integer
);

INSERT INTO
    Sales
VALUES
    ('A', 2002, 50),
    ('A', 2003, 52),
    ('A', 2004, 55),
    ('A', 2007, 55),
    ('B', 2001, 27),
    ('B', 2005, 28),
    ('B', 2006, 28),
    ('B', 2009, 30),
    ('C', 2001, 40),
    ('C', 2005, 39),
    ('C', 2006, 38),
    ('C', 2010, 35);

-- 특정 기업의 매상 변화 산출
-- SIGN 함수는 숫자 자료형을 매개변수로 받아
-- 음수라면 -1, 양수라면 1, 0이라면 0을 리턴
SELECT
    *,
    CASE
        SIGN(
            sale - max(sale) OVER (
                PARTITION BY company
                ORDER BY
                    "year" ROWS BETWEEN 1 PRECEDING
                    AND 1 PRECEDING
            )
        )
        WHEN 0 THEN '='
        WHEN 1 THEN '+'
        WHEN -1 THEN '-'
        ELSE NULL
    END
FROM
    Sales;

-- 회사별 직전 매상 산출
SELECT
    *,
    MAX(sale) OVER(
        PARTITION BY company
        ORDER BY
            "year" ROWS BETWEEN 1 PRECEDING
            AND 1 PRECEDING
    ) AS pre_sale
FROM
    Sales;


/* 2. 최대 반복 횟수가 정해진 경우 */
CREATE TABLE post (
    pcode char(7),
    district_name varchar(50),
    CONSTRAINT pk_code PRIMARY key(pcode)
);

INSERT INTO
    post
VALUES
    ('4130001', 'a'),
    ('4130002', 'b'),
    ('4130103', 'c'),
    ('4130041', 'd'),
    ('4103213', 'e'),
    ('4380824', 'f');


-- 41330033과 가장 유사한 pcode 찾기
SELECT
    pcode,
    district_name
FROM
    post
WHERE
    CASE
        WHEN pcode = '4130033' THEN 0
        WHEN pcode LIKE '413003%' THEN 1
        WHEN pcode LIKE '41300%' THEN 2
        WHEN pcode LIKE '4130%' THEN 3
        WHEN pcode LIKE '413%' THEN 4
        WHEN pcode LIKE '41%' THEN 5
        WHEN pcode LIKE '4%' THEN 6
        ELSE NULL
    END = (
        SELECT
            MIN(
                CASE
                    WHEN pcode = '4130033' THEN 0
                    WHEN pcode LIKE '413003%' THEN 1
                    WHEN pcode LIKE '41300%' THEN 2
                    WHEN pcode LIKE '4130%' THEN 3
                    WHEN pcode LIKE '413%' THEN 4
                    WHEN pcode LIKE '41%' THEN 5
                    WHEN pcode LIKE '4%' THEN 6
                    ELSE NULL
                END
            )
        FROM
            post
    );

-- 앞선 경우는 seq scan이 2번이기에 아래와 같이 수정(정렬이 추가되지만 seq scan보다는 나음)
SELECT
    pcode,
    district_name
FROM
    (
        SELECT
            pcode,
            district_name,
            CASE
                WHEN pcode = '4130033' THEN 0
                WHEN pcode LIKE '413003%' THEN 1
                WHEN pcode LIKE '41300%' THEN 2
                WHEN pcode LIKE '4130%' THEN 3
                WHEN pcode LIKE '413%' THEN 4
                WHEN pcode LIKE '41%' THEN 5
                WHEN pcode LIKE '4%' THEN 6
                ELSE NULL
            END AS hc,
            MIN(
                CASE
                    WHEN pcode = '4130033' THEN 0
                    WHEN pcode LIKE '413003%' THEN 1
                    WHEN pcode LIKE '41300%' THEN 2
                    WHEN pcode LIKE '4130%' THEN 3
                    WHEN pcode LIKE '413%' THEN 4
                    WHEN pcode LIKE '41%' THEN 5
                    WHEN pcode LIKE '4%' THEN 6
                    ELSE NULL
                END
            ) OVER (
                ORDER BY
                    CASE
                        WHEN pcode = '4130033' THEN 0
                        WHEN pcode LIKE '413003%' THEN 1
                        WHEN pcode LIKE '41300%' THEN 2
                        WHEN pcode LIKE '4130%' THEN 3
                        WHEN pcode LIKE '413%' THEN 4
                        WHEN pcode LIKE '41%' THEN 5
                        WHEN pcode LIKE '4%' THEN 6
                        ELSE NULL
                    END
            ) AS min_code
        FROM
            post
    ) foo
WHERE
    hc = min_code;
