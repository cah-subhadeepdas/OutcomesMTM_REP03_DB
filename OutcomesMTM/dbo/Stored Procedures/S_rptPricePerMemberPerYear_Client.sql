


CREATE PROCEDURE [dbo].[S_rptPricePerMemberPerYear_Client]
AS
BEGIN

	SELECT DISTINCT c.clientID
	,c.clientName
	,72 AS defaultClientID
	FROM dbo.rptPricePerMemberPerYear AS pmpy
	JOIN dbo.Policy AS p ON pmpy.policyID=p.policyID
	JOIN dbo.Contract AS cc ON p.contractID=cc.contractID
	JOIN dbo.client	AS c ON cc.clientID=c.clientID
	ORDER BY c.clientName

END




