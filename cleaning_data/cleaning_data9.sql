-- ------
-- FILTER
-- ------
/*
FILTER can be used for pivoting
The right-hand side of the FILTER clause specifies the filter to be used for including records
The left-hand side of the FILTER clause specifies the value to be used for the column.
*/

SELECT 
	-- Include the violation code in results
	violation_code, 
    -- Include the issuing agency in results
    issuing_agency, 
    -- Number of records with violation code/issuing agency
    COUNT(1) 
FROM 
	parking_violation 
WHERE 
	-- Restrict the results to the agencies of interest
	issuing_agency IN ('P', 'S', 'K', 'V') 
GROUP BY 
	-- Define GROUP BY columns to ensure correct pair count
	violation_code, issuing_agency
ORDER BY 
	violation_code, issuing_agency;

-- Pivoting을 통해 위의 결과를 행 단위로 볼 수 있음
SELECT 
	violation_code, 
    -- Define the "Police" column
	COUNT(issuing_agency) FILTER (WHERE issuing_agency = 'P') AS "Police",
    -- Define the "Sanitation" column
	COUNT(issuing_agency) FILTER (WHERE issuing_agency = 'S') AS "Sanitation",
    -- Define the "Parks" column
	COUNT(issuing_agency) FILTER (WHERE issuing_agency = 'K') AS "Parks",
    -- Define the "Transportation" column
	COUNT(issuing_agency) FILTER (WHERE issuing_agency = 'V') AS "Transportation"
FROM 
	parking_violation 
GROUP BY 
	violation_code
ORDER BY 
	violation_code
