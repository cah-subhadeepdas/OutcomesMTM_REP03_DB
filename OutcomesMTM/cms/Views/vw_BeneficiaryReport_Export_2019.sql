

CREATE   VIEW [cms].[vw_BeneficiaryReport_Export_2019]
AS

	SELECT
		  A_ContractNumber = cast( rpt.ContractNumber as char(5))
		, B_HICNumber = cast( ltrim(rtrim(rpt.HICN)) as char(12))
		, C_FirstName = cast( ltrim(rtrim(rpt.FirstName)) as char(30))
		, D_LastName = cast( ltrim(rtrim(rpt.LastName)) as char(30))
		, E_DOB = cast( convert(varchar(8), rpt.DOB, 112) as char(8))
		, F_TargetingCriteriaMet = cast( rpt.MTMPCriteriaMet as char(1))
		, G_CognitivelyImpaired = cast( isnull(rpt.CMR_CognitivelyImpairedIndicator,'U') as char(1))
		, H_LTCIndicator = cast( isnull(rpt.LTCIndicator,'') as char(1))  --// added 2019
		, I_MTMPEnrollmentDate = cast( isnull(convert(varchar(8), rpt.MTMPEnrollmentFromDate, 112),'') as char(8))
		, J_MTMPTargetedDate = cast( isnull(convert(varchar(8), rpt.MTMPTargetingDate, 112),'') as char(8))
		, K_MTMPOptOutDate = cast( isnull(convert(varchar(8), rpt.OptOutDate, 112), '') as char(8))
		, L_MTMPOptOutReasonCode = cast( isnull(rpt.OptOutReasonCode,'') as char(2))
		, M_CMROffered = cast( rpt.CMROffered as char(1))
		, N_CMROfferDate = cast( isnull(convert(varchar(8), rpt.CMROfferDate, 112),'') as char(8))
		, O_CMROfferRecipientCode = cast( isnull(rpt.CMROfferRecipientCode,'') as char(2))  --// added 2019
		, P_CMRReceived = cast( rpt.CMRReceived as char(1))
		, Q_CMRReceivedDate1 = cast( isnull(convert(varchar(8), rpt.CMR_Date1, 112),'') as char(8))
		, R_CMRSPTSentDate = cast( isnull(convert(varchar(8), rpt.CMR_SPTSentDate, 112),'') as char(8))  --// added 2019
		, S_CMRDeliveryMethod = cast( isnull(rpt.CMR_MethodOfDeliveryCode,'') as char(2))
		, T_CMRProviderCode = cast( isnull(rpt.CMR_ProviderCode,'') as char(2))
		, U_CMRRecipientCode = cast( isnull(rpt.CMR_RecipientCode,'') as char(2))
		, V_TMRCount = cast( right('00' + isnull(rpt.TMR_Count,'0'),3) as char(3))
		, W_TMRFirstDate = cast( isnull(convert(varchar(8), rpt.TMR_Date1, 112),'') as char(8))  --// added 2019
		, X_DTPRecommendationsCount = cast( right('00' + isnull(rpt.DTPR_Count,'0'),2) as char(2))
		, Y_DTPChangesCount = cast( right('00' + isnull(rpt.DTPC_Count,'0'),2) as char(2))
		, ValidationCheck_InternalQA_CSV = cast(isnull(vrp.ValidationCheck_InternalQA_CSV,'') as varchar(8000))
		, rpt.BeneficiaryID
		, rpt.ReportLogID
		, bt.BatchID
		, bt.ClientID
		, cl.ClientName
		, bt.ContractYear
		, bt.ContractNumber
		, vrp2.Severity1_Count_Batch
		, vrp2.Severity2_Count_Batch
		, vrp2.Severity3_Count_Batch
		, vrp2.SeverityLevel_Min_Batch
	FROM cms.rpt_Report_Log rpt
	JOIN cms.CMS_rpt_Batch bt
		ON bt.BatchID = rpt.BatchID
	LEFT JOIN dbo.Client cl
		on cl.clientID = bt.ClientID
	LEFT JOIN cms.vw_ValidationRuleRunResult_Active_PivotUID vrp
		ON vrp.UIDValue = rpt.ReportLogID
		AND vrp.BatchKey = 'BatchID'
		and vrp.BatchValue = bt.BatchID
	OUTER APPLY (
			select top 1 vrp99.Severity1_Count_Batch, vrp99.Severity2_Count_Batch, vrp99.Severity3_Count_Batch, vrp99.SeverityLevel_Min_Batch
			from cms.vw_ValidationRuleRunResult_Active_PivotUID vrp99
			where 1=1
			and vrp99.BatchKey = 'BatchID'
			and vrp99.BatchValue = bt.BatchID
		) vrp2
	WHERE 1=1


