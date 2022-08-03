/*
MSSQL 기준의 코드
*/

-- ------------------
-- DECLARE (Variable)
-- ------------------
-- DECLARE variable and assign initial value
DECLARE @ShiftStartTime AS time = '08:00 AM'

-- postgres
DO $$
DECLARE
	ShiftStartTime TIME:= '08:00 AM';
BEGIN
  -- PRINT 
  RAISE NOTICE 'ShiftStartTime: %', ShiftStartTime;
END $$;

-- DECLARE variable and then set VALUE
DECLARE @StartDate AS date

SET 
	@StartDate = (
    	SELECT TOP 1 StartDate 
    	FROM CapitalBikeShare 
    	ORDER BY StartDate ASC
		)

-- postgres
DO $$
DECLARE
	ShiftStartTime DATE:= ( 
		SELECT start_dtm::DATE
		FROM all_visits2
		LIMIT 1
	);
BEGIN
	RAISE NOTICE 'ShiftStartTime: %', ShiftStartTime; 
END $$;

-- DECLARE variable and then set VALUE USING SET
DECLARE @ShiftStartDateTime AS datetime

SET @ShiftStartDateTime = CAST(@StartDate AS datetime) + CAST(@ShiftStartTime AS datetime) 


-- ---------------
-- DECLARE (Table)
-- ---------------
-- Declare @Shifts as a TABLE
DECLARE @Shifts TABLE (
	StartDateTime DATETIME,
	EndDateTime DATETIME
)
INSERT INTO @Shifts (StartDateTime, EndDateTime)
	SELECT '3/1/2018 8:00 AM', '3/1/2018 4:00 PM'
SELECT * 
FROM @Shifts

--Using dynamic query instead of static values
-- Declare @RideDates
DECLARE @RideDates TABLE(
	RideStart DATE, 
    RideEnd DATE
)
INSERT INTO @RideDates(RideStart, RideEnd)
SELECT DISTINCT
	CAST(StartDate as date),
	CAST(EndDate as date) 
FROM CapitalBikeShare 
SELECT * 
FROM @RideDates
