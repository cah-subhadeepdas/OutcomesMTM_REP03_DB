

CREATE     VIEW [cms].[vw_CMROffer_Active]
AS

	select 
		PatientID = cmros.PatientID
		, CMROfferDate = cmros.CMROfferDate
		, CMROfferType = cmros.CMROfferModality
		, SourceSystem = cmros.SourceSystem
		, CMROfferRecipientCode = cmros.CMROfferRecipientCode  --// added 2019
		, CMROfferReturnDate = cmros.CMROfferReturnDate  --// added 2019
		, IsCMROfferComplete = cmros.IsCMROfferComplete
		, CMROfferID = cmros.CMROfferSupplementalID 
		, ClaimID = NULL
		, SnapshotID = cmros.SnapshotID
	from cms.vw_CMROfferSupplemental_Active cmros

	UNION ALL

	select
		cmr.PatientID
		, CMROfferDate = cmr.MTMServiceDT
		, CMROfferType = 'Claim'
		, SourceSystem = cmr.SourceSystem
		, CMROfferRecipientCode = cmr.RecipientCode  --// added 2019
		, CMROfferReturnDate = NULL  --// added 2019
		, IsCMROfferComplete = cmr.CMROffer
		, CMROfferID = cmr.CMRID
		, ClaimID = cmr.ClaimID
		, SnapshotID = cmr.SnapshotID
	from cms.vw_CMR_Active cmr
	where 1=1
	and cmr.CMROffer = 1

