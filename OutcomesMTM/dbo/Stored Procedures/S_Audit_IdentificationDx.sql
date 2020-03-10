

CREATE   PROCEDURE dbo.S_Audit_IdentificationDx
	@PatientID int
	, @IdentificationRunID int


AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY

		/*  --// for testing
		declare
			@PatientID int = 
			, @IdentificationRunID int = 
		--*/

		select
			PatientID = @PatientID
			, IdentificationRunID = @IdentificationRunID
			, DxID = dx.DxID
			, DxTitle = dx.DxTitle

		from dbo.Audit_IdentificationDx dx
		where 1=1
		and dx.PatientID = @PatientID
		and dx.IdentificationRunID = @IdentificationRunID

	END TRY
	BEGIN CATCH
		THROW;
	END CATCH

END
