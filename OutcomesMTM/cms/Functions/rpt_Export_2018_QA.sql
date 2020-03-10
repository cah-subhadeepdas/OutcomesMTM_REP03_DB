





CREATE     FUNCTION [cms].[rpt_Export_2018_QA]
(	
	@BatchID INT
)
RETURNS TABLE 
AS
RETURN 
(

	SELECT
		  [A_ContractNumber]	= cast( rpt.ContractNumber as char(5))
		, [B_HICNumber]	= cast( ltrim(rtrim(rpt.HICN)) as char(12))
		, [C_FirstName]	= cast( ltrim(rtrim(rpt.FirstName)) as char(30))
		, [D_MiddleInitial]	= cast( isnull(left(ltrim(rpt.MI),1),'') as char(1))
		, [E_LastName]	= cast( ltrim(rtrim(rpt.LastName)) as char(30))
		, [F_DOB]	= cast( convert(varchar(8), rpt.DOB, 112) as char(8))
		, [G_TargetingCriteriaMet]	= cast( rpt.MTMPCriteriaMet as char(1))
		, [H_CognitivelyImpaired]	= cast( isnull(rpt.CMR_CognitivelyImpairedIndicator,'U') as char(1))
		, [I_MTMPEnrollmentDate]	= cast( isnull(convert(varchar(8), rpt.MTMPEnrollmentFromDate, 112),'') as char(8))
		, [J_MTMPTargetedDate]		= cast( isnull(convert(varchar(8), rpt.MTMPTargetingDate, 112),'') as char(8))
		, [K_MTMPOptOutDate]		= cast( isnull(convert(varchar(8), rpt.OptOutDate, 112), '') as char(8))
		, [L_MTMPOptOutReasonCode]	= cast( isnull(rpt.OptOutReasonCode,'') as char(2))
		, [M_CMROffered]	= cast( rpt.CMROffered as char(1))
		, [N_CMROfferDate]	= cast( isnull(convert(varchar(8), rpt.CMROfferDate, 112),'') as char(8))
		, [O_CMRReceived]	= cast( rpt.CMRReceived as char(1))
		, [P_CMRReceivedCount]	= cast( right('00' + isnull(rpt.CMR_Count,'0'),2) as char(2))
		, [Q1_CMRReceivedDate1]	= cast( isnull(convert(varchar(8), rpt.CMR_Date1, 112),'') as char(8))
		, [Q2_CMRReceivedDate2]	= cast( isnull(convert(varchar(8), rpt.CMR_Date2, 112),'') as char(8))
		, [R_CMRDeliveryMethod]	= cast( isnull(rpt.CMR_MethodOfDeliveryCode,'') as char(2))
		, [S_CMRProviderCode]	= cast( isnull(rpt.CMR_ProviderCode,'') as char(2))
		, [T_CMRRecipientCode]	= cast( isnull(rpt.CMR_RecipientCode,'') as char(2))
		, [U_TMRCount]			= cast( right('00' + isnull(rpt.TMR_Count,'0'),3) as char(3))
		, [V_DTPRecommendationsCount]	= cast( right('00' + isnull(rpt.DTPR_Count,'0'),2) as char(2))
		, [W_DTPChangesCount]	= cast( right('00' + isnull(rpt.DTPC_Count,'0'),2) as char(2))
		, [X_QACheck] = cast(isnull(vrp.ValidationCheck_InternalQA_CSV,'') as varchar(8000))

	from cms.rpt_Report_Log rpt
	join cms.CMS_rpt_Batch bt
		on bt.BatchID = rpt.BatchID
	left join cms.vw_RPT_ValidationRunResult_Active_PivotPatient vrp
		on vrp.BeneficiaryID = rpt.BeneficiaryID
		and vrp.BatchID = rpt.BatchID
		and ( vrp.ValidationCheck_InternalQA_CSV is not null or vrp.ValidationCheck_InternalQA_CSV <> '' )
	where 1=1
	and rpt.BatchID = @BatchID

)

