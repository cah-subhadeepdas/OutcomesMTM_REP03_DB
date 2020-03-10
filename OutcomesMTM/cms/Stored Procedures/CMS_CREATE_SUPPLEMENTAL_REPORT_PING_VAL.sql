

CREATE   PROCEDURE [cms].[CMS_CREATE_SUPPLEMENTAL_REPORT_PING_VAL]
	  @ClientID int
	, @ContractYear char(4) = ''

AS
BEGIN

	
	--// debugging:  declare @ClientID int = 129, @ContractYear char(4) = '2019'
	drop table if exists #sfvr
	select sfil.*, vrp.ValidationCheck_InternalQA_CSV
	into #sfvr
	from (
		select distinct vr.ClientID, vr.ContractYear, vr.ValidationDataSet, vr.BatchKey, vr.BatchValue, vr.CreateDT, ranker = row_number() over (partition by vr.ClientID, vr.ContractYear, vr.ValidationDataSet order by vr.CreateDT desc)
		from cms.vw_ValidationRuleRunResult_Active vr
		where 1=1
		and vr.BatchKey = 'FileID'
		and vr.ClientID = @ClientID
		and vr.ContractYear = @ContractYear
	) vr2
	join cmsETL.BeneficiarySF_IngestLog sfil
		on sfil.FileID = vr2.BatchValue
	left join cms.vw_ValidationRuleRunResult_Active_PivotUID vrp
		on vrp.BatchValue = sfil.FileID
		and vrp.UIDValue = sfil.IngestLogID
		and vrp.UIDKey = 'IngestLogID'
	where 1=1
	and vr2.ranker = 1


	select distinct
		inglog.[ClientName]
		,inglog.[OMTM_ID]
		,inglog.[MemberID]
		,inglog.[FirstName]
		--,inglog.[MiddleInitial]
		,inglog.[LastName]
		,inglog.[DOB]
		,inglog.[HICN_MBI]
		,inglog.[ContractNumber]
		,inglog.[MTMPEnrollmentStartDate]
		,inglog.[MTMPTargetingDate]
		,inglog.[OptOutDate]
		,inglog.[OptOutReasonCode]
		,inglog.[BeneficiaryMatchCheck]
		,inglog.[ValidationCheck]
		,inglog.[ActionRequiredOnCheck]
		,inglog.[BeneficiaryMatch_OMTM_IDs]
		,inglog.[SelectMasterOMTM_ID]
		,inglog.[RemoveMember]
		,PreIngValidation = isnull(inglog.ValidationCheck_InternalQA_CSV,'')
	from #sfvr inglog
	where 1=1


END

