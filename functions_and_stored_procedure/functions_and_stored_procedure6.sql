/*
MSSQL 기준의 코드
User-Defined Functions vs Stored Procedures

[User-Defined Functions]
  * must return value(table allowed as return value)
  * embedded SELECT execute allowed
  * no output parameters
  * no INSERT, UPDATE, DELETE
  * cannot execute stored procedures
  * no error handling

[Stored Procedures]
  * return value is optional(table not allowed as return value)
  * cannot embed in SELECT to execute
  * return output parameter & status
  * INSERT, UPDATE, DELETE allowed
  * can execute functions & stored-procedures
  * error handling possible with 'try catch'

Output parameters vs Return values

[Output parameters]
  * can be any data type
  * can declare multiple per stored procedure
  * cannot be table-valued parameters

[Return values]
  * used to indicate success or failure
  * integer data type only
  * 0 indicates success and non-zero indicats failure
*/

/*
Executing Stored Procedure
* No Output paramter or return value
* With output parameter
* WIth return value
* With return value & output parameter
*/

-- ----------------
-- Stored Procedure
-- ----------------
-- Create the stored procedure
CREATE PROCEDURE dbo.cuspSumRideHrsSingleDay
	@DateParm date, -- Declare the input parameter
	@RideHrsOut numeric OUTPUT -- Declare the output parameter
AS
SET NOCOUNT ON -- prevent SQL returning number of rows affected by the stored procedure
BEGIN
SELECT
  -- Assign the query result to @RideHrsOut
	@RideHrsOut = SUM(DATEDIFF(second, StartDate, EndDate))/3600
FROM CapitalBikeShare
WHERE CAST(StartDate AS date) = @DateParm
RETURN -- optional, instructs the stored procedure to return the output parameter to the calling application
END

-- -----------------------------------------------
-- Execute Without return value & output parameter
-- -----------------------------------------------
EXEC dbo.TripSummaryUpdate
  @TripDate = '1/5/2017'
  @TripHOurs = '300'

-- -----------------------------
-- Execute With output parameter
-- -----------------------------
-- Create @RideHrs
DECLARE @RideHrs AS NUMERIC(18,0)
-- Execute the stored procedure
EXECUTE dbo.cuspSumRideHrsSingleDay
    -- Pass the input parameter
	@DateParm = '3/1/2018',
    -- Store the output in @RideHrs
	@RideHrsOut = @RideHrs OUTPUT
-- Select @RideHrs
SELECT @RideHrs AS RideHours


-- -------------------------
-- Execute With return value
-- -------------------------
-- Create @ReturnStatus
DECLARE @ReturnStatus AS int
-- Execute the SP, storing the result in @ReturnStatus
EXEC @ReturnStatus = dbo.cuspRideSummaryUpdate
    -- Specify @DateParm
	@DateParm = '3/1/2018',
    -- Specify @RideHrs
	@RideHrs = 300

-- Select the columns of interest
SELECT
	@ReturnStatus AS ReturnStatus,
    Date,
    RideHours
FROM dbo.RideSummary
WHERE Date = '3/1/2018';

-- --------------------------------------------
-- Execute With return value & output parameter
-- --------------------------------------------
-- Create @ReturnStatus
DECLARE @ReturnStatus AS INTEGER
-- Create @RowCount
DECLARE @RowCount AS INTEGER

-- Execute the SP, storing the result in @ReturnStatus
EXEC @ReturnStatus = dbo.cuspRideSummaryDelete
    -- Specify @DateParm
	@DateParm = '3/1/2018',
    -- Specify RowCountOut
	@RowCountOut = @RowCount OUTPUT

-- Select the columns of interest
SELECT
	@ReturnStatus AS ReturnStatus,
    @RowCount AS 'RowCount';

