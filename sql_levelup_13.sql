create TABLE Persons (
    name varchar(8),
    age INTEGER NOT NULL,
    height FLOAT NOT NULL,
    weight FLOAT NOT NULL,
    PRIMARY KEY(name)
);


INSERT INTO
    Persons
VALUES
    ('Anderson', 30, 188, 90),
    ('Adela', 21, 167, 55),
    ('Bates', 87, 158, 48),
    ('Becky', 54, 187, 70),
    ('Bill', 39, 177, 120),
    ('Chris', 90, 175, 48),
    ('Darwin', 12, 160, 55),
    ('Dawson', 25, 182, 90),
    ('Donald', 30, 176, 53);


SELECT
    SUBSTRING(name, 1, 1),
    COUNT(1)
FROM
    Persons
GROUP BY
    SUBSTRING(name, 1, 1)
ORDER BY
    SUBSTRING(name, 1, 1);


SELECT
    CASE
        WHEN age < 20 THEN 'kid'
        WHEN age BETWEEN 20 AND 69 THEN 'adult'
        WHEN age >= 70 THEN 'senior'
        ELSE null
    END AS "age_class",
    count(1)
FROM
    Persons
GROUP BY
    CASE
        WHEN age < 20 THEN 'kid'
        WHEN age BETWEEN 20 AND 69 THEN 'adult'
        WHEN age >= 70 THEN 'senior'
        ELSE null
    END;


SELECT
    CASE
        WHEN weight / POWER((height / 100):: FLOAT, 2) < 18.5 THEN 'low'
        WHEN weight / POWER((height / 100):: FLOAT, 2) BETWEEN 18.5 AND 24 THEN 'middle'
        WHEN weight / POWER((height / 100):: FLOAT, 2) >= 25 THEN 'high'
    END AS "bmi_grp",
    COUNT(1)
FROM
    Persons
GROUP BY
    "bmi_grp";


SELECT
    name,
    age,
    CASE
        WHEN age < 20 THEN 'kid'
        WHEN age BETWEEN 20 AND 69 THEN 'adult'
        WHEN age >= 70 THEN 'senior'
        ELSE null
    END AS "age_class",
    RANK() OVER(
        PARTITION BY CASE
            WHEN age < 20 THEN 'kid'
            WHEN age BETWEEN 20 AND 69 THEN 'adult'
            WHEN age >= 70 THEN 'senior'
            ELSE null
        END
        ORDER BY
            age
    ) AS "age_rank_in_class"
FROM
    Persons
ORDER BY
    age_class,
    age_rank_in_class;

