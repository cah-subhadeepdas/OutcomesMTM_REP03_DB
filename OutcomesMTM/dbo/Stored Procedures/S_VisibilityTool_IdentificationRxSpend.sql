

create   PROCEDURE [dbo].[S_VisibilityTool_IdentificationRxSpend]
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
			, RxID = rx.RxID
			, RxDate = rx.RxDate
			, PatientCopay = rx.PatientCopay
			, ClientPayment = rx.ClientPayment
			, NDC = rx.NDC
			, GPI = rx.GPI
			, Product_Name = rx.Product_Name
			, MnDrugCode = rx.MnDrugCode

		from dbo.Audit_IdentificationRx rx
		where 1=1
		and rx.IdentificationDetailTypeID = 6  --// Rx Sum
		and rx.PatientID = @PatientID
		and rx.IdentificationRunID = @IdentificationRunID

	END TRY
	BEGIN CATCH
		THROW;
	END CATCH

END

