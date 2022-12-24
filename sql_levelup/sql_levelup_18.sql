/*
[기능적 관점으로 구분하는 결합의 종류]
1. 크로스 결합 - 모든 결합의 모체
* 크로스 결합은 (두 테이블 간) 가능한 모든 조합을 구하는 연산
* 이러한 결과는 보통 필요가 없으며, 비용이 많이 드는 연산이라 실무에서 사용되지 않음

2. 내부 결합 - 왜 '내부'라는 말을 사용할까
* cf. 만약 결합조건이 기본 키일 경우 상관 서브쿼리가 내부 결합을 대체할 수 있으나, 기본적으로 내부 결합 연산의 성능이 좋음

3. 외부 결합 - 왜 '외부'라는 말을 사용할까

4. 외부 결합과 내부 결합의 차이
* 외부 결합은 마스터 테이블의 정보를 모두 보존하고자 함

5. 자기 결합 - '자기'란 누구일까?
* 자기 자신과 결합하는 연산
*/
CREATE TABLE employees (
    emp_id char(8) PRIMARY key,
    emp_name varchar(32),
    dept_id char(2)
);

CREATE TABLE departments (
    dept_id char(2) PRIMARY KEY, 
    dept_name varchar(32)
);

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
