/*
Postgres
  * object-relational database management system
  * system components are objects
  * database is the top-level object
*/

-- ---------
-- CREATE DB
-- ---------
-- db_name cannot start with number, and should be less than 32 characters given default settings
CREATE DATABASE db_name;

-- ------------
-- CREATE TABLE
-- ------------
CREATE TABLE IF NOT EXISTS business_type (
	id SERIAL PRIMARY KEY,
  "description" TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS applicant (
	id SERIAL PRIMARY KEY,
  "name" TEXT NOT NULL,
  zip_code CHAR(5) NOT NULL,
  business_type_id INTEGER references business_type(id)
);


-- ------
-- SCHEMA
-- ------
/*
* providing database users with separate environments
* organize components of a database
* public schema is the default schema in postgres
*/
-- schema_name should be less than 32 characters given default settings
-- name beings with letter or "_", and cannot begin with "pg_"
CREATE SCHEMA schema_name;

/*
DECIMAL/NUMERIC(precision, scale)
* precision는 총 숫자의 개수
* scale는 . 뒤에 올수 있는 숫자의 개수
  (e.g. DECIMAL(5, 2)의 최대갑은 999.99)
*/

-- -----------
-- FOREIGN KEY
-- -----------
CREATE TABLE place (
  zip_code CHAR(5) PRIMARY KEY,
  city VARCHAR(50) NOT NULL,
  state CHAR(2) NOT NULL
);

CREATE TABLE borrower (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  approved BOOLEAN DEFAULT NULL,
  place_id CHAR(5) REFERENCES place(zip_code)
);

-- 테이블 생성 이후 편집
CREATE TABLE client (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    site_url VARCHAR(50),
    num_employees SMALLINT,
    num_customers INTEGER
);

CREATE TABLE contact (
	id SERIAL PRIMARY KEY,
  	name VARCHAR(50) NOT NULL,
  	email VARCHAR(50) NOT NULL
);

ALTER TABLE client ADD contact_id INTEGER NOT NULL;
ALTER TABLE client ADD CONSTRAINT fk_c_id FOREIGN KEY (contact_id) REFERENCES contact(id);