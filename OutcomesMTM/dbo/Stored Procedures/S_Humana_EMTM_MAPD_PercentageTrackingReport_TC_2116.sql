


CREATE PROCEDURE [dbo].[S_Humana_EMTM_MAPD_PercentageTrackingReport_TC_2116] @BeginDate Date-- , @EndDate Date
AS
BEGIN 


DECLARE @BEGIN AS DATE
DECLARE @END AS DATE
DECLARE @DATEDIFF AS INT
DECLARE @NEXT AS DATE
--DECLARE @BeginDate AS DATE
--DECLARE @EndDate AS DATE


DECLARE @MONTH AS DATE
DECLARE @MONTH_DATE AS VARCHAR(20)






--SET @BEGIN = (case when convert(varchar,getdate()+307,112)=convert(varchar,dateadd(yy,datediff(yy,0,getdate()),0),112)
--then
--convert(varchar,dateadd(yy,-1,dateadd(yy,datediff(yy,0,getdate()),0)),112)
--else
--convert(varchar,dateadd(d,datediff(d,0,DATEADD(DD,-datepart(DY,getdate())+1,getdate())),0) ,112)
--end)



SET @END = GETDATE()
--SET @BEGIN = (select DATEADD(YY,-1, DATEADD(YY, DATEDIFF(YY,0, GETDATE()), 0)))
SET @BEGIN = @BeginDate
PRINT @BEGIN
PRINT @END




SET @BEGIN = @BeginDate
--SET @END = @EndDate


--TRUNCATE TABLE [dbo].[Humana_EMTM_MAPD_PercentageTrackingReport]


--Regions need to be Included
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

--Get TIP and CMR(Completed and Opportunities) Counts
If OBJECT_ID('tempdb..#EMTM_CMR_TIPS') is not null
Drop table #EMTM_CMR_TIPS
Select DISTINCT
		r.Region
		, CMR1.centerid as OpportunityCMR
		, CMR.centerid as CompletedCMR
		, TipOpp.centerid as OpportunityTIP
		, TipComp.centerID AS CompletedTIP
		
into #EMTM_CMR_TIPS
From outcomesMTM.dbo.pharmacy ph
	join outcomesmtm.dbo.pharmacychain pc on pc.centerid = ph.centerid
	join outcomesmtm.dbo.chain ch on ch.chainid = pc.chainid
	Join #Region r on r.state = ph.AddressState

--=============[CMR Opportunities]
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
				and rp.policyID in (735,737,736,738)
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
				and rp.policyID in (735,737,736,738)
				and ph.AddressState in ('VA','FL','LA','IA','MN','MT','NE','ND','SD','WY','AZ') 
				and rp.primaryPharmacy = 1) u
			where 1 = 1
			and u.rank = 1
			and u.CMRCompleted <>0
			Group by centerid) CMR on cmr.centerid = ph.centerid

--=============[TIP Opportunities]
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
		   and ta.policyid in (735,737,736,738)
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
and car.policyid in (735,737,736,738)
and ph.AddressState in ('VA','FL','LA','IA','MN','MT','NE','ND','SD','WY','AZ')
and car.primarypharmacy = 'yes'
and car.mtmserviceDT between @BEGIN and @END
and c.statusID in (2,6)
and c.isTipClaim=1
and c.resultTypeID not in (12,13,16,18)
group by c.centerid) TipComp on TipComp.centerID = ph.centerid
--=============================================

--Get Centers with TIP Opportunities and Completed TIPs
If OBJECT_ID('tempdb..#EMTM_GetDenominator') is not null
Drop table #EMTM_GetDenominator
Select distinct c.Region, c.OpportunityTIP, c.CompletedTIP
Into #EMTM_GetDenominator
from #EMTM_CMR_TIPS c


--Get Centers with CMR Opportunities and Completed CMRs
If OBJECT_ID('tempdb..#EMTM_GetNumerator') is not null
Drop table #EMTM_GetNumerator
Select distinct c.Region, c.OpportunityCMR, c.CompletedCMR
Into #EMTM_GetNumerator
from #EMTM_CMR_TIPS c

--Remove duplicated
If OBJECT_ID('tempdb..#EMTMTips') is not null
Drop table #EMTMTips
Select d.Region, d.OpportunityTIP, d.CompletedTIP
Into #EMTMTips
From #EMTM_GetDenominator d
where d.OpportunityTIP is not null

If OBJECT_ID('tempdb..#EMTMCMR') is not null
Drop table #EMTMCMR
Select Distinct n.Region, n.OpportunityCMR, n.CompletedCMR
Into #EMTMCMR
From #EMTM_GetNumerator n
Where n.OpportunityCMR is not null

--
If OBJECT_ID('tempdb..#EMTM_Counts') is not null
Drop table #EMTM_Counts
Select t.Region, t.OpportunityTIP as Opportunities, t.CompletedTIP as Completed
Into #EMTM_Counts
From #EMTMTips t
Union all
Select c.Region, c.OpportunityCMR, c.CompletedCMR
From #EMTMCMR c

--Select Distinct
If OBJECT_ID('tempdb..#EMTMDistinctTipsCMRs') is not null
Drop table #EMTMDistinctTipsCMRs
Select distinct * into #EMTMDistinctTipsCMRs from #EMTM_Counts


--===============================================================================================================
--MAPD
--===============================================================================================================

If OBJECT_ID('tempdb..#MAPD_TIPs_CMR') is not null
Drop table #MAPD_TIPs_CMR
Select DISTINCT
		r.Region
		, CMR1.centerid as OpportunityCMR
		, CMR.centerid as CompletedCMR
		, TipOpp.centerid as OpportunityTIP
		, TipComp.centerID AS CompletedTIP
		
into #MAPD_TIPs_CMR
From outcomesMTM.dbo.pharmacy ph
	join outcomesmtm.dbo.pharmacychain pc on pc.centerid = ph.centerid
	join outcomesmtm.dbo.chain ch on ch.chainid = pc.chainid
	Join #Region r on r.state = ph.AddressState

--=============[CMR Opportunities]
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

--=============[TIP Opportunities]
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

--=============================================
--Get Centers with TIP Opportunities and Completed TIPs
If OBJECT_ID('tempdb..#MAPDGetDenominator') is not null
Drop table #MAPDGetDenominator
Select distinct c.Region, c.OpportunityTIP, c.CompletedTIP
Into #MAPDGetDenominator
from #MAPD_TIPs_CMR c

--Get Centers with CMR Opportunities and Completed CMRs
If OBJECT_ID('tempdb..#MAPDGetNumerator') is not null
Drop table #MAPDGetNumerator
Select distinct c.Region, c.OpportunityCMR, c.CompletedCMR
Into #MAPDGetNumerator
from #MAPD_TIPs_CMR c

--Remove duplicated
If OBJECT_ID('tempdb..#MAPDTips') is not null
Drop table #MAPDTips
Select d.Region, d.OpportunityTIP, d.CompletedTIP
Into #MAPDTips
From #MAPDGetDenominator d
where d.OpportunityTIP is not null

If OBJECT_ID('tempdb..#MAPDCMR') is not null
Drop table #MAPDCMR
Select Distinct n.Region, n.OpportunityCMR, n.CompletedCMR
Into #MAPDCMR
From #MAPDGetNumerator n
Where n.OpportunityCMR is not null

If OBJECT_ID('tempdb..#MAPD_Counts') is not null
Drop table #MAPD_Counts
Select t.Region, t.OpportunityTIP, t.CompletedTIP
Into #MAPD_Counts
From #MAPDTips t
Union all
Select c.Region, c.OpportunityCMR, c.CompletedCMR
From #MAPDCMR c

If OBJECT_ID('tempdb..#MAPD_DistinctTipsCMRs') is not null
Drop table #MAPD_DistinctTipsCMRs
Select distinct * into #MAPD_DistinctTipsCMRs from #MAPD_Counts


--=========================================================================================
--BOB
--==========================================================================================
If OBJECT_ID('tempdb..#BOB_TIPs_CMR') is not null
Drop table #BOB_TIPs_CMR
Select DISTINCT
		r.Region
		, CMR1.centerid as OpportunityCMR
		, CMR.centerid as CompletedCMR
		, TipOpp.centerid as OpportunityTIP
		, TipComp.centerID AS CompletedTIP
		
into #BOB_TIPs_CMR
From outcomesMTM.dbo.pharmacy ph
	join outcomesmtm.dbo.pharmacychain pc on pc.centerid = ph.centerid
	join outcomesmtm.dbo.chain ch on ch.chainid = pc.chainid
	Join #Region r on r.state = ph.AddressState

--=============[CMR Opportunities]
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

			/*
			293, 292, 291, 744, 745, 627, 624, 626, 625, 623, 630, 673, 506, 396, 631, 397, 578, 670, 669, 498, 663, 499, 749, 435, 460, 271, 351, 318, 569, 568, 253, 224, 555, 632, 633, 743, 815, 816, 817, 820, 827, 822, 823, 821, 824, 811, 825, 850, 851, 829, 848, 843, 832, 841, 840, 813,
845, 835, 836, 838, 812, 834, 842, 839, 833, 837, 819, 852, 828, 844, 847, 846, 831, 849, 818, 830
			*/
				and rp.policyID in (293, 292, 291, 744, 745, 627, 624, 626, 625, 623, 630, 673, 506, 396, 631, 397, 578, 670, 669, 498, 663, 499, 749, 435, 460, 271, 351, 318, 569, 568, 253, 224, 555, 632, 633, 743, 815, 816, 817, 820, 827, 822, 823, 821, 824, 811, 825, 850, 851, 829, 848, 843, 832, 841, 840, 813,
845, 835, 836, 838, 812, 834, 842, 839, 833, 837, 819, 852, 828, 844, 847, 846, 831, 849, 818, 830)
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
				and rp.policyID in (293, 292, 291, 744, 745, 627, 624, 626, 625, 623, 630, 673, 506, 396, 631, 397, 578, 670, 669, 498, 663, 499, 749, 435, 460 , 271, 351, 318, 569, 568, 253, 224, 555, 632, 633, 743, 815, 816, 817, 820, 827, 822, 823, 821, 824, 811, 825, 850, 851, 829, 848, 843, 832, 841, 840, 813,
845, 835, 836, 838, 812, 834, 842, 839, 833, 837, 819, 852, 828, 844, 847, 846, 831, 849, 818, 830)
				and ph.AddressState in ('VA','FL','LA','IA','MN','MT','NE','ND','SD','WY','AZ') 
				and rp.primaryPharmacy = 1) u
			where 1 = 1
			and u.rank = 1
			and u.CMRCompleted <>0
			Group by centerid) CMR on cmr.centerid = ph.centerid

--=============[TIP Opportunities]
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
		   and ta.policyid in (293, 292, 291, 744, 745, 627, 624, 626, 625, 623, 630, 673, 506, 396, 631, 397, 578, 670, 669, 498, 663, 499, 749, 435, 460,  271, 351, 318, 569, 568, 253, 224, 555, 632, 633, 743, 815, 816, 817, 820, 827, 822, 823, 821, 824, 811, 825, 850, 851, 829, 848, 843, 832, 841, 840, 813,
845, 835, 836, 838, 812, 834, 842, 839, 833, 837, 819, 852, 828, 844, 847, 846, 831, 849, 818, 830)
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
and car.policyid in (293, 292, 291, 744, 745, 627, 624, 626, 625, 623, 630, 673, 506, 396, 631, 397, 578, 670, 669, 498, 663, 499, 749, 435, 460, 271, 351, 318, 569, 568, 253, 224, 555, 632, 633, 743, 815, 816, 817, 820, 827, 822, 823, 821, 824, 811, 825, 850, 851, 829, 848, 843, 832, 841, 840, 813,
845, 835, 836, 838, 812, 834, 842, 839, 833, 837, 819, 852, 828, 844, 847, 846, 831, 849, 818, 830)
and ph.AddressState in ('VA','FL','LA','IA','MN','MT','NE','ND','SD','WY','AZ')
and car.primarypharmacy = 'yes'
and car.mtmserviceDT between @BEGIN and @END
and c.statusID in (2,6)
and c.isTipClaim=1
and c.resultTypeID not in (12,13,16,18)
group by c.centerid) TipComp on TipComp.centerID = ph.centerid

--=============================================
--Get Centers with TIP Opportunities and Completed TIPs
If OBJECT_ID('tempdb..#BOBGetDenominator') is not null
Drop table #BOBGetDenominator
Select distinct c.Region, c.OpportunityTIP, c.CompletedTIP
Into #BOBGetDenominator
from #BOB_TIPs_CMR c

--Get Centers with CMR Opportunities and Completed CMRs
If OBJECT_ID('tempdb..#BOBGetNumerator') is not null
Drop table #BOBGetNumerator
Select distinct c.Region, c.OpportunityCMR, c.CompletedCMR
Into #BOBGetNumerator
from #BOB_TIPs_CMR c

--Remove duplicated
If OBJECT_ID('tempdb..#BOBTips') is not null
Drop table #BOBTips
Select d.Region, d.OpportunityTIP, d.CompletedTIP
Into #BOBTips
From #BOBGetDenominator d
where d.OpportunityTIP is not null

If OBJECT_ID('tempdb..#BOBCMR') is not null
Drop table #BOBCMR
Select Distinct n.Region, n.OpportunityCMR, n.CompletedCMR
Into #BOBCMR
From #BOBGetNumerator n
Where n.OpportunityCMR is not null

If OBJECT_ID('tempdb..#BOB_Counts') is not null
Drop table #BOB_Counts
Select t.Region, t.OpportunityTIP, t.CompletedTIP
Into #BOB_Counts
From #BOBTips t
Union all
Select c.Region, c.OpportunityCMR, c.CompletedCMR
From #BOBCMR c

If OBJECT_ID('tempdb..#BOB_DistinctTipsCMRs') is not null
Drop table #BOB_DistinctTipsCMRs
Select distinct * into #BOB_DistinctTipsCMRs from #BOB_Counts
---=======================================================END BOB===========================================

--==================
--Get Counts Concatinate (EMTM/MAPD)
--==================
If OBJECT_ID('tempdb..#Get_EMTM_MAPD_BOB_Counts') is not null
Drop table #Get_EMTM_MAPD_BOB_Counts
select * into #Get_EMTM_MAPD_BOB_Counts from 
(
select e.Region, 'EMTM' AS [Policy Type]
			, COUNT(e.Opportunities) as [EMTM Denominator]
			, COUNT(e.Completed) as [EMTM Numerator]
			FROM #EMTMDistinctTipsCMRs e 
			Group by e.Region 
			UNION
	Select m.Region, 'MAPD' as [Policy Type]
			, COUNT(m.OpportunityTIP) as [MAPD Denominator]
			, COUNT(m.CompletedTIP) as [MAPD Numerator]
			From #MAPD_DistinctTipsCMRs m
			Group by m.Region
			UNION
	Select m.Region, 'BOB' as [Policy Type]
			, COUNT(m.OpportunityTIP) as [BOB Denominator]
			, COUNT(m.CompletedTIP) as [BOB Numerator]
			From #BOB_DistinctTipsCMRs m
			Group by m.Region
)a


If OBJECT_ID('tempdb..#EMTMCount') is not null
Drop table #EMTMCount
Select * Into #EMTMCount from #Get_EMTM_MAPD_BOB_Counts a
Where a.[Policy Type] = 'EMTM'


If OBJECT_ID('tempdb..#MAPDCount') is not null
Drop table #MAPDCount
Select * Into #MAPDCount from #Get_EMTM_MAPD_BOB_Counts a
Where a.[Policy Type] = 'MAPD'

If OBJECT_ID('tempdb..#BOBCount') is not null
Drop table #BOBCount
Select * Into #BOBCount from #Get_EMTM_MAPD_BOB_Counts a
Where a.[Policy Type] = 'BOB'



--=============================
--Final Query
--=============================
If OBJECT_ID('tempdb..#Numerator_Denominator') is not null
Drop table #Numerator_Denominator
select * into #Numerator_Denominator from 
(
select e.Region, 'EMTM' AS Type
			, COUNT(e.Opportunities) as [EMTM Denominator]
			, COUNT(e.Completed) as [EMTM Numerator]
			FROM #EMTMDistinctTipsCMRs e 
			Group by e.Region 
			UNION
	Select m.Region, 'MAPD' as Type
			, COUNT(m.OpportunityTIP) as [MAPD Denominator]
			, COUNT(m.CompletedTIP) as [MAPD Numerator]
			From #MAPD_DistinctTipsCMRs m
			Group by m.Region
			UNION
	Select m.Region, 'BOB' as Type
			, COUNT(m.OpportunityTIP) as [BOB Denominator]
			, COUNT(m.CompletedTIP) as [BOB Numerator]
			From #BOB_DistinctTipsCMRs m
			Group by m.Region
)a

--select * from  #Numerator_Denominator

--If OBJECT_ID('tempdb..#SUMMARY') is not null
--Drop table #SUMMARY
--SELECT




--SET @MONTH_DATE = (SELECT REPLACE(RIGHT(CONVERT(VARCHAR(9), @BeginDate, 6),6), '' , ''))
SET @MONTH_DATE = (SELECT CONVERT(VARCHAR, @BeginDate, 110))

--If OBJECT_ID('TC_2116') is not null
--Drop table TC_2116

/*
INSERT INTO [dbo].[TC_2116]
           ([Region]
           ,[Policy Type]
           ,[Numerator]
           ,[Denominator]
           ,[Percentage%]
           ,[MONTH])
     VALUES
           (<Region, int,>
           ,<Policy Type, varchar(4),>
           ,<Numerator, int,>
           ,<Denominator, int,>
           ,<Percentage%, numeric(28,12),>
           ,<MONTH, varchar(20),>)

*/




INSERT INTO [dbo].[Humana_EMTM_MAPD_PercentageTrackingReport]
           ([Region]
           ,[Policy Type]
           ,[Numerator]
           ,[Denominator]
           ,[Percentage%]
           ,[MONTH])
select	  a.Region
		, a.Type as [Policy Type]
		, a.[EMTM Numerator] AS Numerator
		, a.[EMTM Denominator] AS Denominator
		, a.[EMTM Numerator] *1.0 /a.[EMTM Denominator] * 100 as [Percentage%]
		,@MONTH_DATE as 'MONTH'
--Into TC_2116
from #Numerator_Denominator a
order by a.Type, a.Region

-- INSERT INTO [dbo].[TC_2116]
--           (
--		   [MONTH]
--		   )
--select	  
--		CONCAT(@MONTH_DATE,'_Total') as 'MONTH'

--Into TC_2116
--from #Numerator_Denominator a
--order by a.Type, a.Region




SET @DATEDIFF =  datediff(M, @Begin, @End)
SET @NEXT = DATEADD(M, +1, @Begin)

IF @DATEDIFF>0 EXEC [dbo].[S_Humana_EMTM_MAPD_PercentageTrackingReport_TC_2116] @NEXT

--END

--Select * from #Final a order by a.[Policy Type], a.Region desc


END


