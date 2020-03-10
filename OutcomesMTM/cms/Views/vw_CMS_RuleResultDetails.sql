CREATE view [cms].[vw_CMS_RuleResultDetails] as 
SELECT 
		res.[RuleRunResultID]
      ,res.[RuleID]
      ,res.[PatientID]
      ,res.[BeneficiaryID]
      ,res.[SnapshotID]
      ,res.[MTMEnrollmentID]
      ,res.[ResultStatus]
      ,res.[RunDT]
	  ,v.[Data Element]
	  ,v.[Automated Check/Validation]
	  ,v.[Severity] 
	  ,v.[OutcomesMTM Internal Error Description]
	  ,v.[OMTM External Error Description]
	  ,v.[OMTM External Error Action Details ]
  FROM [OutcomesMTM].[cms].[RuleRunResult] res
join cms.validationrule v 
  on res.ruleid = v.ruleid

