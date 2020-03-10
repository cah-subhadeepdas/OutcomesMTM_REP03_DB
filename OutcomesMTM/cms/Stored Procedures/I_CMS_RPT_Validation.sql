

CREATE   PROCEDURE [cms].[I_CMS_RPT_Validation]
	  @ClientID int
	, @ContractYear char(4)
	, @BatchID int
	
AS


BEGIN

	--// declare @BatchID varchar(8000) = 393
	exec cms.ValidationEngineRun
		@ValidationDataSet = 3  --// CMS Bene Report
		, @BatchKey = 'BatchID'
		, @BatchValue = @BatchID

END
