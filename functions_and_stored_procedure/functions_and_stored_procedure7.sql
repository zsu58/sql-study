/*
MSSQL 기준의 코드
Stored Procedure is used for CRUD since sp's execution plan is cached, and therefore faster then ad-hoc queries
*/

-- ------
-- INSERT
-- ------
-- Create the stored procedure
CREATE PROCEDURE dbo.cusp_RideSummaryCreate 
    (@DateParm date, @RideHrsParm numeric)
AS
BEGIN
SET NOCOUNT ON
INSERT INTO dbo.RideSummary(Date, RideHours)
VALUES(@DateParm, @RideHrsParm) 

-- Select the record that was just inserted
SELECT
	Date,
    RideHours
FROM dbo.RideSummary
WHERE Date = @DateParm
END;

-- ------
-- UPDATE
-- ------
-- Create the stored procedure
CREATE PROCEDURE dbo.cuspRideSummaryUpdate
	-- Specify @Date input parameter
	(@Date DATE,
  -- Specify @RideHrs input parameter
  @RideHrs numeric(18,0))
AS
BEGIN
SET NOCOUNT ON
-- Update RideSummary
Update RideSummary
SET
	Date = @Date,
    RideHours = @RideHrs
WHERE Date = @Date
END;

-- ------
-- DELETE
-- ------
-- Create the stored procedure
CREATE PROCEDURE dbo.cuspRideSummaryDelete
	(@DateParm DATE,
  @RowCountOut INT OUTPUT)
AS
BEGIN
-- Delete record(s) where Date equals @DateParm
DELETE FROM dbo.RideSummary
WHERE Date = @DateParm
SET @RowCountOut = @@ROWCOUNT
END;

