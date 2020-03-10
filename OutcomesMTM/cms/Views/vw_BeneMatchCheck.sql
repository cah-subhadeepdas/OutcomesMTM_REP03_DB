
CREATE   VIEW [cms].[vw_BeneMatchCheck] 
AS

	select
		--bma.BeneficiaryMatchID
		bma.SnapshotID
		, bma.PatientID
		, bma.BeneficiaryMatchCheck
		, BeneficiaryMatch_OMTM_IDs = bma.BeneficiaryMatch_PatientIDs
		--, CreateDT
		--, ChangeDT
	from outcomesmtm.cms.BeneficiaryMatch bma

