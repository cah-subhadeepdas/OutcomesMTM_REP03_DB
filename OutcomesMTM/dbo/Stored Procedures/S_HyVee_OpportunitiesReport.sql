





CREATE procedure [dbo].[S_HyVee_OpportunitiesReport]
as
begin
set nocount on;
set xact_abort on;

declare @begin date
declare @end date

/*
select dateadd(week, datediff(week, 0, getdate()), -7)
select DATEADD(DAY, 1-DATEPART(WEEKDAY, getdate()), getdate())
*/


set @begin =  dateadd(week, datediff(week, 0, getdate()), -7) 
set @end = DATEADD(DAY, 1-DATEPART(WEEKDAY, getdate()), getdate())


select ph.NCPDP_NABP
, ph.centerid
, ph.centername as [Pharmacy Name]
, cm.[Trained RPhs]
, cm.[Trained Techs]
, cm.[Total Primary CMRs] as [AvailablePrimary CMRs]
, cm.[Potential CMR Revenue Primary] as [Potential Primary CMR Revenue]
, cm.[Total Primary TIPs] as [Available Primary TIPs]
, cm.[Potential TIP Revenue Primary] as [Potiential Primary TIP Revenue]
, cm.[6 Month Claim History]
, isnull(c.ClaimCount, 0) as [CMRs Completed in last week]
, isnull(tr.[ClaimCount], 0) as [TIPs Completed in last week]
, ta.TIPSuccessfulRate as [YTD TIP NER]
, cr.percentCMRcompletion as [YTD CMR Completion Rate]
--select *
from outcomesMTM.dbo.pharmacy ph
join outcomesMTM.dbo.pharmacychain pc on pc.centerid = ph.centerid
join outcomesMTM.dbo.Chain ch on ch.chainid = pc.chainid
left join (

	select cmo.centerid
	, cmo.[Trained RPhs]
	, cmo.[Trained Techs]
	, sum(cmo.[Total Primary CMRs]) as [Total Primary CMRs]
	, sum(cmo.[Potential CMR Revenue Primary]) as [Potential CMR Revenue Primary]
	, sum(cmo.[TotalPrimaryTIPs]) as [Total Primary TIPs]
	, sum(cmo.[PotentialTIPRevenuePrimary]) as [Potential TIP Revenue Primary]
	, cmo.[6 Month Claim History]
	--select *
	from outcomesMTM.dbo.vw_clientMtmOpportunitiesReport cmo
	where 1=1
	group by cmo.centerid
	, cmo.[Trained RPhs]
	, cmo.[Trained Techs]
	, cmo.[6 Month Claim History]

) cm on cm.centerid = ph.centerid
left join (

	select c.centerID, count(*) as [ClaimCount]
	from outcomesMTM.dbo.claim c
	where 1=1
	and c.reasonTypeID = 11
	and c.actionTypeID = 1
	and c.resultTypeID in (5, 6)
	and c.statusID in (2,6)
	and cast(c.mtmserviceDT as date) between @begin and @end
	group by c.centerID

) c on c.centerID = ph.centerID
left join (

	select c.centerID, count(*) as [ClaimCount]
	from outcomesMTM.dbo.claim c
	where 1=1
	and c.tipDetailID is not null
	and c.resultTypeID not in (12, 18, 13, 16)
	and c.statusID in (2,6)
	and cast(c.mtmserviceDT as date) between @begin and @end
	group by c.centerID

)  tr on tr.centerid = ph.centerid
left join (

		select centerID
		, centerName						
		, count(distinct u.PatientID) as CMROpportunity
		, sum(u.CMROffered) as CMROffered				
		, sum(u.CMRCompleted) as completedCMRs
		, case when count(distinct u.PatientID) = 0 then 0 else cast((cast(sum(u.CMROffered) as decimal))/(cast(count(distinct u.PatientID) as decimal)) as decimal(5,2)) end as percentCMRoffered
		, case when count(distinct u.PatientID) = 0 then 0 else cast((cast(sum(u.CMRCompleted) as decimal))/(cast(count(distinct u.PatientID) as decimal)) as decimal(5,2)) end as percentCMRcompletion
		, case when count(distinct u.PatientID) = 0 or sum(u.CMROffered) = 0 then 0 else (cast((cast(sum(u.CMRCompleted) as decimal))/(cast(sum(u.CMROffered) as decimal)) as decimal(5,2)) *	cast((cast(sum(u.CMROffered) as decimal))/(cast(count(distinct u.PatientID) as decimal)) as decimal(5,2))) end as [CMRNetEffectiveRate]	
		from (
			select row_number() over (partition by rp.patientID, rp.centerID order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
			, rp.PatientID
			, rp.PolicyID			
			, ph.centerName
			, ph.ncpdp_nabp				
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
			, case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6, 12) AND rp.centerID = rp.claimcenterID  THEN 1 ELSE 0 END as CMROffered
			, case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END as CMRCompleted
			, case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.statusID in (2, 6) and rp.resultTypeID = 12 AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 end as PatientRefused
			, case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.statusID in (2, 6) and rp.resultTypeID = 18 AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 end as UnableToReachPatient
			, case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.statusID in (2, 6) and rp.resultTypeID = 5 AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 end as CMRWithDrugProblems
			, case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.statusID in (2, 6) and rp.resultTypeID = 6 AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 end as CMRWithoutDrugProblems
			, case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.cmrDeliveryTypeID = 1 AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 end as CMRFace2Face
			, case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.cmrDeliveryTypeID = 2 AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 end as CMRPhone
			, case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.cmrDeliveryTypeID = 3 AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 end as CMRTelehealth
			, case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.centerID <> rp.claimcenterID THEN 1 ELSE 0 END as CMRMissed
			, case when rp.mtmServiceDT not between '20160101' and cast(getdate() as date) AND rp.outcomesTermDate between '20160101' and cast(getdate() as date) AND rp.centerID <> rp.claimcenterID THEN 1 ELSE 0 END as Termed
			, case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.statusID = 5 AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END as CMRRejected
			, case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.statusID = 2 AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END as CMRPendingApproval
			, case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.statusID = 6 and rp.paid = 0 AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END as CMRApprovedPendingPayment
			, case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.statusID = 6 and rp.paid = 1 AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END as CMRApprovedPaid
			, case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.Language = 'EN' AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END EnglishSPT
			, case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.Language = 'SP' AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END SpanishSPT
			, case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.centerID = rp.claimcenterID THEN cast(rp.postHospitalDischarge as int) ELSE 0 END as postHospitalDischarge
			--select *
			from outcomesmtm.dbo.vw_CMRActivityReport rp
			join outcomesmtm.dbo.patientDim pd on pd.patientKey = rp.patientKey
			join outcomesmtm.dbo.policy p on p.policyID = rp.policyID
			left join outcomesmtm.dbo.pharmacy ph on ph.centerID = rp.centerID
			left join outcomesmtm.dbo.chain c on c.chainID = rp.chainID			
			where 1=1 
			and ((year(cast(rp.activeasof as date)) = year(getdate())) 
                             or 
                              (year(cast(rp.activethru as date)) = year(getdate())))
			and (rp.primaryPharmacy = 1 or (case when rp.mtmServiceDT between '20160101' and cast(getdate() as date) AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6, 12, 18) AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END = 1))
			AND ((rp.activethru IS NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > '20160101' THEN rp.activeasof ELSE '20160101' END, cast(getdate() as date)) >= 30)
			OR
			(rp.activethru IS NOT NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > '20160101' THEN rp.activeasof ELSE '20160101' END, CASE WHEN rp.activethru > cast(getdate() as date) THEN cast(getdate() as date) ELSE rp.activethru END) >= 30))

		) u
		where 1 = 1
		and u.rank = 1
		group by centerID, centerName						


) cr on cr.centerid = ph.centerID
left join (

	select ta.centerid
	, cast(sum(ta.[TIP Opportunities]) as decimal) as [TIP Opportunities]
	, cast(sum(ta.[Completed TIPs]) as decimal) as [Completed TIPs]
	, isnull(cast((cast(sum(ta.[Completed TIPs]) as decimal)/nullif(cast(sum(ta.[TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0) as TIPCompletionRate
	, cast(sum(ta.[Successful TIPs]) as decimal) as [Successful TIPs]
	, isnull(cast((cast(sum(ta.[Successful TIPs]) as decimal)/nullif(cast(sum(ta.[TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0) as TIPSuccessfulRate
	, isnull(cast((cast(sum(ta.[Successful TIPs]) as decimal)/nullif(cast(sum(ta.[TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0) as NetEffectiveRate
	-------
	, cast(sum(ta.[Cost TIPs Opportunity]) as decimal) as [Cost TIPs Opportunity]
	, cast(sum(ta.[Cost Completed TIPs]) as decimal) as [Cost Completed TIPs]
	, isnull(cast((cast(sum(ta.[Cost Completed TIPs]) as decimal)/nullif(cast(sum(ta.[Cost TIPs Opportunity]) as decimal), 0)) as decimal (5,2)), 0) as CostTIPCompletionRate
	, cast(sum(ta.[Cost Successful TIPs]) as decimal) as [Cost Successful TIPs]
	, isnull(cast((cast(sum(ta.[Cost Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Cost Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as CostTIPSuccessfulRate
	, isnull(cast((cast(sum(ta.[Cost Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Cost TIPs Opportunity]) as decimal), 0)) as decimal (5,2)), 0) as CostNetEffectiveRate
	-------
	, cast(sum(ta.[Star TIPs Opportunity]) as decimal) as [Star TIPs Opportunity]
	, cast(sum(ta.[Star Completed TIPs]) as decimal) as [Star Completed TIPs]
	, isnull(cast((cast(sum(ta.[Star Completed TIPs]) as decimal)/nullif(cast(sum(ta.[Star TIPs Opportunity]) as decimal), 0)) as decimal (5,2)), 0) as StarTIPCompletionRate
	, cast(sum(ta.[Star Successful TIPs]) as decimal) as [Star Successful TIPs]
	, isnull(cast((cast(sum(ta.[Star Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Star Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as StarTIPSuccessfulRate
	, isnull(cast((cast(sum(ta.[Star Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Star TIPs Opportunity]) as decimal), 0)) as decimal (5,2)), 0) as StarNetEffectiveRate
	--------
	, cast(sum(ta.[Quality TIPs Opportunity]) as decimal) as [Quality TIPs Opportunity]
	, cast(sum(ta.[Quality Completed TIPs]) as decimal) as [Quality Completed TIPs]
	, isnull(cast((cast(sum(ta.[Quality Completed TIPs]) as decimal)/nullif(cast(sum(ta.[Quality TIPs Opportunity]) as decimal), 0)) as decimal (5,2)), 0) as QualityTIPCompletionRate
	, cast(sum(ta.[Quality Successful TIPs]) as decimal) as [Quality Successful TIPs]
	, isnull(cast((cast(sum(ta.[Quality Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Quality Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as QualityTIPSuccessfulRate
	, isnull(cast((cast(sum(ta.[Quality Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Quality TIPs Opportunity]) as decimal), 0)) as decimal (5,2)), 0) as QualityNetEffectiveRate
	from (	
		select row_number() over (partition by tacr.tipresultstatusID order by tacr.[Completed TIPs] desc, tacr.[Unfinished TIPs] desc, tacr.[Review/resubmit Tips] desc, tacr.[Rejected Tips] desc, tacr.[currently active] desc, tacr.[withdrawn] desc, tacr.tipresultstatuscenterID desc) as [Rank] 
		, tacr.centerid
		, tacr.[TIP Opportunities]
		, CASE WHEN tacr.activethru > getdate() THEN 0 ELSE tacr.[Completed TIPs] END AS [Completed TIPs]
		, CASE WHEN tacr.activethru > getdate() THEN 0 ELSE tacr.[Successful TIPs] END AS [Successful TIPs]
		, case when tacr.tiptype = 'COST' then 1 else 0 end as [Cost TIPs Opportunity]
		, case when tacr.tiptype = 'COST' and tacr.activethru <= getdate() then tacr.[Completed TIPs] else 0 end as [Cost Completed TIPs]
		, case when tacr.tiptype = 'COST' and tacr.activethru <= getdate() then tacr.[Successful TIPs] else 0 end as [Cost Successful TIPs]
		, case when tacr.tiptype = 'STAR' then 1 else 0 end as [Star TIPs Opportunity]
		, case when tacr.tiptype = 'STAR' and tacr.activethru <= getdate() then tacr.[Completed TIPs] else 0 end as [Star Completed TIPs]
		, case when tacr.tiptype = 'STAR' and tacr.activethru <= getdate() then tacr.[Successful TIPs] else 0 end as [Star Successful TIPs]
		, case when tacr.tiptype = 'QUALITY' then 1 else 0 end as [Quality TIPs Opportunity]
		, case when tacr.tiptype = 'QUALITY' and tacr.activethru <= getdate() then tacr.[Completed TIPs] else 0 end as [Quality Completed TIPs]
		, case when tacr.tiptype = 'QUALITY' and tacr.activethru <= getdate() then tacr.[Successful TIPs] else 0 end as [Quality Successful TIPs]
		from outcomesMTM.dbo.tipActivityCenterReport tacr
		where 1=1
		--and tacr.centerid = 19572
		and (tacr.primaryPharmacy = 1)-- or tacr.[Completed TIPs] = 1)
		and ((year(cast(tacr.activeasof as date)) = year(getdate())) 
                             or 
                              (year(cast(tacr.activethru as date)) = year(getdate())))
		AND ((tacr.activethru <= getdate() AND (tacr.[completed tips] = 1 or tacr.[unfinished tips] = 1 or tacr.[review/resubmit tips] = 1 or tacr.[rejected tips] = 1)) 
			OR datediff(day, case when tacr.activeasof > '20160101' then tacr.activeasof else '20160101' end, case when tacr.activethru > getdate() then getdate() else tacr.activethru end) > 30)
	) ta
	where 1=1
	and ta.Rank = 1
	group by ta.centerID

) ta on ta.centerid = ph.centerID
where 1=1
and ph.active = 1
and ch.chaincode = '097'
order by ph.NCPDP_NABP




end

