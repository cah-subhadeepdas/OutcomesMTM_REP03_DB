

-- ==========================================================================================
-- Author:		Paul Dickey
-- Create date: 10/20/2016
-- Description:	This proc is used by the SSRS report named pricePerMemberPerYear.rdl, which reports
--				the number of members who became plan active in a policy for the first time in a year.
--				Meredith in Client Services or Luke in Accounting use the report for billing Humana.
--				The data comes from the patientRepositoryLog table in Repository because the patientDim
--				table in Reporting is inaccurate for periods in 2016.
-- Exec Time:   < 00:00:00.050 on 10/20/2016
-- ==========================================================================================
-- Change Log
-- ==========================================================================================
--   #		Date		Author			Description
--   --		--------	----------		----------------
--   1		10/20/2016	Paul Dickey		Created proc
-- ==========================================================================================
CREATE PROCEDURE [dbo].[S_rptPricePerMemberPerYear]
@policyIDs VARCHAR(MAX)
,@reportYears VARCHAR(MAX)
,@reportMonths VARCHAR(MAX)
AS
BEGIN

	SELECT pmpy.pricePerMemberPerYearID
	,pmpy.policyID
	,pmpy.reportYear
	,pmpy.reportMonth
	,ISNULL(pmpy.memberCount, 0) AS memberCount
	,pmpy.createDate
	,pmpy.active
	,c.clientID
	,c.clientName
	,p.policyName
	,'(' + CAST(p.policyID AS VARCHAR(50)) + ') ' + p.policyName AS policyDisplayName
	FROM dbo.rptPricePerMemberPerYear AS pmpy
	JOIN dbo.Policy AS p ON pmpy.policyID=p.policyID
	JOIN dbo.Contract AS cc ON p.contractID=cc.contractID
	JOIN dbo.client	AS c ON cc.clientID=c.clientID
	WHERE pmpy.policyID IN
	(
		SELECT pp.Item FROM dbo.DelimitedSplit8K(@policyIDs, ',') AS pp
	)
	AND pmpy.reportYear IN
	(
		SELECT y.Item FROM dbo.DelimitedSplit8K(@reportYears, ',') AS y
	)
	AND pmpy.reportMonth IN
	(
		SELECT m.Item FROM dbo.DelimitedSplit8K(@reportMonths, ',') AS m
	)
	AND pmpy.active=1
	AND DATEFROMPARTS(pmpy.reportYear, pmpy.reportMonth, 1) <= GETDATE()
	ORDER BY pmpy.pricePerMemberPerYearID

END



