
CREATE   FUNCTION [cms].[valid_CMSID] ( @String varchar(8000) )
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

	, InputValue AS
	(
		select
			i.InputValue
			, ValidMBI = case  --// MBI convention
							when i.InputValue like '[1-9][A,C-H,J,K,M,N,P-R,T-Y][0-9,A,C-H,J,K,M,N,P-R,T-Y][0-9][A,C-H,J,K,M,N,P-R,T-Y][0-9,A,C-H,J,K,M,N,P-R,T-Y][0-9][A,C-H,J,K,M,N,P-R,T-Y][A,C-H,J,K,M,N,P-R,T-Y][0-9][0-9]' 
						then 1 end
			, ValidSSA = case  --// Social Security Administration convention
							when i.InputValue like '[0-8][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%'
							and len(i.InputValue) < 12
							and substring(i.InputValue,10,2) like '[ABCDEFJKMTW]%'  --// this logic is not complete; should be an explicit list of possible 1-2 character strings
							and	left(i.InputValue,9) not in ('21909999','078051120')
							and left(i.InputValue,3) not in ('000','666')
							and substring(i.InputValue,4,2) not in ('00')
							and substring(i.InputValue,6,4) not in ('0000')
						then 1 end
			, ValidRRB = case
							when i.InputValue like '[a-z]%'  --// Railroad Retirement Board convention
							and reverse(i.InputValue) like '[0-9]%'
							and	substring(i.InputValue,1,len(i.InputValue)-len(ii.Result)) in ('A','CA','H','JA','MA','MH','MH','PA','PD','PH','WA','WCA','WCD','WCH','WD','WH')
							and (		len(ii.Result) = 9
									and left(ii.Result,9) not in ('21909999','078051120')
									and left(ii.Result,3) not in ('000','666')
									and substring(ii.Result,4,2) not in ('00')
									and substring(ii.Result,6,4) not in ('0000')
								or		len(ii.Result) = 6
									and cast(ii.Result as int) between 1 and 994999 
								)					
						then 1 end

		from ( select InputValue = @String ) i
		cross apply (
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
				) AS VARCHAR(8000)
			)
		)  ii
	)


	select i.InputValue
		, ValidFormat = case when coalesce(i.ValidMBI,i.ValidSSA,i.ValidRRB) = 1 then 'Y' else 'N' end
		, CMSIDType = case	when i.ValidMBI = 1 then 'MBI'
				when coalesce(i.ValidSSA,i.ValidRRB) = 1 then 'HICN' 
				else '' end
	from InputValue i


)
