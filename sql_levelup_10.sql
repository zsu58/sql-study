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


SELECT
    *
FROM
    test
WHERE
    date_1 = '2013-11-01'
    AND flg_1 = 'T'
    OR date_2 = '2013-11-01'
    AND flg_2 = 'T'
    OR date_3 = '2013-11-01'
    AND flg_3 = 'T';


SELECT
    *
FROM
    test
WHERE
    ('2013-11-01', 'T') IN ((date_1, flg_1), (date_2, flg_2), (date_3, flg_3));


EXPLAIN analyze
SELECT * FROM test WHERE 
CASE 
	WHEN date_1 = '2013-11-01' THEN flg_1
	WHEN date_2 = '2013-11-01' THEN flg_2
	WHEN date_3 = '2013-11-01' THEN flg_3
	ELSE NULL
END = 'T';

