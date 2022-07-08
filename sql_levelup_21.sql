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

