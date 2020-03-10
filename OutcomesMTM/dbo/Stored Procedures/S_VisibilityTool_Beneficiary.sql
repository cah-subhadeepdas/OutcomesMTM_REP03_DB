



CREATE   PROCEDURE [dbo].[S_VisibilityTool_Beneficiary]
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

	/*
	declare @ContractYear char(4) ='2018'	, @ClientID int = 83
	declare  @PolicyID varchar(255) = ''
	, @ContractNumber varchar(255) = ''
	, @FirstName varchar(255) = ''
	, @LastName varchar(255) = ''
	, @DOB varchar(255) = ''
	, @HICN varchar(255) = ''
	, @PatientID_All varchar(255) = ''
	*/

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

			
		--// detail result
		select
			ContractYear = rpt.ContractYear
			, ContractNumber = rpt.ContractNumber
			, HICN_Current = rpt.HICN
			, HICN_Reported = rpt.HICN_Reported
			, MemberID = rpt.PatientID_All
			, PatientID = rpt.PatientID
			, FirstName = rpt.First_Name
			, LastName = rpt.Last_Name
			, DOB = convert(varchar,rpt.DOB,101)
			, MTMPEnrollmentDate = convert(varchar,rpt.MTMPEnrollmentFromDate,101)
			, MTMPEnrollmentSource = case
			        when rpt.MTMPEnrollment_ActionTrigger = 'MTMEligibilityDate' then 'Client File: ' + cast(rpt.MTMPEnrollment_fileID as varchar(max)) + '; ' +  cast(rpt.[MTMPEnrollment_MTMEligibilityDate] as varchar(max))					
					when rpt.MTMPEnrollment_ActionTrigger = 'ApprovedDate' then 'ID Run: ' + cast(rpt.MTMPEnrollment_IdentificationRunID as varchar(max)) + '; ' + convert(varchar(max),rpt.Enrollment_ApprovedDate,101)
					when rpt.MTMPEnrollment_ActionTrigger = 'CMROfferDate' then 'CMR Claim:  ' + cast(rpt.MTMPEnrollment_ClaimID as varchar(max)) + ';' + (select top 1 isnull(cast(mtmServiceDT as  varchar(max)),'') from dbo.claim where claimid = cast(rpt.MTMPEnrollment_ClaimID as int) )
					when rpt.MTMPEnrollment_ActionTrigger = 'CMRTargetedDate' then 'CMR Targeted File ID ' + cast(rpt.MTMPEnrollment_fileID as varchar(max)) + '; ' + + cast(rpt.MTMPEnrollment_CMRTargetedDate as varchar(max))					
					end
			, MTMPTargetDate = convert(varchar,rpt.MTMPTargetingDate,101)
			, MTMPTargetSource = case 
					when rpt.MTMPTargeting_ActionTrigger = 'MTMEligibilityDate' then 'Client File: ' + cast(rpt.MTMPTargeting_fileID as varchar(max)) + '; ' +  cast(rpt.[MTMPTargeting_MTMEligibilityDate] as varchar(max))					
					when rpt.MTMPTargeting_ActionTrigger = 'ApprovedDate' then 'ID Run: ' + cast(rpt.MTMPTargeting_IdentificationRunID as varchar(max)) + '; ' + convert(varchar(max),rpt.Targeting_ApprovedDate,101)					
					end
			, OptOutDate = case 
					when rpt.OptOutDate is null and isnull(rpt.OptOutReasonCode,'') not in ('01','02','03','04') and rpt.OptOutDT_Other is not null and rpt.OptOutReasonCode_Other is not null then convert(varchar,rpt.OptOutDT_Other,101)
					when rpt.OptOutDate is not null and isnull(rpt.OptOutReasonCode,'') in ('01','02','03','04') and rpt.OptOutDT_Other is null and rpt.OptOutReasonCode_Other is null then convert(varchar,rpt.OptOutDate,101)
					end
			, OptOutReasonCode = case 
					when rpt.OptOutDate is null and isnull(rpt.OptOutReasonCode,'') not in ('01','02','03','04') and rpt.OptOutDT_Other is not null and rpt.OptOutReasonCode_Other is not null then rpt.OptOutReasonCode_Other
					when rpt.OptOutDate is not null and isnull(rpt.OptOutReasonCode,'') in ('01','02','03','04') and rpt.OptOutDT_Other is null and rpt.OptOutReasonCode_Other is null then rpt.OptOutReasonCode
					end
			, OptOutSource = ''
			, CMRReceived_Count = rpt.cmr_Count
			, CMROfferReceived_Count = rpt.cmrOffer_Count
			, FirstTMRDate = cast(rpt.tmr_Min as date)
		from [dbo].[VisibilityTool_BeneficiaryDetails] rpt
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


	END TRY
	BEGIN CATCH

		IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

		IF ISNULL(@Return,'') <> ''
			PRINT @Return;
		ELSE
			THROW;

	END CATCH

END
