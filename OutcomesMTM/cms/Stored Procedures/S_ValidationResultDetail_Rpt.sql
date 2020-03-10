


CREATE   PROCEDURE [cms].[S_ValidationResultDetail_Rpt]
	@ClientID int
	, @ContractYear char(4) = ''

/*
	EXEC cms.S_ValidationResultDetail_Rpt
		@ClientID = 146
*/


AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


	IF isnull(@ContractYear,'') = ''
		SET @ContractYear = ( select top 1 ContractYear from cms.vw_Snapshot s order by ContractYear desc )

	
	SELECT
		vr.clientID
		, vr.ClientName
		, vr.ContractYear
		, vr.OMTM_ID
		, vr.ValidationRunDateTime
		, vr.[Data Element]
		, vr.[Automated Check/Validation]
		, vr.Severity
		, vr.[OutcomesMTM Internal Error Description]
		, vr.ValidationResult
	from vw_ValidationResult_DetailRpt vr
	where 1=1
	and vr.clientID = @ClientID
	and vr.ContractYear = @ContractYear


END


