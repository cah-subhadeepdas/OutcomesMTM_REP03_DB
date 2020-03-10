CREATE PROCEDURE [dbo].[S_HumanaMAPDTracking_PharmacyCenters]
AS
BEGIN

DECLARE @BEGIN AS DATE
DECLARE @END AS DATE

SET @BEGIN = (case when convert(varchar,getdate()+307,112)=convert(varchar,dateadd(yy,datediff(yy,0,getdate()),0),112)
then
convert(varchar,dateadd(yy,-1,dateadd(yy,datediff(yy,0,getdate()),0)),112)
else
convert(varchar,dateadd(d,datediff(d,0,DATEADD(DD,-datepart(DY,getdate())+1,getdate())),0) ,112)
end)

SET @END = GETDATE()


If OBJECT_ID('tempdb..#Region') is not null
drop table #Region
Create table #Region (
						id int identity (1,1) not null,
						state varchar(2),
						Region int 
					)
insert into #Region select 'VA','7'
insert into #Region select 'FL','11'
insert into #Region select 'LA','21'
insert into #Region select 'IA','25'
insert into #Region select 'MN','25'
insert into #Region select 'MT','25'
insert into #Region select 'NE','25'
insert into #Region select 'ND','25'
insert into #Region select 'SD','25'
insert into #Region select 'WY','25'
insert into #Region select 'AZ','28'

If OBJECT_ID('tempdb..#MAPD_CMR') is not null
Drop table #MAPD_CMR
Select DISTINCT
		r.Region
		, CMR1.centerid as OpportunityCMR
		, CMR.centerid as CompletedCMR
		, TipOpp.centerid as OpportunityTIP
		, TipComp.centerID AS CompletedTIP
		
into #MAPD_CMR
From outcomesMTM.dbo.pharmacy ph
	join outcomesmtm.dbo.pharmacychain pc on pc.centerid = ph.centerid
	join outcomesmtm.dbo.chain ch on ch.chainid = pc.chainid
	Join #Region r on r.state = ph.AddressState

--=============[CMR Opportunity]
Left join( 
SELECT distinct centerid
	,count(distinct u.PatientID) as [CMR Opportunities]
			from (
			select row_number() over (partition by rp.patientID order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
					, rp.PatientID
					, rp.centerid
		from vw_CMRActivityReport rp
			join patientDim pd on pd.patientKey = rp.patientKey
			join policy p on p.policyID = rp.policyID
			join pharmacy ph on ph.centerID = rp.centerID
			left join chain c on c.chainID = rp.chainID
			where 1=1
			AND isNull(rp.activethru, '99991231') >= @BEGIN
			AND rp.activeasof <= @END
				and rp.policyID in (635,636,262,602,639,642,643,644,603,645,648,649,650,652,653,655,656,657,659,607,661
,866,867,868,869,870,871,872,873,874,875,876,606,877,878)
				and ph.AddressState in ('VA','FL','LA','IA','MN','MT','NE','ND','SD','WY','AZ') 
				and rp.primaryPharmacy = 1) u
			where 1 = 1
			and u.rank = 1
			Group by centerid) CMR1 on cmr1.centerid = ph.centerid

--=============[CMR Completed]
Left join( 
SELECT distinct centerid
	, sum(u.CMRCompleted) as [Completed CMR]
			from (
			select row_number() over (partition by rp.patientID order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
					, rp.PatientID
					, rp.centerid
, case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) THEN 1 ELSE 0 END as CMRCompleted
		from vw_CMRActivityReport rp
			join patientDim pd on pd.patientKey = rp.patientKey
			join policy p on p.policyID = rp.policyID
			join pharmacy ph on ph.centerID = rp.centerID
			left join chain c on c.chainID = rp.chainID
			where 1=1
			AND isNull(rp.activethru, '99991231') >= @BEGIN
			AND rp.activeasof <= @END
				and rp.policyID in (635,636,262,602,639,642,643,644,603,645,648,649,650,652,653,655,656,657,659,607,661
,866,867,868,869,870,871,872,873,874,875,876,606,877,878)
				and ph.AddressState in ('VA','FL','LA','IA','MN','MT','NE','ND','SD','WY','AZ') 
				and rp.primaryPharmacy = 1) u
			where 1 = 1
			and u.rank = 1
			and u.CMRCompleted <>0
			Group by centerid) CMR on cmr.centerid = ph.centerid

--=====================(TIP Opportunities)
Left join(
SELECT f.centername,
       f.ncpdp_nabp,
	   f.centerid,
       f.tipopportunities
FROM
  (SELECT row_number() OVER (ORDER BY centername ASC) AS [rank],t.*
   FROM
     (SELECT ta.centerid,
             ta.centername,
             ta.ncpdp_nabp,
             sum(ta.[tip opportunities]) AS tipopportunities
                  FROM
        (SELECT row_number() OVER (PARTITION BY ta.tipresultstatusid,ta.centerid
        ORDER BY ta.[completed tips] DESC, ta.[unfinished tips] DESC, ta.[review/resubmit tips] DESC, ta.[rejected tips] DESC, ta.[currently active] DESC
		, ta.[withdrawn] DESC, ta.tipresultstatuscenterid DESC) AS [rank],ta.centerid,
             ta.centername,
             ta.ncpdp_nabp,
			 [TIP Opportunities]
		 FROM vw_tipactivitycenterreport ta WITH (nolock)
		 Join Pharmacy ph on ph.centerid = ta.centerid
         WHERE 1 = 1
           AND ta.activethru >= @BEGIN
           AND ta.activeasof <= @END
		   and ta.policyid in (635,636,262,602,639,642,643,644,603,645,648,649,650,652,653,655,656,657,659,607,661
,866,867,868,869,870,871,872,873,874,875,876,606,877,878)
		   and ta.primaryPharmacy = 1
		   and ph.AddressState in ('VA','FL','LA','IA','MN','MT','NE','ND','SD','WY','AZ')
		   ) ta
      WHERE 1 = 1
        AND ta.[rank] = 1
      GROUP BY ta.centerid,
               ta.centername,
               ta.ncpdp_nabp) t
   WHERE isnull(t.centerid,0) <> 0 ) f
WHERE 1 = 1
) TipOpp on TipOpp.centerID = ph.centerid

--=============[TIP COMPLETED]
Left join(
select c.centerid, count(distinct c.claimid) as [Tips Completed]
from	OutcomesMTM.dbo.vw_clientManagerReport car
join OutcomesMTM.dbo.claim c on c.claimid = car.claimID
join pharmacychain p on p.centerid=car.centerid
join Chain ch on ch.chainid=p.chainid
Join Pharmacy ph on ph.centerid = car.centerid
where	1=1
and car.policyid in (635,636,262,602,639,642,643,644,603,645,648,649,650,652,653,655,656,657,659,607,661
,866,867,868,869,870,871,872,873,874,875,876,606,877,878)
and ph.AddressState in ('VA','FL','LA','IA','MN','MT','NE','ND','SD','WY','AZ')
and car.primarypharmacy = 'yes'
and car.mtmserviceDT between @BEGIN and @END
and c.statusID in (2,6)
and c.isTipClaim=1
and c.resultTypeID not in (12,13,16,18)
group by c.centerid) TipComp on TipComp.centerID = ph.centerid

--==========================================
--Get Denominator and Numerator
If OBJECT_ID('tempdb..#GetDenominator') is not null
Drop table #GetDenominator
Select distinct c.Region, c.OpportunityTIP, c.CompletedTIP
Into #GetDenominator
from #MAPD_CMR c

If OBJECT_ID('tempdb..#GetNumerator') is not null
Drop table #GetNumerator
Select distinct c.Region, c.OpportunityCMR, c.CompletedCMR
Into #GetNumerator
from #MAPD_CMR c

--Remove duplicated
If OBJECT_ID('tempdb..#Tips') is not null
Drop table #Tips
Select d.Region, d.OpportunityTIP, d.CompletedTIP
Into #Tips
From #GetDenominator d
where d.OpportunityTIP is not null

If OBJECT_ID('tempdb..#CMR') is not null
Drop table #CMR
Select Distinct n.Region, n.OpportunityCMR, n.CompletedCMR
Into #CMR
From #GetNumerator n
Where n.OpportunityCMR is not null

If OBJECT_ID('tempdb..#Tips_CMRs') is not null
Drop table #Tips_CMRs
Select t.Region, t.OpportunityTIP as [MAPD Denominator], t.CompletedTIP as [MAPD Numerator]
Into #Tips_CMRs
From #Tips t
Union all
Select c.Region, c.OpportunityCMR, c.CompletedCMR
From #CMR c

--Select Distinct
If OBJECT_ID('tempdb..#DistinctTipsCMRs') is not null
Drop table #DistinctTipsCMRs
Select distinct * into #DistinctTipsCMRs from #Tips_CMRs

--Final Query
Select * from #DistinctTipsCMRs Order by 1

END




