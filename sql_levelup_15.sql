CREATE TABLE Sales (company varchar(5), "year" integer, sale integer);

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


SELECT
    *,
    CASE
        SIGN(
            sale - max(sale) OVER (
                PARTITION BY company
                ORDER BY
                    "year" ROWS BETWEEN 1 PRECEDING
                    AND 1 preceding
            )
        )
        WHEN 0 THEN '='
        WHEN 1 THEN '+'
        WHEN -1 THEN '-'
        ELSE NULL
    END
FROM
    Sales;

