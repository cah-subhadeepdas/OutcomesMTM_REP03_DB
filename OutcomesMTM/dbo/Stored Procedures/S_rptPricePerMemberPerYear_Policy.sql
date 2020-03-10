

-- ==========================================================================================
-- Author:		Paul Dickey
-- Create date: 10/20/2016
-- Description:	This proc is used by the SSRS report named pricePerMemberPerYear.rdl, which reports
--				the number of members who became plan active in a policy for the first time in a year.
--				Meredith in Client Services or Luke in Accounting use the report for billing Humana.
--				This proc is used to populate the policy parameter drop-down list.
-- Exec Time:   < 00:00:00.010 on 10/20/2016
-- ==========================================================================================
-- Change Log
-- ==========================================================================================
--   #		Date		Author			Description
--   --		--------	----------		----------------
--   1		10/20/2016	Paul Dickey		Created proc
-- ==========================================================================================
CREATE PROCEDURE [dbo].[S_rptPricePerMemberPerYear_Policy]
@clientIDs VARCHAR(MAX)
AS
BEGIN

	SELECT p.policyID
	,p.policyName
	,c.clientName + ' - (' + CAST(p.policyID AS VARCHAR(50)) + ') ' + p.policyName AS policyDisplayName
	,CASE WHEN p.policyID IN  (527, 589, 571, 600, 612, 665) -- Humana default policy IDs.
		  THEN p.policyID
		  ELSE 527 -- The report doesn't seem to like null values here.
	 END As defaultPolicyIDs
	FROM dbo.rptPricePerMemberPerYear AS pmpy
	JOIN dbo.Policy AS p ON pmpy.policyID=p.policyID
	JOIN dbo.Contract AS cc ON p.contractID=cc.contractID
	JOIN dbo.client	AS c ON cc.clientID=c.clientID
	JOIN dbo.DelimitedSplit8K(@clientIDs, ',') AS pp ON c.clientID=pp.Item
	GROUP BY p.policyID
	,p.policyName
	,c.clientName
	ORDER BY c.clientName, p.policyID

END



