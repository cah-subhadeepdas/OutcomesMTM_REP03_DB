




CREATE    VIEW [cms].[vw_CMS__bak_20190213] 
AS


with bm AS
(

		SELECT
			b.[BeneficiaryID], 
			b.[ClientID], 
			b.[ContractYear], 
			b.[HICN], 
			b.[First_Name], 
			b.MI,
			b.[Last_Name], 
			b.[dob], 
			b.[snapshotID], 
			b.[ActiveFromDT], 
			b.[ActiveThruDT], 
			b.[isCurrent], 
			mtmp.[MTMPEnrollmentID], 
			mtmp.[PatientID_All], 
			mtmp.[PatientID], 
			mtmp.[ContractNumber], 
			mtmp.[MTMPTargetingDate],
			mtmp.[MTMPEnrollmentFromDate],
			mtmp.[MTMPEnrollmentThruDate],
			mtmp.OptOutReasonCode,
			mtmp.OptOutDate
			,MTMPEnrollmentFromDate_NEXT = lead(mtmp.MTMPEnrollmentFromDate) over (partition by mtmp.SnapshotID, mtmp.PatientID order by mtmp.MTMPEnrollmentFromDate asc, mtmp.MTMPEnrollmentThruDate asc, mtmp.MTMPEnrollmentID asc)
			,Rank_Contract = ROW_NUMBER() over (partition by b.BeneficiaryID, mtmp.ContractYear, mtmp.ContractNumber order by mtmp.MTMPEnrollmentFromDate, mtmp.MTMPEnrollmentID asc)
			,Rank_Contract_Desc = ROW_NUMBER() over (partition by b.BeneficiaryID, mtmp.ContractYear, mtmp.ContractNumber order by mtmp.MTMPEnrollmentFromDate, mtmp.MTMPEnrollmentID desc)
		FROM OutcomesMTM.cms.CMS_Beneficiary_History b
		Join OutcomesMTM.[cms].[CMS_BeneficiaryPatient_History] bp 
			on bp.BeneficiaryID = b.BeneficiaryID
			and b.SnapshotID = bp.SnapshotID    
		Join [OutcomesMTM].[cms].[CMS_MTMPEnrollment_History] mtmp
			on mtmp.PatientID = bp.PatientID       
			and mtmp.SnapshotID=bp.SnapshotID
		join (
			select s.SnapshotID, s.ClientID, s.ContractYear
			from cms.CMS_SnapshotTracker s
			where 1=1
			and s.DataSetTypeID = 2
			and s.ActiveThruDT > getdate()
		) s
			on s.ClientID = b.ClientID
			and s.ContractYear = b.ContractYear
			and s.SnapshotID = b.SnapshotID										   
		Where 1=1
		and mtmp.MTMPEnrollmentThruDate >= mtmp.CYFromDate
		and mtmp.MTMPENrollmentFromDate <= mtmp.CYThruDate
		and mtmp.MTMPEnrollmentThruDate >= mtmp.MTMPEnrollmentFromDate
)

	SELECT
		bm.[BeneficiaryID]
		,bm.[ClientID]
		,bm.[ContractYear]
		,bm.[HICN]
		,bm.[First_Name]
		,bm.MI
		,bm.[Last_Name]
		,bm.[dob]
		,bm.[snapshotID]
		,bm.[ActiveFromDT]
		,bm.[ActiveThruDT]
		,bm.[isCurrent]
		,bm.[MTMPEnrollmentID]
		,bm.[PatientID_All]
		,bm.[PatientID]
		,bm.[ContractNumber]
		,MTMPTargetingDate = coalesce(bm.MTMPTargetingDate,bm2.MTMPTargetingDate)  --bm.[MTMPTargetingDate]
		,bm.[MTMPEnrollmentFromDate]
		--bm.[MTMPEnrollmentThruDate]
		--bm.OptOutReasonCode
		--bm.OptOutDate
		,MTMPEnrollmentThruDate = case when isnull(bm2.OptOutReasonCode,'') in ('02','') and bm2.MTMPEnrollmentFromDate_NEXT < bm2.MTMPEnrollmentThruDate and bm2.MTMPEnrollmentFromDate_NEXT > bm2.MTMPEnrollmentFromDate then dateadd(day,-1,bm2.MTMPEnrollmentFromDate_NEXT) else bm2.[MTMPEnrollmentThruDate] end
		,OptOutDate = case when isnull(bm2.OptOutReasonCode,'') in ('02','') and bm2.MTMPEnrollmentFromDate_NEXT < bm2.MTMPEnrollmentThruDate and bm2.MTMPEnrollmentFromDate_NEXT > bm2.MTMPEnrollmentFromDate then dateadd(day,-1,bm2.MTMPEnrollmentFromDate_NEXT) else bm2.OptOutDate end
		,OptOutReasonCode = case when isnull(bm2.OptOutReasonCode,'') in ('02','') and bm2.MTMPEnrollmentFromDate_NEXT < bm2.MTMPEnrollmentThruDate and bm2.MTMPEnrollmentFromDate_NEXT > bm2.MTMPEnrollmentFromDate then '02' else bm2.OptOutReasonCode end

	from bm bm
	join bm bm2
		on bm2.BeneficiaryID = bm.BeneficiaryID
		and bm2.ContractYear = bm.ContractYear
		and bm2.ContractNumber = bm.ContractNumber
		and bm2.Rank_Contract_Desc = 1
	where 1=1
	and bm.Rank_Contract = 1


