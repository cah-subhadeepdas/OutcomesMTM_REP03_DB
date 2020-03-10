

CREATE     VIEW [cms].[vw_CMS]
AS


WITH cteBM AS
(

		SELECT
			b.[BeneficiaryID]
			, b.[ClientID]
			, b.[ContractYear]
			, b.[HICN]
			, b.[First_Name]
			, b.MI
			, b.[Last_Name]
			, b.[dob]
			, b.[snapshotID]
			, b.[ActiveFromDT]
			, b.[ActiveThruDT]
			, b.[isCurrent]
			, mtmp.[MTMPEnrollmentID]
			, mtmp.[PatientID_All]
			, mtmp.[PatientID]
			, mtmp.[ContractNumber]
			, mtmp.[MTMPTargetingDate]
			, mtmp.[MTMPEnrollmentFromDate]
			, mtmp.[MTMPEnrollmentThruDate]
			, mtmp.OptOutReasonCode
			, mtmp.OptOutDate
			, Rank_Contract = ROW_NUMBER() over (partition by b.BeneficiaryID, mtmp.ContractYear, mtmp.ContractNumber order by mtmp.MTMPEnrollmentFromDate, mtmp.MTMPEnrollmentID asc)
			, Rank_Contract_Desc = ROW_NUMBER() over (partition by b.BeneficiaryID, mtmp.ContractYear, mtmp.ContractNumber order by mtmp.MTMPEnrollmentThruDate desc, mtmp.MTMPEnrollmentFromDate, mtmp.MTMPEnrollmentID desc)
		FROM OutcomesMTM.cms.CMS_Beneficiary_History b
		JOIN OutcomesMTM.cms.CMS_BeneficiaryPatient_History bp 
			on bp.BeneficiaryID = b.BeneficiaryID
			and b.SnapshotID = bp.SnapshotID    
		JOIN OutcomesMTM.cms.CMS_MTMPEnrollment_History mtmp
			on mtmp.PatientID = bp.PatientID       
			and mtmp.SnapshotID = bp.SnapshotID
		JOIN (
			select s.SnapshotID, s.ClientID, s.ContractYear
			from cms.CMS_SnapshotTracker s
			where 1=1
			and s.DataSetTypeID = 2
			and s.ActiveThruDT > getdate()
		) s
			on s.ClientID = b.ClientID
			and s.ContractYear = b.ContractYear
			and s.SnapshotID = b.SnapshotID								   
		WHERE 1=1
		and mtmp.MTMPEnrollmentThruDate >= mtmp.CYFromDate
		and mtmp.MTMPENrollmentFromDate <= mtmp.CYThruDate
		and mtmp.MTMPEnrollmentThruDate >= mtmp.MTMPEnrollmentFromDate

)  --//  cteBM

,cteBM2 AS (

	SELECT
		bm.BeneficiaryID
		, bm.ClientID
		, bm.ContractYear
		, bm.HICN
		, bm.First_Name
		, bm.MI
		, bm.Last_Name
		, bm.DOB
		, bm.SnapshotID
		, bm.ActiveFromDT
		, bm.ActiveThruDT
		, bm.IsCurrent
		, bm.MTMPEnrollmentID
		, bm.PatientID_All
		, bm.PatientID
		, bm.ContractNumber
		, MTMPTargetingDate = coalesce(bm.MTMPTargetingDate,bm2.MTMPTargetingDate)
		, bm.MTMPEnrollmentFromDate
		, MTMPEnrollmentThruDate = bm2.MTMPEnrollmentThruDate
		, OptOutDate = bm2.OptOutDate
		, OptOutReasonCode = bm2.OptOutReasonCode
		, MTMPEnrollmentFromDate_NEXT = lead(bm.MTMPEnrollmentFromDate) over (partition by bm.BeneficiaryID order by bm.MTMPEnrollmentFromDate asc, bm.MTMPEnrollmentThruDate asc, bm.MTMPEnrollmentID asc)
		, bm.Rank_Contract
		, bm.Rank_Contract_Desc
	from cteBM bm
	join cteBM bm2
		on bm2.BeneficiaryID = bm.BeneficiaryID
		and bm2.ContractYear = bm.ContractYear
		and bm2.ContractNumber = bm.ContractNumber
		and bm2.Rank_Contract_Desc = 1
	where 1=1
	and bm.Rank_Contract = 1

)  --// cteBM2

select
	bm.BeneficiaryID
	, bm.ClientID
	, bm.ContractYear
	, bm.HICN
	, bm.First_Name
	, bm.MI
	, bm.Last_Name
	, bm.DOB
	, bm.SnapshotID
	, bm.ActiveFromDT
	, bm.ActiveThruDT
	, bm.IsCurrent
	, bm.MTMPEnrollmentID
	, bm.PatientID_All
	, bm.PatientID
	, bm.ContractNumber
	, bm.MTMPTargetingDate
	, bm.MTMPEnrollmentFromDate
	, bm.MTMPEnrollmentThruDate
	, bm.OptOutDate
	, bm.OptOutReasonCode
	, MTMPEnrollmentThruDate_INFERRED = case when isnull(bm.OptOutReasonCode,'') in ('02','') and bm.MTMPEnrollmentFromDate_NEXT < bm.MTMPEnrollmentThruDate and bm.MTMPEnrollmentFromDate_NEXT > bm.MTMPEnrollmentFromDate then dateadd(day,-1,bm.MTMPEnrollmentFromDate_NEXT) else bm.[MTMPEnrollmentThruDate] end
	, OptOutDate_INFERRED = case when isnull(bm.OptOutReasonCode,'') in ('02','') and bm.MTMPEnrollmentFromDate_NEXT < bm.MTMPEnrollmentThruDate and bm.MTMPEnrollmentFromDate_NEXT > bm.MTMPEnrollmentFromDate then dateadd(day,-1,bm.MTMPEnrollmentFromDate_NEXT) else bm.OptOutDate end
	, OptOutReasonCode_INFERRED = case when isnull(bm.OptOutReasonCode,'') in ('02','') and bm.MTMPEnrollmentFromDate_NEXT < bm.MTMPEnrollmentThruDate and bm.MTMPEnrollmentFromDate_NEXT > bm.MTMPEnrollmentFromDate then '02' else bm.OptOutReasonCode end

from cteBM2 bm


