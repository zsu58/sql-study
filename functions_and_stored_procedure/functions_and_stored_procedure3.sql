/*
MSSQL 기준의 코드
*/

-- Find the first day of the current month
SELECT DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)
-- Calculate the difference in months between today and 0
-- then add 0 months to that difference to get the first day of the month
