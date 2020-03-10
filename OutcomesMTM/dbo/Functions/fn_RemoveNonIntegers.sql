




--drop function [dbo].[fn_RemoveNonIntegers]
Create FUNCTION [dbo].[fn_RemoveNonIntegers] ( @String varchar(255) )
RETURNS TABLE WITH SCHEMABINDING
AS RETURN
(

--// Use cteTally table for performance (can evaluate up to 10K characters per string)
WITH E1(N) AS (
	SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
	SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
	SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1
	)  --// 10E+1 or 10 rows
	,E2(N) AS (SELECT 1 FROM E1 a, E1 b)  --// 10E+2 or 100 rows
	,E4(N) AS (SELECT 1 FROM E2 a, E2 b)  --// 10E+4 or 10,000 rows max
	,cteTally(N) AS (--// This provides the "zero base" and limits the number of rows right up front
                     --// for both a performance gain and prevention of accidental "overruns"
		SELECT 0 UNION ALL
		SELECT TOP (DATALENGTH(ISNULL(@String,1))) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) FROM E4
	)

--// Cleanse string value
SELECT Result = CAST(
	(
	SELECT CASE  --// Evaluate each character and remove if not an integer (0-9)
		WHEN ( ASCII(UPPER(SUBSTRING(@String, N, 1))) BETWEEN 48 AND 57 )
		THEN SUBSTRING(@String, N, 1)
		ELSE '' END
	FROM cteTally
	WHERE 1=1
	FOR XML PATH('')  --// Pivots results of each character back into a single row
	) AS VARCHAR(255))  --// This could be changed to accommodate larger strings


)




