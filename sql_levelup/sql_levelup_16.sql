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

