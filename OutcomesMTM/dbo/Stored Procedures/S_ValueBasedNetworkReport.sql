






CREATE PROCEDURE [dbo].[S_ValueBasedNetworkReport]
(
@BEGIN date
,@END date
)

AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;

/*
select dateadd(wk,datediff(wk,6,getdate()),6) --last sunday

select dateadd(qq,datediff(qq,0,getdate())-1,0) -- first day of last quarter

select dateadd(dd,-1,dateadd(qq,datediff(qq,0,getdate()),0) ) -- last day of last quarter

*/


----//For Test Purpose
--DECLARE @BEGIN date
--DECLARE @END date


--SET @BEGIN =  dateadd(qq,datediff(qq,0,getdate()),0)		
--SET @END =  dateadd(wk,datediff(wk,6,getdate()),6)


if object_id('tempdb..#base') is not null
drop table #base

select distinct ph.NCPDP_NABP
 , np.[Name_(Doing_Business_As_Name)] 
 , relationship_id = pr.Relationship_ID
 , Name
 , Physical_Location_State_Code
, isnull(cm.CMROpportunity,0) as [CMROpportunity]
, isnull(cm.CMROffered,0) as [CMROffered]
, isnull(cm.completedCMRs,0) as [completedCMRs]
, isnull(cm.percentCMRcompletion,0) as [percentCMRcompletion]
, isnull(cm.missedcmrs,0) as [#Missed]
, isnull(cm2.remainingprimary,0) as [remainingprimary]
, isnull(cm3.remainingnonprimary,0) as [remainingnonprimary]
, (isnull(cm.completedCMRs,0)+isnull(cm2.remainingprimary,0) + isnull(cm3.remainingnonprimary,0))/(isnull(cm.CMROpportunity,0)+isnull(cm3.remainingnonprimary,0)) as [percentage]
into #base
from outcomesMTM.dbo.pharmacy ph
join OutcomesMTM.dbo.NCPDP_Provider np on np.NCPDP_Provider_ID = ph.NCPDP_NABP
left join OutcomesMTM.dbo.NCPDP_ProviderRelationship AS pr on np.NCPDP_Provider_ID=pr.NCPDP_Provider_ID
															and pr.active = 1
															and pr.is_primary = 'Y'
left join outcomesmtm.dbo.NCPDP_RelationshipDemographic rd on rd.Relationship_id = pr.relationship_id
left join (
	
	select centerID
	, centerName						
	, count(distinct u.PatientID) as CMROpportunity
	, sum(u.CMROffered) as CMROffered				
	, sum(u.CMRCompleted) as completedCMRs
	, sum(u.cmrmissed) as missedCMRs
	, case when sum(u.CMROffered) = 0 then 0 else cast((cast(sum(u.CMRCompleted) as decimal))/(cast(count(distinct u.Patientid) as decimal)) as decimal(5,4)) end as percentCMRcompletion
	from (
		select row_number() over (partition by rp.patientID, rp.centerID order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
		, rp.PatientID
        , rp.PolicyID
        , rp.centerid
		, rp.claimcenterid 
		, ph.centername
        , rp.chainid
        , rp.primaryPharmacy
        , rp.CMREligible
        , rp.mtmServiceDT
        , rp.resultTypeID
        , rp.statusID
        , rp.activeAsOF
        , rp.activeThru
        , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) AND rp.centerid = rp.claimcenterID  THEN 1 ELSE 0 END as CMROffered
        , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END as CMRCompleted
        , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.centerID <> rp.claimcenterID THEN 1 ELSE 0 END as CMRMissed
         from (select t.patientKey 
				, t.patientMTMcenterKey
				, c.claimID
				, t.PatientID
				, t.PolicyID
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
				, t.outcomesTermDate
				, t.activeAsOF
				, t.activeThru
				from CMRActivityOpportunity t 
				left join pharmacychain pc on pc.centerid = t.centerid 
				left join CMRActivityClaim c on c.patientid = t.patientid 
											and mtmServiceDT between @BEGIN and @END
											and c.statusID in (2,6)
				left join pharmacychain pc2 on pc2.centerid = c.centerid 
				where t.policyid in (602,642,650,652,659)
					) rp
         join patientDim pd on pd.patientKey = rp.patientKey
         join policy p on p.policyID = rp.policyID
         join pharmacy ph on ph.centerID = rp.centerID
         left join chain c on c.chainID = rp.chainID
         where 1=1
		  and rp.policyid in(602,642,650,652,659)
		  and (rp.primaryPharmacy = 1 or (rp.primaryPharmacy = 0 and case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END = 1))  
             --30 day include
             AND (
                     (rp.activethru IS NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @BEGIN THEN rp.activeasof ELSE @BEGIN END, @END) >= 30)
                     OR
                     (rp.activethru IS NOT NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @BEGIN THEN rp.activeasof ELSE @BEGIN END, CASE WHEN rp.activethru > @END THEN @END ELSE rp.activethru END) >= 30)
					 OR
					(rp.activethru between @BEGIN and @END AND DATEDIFF(DAY, rp.activeasof, rp.activethru) >= 30)
                     OR
                     (rp.mtmServiceDT BETWEEN @BEGIN AND @END AND rp.statusID in (2, 6)and rp.resultTypeID in (5, 6))
                     AND
                     (rp.claimcenterID = rp.centerid)
                 )

	) u
	where 1 = 1
	and u.rank = 1
	group by centerID, centerName		


) cm on cm.centerid = ph.centerID
left join (
			select centerid
				, remainingprimary =count(u2.patientid)
			from (
					select   row_number() over (partition by rp.patientID, rp.centerID order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
							, rp.patientid
							, rp.centerid
					  from vw_CMRActivityReport rp
					join patientDim pd on pd.patientKey = rp.patientKey
					join policy p on p.policyID = rp.policyID
					join pharmacy ph on ph.centerID = rp.centerID
					left join chain c on c.chainID = rp.chainID
					where 1=1
					and rp.policyid in(602,642,650,652,659)
					AND isNull(rp.activethru, '99991231') >= @BEGIN
					AND rp.activeasof <= @END
					and rp.primaryPharmacy = 1) u2
			where 1=1 
			and u2.rank=1
			group by centerID
			)cm2  on cm2.centerid = cm.centerID
left join (
			select centerid
				, remainingnonprimary =count(u3.patientid)
			from (
					select   row_number() over (partition by rp.patientID, rp.centerID order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
							, rp.patientid
							, rp.centerid
					  from vw_CMRActivityReport rp
					join patientDim pd on pd.patientKey = rp.patientKey
					join policy p on p.policyID = rp.policyID
					join pharmacy ph on ph.centerID = rp.centerID
					left join chain c on c.chainID = rp.chainID
					where 1=1
					and rp.policyid in(602,642,650,652,659)
					AND isNull(rp.activethru, '99991231') >= @BEGIN
					AND rp.activeasof <= @END
					and rp.primaryPharmacy = 0) u3
			where 1=1 
			and u3.rank=1
			group by centerID
			)cm3 on cm3.centerid = cm.centerID
where 1=1
and np.Active = 1
and cm.cmropportunity >0



If object_id('tempdb..#paymenttier') is not null
drop table #paymenttier

select b.*
	   ,[payment tier] = case when b.[percentCMRcompletion]  < 0.6499 then 50 
							 when b.[percentCMRcompletion]  between 0.65 and 0.7499 then 60
							 when b.[percentCMRcompletion]  between 0.75 and 0.8999 then 75
							 else 80 end
	   ,[#completedCMRs to next payment tier] = case when b.[percentCMRcompletion]  < 0.6499 then ceiling(0.65*[CMROpportunity] - [completedCMRs])
							 when b.[percentCMRcompletion]  between 0.65 and 0.7499 then ceiling(0.75*[CMROpportunity] - [completedCMRs])
							 when b.[percentCMRcompletion] between 0.75 and 0.8999 then ceiling(0.9*[CMROpportunity] - [completedCMRs])
							 else null end

		,[new payment tier] = case when b.[percentage]  < 0.6499 then 50 
							 when b.[percentage]  between 0.65 and 0.7499 then 60
							 when b.[percentage]  between 0.75 and 0.8999 then 75
							 else 80 end
into #paymenttier
from #base b

select    NCPDP_NABP as [NCPDP_Provider_ID]
		, [Name_(Doing_Business_As_Name)] as [Name]
		, relationship_id
		, Name as [Relationship Name]
		, Physical_Location_State_Code as [Pharmacy State]
		, CMROpportunity
		, CMROffered
		, completedCMRs
		, cast(100*cast(percentCMRcompletion as decimal(5,2)) as varchar(10)) + '%' as CMRCompletionRate
		, [#Missed]
		, [payment tier]
		, isnull(cast([#completedCMRs to next payment tier] as varchar(10)),'N/A') as [completedCMRs to next payment tier]
		, [payment tier]*[completedcmrs] - [completedcmrs]*50 as [Bonus earned on current performance]
		, [payment tier]*[completedcmrs] as [Total revenue based on current performance]
		, [new payment tier] *(isnull(completedCMRs,0)+isnull(remainingprimary,0) + isnull(remainingnonprimary,0)) - ([payment tier]*[completedcmrs]) as [Potential additional revenue available]
		, remainingprimary as [Remaining Primary CMRs]
		, remainingnonprimary as [Remaining Non-Primary CMRs]
from #paymenttier pmt
order by NCPDP_NABP

END





