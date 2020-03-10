




Create         PROCEDURE [cms].[CMS_REPORT_QA]
	  @ClientID int
	, @ContractYear char(4) = ''
	, @Thrudate date = null
	, @BatchID int

AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

	--// declare @ClientID int = 142; declare @ContractYear char(4); declare @ThruDate date  --// for testing

	IF isnull(@ContractYear,'') = ''
		SET @ContractYear = ( select top 1 ContractYear from cms.vw_Snapshot s order by ContractYear desc )
		--Select @ContractYear

	IF isnull(@Thrudate,'19000101') not between cast(@ContractYear + '0101' as date) and cast(@ContractYear + '1231' as date)
		SET @Thrudate = cast(@ContractYear + '1231' as date)
		--Select @Thrudate


	--	 Declare 
 --@ClientID int = 142,
 --@ContractYear char(4) = '2018',
 --@BatchID Int = 5

 

	drop table if exists #rptval
	SELECT
          vw.PatientID, vw.ClientID , ContractYear =@ContractYear
		, rpt.BatchID, rpt.BeneficiaryID , rundt =getdate()
		, [ContractNumber]	= cast( rpt.ContractNumber as char(5))
		, [HICNumber]	= cast( ltrim(rtrim(rpt.HICN)) as char(12))
		, [FirstName]	= cast( ltrim(rtrim(rpt.FirstName)) as char(30))
		, [MiddleInitial]	= cast( isnull(left(ltrim(rpt.MI),1),'') as char(1))
		, [LastName]	= cast( ltrim(rtrim(rpt.LastName)) as char(30))
		, [DOB]	= cast( convert(varchar(8), rpt.DOB, 112) as char(8))
		, [TargetingCriteriaMet]	= cast( rpt.MTMPCriteriaMet as char(1))
		, [CognitivelyImpaired]	= cast( isnull(rpt.CMR_CognitivelyImpairedIndicator,'U') as char(1))
		, [MTMPEnrollmentDate]	= cast( isnull(convert(varchar(8), rpt.MTMPEnrollmentFromDate, 112),'') as char(8))
		, [MTMPTargetedDate]		= cast( isnull(convert(varchar(8), rpt.MTMPTargetingDate, 112),'') as char(8))
		, [MTMPOptOutDate]		= cast( isnull(convert(varchar(8), rpt.OptOutDate, 112), '') as char(8))
		, [MTMPOptOutReasonCode]	= cast( isnull(rpt.OptOutReasonCode,'') as char(2))
		, [CMROffered]	= cast( rpt.CMROffered as char(1))
		, [CMROfferDate]	= cast( isnull(convert(varchar(8), rpt.CMROfferDate, 112),'') as char(8))
		, [CMRReceived]	= cast( rpt.CMRReceived as char(1))
		, [CMRReceivedCount]	= cast( right('00' + isnull(rpt.CMR_Count,'0'),2) as char(2))
		, [CMRReceivedDate1]	= cast( isnull(convert(varchar(8), rpt.CMR_Date1, 112),'') as char(8))
		, [CMRReceivedDate2]	= cast( isnull(convert(varchar(8), rpt.CMR_Date2, 112),'') as char(8))
		, [CMRDeliveryMethod]	= cast( isnull(rpt.CMR_MethodOfDeliveryCode,'') as char(2))
		, [CMRProviderCode]	= cast( isnull(rpt.CMR_ProviderCode,'') as char(2))
		, [CMRRecipientCode]	= cast( isnull(rpt.CMR_RecipientCode,'') as char(2))
		, [TMRCount]			= cast( right('00' + isnull(rpt.TMR_Count,'0'),3) as char(3))
		, [DTPRecommendationsCount]	= cast( right('00' + isnull(rpt.DTPR_Count,'0'),2) as char(2))
		, [DTPChangesCount]	= cast( right('00' + isnull(rpt.DTPC_Count,'0'),2) as char(2))
				
		into #rptval

	from cms.rpt_Report_Log rpt
	join cms.CMS_rpt_Batch bt
	on bt.BatchID = rpt.BatchID
	join cms.vw_CMS vw
	on rpt.BeneficiaryID =vw.BeneficiaryID
	where 1=1
	and rpt.BatchID = @BatchID


		drop table if exists #vrp
		select vrp.*
		into #vrp
		from #rptval bm
		join  [OutcomesMTM].cms.[vw_RPT_ValidationRunResult_Active_PivotPatient] vrp
			on vrp.PatientID = bm.PatientID
		where 1=1
		and ( vrp.ValidationCheck_InternalQA_CSV is not null or vrp.ValidationCheck_InternalQA_CSV <> '' )
		;


		--drop table if exists #benematch
		--select bmc.*
		--into #benematch
		--from #benemtmp bm
		--join OutcomesMTM.cms.vw_BeneMatchCheck bmc
		--	on bmc.PatientID = bm.PatientID
		--where 1=1
		--;

	SELECT
  
		  [A_ContractNumber]	= cast( rpt.ContractNumber as char(5))
		, [B_HICNumber]	= cast( ltrim(rtrim(rpt.[HICNumber])) as char(12))
		, [C_FirstName]	= cast( ltrim(rtrim(rpt.FirstName)) as char(30))
		, [D_MiddleInitial]	= cast( isnull(left(ltrim(rpt.[MiddleInitial]),1),'') as char(1))
		, [E_LastName]	= cast( ltrim(rtrim(rpt.LastName)) as char(30))
		, [F_DOB]	= cast( convert(varchar(8), rpt.DOB, 112) as char(8))
		, [G_TargetingCriteriaMet]	= cast( rpt.[TargetingCriteriaMet] as char(1))
		, [H_CognitivelyImpaired]	= cast( isnull(rpt.[TargetingCriteriaMet],'U') as char(1))
		, [I_MTMPEnrollmentDate]	= cast( isnull(convert(varchar(8), rpt.[MTMPEnrollmentDate], 112),'') as char(8))
		, [J_MTMPTargetedDate]		= cast( isnull(convert(varchar(8), rpt.[MTMPTargetedDate], 112),'') as char(8))
		, [K_MTMPOptOutDate]		= cast( isnull(convert(varchar(8), rpt.[MTMPOptOutDate], 112), '') as char(8))
		, [L_MTMPOptOutReasonCode]	= cast( isnull(rpt.[MTMPOptOutReasonCode],'') as char(2))
		, [M_CMROffered]	= cast( rpt.CMROffered as char(1))
		, [N_CMROfferDate]	= cast( isnull(convert(varchar(8), rpt.CMROfferDate, 112),'') as char(8))
		, [O_CMRReceived]	= cast( rpt.CMRReceived as char(1))
		, [P_CMRReceivedCount]	= cast( right('00' + isnull(rpt.[CMRReceivedCount],'0'),2) as char(2))
		, [Q1_CMRReceivedDate1]	= cast( isnull(convert(varchar(8), rpt.[CMRReceivedDate1], 112),'') as char(8))
		, [Q2_CMRReceivedDate2]	= cast( isnull(convert(varchar(8), rpt.[CMRReceivedDate2], 112),'') as char(8))
		, [R_CMRDeliveryMethod]	= cast( isnull(rpt.[CMRDeliveryMethod],'') as char(2))
		, [S_CMRProviderCode]	= cast( isnull(rpt.[CMRProviderCode],'') as char(2))
		, [T_CMRRecipientCode]	= cast( isnull(rpt.[CMRRecipientCode],'') as char(2))
		, [U_TMRCount]			= cast( right('00' + isnull(rpt.[TMRCount],'0'),3) as char(3))
		, [V_DTPRecommendationsCount]	= cast( right('00' + isnull(rpt.[DTPRecommendationsCount],'0'),2) as char(2))
		, [W_DTPChangesCount]	= cast( right('00' + isnull(rpt.[DTPChangesCount],'0'),2) as char(2))
		, [X_QACheck] =  isnull(vrp.ValidationCheck_InternalQA_CSV,'')	
			

	from #rptval rpt
	left join #vrp vrp
	on  rpt.PatientID = vrp.PatientID
	--left join #benematch bmc
	--on bmc.PatientID = bm.PatientID
	where 1=1
	and rpt.BatchID = @BatchID  --5

END




