/*
USER-DEFINED FUNCTION
*/

-- ---------------------
-- USER DEFINED FUNCTION
-- ---------------------
CREATE FUNCTION squared(i INTEGER) 
  RETURNS INTEGER AS $$
BEGIN 
  RETURN i * i;
END;
$$ LANGUAGE plplgsql;

SELECT squared(10);

-- 아래 링크에서 더 saclia db에 적용가능한 function 이용 가능
-- https://github.com/zsu020958/data_base/blob/main/SQL/functions_for_manipulating_data_in_psql/postgres-sakila-incremental-schema_06172019.sql.txt
