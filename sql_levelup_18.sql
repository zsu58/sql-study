CREATE TABLE employees (
    emp_id char(8) PRIMARY key,
    emp_name varchar(32),
    dept_id char(2)
);


CREATE TABLE departments (dept_id char(2) PRIMARY KEY, dept_name varchar(32));


INSERT INTO
    employees
VALUES
    ('001', '하린', 10),
    ('002', '한마루', 11),
    ('003', '사라', 11),
    ('004', '중민', 12),
    ('005', '웅식', 12),
    ('006', '주아', 12);


INSERT INTO
    departments
VALUES
    ('10', '총무'),
    ('11', '인사'),
    ('12', '개발'),
    ('13', '영업');


EXPLAIN ANALYZE
SELECT
    dept_id,
    dept_name
FROM
    departments d
WHERE
    EXISTS (
        SELECT
            1
        FROM
            employees e
        WHERE
            d.dept_id = e.dept_id
    );


EXPLAIN analyze
SELECT
    dept_id,
    dept_name
FROM
    departments d
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            employees e
        WHERE
            d.dept_id = e.dept_id
    );


-- not in이 not exists 보다 나음
EXPLAIN analyze
SELECT
    dept_id,
    dept_name
FROM
    departments d
WHERE
    dept_id NOT IN (
        SELECT
            dept_id
        FROM
            employees e
    );


ANALYZE departments;
ANALYZE employees;

