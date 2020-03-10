

CREATE   VIEW [cms].[vw_CMROfferSupplemental_Active]

AS

	select
		cmros.CMROfferSupplementalID
		, cmros.CMROfferSupplementalID_Source
		, cmros.SourceSystem
		, cmros.PatientID
		, cmros.PatientID_All
		, cmros.ClientID
		, cmros.CMROfferDate
		, cmros.CMROfferModality
		, cmros.CMROfferRecipientCode
		, cmros.CMROfferRecipientCode_Actual
		, cmros.CMROfferReturnDate
		, cmros.IsCMROfferComplete
		, cmros.IsCurrent
		, cmros.SnapshotID
		, cmros.CreateDT
		, cmros.ChangeDT
	from cms.vw_CMROfferSupplemental_History cmros
	where 1=1
	and cmros.IsCurrent = 1

