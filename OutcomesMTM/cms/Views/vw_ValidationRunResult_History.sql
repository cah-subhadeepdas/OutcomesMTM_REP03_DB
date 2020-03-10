

CREATE      VIEW [cms].[vw_ValidationRunResult_History]
AS

SELECT 
		rrr.[RuleRunResultID]
      ,rrr.[RuleID]
      ,rrr.[PatientID]
      ,rrr.[BeneficiaryID]
      ,rrr.[SnapshotID]
      ,rrr.[MTMEnrollmentID]
      ,rrr.[ResultStatus]
      ,rrr.[RunDT]
	  ,vr.[Data Element]
	  ,vr.[Automated Check/Validation]
	  ,vr.[Severity] 
	  ,vr.[OutcomesMTM Internal Error Description]
	  ,vr.[OMTM External Error Description]
	  ,vr.[OMTM External Error Action Details ]
	  ,IsCurrent = case when rr.ranker = 1 then 1 else 0 end  --  case when ROW_NUMBER() over (partition by rrr.RuleID, rrr.SnapshotID, rrr.PatientID order by rrr.RuleRunResultID desc) = 1 then 1 else 0 end
	  ,rrr.[ContractNumber]   -- Added to test

FROM (
	select *, ranker = dense_rank() over (partition by rr.ClientID order by rr.RunDT desc)
	from cms.RuleRun rr
) rr
left join [OutcomesMTM].[cms].[RuleRunResult] rrr 
	on rrr.ClientID = rr.ClientID
	and rrr.RunID = rr.RunID

join cms.validationrule vr
	ON rrr.ruleid = vr.ruleid
WHERE 1=1




