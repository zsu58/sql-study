/*
Database Storage Types
1) Row-oriented storage
  retains relation between columns, which means that one row is stored in the same location
    * fast on transactional focus(fast to append or delete records)
    * a query to return one column is as fast as a query to return all columns
    * returning all rows are slow
2) Column-oriented storage
  retains relation between rows, which means that one column is stored in the same location
    * slow on transactional focus(insert and delete of records)
    * quick to return all rows
    * fast performance in column aggregation(e.g. SUM, AVG), which is good for data analytics
    * returning all columns are slow & loading data is slow(since data is usually loaded on a row-basis)


[Row-oriented Storage]
  DB: Postgres, MySQL
  therefore in row-oriented storage like postgres, reducing the number of rows (with the below method) is important
    * WHERE
    * INNER JOIN
    * DISTINCT
    * LIMIT

[Column-oriented storage]
DB: Redshift, BigQuery, Snowflake
  therefore in column-oriented storage, reducing the number of columns is important
  * don't use * if not required
  * use the information schema to retrieve informatino about the table before querying(e.g. which column to selectㅇ)
*/

-- Examine metadata about daily_aqi
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_catalog = 'olympics_aqi'
AND table_name = 'daily_aqi';

/*
Partitions: method of splitting one (parent) table into many smaller(child) tables based on a column
  * 즉, column category 수 만큼의 child table이 만들어짐, 주로 Date, Location 등이 사용됨
  * Benefit
    * storage flexibility (each child table can be stored on different server with cheaper storage options)
    * faster queries
Indexs: method of creating sorted column keys to improve search

Using Partitions & Indexes require set up and maintenance by as database administrator(DBA)

[Partitions]
Parent table
  * Visible in database front end
  * tables that queries are written

Child tables
  * Not visible in database front end
  * used when queries actually search for data

[Index]
Method of creating sorted column keys(reference to data location) to improve search, making the queries faster

Indexes are recommended on a table that is large and on columns that are 1) filtered often or on a 2) primary key
Indexes should not be used on small tables, or tables that are frequently updated, Also column with many nulls should not become a index
*/

SELECT tablename, indexname
FROM pg_indexes;

-- INDEX on 1 column
CREATE INDEX recipe_index ON cookbook (recipe_id);

-- INDEX on 2 column
CREATE INDEX CONCURRENTLY recipe_index ON cookbook (recipe_id, serving_zie);

/*
정리: 
Postgres는 기본적으로 Row Oriented Database
  * 따라서 ROW를 줄이는 것이 중요
    * WHERE/ INNER JOIN/ DISTINCT/ LIMIT 등을 활용
  * 데이터 양이 많아지면 DBA가 테이블을 Partition하면 성능향상을 기대할 수 있음
  * 데이터 양이 많아지면 DBA가 테이블에 적절한 INDEX를 부여해 성능향상을 기대할 수 있음
*/
