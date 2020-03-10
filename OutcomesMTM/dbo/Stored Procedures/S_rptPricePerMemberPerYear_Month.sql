

-- ==========================================================================================
-- Author:		Paul Dickey
-- Create date: 10/20/2016
-- Description:	This proc is used by the SSRS report named pricePerMemberPerYear.rdl, which reports
--				the number of members who became plan active in a policy for the first time in a year.
--				Meredith in Client Services or Luke in Accounting use the report for billing Humana.
--				This proc is used to populate the month parameter drop-down list.
-- Exec Time:   < 00:00:00.010 on 10/20/2016
-- ==========================================================================================
-- Change Log
-- ==========================================================================================
--   #		Date		Author			Description
--   --		--------	----------		----------------
--   1		10/20/2016	Paul Dickey		Created proc
-- ==========================================================================================
CREATE PROCEDURE [dbo].[S_rptPricePerMemberPerYear_Month]
AS
BEGIN

	SELECT DISTINCT pmpy.reportMonth
	,pmpy.reportMonth AS defaultReportMonths
	FROM dbo.rptPricePerMemberPerYear AS pmpy
	ORDER BY pmpy.reportMonth

END



