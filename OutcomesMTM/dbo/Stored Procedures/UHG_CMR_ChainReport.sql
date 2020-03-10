

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UHG_CMR_ChainReport]
AS
BEGIN
SET NOCOUNT ON;

SELECT f.*
FROM (
	select row_number() OVER (ORDER BY [Chain Name]) AS [rank],
	t.*
	FROM (
				SELECT
				chainNm as [Chain Name]
				--, Relationship_ID as [Relationship ID]
				, count(distinct u.PatientID) as [## CMR Targeted Patients]
				, sum(u.CMROffered) as [## CMRs Offered by MTM Center]
				, case when count(distinct u.PatientID) = 0 then 0 else Isnull(cast((100.0 * sum(u.CMROffered))/count(distinct u.PatientID) as numeric(36,2)),0) end as [CMR Offer %]
				, sum(u.CMRCompleted) as [## Patients with Completed CMR]
				, case when sum(u.CMROffered) = 0 then 0 else Isnull(cast((100.0 * sum(u.CMRCompleted))/sum(u.CMROffered) as numeric(36,2)),0.0) end as [CMR Acceptance Rate (%)]
				, case when count(distinct u.PatientID) = 0 then 0 else Isnull(cast((100.0 * sum(u.CMRCompleted))/count(distinct u.PatientID) as numeric(36,2)),0) end as [CMR Completion Rate (%)]
				, sum(u.PatientRefused) as [## Refusals]
				, case when sum(u.CMROffered) = 0 then 0 else Isnull(cast((100.0 * sum(u.PatientRefused))/sum(u.CMROffered) as numeric(36,2)),0) end as [CMR Refusal Rate (%)]
				, sum(u.UnableToReachPatient) as [## Unable to Reach Patient]
				, case when count(distinct u.PatientID) = 0 then 0 else Isnull(cast((100.0 * sum(u.UnableToReachPatient))/count(distinct u.PatientID) as numeric(36,2)),0) end as [Unable to Reach Patient Rate (%)]
				, sum(u.CMRWithDrugProblems) as [## CMRs with DTPs identified]
				, case when sum(u.CMRCompleted) = 0 then 0 else Isnull(cast((100.0 * sum(u.CMRWithDrugProblems))/sum(u.CMRCompleted) as numeric(36,2)),0) end as [% of CMRs with DTPs identified]
				, sum(u.CMRWithoutDrugProblems) as [## CMRs with no DTPs identified]
				, case when sum(u.CMRCompleted) = 0 then 0 else Isnull(cast((100.0 * sum(u.CMRWithoutDrugProblems))/sum(u.CMRCompleted) as numeric(36,2)),0) end as [% of CMRs with no DTPs identified]
				, isNull(sum(u.CMRFace2Face),0) as [## Face-to-Face]
				, isNull(sum(u.CMRPhone),0) as [## Phone]
				, isNull(sum(u.CMRTelehealth),0) as [## Telehealth]
				, isNull(sum(u.postHospitalDischarge), 0) as [## Medication Reconciliation]
				, isNull(sum(u.CMRPendingApproval),0) as [## Pending Approval]
				, isNull(sum(u.CMRApprovedPendingPayment),0) as [## Approved & pending payment]
				, isNull(sum(u.CMRApprovedPaid),0) as [## Approved & paid]
				, isNull(sum(u.CMRRejected),0) as [## Rejected]
				, isNull(sum(u.Termed),0) as [## Termed]
				, isNull(sum(u.CMRMissed),0) as [## Missed]
				, isNull(count(distinct u.PatientID) - sum(u.cmrOffered) - sum(u.UnableToReachPatient) - sum(u.CMRRejected) - sum(u.CMRMissed) - sum(u.Termed),0) as [## Patients awaiting CMR]
			from (
			select row_number() over (partition by t.chainid, rp.patientid order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
					, rp.PatientID
					, rp.PolicyID
					, t.chainNm
				   	, t.Relationship_ID
					, rp.CMSContractNumber
					, rp.centerid
					, rp.chainid
					, rp.primaryPharmacy
					, rp.CMREligible
					, rp.mtmServiceDT
					, rp.resultTypeID
					, rp.cmrDeliveryTypeID
					, rp.statusID
					, rp.paid
					, rp.Language
					, rp.activeAsOF
					, rp.activeThru
					, case when  isNull(rp.mtmServiceDT, '99991231') not between cast(concat(year(getdate()),'0101') as date) and cast(concat(year(getdate()),'1231') as date) THEN 1 ELSE 0 END as Termed
					, case when  rp.statusID in (2, 6) and rp.resultTypeID in (5, 6, 12) AND rp.chainID = rp.claimChainID  THEN 1 ELSE 0 END as CMROffered
					, case when  rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 END as CMRCompleted
					, case when  rp.statusID in (2, 6) and rp.resultTypeID = 12 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as PatientRefused
					, case when  rp.statusID in (2, 6) and rp.resultTypeID = 18 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as UnableToReachPatient
					, case when  rp.statusID in (2, 6) and rp.resultTypeID = 5 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as CMRWithDrugProblems
					, case when  rp.statusID in (2, 6) and rp.resultTypeID = 6 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as CMRWithoutDrugProblems
					, case when  rp.cmrDeliveryTypeID = 1 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as CMRFace2Face
					, case when  rp.cmrDeliveryTypeID = 2 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as CMRPhone
					, case when  rp.cmrDeliveryTypeID = 3 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as CMRTelehealth
					, case when  rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.chainID <> rp.claimChainID THEN 1 ELSE 0 END as CMRMissed
					, case when  rp.statusID = 5 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 END as CMRRejected
					, case when  rp.statusID = 2 AND rp.chainID = rp.claimChainID AND rp.resultTypeID in (5, 6) THEN 1 ELSE 0 END as CMRPendingApproval
					, case when  rp.statusID = 6 and rp.paid = 0 AND rp.chainID = rp.claimChainID AND rp.resultTypeID in (5, 6) THEN 1 ELSE 0 END as CMRApprovedPendingPayment
					, case when  rp.statusID = 6 and rp.paid = 1 AND rp.chainID = rp.claimChainID AND rp.resultTypeID in (5, 6) THEN 1 ELSE 0 END as CMRApprovedPaid
					, case when  rp.Language = 'EN' AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 END EnglishSPT
					, case when  rp.Language = 'SP' AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 END SpanishSPT
					, case when  rp.chainID = rp.claimChainID THEN cast(rp.postHospitalDischarge as int) ELSE 0 END as postHospitalDischarge
			from vw_CMRActivityReport rp
			join patientDim pd on pd.patientKey = rp.patientKey
			join policy p on p.policyID = rp.policyID
			join pharmacy ph on ph.centerID = rp.centerID
			--left join chain c on c.chainID = rp.chainID
			--join ProviderChain pc on pc.chaincode = c.chaincode
			--join providerRelationshipView prv on prv.mtmCenterNumber = pc.NCPDP_Provider_ID
			left join ( 
              select pv.mtmCenterNumber, pv.Relationship_ID, pv.Relationship_ID_Name, pp.chainid, ch.chainnm
              from [dbo].[pharmacychain] pp
                 JOIN dbo.pharmacy ph 
                    on ph.centerid = pp.centerid
                 JOIN dbo.Chain ch 
                    on ch.chainid = pp.chainid
                 left join [dbo].[providerRelationshipView] pv 
                    on ph.NCPDP_NABP = pv.mtmCenterNumber
                   and ch.chaincode = pv.Relationship_ID
       ) t on t.mtmCenterNumber = ph.NCPDP_NABP
			where 1=1
			AND isNull(rp.activethru, '99991231') >= cast(concat(year(getdate()),'0101') as date)
			AND rp.activeasof <= cast(concat(year(getdate()),'1231') as date)
			--AND rp.mtmServiceDT between cast(concat(year(getdate()),'0101') as date) and cast(concat(year(getdate()),'1231') as date)
			--AND rp.policyid in(592,598,599,617,618,674,676,677,678,679,680,681,682,683,685,686,687,688,689,690,691,692,693,694,695,696,698,699,700,701,702,703,704,705,706,707,708,710,711,713,715,716,717,718,808)
			AND rp.policyid in(Select Distinct policyID From [AOCWPAPSQL02].[outcomes].[dbo].[ClientContractPolicyView] where ClientID = '132' AND connectActiveFlag =1)
			) u
			where 1=1
			and u.rank = 1
	group by chainNm
	--order by chainNm
	) t 
) f
where 1=1
--and f.[rank] between '2016-01-01' and '2016-12-31'
and ([Chain Name] like '%H-E-B LP%'
    or [chain name] like '%Publix%'
	or [chain name] like '%Wegman%'
	or [chain name] like '%Walgreen%'
	or [chain name] like '%Walmart%'
	or [chain name] like '%Kroger%'
	or [chain name] like '%Safeway%'
	or [chain name] like '%Hy-Vee%'
	or [chain name] like '%CVS%'
	or [chain name] like '%Stop and Shop%'
	or [Chain Name] like '%GIANT EAGLE INC%'
	)

ORDER BY f.rank

   
END

