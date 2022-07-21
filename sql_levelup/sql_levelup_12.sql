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
    sum(high_age - low_age) = 100;


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

