
CREATE     VIEW [cms].[vw_CMROfferSupplemental_History]

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
		, CMROfferRecipientCode = case 
					when s.ClientID is not null and cmros.CMROfferRecipient in ('01','02','03','04') then cmros.CMROfferRecipient  --// Client supplemental
					when s.ClientID is null and year(cmros.CMROfferDate) >= 2019 then '01' end  --// default to 01 (Beneficiary) for non-Client supplemental
		, CMROfferRecipientCode_Actual = cmros.CMROfferRecipient
		, cmros.CMROfferReturnDate
		, IsCMROfferComplete = case when cmros.CMROfferDate is not null and (cmros.CMROfferReturnDate is null or cmros.CMROfferReturnDate < cmros.CMROfferDate) then 1 else 0 end
		, IsCurrent = case 
					when cmros.SnapshotID = 0 then 1
					else s.IsCurrent end
		, cmros.SnapshotID
		, cmros.CreateDT
		, cmros.ChangeDT
	from cms.CMROfferSupplemental cmros
	left join (
		select s.SnapshotID, s.ClientID, s.ContractYear, IsCurrent = case when getdate() between s.ActiveFromDT and s.ActiveThruDT then 1 else 0 end
		from cms.CMS_SnapshotTracker s
		where 1=1
		and s.DataSetTypeID = 6  --// CMROfferSupplemental
	) s
		on s.SnapshotID = cmros.SnapshotID
		--or cmros.SnapshotID = 0  --// removed by Steve per Bug/Fix
	where 1=1


