



create PROCEDURE [dbo].[S_VisibilityTool_ClientList]
AS
BEGIN

	SELECT c.clientID
	,c.clientName
	FROM [dbo].[Client] AS c
	ORDER BY c.clientName

END


