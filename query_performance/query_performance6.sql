/*
1) Parser
  * Front-end steps: Send query to database
  * Back end processes: Checks syntax. Translates SQL into computer friendly syntax based on system stored rules

2) Planner & Optimizer
  * Front-end steps: Assess and optimize query tasks
  * Back end processes: Uses database stats to create query plan. Calculates costs and chooses the best plan
  * Planner generates a series of plan trees with many nodes or steps
    * tree are unique plans that vary the query steps order
  * Planner estimates the cost of each plan by using row counts and other metadata in the pg_tables schema
  * Optimizer chooses the best among the plans
  
  * Postgres uses time as its cost metric for optimization
    * pg_class & pg_stats are used to create plan and cost estimates

2) Executor
  * Front-end steps: Return query resulsts
  * Back end processes: Follows the query plan to execute the query
*/

SELECT *
FROM pg_class
WHERE relname = 'daily_aqi';

SELECT *
FROM pg_stats
WHERE tablename = 'daily_aqi'
AND attname = 'category';

/*
cost: can be used to compare two structures of a query with the same output(should not be used to compare queries with different output)
  * composed of start-up cost .. total cost
rows: rows query needs to examine to run
width: byte width of rows
*/

-- result column까지 볼 수 있음
EXPLAIN VERBOSE
SELECT *
FROM country_demos;

-- actual runtime까지 볼 수 있음
EXPLAIN ANALYZE
SELECT *
FROM country_demos;
