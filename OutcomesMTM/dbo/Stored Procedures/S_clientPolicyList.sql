



CREATE PROCEDURE [dbo].[S_clientPolicyList]
@clientIDs VARCHAR(MAX)
AS
BEGIN

	DECLARE @tblClientIDs TABLE
	(
		clientID INT
	)
	INSERT INTO @tblClientIDs
	SELECT Item
	FROM OutcomesMTM.dbo.DelimitedSplit8K(@clientIDs, ',')

	SELECT ccpv.policyID
	,ccpv.policyName
	,ccpv.clientName + ' - (' + CAST(ccpv.policyID AS VARCHAR(50)) + ') ' + ccpv.policyName AS policyDisplayName
	FROM [OutcomesMTM].[dbo].[ClientContractPolicyView] AS ccpv
	JOIN @tblClientIDs AS cids ON ccpv.clientID=cids.clientID
	ORDER BY ccpv.clientName, ccpv.policyID

END






