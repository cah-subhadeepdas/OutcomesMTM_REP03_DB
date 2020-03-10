


CREATE     VIEW [cms].[vw_CMR_History]

AS

	select
		SourceSystem = 'Connect'
		, cmr.CMRID
		, cmr.ClaimID
		, cmr.MTMServiceDT
		, cmr.ReasonCode
		, cmr.ActionCode
		, cmr.ResultCode
		, cmr.ClaimStatus
		, cmr.ClaimStatusDT
		, cmr.PatientID
		, cmr.PharmacyID
		, cmr.NCPDP_NABP
		, cmr.CMRWithSPT
		, cmr.CMRSuccess  --// added 2019
		, cmr.CMROffer
		, cmr.CMRID_Source
		, cmr.CognitivelyImpairedIndicator
		, cmr.MethodOfDeliveryCode
		, cmr.ProviderCode
		, cmr.RecipientCode
		, cmr.AuthorizedRepresentative
		, cmr.Topic01
		, cmr.Topic02
		, cmr.Topic03
		, cmr.Topic04
		, cmr.Topic05
		, cmr.MAPCount
		, cmr.SPTDate  --// added 2019
		, cmr.SPTReturnDate  --// added 2019
		, cmr.LTC  --// added 2019
		, s.SnapshotID
		, s.ClientID
		, s.ContractYear
		, s.IsCurrent
	from cms.CMR cmr
	join (
		select s.SnapshotID, s.ClientID, s.ContractYear, IsCurrent = case when getdate() between s.ActiveFromDT and s.ActiveThruDT then 1 else 0 end
		from cms.CMS_SnapshotTracker s
		where 1=1
		and s.DataSetTypeID = 1  --// CMR
	) s
		on s.SnapshotID = cmr.SnapshotID		

