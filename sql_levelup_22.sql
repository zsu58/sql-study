CREATE TABLE companies (
    co_cd char(3) NOT NULL PRIMARY key,
    district char(1) NOT NULL
);


INSERT INTO
    companies
VALUES
    ('001', 'A'),
    ('002', 'B'),
    ('003', 'C'),
    ('004', 'D');


CREATE TABLE shops (
    co_cd char(3) NOT NULL,
    shop_id char(3) NOT NULL,
    emp_nbr integer NOT NULL,
    main_flg char(1) NOT NULL,
    PRIMARY KEY (co_cd, shop_id)
);


INSERT INTO
    shops
VALUES
    ('001', '1', 300, 'Y'),
    ('001', '2', 400, 'N'),
    ('001', '3', 250, 'Y'),
    ('002', '1', 100, 'Y'),
    ('002', '2', 20, 'N'),
    ('003', '1', 400, 'Y'),
    ('003', '2', 500, 'Y'),
    ('003', '3', 300, 'N'),
    ('003', '4', 200, 'Y'),
    ('004', '1', 999, 'Y');


EXPLAIN ANALYZE
SELECT
    c.co_cd,
    c.district,
    sum(emp_nbr)
FROM
    companies c
    INNER JOIN
        shops s
    ON
        c.co_cd = s.co_cd
        AND main_flg = 'Y'
GROUP BY
    c.co_cd,
    c.district;

