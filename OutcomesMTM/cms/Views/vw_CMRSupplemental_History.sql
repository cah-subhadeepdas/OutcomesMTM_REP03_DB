
CREATE   VIEW [cms].[vw_CMRSupplemental_History]

AS

	select
		SourceSystem = cmrs.SourceSystem
		, CMRID = cmrs.CMRSupplementalID
		, ClaimID = NULL
		, MTMServiceDT = cmrs.CMRDate
		, ReasonCode = NULL
		, ActionCode = NULL
		, ResultCode = NULL
		, ClaimStatus = NULL
		, ClaimStatusDT = NULL
		, PatientID = cmrs.PatientID
		, PharmacyID = NULL
		, NCPDP_NABP = NULL
		, CMRWithSPT = 1
		, CMROffer = 1
		, CMRID_Source = cmrs.CMRSupplementalID_Source
		, CognitivelyImpairedIndicator = cmrs.CognitivelyImpairedIndicator
		, MethodOfDeliveryCode = cmrs.MethodOfDeliveryCode
		, ProviderCode = cmrs.ProviderCode
		, RecipientCode = cmrs.RecipientCode
		, AuthorizedRepresentative = case when cmrs.RecipientCode = '01' then 'N' when cmrs.RecipientCode <> '01' and cmrs.RecipientCode like '[0-9][0-9]' then 'Y' else cmrs.AuthorizedRepresentative end
		, Topic01 = NULL
		, Topic02 = NULL
		, Topic03 = NULL
		, Topic04 = NULL
		, Topic05 = NULL
		, MAPCount = NULL
		, SPTDate = cmrs.SPTDate
		, LTC = case when cmrs.SourceSystem = 'Omnicare' then 1 else 0 end
		, s.SnapshotID
		, s.ClientID
		, s.ContractYear
		, s.IsCurrent
	from cms.CMRSupplemental cmrs
	join (
		select s.SnapshotID, s.ClientID, s.ContractYear, IsCurrent = case when getdate() between s.ActiveFromDT and s.ActiveThruDT then 1 else 0 end
		from cms.CMS_SnapshotTracker s
		where 1=1
		and s.DataSetTypeID = 5  --// CMRSupplemental
	) s
		on s.SnapshotID = cmrs.SnapshotID


