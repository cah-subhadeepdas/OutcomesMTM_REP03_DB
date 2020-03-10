




CREATE proc [dbo].[S_APNS_ReportCard] 
as 
begin 



DECLARE @BEGIN VARCHAR(10)
DECLARE @END VARCHAR(10)


/*
select cast(year(getdate()) as varchar(4)) + '0101'
,cast(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as date)

*/

SET @BEGIN =  cast(year(getdate()) as varchar(4)) + '0101'		
SET @END =  cast(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as date)	 		--end of last month


---------------------------------------------------------------------------------------------------------
--------------------------CHAINS
---------------------------------------------------------------------------------------------------------
--Below temp table was provided by Network Performance
if(object_ID('tempdb..#chainRollUp') is not null)
begin
drop table #chainRollUp
end
create table #chainRollUp (
ID int identity (1,1) primary key
, Preferred int
, [Organization Category Size] int
, [Organization Name] varchar(100)
, RelationshipID varchar(50))

insert into #chainrollup select   0,     4,		'American Pharmacy Network',            '841'


if(object_ID('tempdb..#org') is not null)
begin
drop table #org
end
create table #org (
orgID int identity (1,1) primary key
, [Organization Name] varchar(100)
, [Organization Category Size] int
)
insert into #org ([Organization Name], [Organization Category Size])
select distinct [organization Name]
, [Organization Category Size] 
from #chainrollup
where 1=1 


if(object_ID('tempdb..#Org2Center') is not null)
begin
drop table #Org2Center
end
create table #org2Center (
orgID int 
, centerid int
, NCPDP_NABP varchar (50) 
primary key (orgid, centerid) 
)
;with ch as (

       select cr.[Organization Name]
          , p.centerid
          , p.NCPDP_NABP 
       from #chainRollUp cr
       join outcomesMTM.dbo.chain c on c.chainCode = cr.RelationshipID 
       join outcomesMTM.dbo.pharmacychain pc on pc.chainid = c.chainid
       join outcomesMTM.dbo.pharmacy p on p.centerid = pc.centerid
       where 1=1

)
insert into #Org2Center (orgid, centerid, NCPDP_NABP) 
select o.orgid, t.centerid, t.NCPDP_NABP  
from (
		select ch.[Organization Name], ch.centerid, ch.NCPDP_NABP
		from ch
		where 1=1
) t
join #org o on o.[Organization Name] = t.[Organization Name]
where 1=1

-----------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
/*
Pulling the relationship of each center
*/

select row_number() over (partition by ph.centerID order by case when pr.Relationship_type = '02' then '99' else pr.Relationship_type end asc) as [Rank]
, ph.centerid
, pr.Relationship_ID
, pr.Relationship_ID_Name
into #Relationship
from outcomesmtm.dbo.providerRelationshipView pr
join outcomesmtm.dbo.pharmacy ph on ph.NCPDP_NABP = pr.mtmCenterNumber
where 1=1
and pr.Relationship_Type in ('01', '05', '02')

----------------------------------------------------------------------------------------------------------------------------------------
/*
Pulling TIP opportunity 
*/

select ta.centerid
, cast(sum(ta.[TIP Opportunities]) as decimal) as [TIP Opportunities]
, cast(sum(ta.[Completed TIPs]) as decimal) as [Completed TIPs]
, cast(sum(ta.[Successful TIPs]) as decimal) as [Successful TIPs]
, isnull(cast((cast(sum(ta.[Successful TIPs]) as decimal)/nullif(cast(sum(ta.[TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0) as NetEffectiveRate
-------
, cast(sum(ta.[Cost TIPs Opportunity]) as decimal) as [Cost TIPs Opportunity]
, cast(sum(ta.[Cost Completed TIPs]) as decimal) as [Cost Completed TIPs]
, cast(sum(ta.[Cost Successful TIPs]) as decimal) as [Cost Successful TIPs]
, isnull(cast((cast(sum(ta.[Cost Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Cost TIPs Opportunity]) as decimal), 0)) as decimal (5,2)), 0) as CostNetEffectiveRate
-------
, cast(sum(ta.[Star TIPs Opportunity]) as decimal) as [Star TIPs Opportunity]
, cast(sum(ta.[Star Completed TIPs]) as decimal) as [Star Completed TIPs]
, cast(sum(ta.[Star Successful TIPs]) as decimal) as [Star Successful TIPs]
, isnull(cast((cast(sum(ta.[Star Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Star TIPs Opportunity]) as decimal), 0)) as decimal (5,2)), 0) as StarNetEffectiveRate
--------
, cast(sum(ta.[Quality TIPs Opportunity]) as decimal) as [Quality TIPs Opportunity]
, cast(sum(ta.[Quality Completed TIPs]) as decimal) as [Quality Completed TIPs]
, cast(sum(ta.[Quality Successful TIPs]) as decimal) as [Quality Successful TIPs]
, isnull(cast((cast(sum(ta.[Quality Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Quality TIPs Opportunity]) as decimal), 0)) as decimal (5,2)), 0) as QualityNetEffectiveRate
into #TIP
from (	
	select row_number() over (partition by tacr.tipresultstatusID order by tacr.[Completed TIPs] desc, tacr.[Unfinished TIPs] desc, tacr.[Review/resubmit Tips] desc, tacr.[Rejected Tips] desc, tacr.[currently active] desc, tacr.[withdrawn] desc, tacr.tipresultstatuscenterID desc) as [Rank] 
	, tacr.centerid
	, tacr.[TIP Opportunities]
	, CASE WHEN tacr.activethru > @END THEN 0 ELSE tacr.[Completed TIPs] END AS [Completed TIPs]
	, CASE WHEN tacr.activethru > @END THEN 0 ELSE tacr.[Successful TIPs] END AS [Successful TIPs]
	, case when tacr.tiptype = 'COST' then 1 else 0 end as [Cost TIPs Opportunity]
	, case when tacr.tiptype = 'COST' and tacr.activethru <= @END then tacr.[Completed TIPs] else 0 end as [Cost Completed TIPs]
	, case when tacr.tiptype = 'COST' and tacr.activethru <= @END then tacr.[Successful TIPs] else 0 end as [Cost Successful TIPs]
	, case when tacr.tiptype = 'STAR' then 1 else 0 end as [Star TIPs Opportunity]
	, case when tacr.tiptype = 'STAR' and tacr.activethru <= @END then tacr.[Completed TIPs] else 0 end as [Star Completed TIPs]
	, case when tacr.tiptype = 'STAR' and tacr.activethru <= @END then tacr.[Successful TIPs] else 0 end as [Star Successful TIPs]
	, case when tacr.tiptype = 'QUALITY' then 1 else 0 end as [Quality TIPs Opportunity]
	, case when tacr.tiptype = 'QUALITY' and tacr.activethru <= @END then tacr.[Completed TIPs] else 0 end as [Quality Completed TIPs]
	, case when tacr.tiptype = 'QUALITY' and tacr.activethru <= @END then tacr.[Successful TIPs] else 0 end as [Quality Successful TIPs]
	from outcomesMTM.dbo.tipActivityCenterReport tacr
	join #Org2Center oc on oc.centerid = tacr.centerID
	where 1=1
	and tacr.policyid not in (574, 575, 298)
	and (tacr.primaryPharmacy = 1 or tacr.[Completed TIPs] = 1)
	and tacr.activethru >= @BEGIN
	and tacr.activeasof <= @END
	AND ((tacr.activethru <= @end AND (tacr.[completed tips] = 1 or tacr.[unfinished tips] = 1 or tacr.[review/resubmit tips] = 1 or tacr.[rejected tips] = 1)) 
		OR datediff(day, case when tacr.activeasof > @begin then tacr.activeasof else @begin end, case when tacr.activethru > @end then @end else tacr.activethru end) > 30)
) ta
where 1=1
and ta.Rank = 1
group by ta.centerID

------------------------------------------------------------------------------------------------------------------------------------------
/*
Pulling Claims
*/

select v.[MTM CenterID]
, sum(v.claimSubmitted) as claimSubmitted
into #claims
from (
	select c.claimID
	, c.[MTM CenterID]
	, 1 as claimSubmitted
	from outcomesMTM.dbo.ClaimActivityReport c
	where 1=1
	and c.mtmServiceDT between @BEGIN and @END
	and c.statusID not in (3,5)
	and c.policyID not in (574 ,575 ,298)
) v
where 1=1
group by v.[MTM CenterID]

---------------------------------------------------------------------------------------------------------------------------------------------

/*
Pulling number of eligibilty members from each center
*/

select pm.centerid, count(distinct pt.patientID) as [EligiblePatient]
into #Eligibility
from outcomesMTM.dbo.patientMTMCenterDim pm
join (

	select distinct pt.patientID
	--select count(distinct pt.patientID)
	from outcomesMTM.dbo.patientDim pt
	where 1=1
	and isnull(pt.activethru, '99991231') >= @BEGIN
	and pt.policyid not in (574 ,575 ,298)
	and pt.activeasof <= @END

) pt on pt.patientID = pm.patientid
where 1=1
and isnull(pm.activethru, '99991231') >= @BEGIN
and pm.activeasof <= @END
group by pm.centerid

----------------------------------------------------------------------------------------------------------------------------------------------

/*
Pulling CMR
*/

	select t.*
	into #CMR
	FROM (		
		select centerID
		, centerName						
		, count(distinct u.PatientID) as CMROpportunity
		, sum(u.CMROffered) as CMROffered				
		, sum(u.CMRCompleted) as completedCMRs
		, case when sum(u.CMROffered) = 0 then 0 else cast((cast(sum(u.CMRCompleted) as decimal))/(cast(sum(u.CMROffered) as decimal)) as decimal(5,2)) end as percentCMRcompletion
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
			, case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6, 12) AND rp.centerID = rp.claimcenterID  THEN 1 ELSE 0 END as CMROffered
			, case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END as CMRCompleted
			from outcomesmtm.dbo.vw_CMRActivityReport rp
			join outcomesmtm.dbo.patientDim pd on pd.patientKey = rp.patientKey
			join outcomesmtm.dbo.policy p on p.policyID = rp.policyID
			left join outcomesmtm.dbo.pharmacy ph on ph.centerID = rp.centerID
			left join outcomesmtm.dbo.chain c on c.chainID = rp.chainID			
			where 1=1
			and isNull(rp.activethru, '99991231') >= @BEGIN
			and rp.activeasof <= @END
			--and ph.NCPDP_NABP = '2369797'
			--and DATEDIFF(DAY, CASE WHEN rp.activeasof > @BEGIN THEN rp.activeasof ELSE @BEGIN END, CASE WHEN isNull(rp.activethru, @END) >= @END THEN @END ELSE rp.activethru END) >= 30 
			and (rp.primaryPharmacy = 1 or (case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6, 12, 18) AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END = 1))
			AND ((rp.activethru IS NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @begin THEN rp.activeasof ELSE @begin END, @end) >= 30)
			OR
			(rp.activethru IS NOT NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @begin THEN rp.activeasof ELSE @begin END, CASE WHEN rp.activethru > @end THEN @end ELSE rp.activethru END) >= 30))

		) u
		where 1 = 1
		and u.rank = 1
		group by centerID, centerName						
	) t
	where 1=1


-----------------------------------------------------------------------------------------------------------------------------------------------

select distinct ph.NCPDP_NABP
, replace(replace(replace(ph.centername,char(9),''),char(10),''),char(13),'') as [PharmacyName]
, ph.addressState as [Pharmacy State]
-------------------------
, pr.Relationship_ID
, pr.Relationship_ID_Name
---------------------
, ISNULL(ta.[TIP Opportunities], 0) as [TIP Opportunities]
, ISNULL(ta.[Completed TIPs], 0) as [Completed TIPs]
, ISNULL(ta.[Successful TIPs], 0) as [Successful TIPs]
, ISNULL(ta.NetEffectiveRate, 0) as NetEffectiveRate
---------------
, ISNULL(ta.[Cost TIPs Opportunity], 0) as [Cost TIPs Opportunity]
, ISNULL(ta.[Cost Completed TIPs], 0) as [Cost Completed TIPs]
, ISNULL(ta.[Cost Successful TIPs], 0) as [Cost Successful TIPs]
, ISNULL(ta.CostNetEffectiveRate, 0) as CostNetEffectiveRate
----------------
, ISNULL(ta.[Star TIPs Opportunity], 0) as [Star TIPs Opportunity]
, ISNULL(ta.[Star Completed TIPs], 0) as [Star Completed TIPs]
, ISNULL(ta.[Star Successful TIPs], 0) as [Star Successful TIPs]
, ISNULL(ta.StarNetEffectiveRate, 0) as StarNetEffectiveRate
-------------------------
, ISNULL(ta.[Quality TIPs Opportunity], 0) as [Quality TIPs Opportunity]
, ISNULL(ta.[Quality Completed TIPs], 0) as [Quality Completed TIPs]
, ISNULL(ta.[Quality Successful TIPs], 0) as [Quality Successful TIPs]
, ISNULL(ta.QualityNetEffectiveRate, 0) as QualityNetEffectiveRate
-----------------------
, ISNULL(cm.CMROpportunity, 0) as CMROpportunity
, ISNULL(cm.CMROffered, 0) as CMROffered
, ISNULL(cm.completedCMRs, 0) as completedCMRs
, ISNULL(cm.percentCMRcompletion, 0) as percentCMRcompletion
---------------------------
, ISNULL(pm.EligiblePatient, 0) as EligiblePatient
, ISNULL(cl.claimSubmitted, 0) as claimSubmitted
--select count(*)
from outcomesMTM.dbo.pharmacy ph
join #Org2Center oc on oc.centerid = ph.centerID
join #org o on o.orgID = oc.orgID
left join (

	select r.[Rank]
	, r.centerid
	, r.Relationship_ID
	, r.Relationship_ID_Name
	from #Relationship r
	where 1=1

) pr on pr.centerid = ph.centerid and pr.[Rank] = 1
left join (

	select t.centerid
	, t.[TIP Opportunities]
	, t.[Completed TIPs]
	, t.[Successful TIPs]
	, t.NetEffectiveRate
	, t.[Cost TIPs Opportunity]
	, t.[Cost Completed TIPs]
	, t.[Cost Successful TIPs]
	, t.CostNetEffectiveRate
	, t.[Star TIPs Opportunity]
	, t.[Star Completed TIPs]
	, t.[Star Successful TIPs]
	, t.StarNetEffectiveRate
	, t.[Quality TIPs Opportunity]
	, t.[Quality Completed TIPs]
	, t.[Quality Successful TIPs]
	, t.QualityNetEffectiveRate
	from #TIP t
	where 1=1

) ta on ta.centerid = ph.centerID
left join (		

	select e.centerid
	, e.EligiblePatient
	from #Eligibility e
	where 1=1

) pm on pm.centerid = ph.centerid
left join (

	select c.[MTM CenterID]
	, c.claimSubmitted
	from #claims c
	where 1=1

) cl on cl.[MTM CenterID] = ph.NCPDP_NABP
left join (

	select c.centerid
	, c.CMROpportunity
	, c.CMROffered
	, c.completedCMRs
	, c.percentCMRcompletion
	from #CMR c
	where 1=1
	
) cm on cm.centerid = ph.centerID
where 1=1

end 




