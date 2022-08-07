/*
Temporary tables are short-lived table that have the following feature
1) transient storage(stored in memory)
2) lives only inside the database session
3) can be used inside multiple queries
  * cte can be used only inside one query
4) user specific

Created by:  CREATE TEMP TABLE name AS

Similar to VIEW but Temporary table actually contains the data(stored data) whereas VIEW directs the data(stored query)
therefore Temporary table can be faster than using VIEW
*/

-- Create a temp table of Canadians
CREATE TEMP TABLE canadians AS
    SELECT *
    FROM athletes_recent
    WHERE country_code = 'CAN'
    AND season = 'Winter'; 

ANALYZE canadians;

-- Find the most popular sport of canadians
SELECT sport
  , COUNT(DISTINCT athlete_id) as no_athletes
FROM canadians
GROUP BY sport 
ORDER BY no_athletes DESC;

/*
Temporary table vs (Standard) View vs (Materialized) View

[Temporary table]
Describe: organized storage
Contains: data
Loaded: query(transient)
Source: existing base tables

[(Standard) View]
Describe: stored query
Contains: directions(view definitions)
Loaded: never
Source: existing base tables

[(Materialized) View]
Describe: stored query
Contains: data
Loaded: refresh process -- runs the view definition at some defined interval
Source: existing base tables

Conclusion:
Table: base storage
Temp Table: speeds query using big table -- Table에서 WHERE를 통해 특정 국가의 data만 보유
(Standard) View: complicated logic or calculated fields -- 고객의 첫 주문 등
(Materialized) View: complicated logic that slows performance
*/

-- 'customer_table'의 table_type 알아내는 법
SELECT table_type
FROM information_schema.tables
WHERE table_catalog = 'orders_schema'
AND table_name = 'customer_table'
