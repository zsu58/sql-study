/*
[그래도 UNION이 필요한 경우]
*/

/* 
1. UNION을 사용할 수 밖에 없는 경우 
* 여러 개의 테이블에서 검색한 결과를 머지하는 경우
* UNION을 사용했을 때 인덱스를 사용하는 경우
*/

CREATE TABLE test (
    KEY integer,
    name varchar(5),
    date_1 date,
    flg_1 varchar(5),
    date_2 date,
    flg_2 varchar(5),
    date_3 date,
    flg_3 varchar(5)
);

INSERT INTO
    test
VALUES
    (1, 'a', '2013-11-01', 'T', NULL, NULL, NULL, NULL),
    (2, 'b', NULL, 'T', '2013-11-01', 'T', NULL, NULL),
    (3, 'c', NULL, 'T', '2013-11-01', 'F', NULL, NULL),
    (4, 'd', NULL, 'T', '2013-12-30', 'T', NULL, NULL),
    (5, 'e', NULL, 'T', NULL, NULL, '2013-11-01', 'T'),
    (6, 'f', NULL, 'T', NULL, NULL, '2013-11-01', 'F'),
    (7, 'g', '2013-11-01', 'F', NULL, NULL, '2013-11-01', 'T');

CREATE INDEX idx_1 ON test (date_1, flg_1);
CREATE INDEX idx_2 ON test (date_2, flg_2);
CREATE INDEX idx_3 ON test (date_3, flg_3);

-- index를 활용할 수 있는 경우
SELECT
    "key",
    "name",
    date_1,
    flg_1,
    date_2,
    flg_2,
    date_3,
    flg_3
FROM
    test
WHERE
    date_1 = '2013-11-01'
    AND flg_1 = 'T'
UNION
SELECT
    "key",
    "name",
    date_1,
    flg_1,
    date_2,
    flg_2,
    date_3,
    flg_3
FROM
    test
WHERE
    date_2 = '2013-11-01'
    AND flg_2 = 'T'
UNION
SELECT
    "key",
    "name",
    date_1,
    flg_1,
    date_2,
    flg_2,
    date_3,
    flg_3
FROM
    test
WHERE
    date_3 = '2013-11-01'
    AND flg_3 = 'T'


-- OR을 사용해 full scan 한번
SELECT
    *
FROM
    test
WHERE
    (
        date_1 = '2013-11-01'
        AND flg_1 = 'T'
    )
    OR (
        date_2 = '2013-11-01'
        AND flg_2 = 'T'
    )
    OR (
        date_3 = '2013-11-01'
        AND flg_3 = 'T'
    );

-- IN을 활용(실행 계획은 위의 OR과 같음)
SELECT
    *
FROM
    test
WHERE
    ('2013-11-01', 'T') IN ((date_1, flg_1), (date_2, flg_2), (date_3, flg_3));


-- case를 사용하는 경우(실행 계획은 위의 OR, IN과 같음)
SELECT
    *
FROM
    test
WHERE
    CASE
        WHEN date_1 = '2013-11-01' THEN flg_1
        WHEN date_2 = '2013-11-01' THEN flg_2
        WHEN date_3 = '2013-11-01' THEN flg_3
        ELSE NULL
    END = 'T'

/* 
위 3가지 경우에서
테이블이 크고 WHERE 조건으로 선택되는 레코드 수가 작을 경우 UNION(index 활용)이 OR보다 빠름
case 문의 경우 결과가 다른 것과 다름, 이런 부분도 주의해야함
*/