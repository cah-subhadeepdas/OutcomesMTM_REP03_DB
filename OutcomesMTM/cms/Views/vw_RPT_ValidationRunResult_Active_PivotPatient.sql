


CREATE      VIEW [cms].[vw_RPT_ValidationRunResult_Active_PivotPatient]
AS


SELECT distinct

	  v.ClientID
	, v.PatientID
	, v.BeneficiaryID
	, v.RunDT
	, v.ContractNumber
	, v.BatchID   
	--, ValidationCheck_CSV = stuff((
	--		select '|' + v2.[OMTM External Error Description]
	--		from cms.vw_ValidationRunResult_Active v2
	--		where v2.PatientID = v.PatientID
	--		--and v2.SnapshotID = v.SnapshotID
	--		and isnull(v2.[OMTM External Error Description],'') <> ''
	--		order by v2.[OMTM External Error Description]
	--		for XML PATH('')), 1, 1, '')
	--, ValidationAction_CSV = stuff((
	--		select '|' + v2.[OMTM External Error Action Details ]
	--		from cms.vw_ValidationRunResult_Active v2
	--		where v2.PatientID = v.PatientID
	--		and isnull(v2.[OMTM External Error Description],'') <> ''
	--		order by v2.[OMTM External Error Description]
	--		for XML PATH('')), 1, 1, '')
	, ValidationCheck_InternalQA_CSV = stuff((
			select '|' + v2.[OutcomesMTM Internal Error Description]
			--from cms.vw_ValidationRunResult_Active v2
			from (
					select rrr.*, vr.[OutcomesMTM Internal Error Description]
					FROM [OutcomesMTM].[cms].[RptRunResult] rrr  
					JOIN cms.validationrule vr
						ON rrr.ruleid = vr.ruleid
			) v2
			where 1=1
			and v2.BeneficiaryID = v.BeneficiaryID
			and v2.BatchID = v.BatchID
			and isnull(v2.[OutcomesMTM Internal Error Description],'') <> ''
			order by v2.[OutcomesMTM Internal Error Description]
			for XML PATH('')), 1, 1, '')
FROM 
(
		SELECT 
			   rrr.[RptRunResultID]
			  ,rrr.clientID
			  ,rrr.[RuleID]
			  ,rrr.[PatientID]
			  ,rrr.[BeneficiaryID]
			  ,rrr.[ResultStatus]
			  ,rrr.[RunDT]
			  ,vr.[Data Element]
			  ,vr.[Automated Check/Validation]
			  ,vr.[Severity] 
			  ,vr.[OutcomesMTM Internal Error Description]
			  ,vr.[OMTM External Error Description]
			  ,vr.[OMTM External Error Action Details ]
			  ,rrr.[ContractNumber]
			  ,rrr.BatchID 
			  --// select top 100 *
		FROM [OutcomesMTM].[cms].[RptRunResult] rrr  
		JOIN cms.validationrule vr
			ON rrr.ruleid = vr.ruleid
		WHERE 1=1

) 	v
WHERE 1=1




