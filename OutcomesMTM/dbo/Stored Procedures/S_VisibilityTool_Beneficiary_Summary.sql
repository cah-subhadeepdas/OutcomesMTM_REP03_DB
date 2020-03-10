




create   PROCEDURE [dbo].[S_VisibilityTool_Beneficiary_Summary]
	@ContractYear char(4)
	, @ClientID int
	-------------
	, @PolicyID varchar(255) = ''
	, @ContractNumber varchar(255) = ''
	, @FirstName varchar(255) = ''
	, @LastName varchar(255) = ''
	, @DOB varchar(255) = ''
	, @HICN varchar(255) = ''
	, @PatientID_All varchar(255) = ''

AS
BEGIN

	SET NOCOUNT ON;


	--// declare local variables
	DECLARE @ErrorCondition int = 0
	DECLARE @Return varchar(8000) = ''

		IF ISNUMERIC(@PolicyID) = 1 and @PolicyID > 0
		SET @PolicyID = @PolicyID
	
	IF ISNUMERIC(@PolicyID) <> 1 and @PolicyID <> ''
		SET @PolicyID = -1

	IF ISDATE(@DOB) = 1 and @DOB <> '1900-01-01'
		SET @DOB = @DOB

	IF ISDATE(@DOB) <> 1 and @DOB <> ''
		SET @DOB = '9999-12-31'


	BEGIN TRY


		--// summary result
		select 
			rpt.ContractYear
			, rpt.ContractNumber
			, Bene_Enrolled_Count = count( distinct rpt.PatientID )
			, Bene_Targeted_Count = sum( case when rpt.MTMPTargetingDate is not null then 1 else 0 end )
			, Bene_withCMROffer_Count = sum( case when rpt.cmrOffer_Count > 0 then 1 else 0 end )
			, Bene_withoutCMROffer_Count = sum( case when rpt.cmrOffer_Count = 0 then 1 else 0 end )
			, Bene_withCMR_Count = sum( case when rpt.cmr_Count > 0 then 1 else 0 end )
			, Bene_withoutCMR_Count = sum( case when rpt.cmr_Count = 0 then 1 else 0 end )
			, Bene_OptOut_01_Count = sum( case when rpt.OptOutReasonCode = '01' then 1 else 0 end )
			, Bene_OptOut_02_Count = sum( case when rpt.OptOutReasonCode = '02' then 1 else 0 end )
			, Bene_OptOut_03_Count = sum( case when rpt.OptOutReasonCode = '03' then 1 else 0 end )
			, Bene_OptOut_04_Count = sum( case when rpt.OptOutReasonCode = '04' then 1 else 0 end )
			, Bene_OptOut_Other_Count = sum( case when isnull(rpt.OptOutReasonCode,'') not in ('01','02','03','04') and rpt.OptOutReasonCode_Other is not null then 1 else 0 end )
			, Bene_withTMR_Count = sum( case when rpt.tmr_Count > 0 then 1 else 0 end )
			, Bene_withoutTMR_Count = sum( case when rpt.tmr_Count = 0 then 1 else 0 end )
		from [dbo].[VisibilityTool_BeneficiaryDetails]  rpt
		where 1=1
			and rpt.ContractYear = @ContractYear
			and rpt.ClientID = @ClientID
			-------------
			and ( rpt.PolicyID = @PolicyID or isnull(@PolicyID,0) = 0 )
			and ( rpt.ContractNumber = @ContractNumber or isnull(@ContractNumber,'') = '' )
			and ( rpt.First_Name = @FirstName or isnull(@FirstName,'') = '' )
			and ( rpt.Last_Name = @LastName or isnull(@LastName,'') = '' )
			and ( rpt.DOB = cast(@DOB as date) or isnull(@DOB,'') = '' )
			and ( rpt.HICN = @HICN or isnull(@HICN,'') = '' )
			and ( rpt.PatientID_All = @PatientID_All or isnull(@PatientID_All,'') = '' )
		group by
			rpt.ContractYear
			, rpt.ContractNumber



	END TRY
	BEGIN CATCH

		IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

		IF ISNULL(@Return,'') <> ''
			PRINT @Return;
		ELSE
			THROW;

	END CATCH

END
