/*
[집약]
*/

/*
1. 여러 개의 레코드를 한 개의 레코드로 집약
* CASE와 함께 MAX, MIN을 활용
*/

CREATE TABLE nonaggtbl (
	id varchar(4),
	data_type varchar(1),
	data_1 integer,
	data_2 integer,
	data_3 integer,
	data_4 integer,
	data_5 integer,
	data_6 integer
);

INSERT INTO nonaggtbl VALUES
('Jim', 'A', 100, 10, 34, 346, 54, null),
('Jim', 'B', 45, 2, 167, 77, 90, 157),
('Jim', 'C', null, 3, 687, 1355, 324, 457),
('Ken', 'A', 78, 5, 724, 457, null, 1),
('Ken', 'B', 123, 178, 34, 346, 85, 235),
('Ken', 'C', 45, 23, 34, 46, 687, 33),
('Beth', 'A', 75, 0, 190, 25, 356, null),
('Beth', 'B', 435, 0, 183, null, 4, 325),
('Beth', 'C', 96, 128, null, 0, 0, 12);

SELECT 
	id,
	MAX(CASE WHEN data_type = 'A' THEN data_1 ELSE NULL END) AS data_1,
	MAX(CASE WHEN data_type = 'A' THEN data_2 ELSE NULL END) AS data_2,
	MAX(CASE WHEN data_type = 'B' THEN data_3 ELSE NULL END) AS data_3,
	MAX(CASE WHEN data_type = 'B' THEN data_4 ELSE NULL END) AS data_4,
	MAX(CASE WHEN data_type = 'B' THEN data_5 ELSE NULL END) AS data_5,
	MAX(CASE WHEN data_type = 'C' THEN data_6 ELSE NULL END) AS data_6
FROM
	nonaggtbl
GROUP BY
	id;

/*
집약, 해시, 정렬
* GROUP BY 시 정렬 혹은 해시 함수가 사용
  * 해시 함수는 같은 키를 가진 그룹을 모아 집약, 고전적인 정렬보다 빠름
  * 다만, 정렬 혹은 해시는 모두 메모리를 사용해 충분한 워킹 메모리가 없을 경우 느려짐
*/

/*
2. 합쳐서 하나
*/
CREATE TABLE PriceByAge (
    product_id varchar(32) NOT NULL,
    low_age integer NOT NULL,
    high_age integer NOT NULL,
    price integer NOT NULL,
    PRIMARY KEY (product_id, low_age),
    CHECK (low_age < high_age)
);

INSERT INTO
    PriceByAge
VALUES
    ('a', 0, 50, 2000),
    ('a', 51, 100, 3000),
    ('b', 0, 100, 4200),
    ('c', 0, 20, 500),
    ('c', 31, 70, 800),
    ('c', 71, 100, 1000),
    ('d', 0, 99, 8900);


SELECT
    product_id
FROM
    PriceByAge
GROUP BY
    product_id
HAVING
    sum(high_age - low_age + 1) = 101;


CREATE TABLE HotelRooms (
    room_nbr INTEGER,
    start_date date,
    end_date date,
    PRIMARY key(room_nbr, start_date)
);

INSERT INTO
    HotelRooms
VALUES
    (101, '2008-02-01', '2008-02-06'),
    (101, '2008-02-06', '2008-02-08'),
    (101, '2008-02-10', '2008-02-13'),
    (202, '2008-02-05', '2008-02-08'),
    (202, '2008-02-08', '2008-02-11'),
    (202, '2008-02-11', '2008-02-12'),
    (303, '2008-02-03', '2008-02-17');


SELECT
    *
FROM
    hotelrooms
SELECT
    room_nbr,
    sum(end_date - start_date)
FROM
    HotelRooms
GROUP BY
    room_nbr
having
    sum(end_date - start_date) >= 10;
