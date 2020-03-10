



CREATE   VIEW [cms].[vw_ValidationRunResult_Active]
AS

SELECT 
	[RuleRunResultID]
	,[RuleID]
	,[PatientID]
	,[BeneficiaryID]
	,[SnapshotID]
	,[MTMEnrollmentID]
	,[ResultStatus]
	,[RunDT]
	,[Data Element]
	,[Automated Check/Validation]
	,[Severity] 
	,[OutcomesMTM Internal Error Description]
	,[OMTM External Error Description]
	,[OMTM External Error Action Details ]
	,IsCurrent
	,ContractNumber  -- Add here to test 1 client with multiple contract
FROM cms.vw_ValidationRunResult_History h
WHERE 1=1
and h.IsCurrent = 1



