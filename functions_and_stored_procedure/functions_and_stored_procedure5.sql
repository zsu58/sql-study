/*
MSSQL 기준의 코드
Inline
  * RETURN results of SELECT along with table column names
  * No table variable available
  * No BEGIN END needed
  * No Insert
  * Faster performance

Multiline
  * must DECLARE table variable to be returned
  * BEGIN END block required
  * INSERT data into table variable
  * RETURN should be the last statement within BEGIN/END block

유지보수에 보통은 CREATE OR ALTER FUNCTION 사용
단, Inline에서 Multiline으로 ALTER는 불가능
  * 이 경우 DROP하고 새로 CREATE해야함

같은 paramter & 같은 db(데이터)일 때 같은 결과를 주는 것: deterministic
  * 4번 파일의 GetYesterday()는 nondeterministic함
* deterministic한 것이 성능에 좋음
  * 왜냐하면 SQL SEVER가 결과를 index할 수 있기 때문

* SCHEMABINDING을 통해 function 내에서 사용하는 column 들이 ALTER 되는 것을 방지할 수 있음
*/


-- -----------------
-- UDF(INLINE TABLE)
-- -----------------
-- function returning the number of rides and total ride duration for each StartStation where the StartDate of the ride is equal to the input parameter.
CREATE FUNCTION SumStationStats(@StartDate AS DATETIME)
RETURNS TABLE
AS
RETURN
  SELECT
    StartStation,
    COUNT(ID) AS RideCount,
    SUM(Duration) AS TotalDuration
  FROM CapitalBikeShare
  WHERE CAST(StartDate AS Date) = @StartDate
  GROUP BY StartStation;

-- apply SumStationStats
DECLARE @StationStats TABLE(
	StartStation nvarchar(100), 
	RideCount int, 
	TotalDuration numeric
)
INSERT INTO @StationStats 
SELECT TOP 10 *
-- Execute SumStationStats with 3/15/2018
FROM dbo.SumStationStats('3/15/2018') 
ORDER BY RideCount DESC
-- Select all the records from @StationStats
SELECT * 
FROM @StationStats

-- Update SumStationStats, Enabling SCHEMABINDING
CREATE OR ALTER FUNCTION dbo.SumStationStats(@Enddate AS DATE)
RETURNS TABLE WITH SCHEMABINDING
AS
RETURN
  SELECT
    StartStation,
      COUNT(ID) AS RideCount,
      SUM(DURATION) AS TotalDuration
  FROM dbo.CapitalBikeShare
  WHERE CAST(EndDate AS Date) = @Enddate
GROUP BY StartStation;

-- --------------------------
-- UDF(MULTI-STATEMENT TABLE)
-- --------------------------
-- function returning the trip count and average ride duration for each day for the month & year parameter values passed
CREATE FUNCTION  CountTripAvgDuration (@Month CHAR(2), @Year CHAR(4))
RETURNS @DailyTripStats TABLE(
	TripDate	date,
	TripCount	int,
	AvgDuration	numeric)
AS
BEGIN
INSERT INTO @DailyTripStats
  SELECT
    CAST(StartDate AS DATE),
    COUNT(ID),
    AVG(Duration)
  FROM CapitalBikeShare
  WHERE
    DATEPART(month, StartDate) = @Month AND
      DATEPART(year, StartDate) = @Year
  GROUP BY CAST(StartDate AS DATE)
-- Return
RETURN 
END

-- True: 1, False: 0
OBJECTPROPERTY(
  OBJECT_ID('[schema].[function_name]'),
  'IsDeterministic'
)
