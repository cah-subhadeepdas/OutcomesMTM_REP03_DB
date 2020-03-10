

CREATE view [dbo].[vw_CMRActivityReport_TEST]
as 

with cms as (
	select policyid 
	from (
		select row_Number() over (partition by policyid order by active desc, activeasof desc) as cmsrank 
		, policyid 
		from identificationConfig 
		where 1=1 
		and identificationTypeID = 1
	) T
	where 1=1 
	and cmsrank = 1
)
select t.patientKey 
, t.patientMTMcenterKey
, c.claimID
, t.PatientID
, coalesce(c.policyid, t.PolicyID) as policyid  
, t.CMSContractNumber
, t.centerid
, pc.chainid
, t.primaryPharmacy
, t.CMREligible
, c.centerID as claimcenterID
, pc2.chainID as claimChainID 
, c.mtmServiceDT
, c.statusID
, c.resultTypeID
, c.cmrDeliveryTypeID
, c.postHospitalDischarge
, c.paid
, c.Language
, c.changeDate as claimChangeDate 
, case when cms.policyid is not null then 1 else 0 end as CMSpolicy  
, t.activeAsOF
, t.activeThru
from CMRActivityOpportunity t 
left join pharmacychain pc on pc.centerid = t.centerid 
left join CMRActivityClaim c on c.patientid = t.patientid 
							and c.mtmservicedt >= cast(t.activeasof as Date) 
							and c.mtmservicedt < cast(isnull(t.activethru,'99991231') as Date)
							and c.statusID <> 3
left join pharmacychain pc2 on pc2.centerid = c.centerid 
left join cms on cms.policyid = t.policyid 



