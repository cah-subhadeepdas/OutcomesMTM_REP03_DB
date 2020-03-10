






CREATE     VIEW [cms].[vw_ValidationRunResult_Active_PivotPatient]
AS


SELECT
	s.SnapshotID
	, s.ClientID
	, v.PatientID
	, v.BeneficiaryID
	, v.RunDT
	, v.ContractNumber   -- Added here for 1 client may have multiple Contract
	, ValidationCheck_CSV = stuff((
			select '|' + v2.[OMTM External Error Description]
			from cms.vw_ValidationRunResult_Active v2
			where v2.PatientID = v.PatientID
			and v2.SnapshotID = v.SnapshotID
			and isnull(v2.[OMTM External Error Description],'') <> ''
			order by v2.[OMTM External Error Description]
			for XML PATH('')), 1, 1, '')
	, ValidationAction_CSV = stuff((
			select '|' + v2.[OMTM External Error Action Details ]
			from cms.vw_ValidationRunResult_Active v2
			where v2.PatientID = v.PatientID
			and v2.SnapshotID = v.SnapshotID
			and isnull(v2.[OMTM External Error Description],'') <> ''
			order by v2.[OMTM External Error Description]
			for XML PATH('')), 1, 1, '')
	, ValidationCheck_InternalQA_CSV = stuff((
			select '|' + v2.[OutcomesMTM Internal Error Description]
			from cms.vw_ValidationRunResult_Active v2
			where v2.PatientID = v.PatientID
			and v2.SnapshotID = v.SnapshotID
			and isnull(v2.[OutcomesMTM Internal Error Description],'') <> ''
			order by v2.[OutcomesMTM Internal Error Description]
			for XML PATH('')), 1, 1, '')
FROM cms.vw_ValidationRunResult_Active v
JOIN cms.CMS_SnapshotTracker s
	on s.SnapshotID = v.SnapshotID
WHERE 1=1




