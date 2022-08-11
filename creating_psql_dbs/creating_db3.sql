/*
* default Postgres 설치: "postgres" 유저 생성
  * superuser
    * creating database
    * dropping database
    * inserting records
    * deleting records
    * dropping tables
  * (normal) users
    * adding records
    * querying records
    * editing records
*/

-- -----------
-- CREATE USER
-- -----------
-- this user can create tables in the db that is currently in use when user is created
-- but cannot access tables made by other users
CREATE USER newuser_name;
CREATE USER newuser_name WITH PASSWORD 'secret';
ALTER USER newuser_name WITH PASSWORD 'new_password'; 

-- -----
-- GRANT
-- -----
/*
db is owned by the user who created it
other users can access db if privileges are granted
granted privileges include the following
* SELECT
* DELETE
* UPDATE
*/
GRANT INSERT ON table_name TO user_name;
GRANT UPDATE ON table_name TO user_name;
GRANT SELECT ON table_name TO user_name;
GRANT DELETE ON table_name TO user_name;

-- modifying the table schema(changing column name, adding new column, etc) requires ownership
-- if a specific user wants to change the table schema, the ownership can be granted
ALTER TABLE table_name OWNER to user_name;


-- -----
-- GROUP
-- -----
CREATE GROUP family;
CREATE SCHEMA park

GRANT USAGE ON SCHEMA park TO family;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA park TO family; -- specific schema
GRANT INSERT, UPDATE, DELETE, SELECT ON park.household TO family; -- specific table

CREATE USER spouse WITH PASSWORD 'changeme';
ALTER GROUP family ADD USER spouse;

-- ------
-- REVOKE 
-- ------
-- remove privileges given to an user
REVOKE DELETE, TRUNCATE ON park.household FROM spouse;
REVOKE ALL PRIVILEGES ON park.household FROM spouse;
REVOKE family FROM cousin; -- cousin is removed from the family group
GRANT SELECT ON park.household TO spouse;
