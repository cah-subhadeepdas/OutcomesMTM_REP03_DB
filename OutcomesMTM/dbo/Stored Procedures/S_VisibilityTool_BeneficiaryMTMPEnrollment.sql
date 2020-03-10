



CREATE    PROCEDURE [dbo].[S_VisibilityTool_BeneficiaryMTMPEnrollment]
	@ContractYear char(4)
	, @ClientID int
	, @PatientID_All varchar(50) = ''
	, @HICN_MBI varchar(15) = ''


AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY

		  --// for testing
		--declare
		--	@ContractYear char(4) = '2018'
		--	, @ClientID int = 83
		--	, @PatientID_All varchar(50) = '948105942-00'
		--	, @HICN_MBI varchar(15) = '' --'380900936A'
	

		

		select
			PatientID = cast(bm.PatientID as varchar(10))
			, bm.MTMPEnrollmentID
			, bm.ClientID
			, bm.ContractYear
			, bm.ContractNumber
			, bm.HICN as HICN_MBI
			, isnull(bm.HICN_Reported,'') as HICN_Reported
			, bm.PatientID_All
			, bm.First_Name as FirstName
			, bm.MI
			, bm.Last_Name as LastName
			, bm.DOB
			, bm.MTMPTargetingDate
			, bm.MTMPEnrollmentFromDate
			, MTMPEnrollmentSource = case
			        when bm.MTMPEnrollment_ActionTrigger = 'MTMEligibilityDate' then 'Client File: ' + cast(bm.MTMPEnrollment_fileID as varchar(max)) + '; ' +  cast(bm.[MTMPEnrollment_MTMEligibilityDate] as varchar(max))					
					when bm.MTMPEnrollment_ActionTrigger = 'ApprovedDate' then 'ID Run: ' + cast(bm.MTMPEnrollment_IdentificationRunID as varchar(max)) + '; ' + convert(varchar(max),bm.Enrollment_ApprovedDate,101)
					when bm.MTMPEnrollment_ActionTrigger = 'CMROfferDate' then 'CMR Claim:  ' + cast(bm.MTMPEnrollment_ClaimID as varchar(max)) + ';' + (select top 1 isnull(cast(mtmServiceDT as  varchar(max)),'') from dbo.claim where claimid = cast(bm.MTMPEnrollment_ClaimID as int) )
					when bm.MTMPEnrollment_ActionTrigger = 'CMRTargetedDate' then 'CMR Targeted File ID ' + cast(bm.MTMPEnrollment_fileID as varchar(max)) + '; ' + + cast(bm.MTMPEnrollment_CMRTargetedDate as varchar(max))					
					end
			, bm.MTMPEnrollmentThruDate
			, MTMPTargetSource = case 
					when bm.MTMPTargeting_ActionTrigger = 'MTMEligibilityDate' then 'Client File: ' + cast(bm.MTMPTargeting_fileID as varchar(max)) + '; ' +  cast(bm.[MTMPTargeting_MTMEligibilityDate] as varchar(max))					
					when bm.MTMPTargeting_ActionTrigger = 'ApprovedDate' then 'ID Run: ' + cast(bm.MTMPTargeting_IdentificationRunID as varchar(max)) + '; ' + convert(varchar(max),bm.Targeting_ApprovedDate,101)					
					end
			, bm.OptOutDate
			, bm.OptOutReasonCode
			, bm.DxCount
			, bm.RxSum
			, bm.RxCount
			, IdentificationRunID = isnull(bm.IdentificationRunID,0)
			, FirstTMRDate = cast(bm.tmr_Min as date)
		from dbo.VisibilityTool_BeneficiaryDetails bm (nolock)		
		where 1=1
		and bm.ContractYear = @ContractYear 
		and bm.ClientID = @ClientID
		and (
				( bm.PatientID_All = @PatientID_All and @PatientID_All <> '' and @HICN_MBI = '' )
			or	( bm.HICN = @HICN_MBI and @HICN_MBI <> '' and @PatientID_All = '' )
			or  ( bm.HICN = @HICN_MBI and bm.PatientID_All = @PatientID_All )
			)

	END TRY
	BEGIN CATCH
		THROW;
	END CATCH

END

