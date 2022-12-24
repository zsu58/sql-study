/*
[서브쿼리가 일으키는 폐해]
1. 서브쿼리의 문제점
* 연산 비용 추가
  * 실제적인 데이터를 저장하고 있지 않아 서브쿼리에 접근할 때마다 SELECT 구문을 실행해 데이터를 만들어야 함(서브쿼리 내용이 복잡할 수록 실행 비용은 높아짐)
* 데이터 I/O 비용 발생
  * 연산 결과가 어딘가에는 저장되어야 함, 이때 데이터 양이 크면 (메모리에 다 못 올려) 접근 속도가 급격하게 떨어질 수 있음
* 최적화를 받을 수 없음
  * 서브쿼리로 만들어지는 데이터는 구고적으로 테이블과 같음
  * 그러나 명시적인 제약 또는 인덱스가 있는 테이블과 달리 메타 정보가 없어 옵티마이저는 쿼리를 해석하기 위한 정보를 서브쿼리에서 얻을 수 없음

2. 서브쿼리 의존증


*/

CREATE TABLE receipts (
    cust_id char(1) NOT NULL,
    seq integer NOT NULL,
    price integer NOT NULL,
    primary key(cust_id, seq)
);


INSERT INTO
    receipts
VALUES
    ('A', 1, 500),
    ('A', 2, 1000),
    ('A', 3, 700),
    ('B', 5, 100),
    ('B', 6, 5000),
    ('B', 7, 300),
    ('B', 9, 200),
    ('B', 12, 1000),
    ('C', 10, 600),
    ('C', 20, 100),
    ('C', 45, 200),
    ('C', 70, 50),
    ('D', 3, 2000);


SELECT
    *
FROM
    (
        SELECT
            *,
            ROW_NUMBER() OVER(
                PARTITION BY cust_id
                ORDER BY
                    seq
            ) row_num
        FROM
            receipts
    ) AS foo
WHERE
    row_num = 1;


-- 좋지 못한 방법
WITH cte AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY cust_id
            ORDER BY
                seq
        ) AS f,
        ROW_NUMBER() OVER(
            PARTITION BY cust_id
            ORDER BY
                seq DESC
        ) AS l
    FROM
        receipts
),
first_price AS (
    SELECT
        cust_id,
        price
    FROM
        cte
    WHERE
        f = 1
),
last_price AS (
    SELECT
        cust_id,
        price
    FROM
        cte
    WHERE
        l = 1
)
SELECT
    cust_id,
    fp.price - lp.price
FROM
    first_price AS fp
    INNER JOIN
        last_price AS lp USING (cust_id);


-- 위보다 좋은 방법
WITH cte AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY cust_id
            ORDER BY
                seq
        ) AS f,
        ROW_NUMBER() OVER(
            PARTITION BY cust_id
            ORDER BY
                seq DESC
        ) AS l
    FROM
        receipts
)
SELECT
    cust_id,
    SUM(
        CASE
            WHEN f = 1 THEN price
            ELSE 0
        END
    ) - SUM(
        CASE
            WHEN l = 1 THEN price
            ELSE 0
        END
    )
FROM
    cte
GROUP BY
    cust_id;

