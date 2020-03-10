

CREATE   PROCEDURE dbo.S_Audit_IdentificationRxCount
	@PatientID int NULL
	, @IdentificationRunID int NULL


AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY

	IF @PatientID IS NULL OR @IdentificationRunID IS NULL
	BEGIN
		select
			PatientID = ''
			, IdentificationRunID = ''
			, RxID =''
			, RxDate = ''
			, PatientCopay = ''
			, ClientPayment = ''
			, NDC = ''
			, GPI = ''
			, Product_Name = ''
			, MnDrugCode = ''
	END

		/*  --// for testing
		declare
			@PatientID int = 
			, @IdentificationRunID int = 
		--*/

	IF @PatientID IS NOT NULL AND @IdentificationRunID IS NOT NULL
	BEGIN
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
		and rx.IdentificationDetailTypeID = 5  --// Rx Count
		and rx.PatientID = @PatientID
		and rx.IdentificationRunID = @IdentificationRunID
	END

	END TRY
	BEGIN CATCH
		THROW;
	END CATCH

END

