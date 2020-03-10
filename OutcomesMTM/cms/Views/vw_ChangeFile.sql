CREATE   VIEW cms.vw_ChangeFile
AS

	select
		ClientID = s.ClientID
		, ContractYear = s.ContractYear
		, ClientName = cl.clientName
		, OMTM_ID = ad.PatientID
		, MemberID = ad.PatientID_All
		, ContractNumber = ad.ContractNumber
		, ChangeActivity = aat.AuditActivityTypeDescription
		, ChangeDetail = case when ad.AuditActivityTypeID = 2 then 'NA' else isnull(nullif(ad.AuditDetailAttributeNameExternal,''),'') + isnull(nullif(aat.AuditDetailText,''),'') + isnull(nullif(ad.AuditDetailValue_NEW,''),'') end
		, ChangeDate = convert(varchar,ad.CreateDT,112)
	from cms.AuditDetail ad
	join cms.AuditActivityType aat
		on aat.AuditActivityTypeID = ad.AuditActivityTypeID
	join cms.CMS_SnapshotTracker s
		on s.SnapshotID = ad.SnapshotID
	join ( select distinct ccp.ClientID, ccp.ClientName from ClientContractPolicyView ccp) cl
		on cl.clientID = s.ClientID
	where 1=1


