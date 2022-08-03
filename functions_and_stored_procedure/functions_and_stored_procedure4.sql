/*
MSSQL 기준의 코드
*/

-- ------------------
-- UDF(RETURN SCALAR)
-- ------------------
-- function returning yesterday
CREATE FUNCTION GetYesterday()
RETURNS DATE
AS
BEGIN
-- Calculate yesterday's date value
RETURN (SELECT DATEADD(day, -1, GETDATE()))
END 

-- using GetYesterday
SELECT dbo.GetYesterday()

-- Function returning the total ride time in hours for the @DateParm parameter passed
CREATE FUNCTION SumRideHrsSingleDay (@DateParm DATE)
RETURNS NUMERIC
AS
BEGIN
RETURN
-- Add the difference between StartDate and EndDate
  (SELECT SUM(DATEDIFF(second, StartDate, EndDate))/3600
  FROM CapitalBikeShare
  -- Only include transactions where StartDate = @DateParm
  WHERE CAST(StartDate AS DATE) = @DateParm)
END

-- using SumRideHrsSingleDay
DECLARE @RideHrs AS NUMERIC
-- Execute SumRideHrsSingleDay function and store the result in @RideHrs
EXEC @RideHrs = dbo.SumRideHrsSingleDay @DateParm = '3/5/2018' 
SELECT 
  'Total Ride Hours for 3/5/2018:', 
  @RideHrs

-- Function returning the total ride hours for all transactions that have a StartDate within the parameter value
CREATE FUNCTION SumRideHrsDateRange (@StartDateParm datetime, @EndDateParm datetime)
RETURNS numeric
AS
BEGIN
RETURN
-- Sum the difference between StartDate and EndDate
  (SELECT SUM(DATEDIFF(second, StartDate, EndDate))/3600
  FROM CapitalBikeShare
  -- Include only the relevant transactions
  WHERE StartDate > @StartDateParm and StartDate < @EndDateParm)
END

-- using UDF(SumRideHrsDateRange)
DECLARE @BeginDate AS date = '3/1/2018'
DECLARE @EndDate AS date = '3/10/2018' 
SELECT
  @BeginDate AS BeginDate,
  @EndDate AS EndDate,
  -- Execute SumRideHrsDateRange()
  dbo.SumRideHrsDateRange(@BeginDate, @EndDate) AS TotalRideHrs
