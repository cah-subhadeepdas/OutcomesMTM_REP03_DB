

CREATE   VIEW [cms].[vw_ValidationResult_DetailRpt]
AS


	select distinct
		cl.clientID
		, cl.ClientName
		, s.ContractYear
		, OMTM_ID = vrr.PatientID
		, ValidationRunDateTime = convert(varchar(20),vrr.RunDT, 120)
		, vrr.[Data Element]
		, vrr.[Automated Check/Validation]
		, vrr.Severity
		, vrr.[OutcomesMTM Internal Error Description]
		, ValidationResult = case when vrr.ResultStatus = 1 then 'FAIL' else 'PASS' end
	from OutcomesMTM.cms.vw_ValidationRunResult_Active vrr
	join OutcomesMTM.cms.CMS_SnapshotTracker s
		on s.SnapshotID = vrr.SnapshotID
		and s.ActiveThruDT > getdate()
	left join OutcomesMTM.dbo.Client cl
		on cl.clientID = s.ClientID
	where 1=1


