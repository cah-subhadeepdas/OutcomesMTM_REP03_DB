




CREATE PROCEDURE [dbo].[S_clientList]
AS
BEGIN

	SELECT c.clientID
	,c.clientName
	FROM [OutcomesMTM].[dbo].[Client] AS c
	ORDER BY c.clientName

END







