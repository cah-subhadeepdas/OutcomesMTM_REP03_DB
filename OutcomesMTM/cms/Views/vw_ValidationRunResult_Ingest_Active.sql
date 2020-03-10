

CREATE     VIEW [cms].[vw_ValidationRunResult_Ingest_Active]
AS

	select *
	from (

			select
				vr.[OutcomesMTM Internal Error Description]
				, vrrr.Patientid
				, vrr.*
				, vrrr.ResultStatus
				, vrrr.IngestLogID
				, ranker = dense_rank() over (partition by vrr.ClientID, vrr.ContractYear, vrr.ValidationRuleID, vrr.ValidationRuleWorkflowID order by vrr.CreateDT desc)
			from cms.ValidationRule vr
			join cms.ValidationRuleRun vrr
				on vrr.ValidationRuleID = vr.RuleID
			left join cms.ValidationRuleRunResult vrrr
				on vrrr.ValidationRuleRunID = vrr.ValidationRuleRunID
			where 1=1
			and vrr.ValidationRuleWorkflowID = 2  --// 2: PreIngest Validation

	) vrrr
	where 1=1
	and vrrr.ranker = 1


