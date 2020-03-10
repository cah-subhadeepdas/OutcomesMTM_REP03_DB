


-- ==========================================================================================
-- Author:	Skyla
-- Create date: 09/21/2018
-- Description:	
-- ==========================================================================================
-- Change Log
-- ==========================================================================================
--   #		Date		Author			Description
--   --		--------	----------		----------------
--   1		09/21/2018	Skyla    	TC-2135

-- ==========================================================================================


CREATE proc [dbo].[S_ReportCard_Pharmacy_Scored] 
as 
begin 



DECLARE @BEGIN VARCHAR(10)
DECLARE @END VARCHAR(10)


/*
select cast(year(getdate()) as varchar(4)) + '0101'
,cast(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as date)

*/

SET @BEGIN =  case when month(getdate()) = 1 then cast(year(getdate()) - 1 as varchar(4)) + '0101' else cast(year(getdate()) as varchar(4)) + '0101' end  --// Beginning of year (if current month is Jan. then beginning of last year)		
SET @END =  cast(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as date)	 		--end of last month



If OBJECT_ID('tempdb..#report') is not null
drop table #report 


select distinct ph.centerid
, ph.NCPDP_NABP
, replace(replace(replace(ph.centername,char(9),''),char(10),''),char(13),'') as [PharmacyName]
, ph.addressState as [Pharmacy State]
, pr.Relationship_ID
, pr.Relationship_ID_Name
, isnull(ta.[TIP Opportunities],0) as [TIP Opportunities]
, isnull(ta.[Completed TIPs],0) as [Completed TIPs]
, isnull(ta.[Successful TIPs],0) as [Successful TIPs]
, isnull(ta.NetEffectiveRate,0) as NetEffectiveRate
-----------------------------
, isnull(ta.[Cost TIPs Opportunity],0) as [Cost TIPs Opportunity]
, isnull(ta.[Cost Completed TIPs],0) as [Cost Completed TIPs]
, isnull(ta.[Cost Successful TIPs],0) as [Cost Successful TIPs]
, isnull(ta.CostNetEffectiveRate,0) as CostNetEffectiveRate
-----------------------------
, isnull(ta.[Star TIPs Opportunity],0) as [Star TIPs Opportunity]
, isnull(ta.[Star Completed TIPs],0) as [Star Completed TIPs]
, isnull(ta.[Star Successful TIPs],0) as [Star Successful TIPs]
, isnull(ta.StarNetEffectiveRate,0) as StarNetEffectiveRate
-----------------------------
, isnull(ta.[Quality TIPs Opportunity],0) as [Quality TIPs Opportunity]
, isnull(ta.[Quality Completed TIPs] ,0) as [Quality Completed TIPs]
, isnull(ta.[Quality Successful TIPs],0) as [Quality Successful TIPs]
, isnull(ta.QualityNetEffectiveRate,0) as QualityNetEffectiveRate
-----------------------------
,isnull(cm.CMROpportunity ,0) as CMROpportunity
,isnull(cm.CMROffered ,0) as CMROffered
,isnull(cm.completedCMRs ,0) as completedCMRs
,isnull(cm.percentCMRcompletion,0) as percentCMRcompletion
-----------------------------
, isnull(pm.EligiblePatient,0) as EligiblePatient
, isnull(cl.claimSubmitted,0) as claimSubmitted
-----------------------------
, case when isnull([Cost TIPs Opportunity],0) <> 0 then 5 else 0 end costpt
, case when isnull([Star TIPs Opportunity],0) <> 0 then 30 else 0 end starpt
, case when isnull([Quality TIPs Opportunity],0) <> 0 then 15 else 0 end qualitypt
, case when isnull(cm.CMROpportunity,0) <> 0 then 50 else 0 end cmrpt

into #report
from outcomesMTM.dbo.pharmacy ph
join OutcomesMTM.dbo.NCPDP_Provider np on np.NCPDP_Provider_ID = ph.NCPDP_NABP
left join (

	select row_number() over (partition by ph.centerID order by case when pr.Relationship_type = '02' then '99' else pr.Relationship_type end asc) as [Rank]
	, ph.centerid
	, pr.Relationship_Type
	, pr.Relationship_ID
	, pr.Relationship_ID_Name
	, pr.parent_organization_ID
	, pr.parent_organization_Name
	from outcomesmtm.dbo.providerRelationshipView pr
	join outcomesmtm.dbo.pharmacy ph on ph.NCPDP_NABP = pr.mtmCenterNumber
	where 1=1
	and pr.Relationship_Type in ('01', '05', '02')

) pr on pr.centerid = ph.centerid and pr.[Rank] = 1
left join (

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
		where 1=1
		and tacr.policyid not in (574, 575, 298)
		and tacr.primaryPharmacy = 1 
		and tacr.activethru >= @BEGIN
		and tacr.activeasof <= @END
		AND ((tacr.activethru <= @END AND (tacr.[completed tips] = 1 or tacr.[unfinished tips] = 1 or tacr.[review/resubmit tips] = 1 or tacr.[rejected tips] = 1)) 
			OR datediff(day, case when tacr.activeasof > @BEGIN then tacr.activeasof else @BEGIN end, case when tacr.activethru > @END then @END else tacr.activethru end) > 30)
	) ta
	where 1=1
	and ta.Rank = 1
	group by ta.centerID

) ta on ta.centerid = ph.centerID
left join (		

	select pm.centerid, count(distinct pt.patientID) as [EligiblePatient]
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

) pm on pm.centerid = ph.centerid
left join (

	select v.[MTM CenterID]
	, sum(v.claimSubmitted) as claimSubmitted
	from (
		select c.claimID
		, c.[MTM CenterID]
		, 1 as claimSubmitted
		from outcomesMTM.dbo.ClaimActivityReport c
		where 1=1
		and c.mtmServiceDT between @BEGIN and @END
		and c.statusID not in (3,5)
		and c.policyID not in 
		(574 ,575 ,298)
	) v
	where 1=1
	group by v.[MTM CenterID]

) cl on cl.[MTM CenterID] = ph.NCPDP_NABP
left join (
	
	select centerID
	, centerName						
	, count(distinct u.PatientID) as CMROpportunity
	, sum(u.CMROffered) as CMROffered				
	, sum(u.CMRCompleted) as completedCMRs
	, case when count(distinct u.PatientID) = 0 then 0 else cast((cast(sum(u.CMROffered) as decimal))/(cast(count(distinct u.PatientID) as decimal)) as decimal(5,2)) end as percentCMRoffered
	, case when count(distinct u.PatientID) = 0 then 0 else cast((cast(sum(u.CMRCompleted) as decimal))/(cast(count(distinct u.PatientID) as decimal)) as decimal(5,2)) end as percentCMRcompletion	
	--, case when count(distinct u.PatientID) = 0 or sum(u.CMROffered) = 0 then 0 else (cast((cast(sum(u.CMRCompleted) as decimal))/(cast(sum(u.CMROffered) as decimal)) as decimal(5,2)) *	cast((cast(sum(u.CMROffered) as decimal))/(cast(count(distinct u.PatientID) as decimal)) as decimal(5,2))) end as [CMRNetEffectiveRate]	
	from (
		select row_number() over (partition by rp.patientID, rp.centerID order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
		, rp.PatientID
        , rp.PolicyID
        , rp.CMSContractNumber
        , rp.centerid
		, ph.centername
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
        , case when rp.outcomesTermDate between @BEGIN and @END AND isNull(rp.mtmServiceDT, '99991231') not between @BEGIN and @END THEN 1 ELSE 0 END as Termed
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6, 12) AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'')  THEN 1 ELSE 0 END as CMROffered
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') THEN 1 ELSE 0 END as CMRCompleted
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID = 12 AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') THEN 1 ELSE 0 end as PatientRefused
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID = 18 AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') THEN 1 ELSE 0 end as UnableToReachPatient
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID = 5 AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') THEN 1 ELSE 0 end as CMRWithDrugProblems
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID = 6 AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') THEN 1 ELSE 0 end as CMRWithoutDrugProblems
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.cmrDeliveryTypeID = 1 AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') THEN 1 ELSE 0 end as CMRFace2Face
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.cmrDeliveryTypeID = 2 AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') THEN 1 ELSE 0 end as CMRPhone
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.cmrDeliveryTypeID = 3 AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') THEN 1 ELSE 0 end as CMRTelehealth
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.centerID <> rp.claimcenterID THEN 1 ELSE 0 END as CMRMissed
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID = 5 AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') THEN 1 ELSE 0 END as CMRRejected
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID = 2 AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') AND rp.resultTypeID in (5, 6) THEN 1 ELSE 0 END as CMRPendingApproval
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID = 6 and rp.paid = 0 AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') AND rp.resultTypeID in (5, 6) THEN 1 ELSE 0 END as CMRApprovedPendingPayment
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID = 6 and rp.paid = 1 AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') AND rp.resultTypeID in (5, 6) THEN 1 ELSE 0 END as CMRApprovedPaid
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.Language = 'EN' AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') THEN 1 ELSE 0 END EnglishSPT
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.Language = 'SP' AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') THEN 1 ELSE 0 END SpanishSPT
            , case when rp.mtmServiceDT between @BEGIN and @END AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') THEN cast(rp.postHospitalDischarge as int) ELSE 0 END as postHospitalDischarge
            from vw_CMRActivityReport rp
            join patientDim pd on pd.patientKey = rp.patientKey
            join policy p on p.policyID = rp.policyID
            join pharmacy ph on ph.centerID = rp.centerID
            left join chain c on c.chainID = rp.chainID
            where 1=1
            AND isNull(rp.activethru, '99991231') >= @BEGIN
            AND rp.activeasof <= @END
			and rp.primaryPharmacy = 1 
                --30 day include
                AND (
                        (rp.activethru IS NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @BEGIN THEN rp.activeasof ELSE @BEGIN END, @END) >= 30)
                        OR
                        (rp.activethru IS NOT NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @BEGIN THEN rp.activeasof ELSE @BEGIN END, CASE WHEN rp.activethru > @END THEN @END ELSE rp.activethru END) >= 30)
                        OR
                        (rp.mtmServiceDT BETWEEN @BEGIN AND @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6))
                        AND
                        (rp.claimcenterID = rp.centerid)
                    )

	) u
	where 1 = 1
	and u.rank = 1
	group by centerID, centerName						

) cm on cm.centerid = ph.centerID
where 1=1
and np.Active = 1




If object_id('tempdb..#function') is not null
drop table #function

select distinct sum(r.CostNetEffectiveRate)/count(nullif(r.CostNetEffectiveRate,0)) as costavg
,sum(r.starNetEffectiveRate)/count(nullif(r.starNetEffectiveRate,0)) as staravg
,sum(r.QualityNetEffectiveRate)/count(nullif(r.QualityNetEffectiveRate,0)) as qualityavg
,sum(r.percentCMRcompletion)/count(nullif(r.percentcmrcompletion,0)) as cmravg
,STDEV(nullif(r.costneteffectiverate,0)) as costsd
,STDEV(nullif(r.starneteffectiverate,0)) as starsd
,STDEV(nullif(r.qualityneteffectiverate,0)) as qualitysd
,STDEV(nullif(r.percentcmrcompletion,0)) as cmrsd
into #function
from #report r



If object_id('tempdb..#score') is not null
drop table #score

select centerid
, case when costneteffectiverate = 0 then 0 else round((CUME_DIST() over (partition by (case when costneteffectiverate <> 0 then 1 else 0 end) order by costneteffectiverate))*5,4) end as costcdf
, case when StarNetEffectiveRate = 0 then 0 else round((CUME_DIST() over (partition by (case when StarNetEffectiveRate <> 0 then 1 else 0 end) order by StarNetEffectiveRate))*30,4) end as starcdf
, case when QualityNetEffectiveRate = 0 then 0 else round(CUME_DIST() over (partition by (case when QualityNetEffectiveRate <> 0 then 1 else 0 end) order by QualityNetEffectiveRate)*15,4) end as qualitycdf
, case when percentCMRcompletion = 0 then 0 else round(CUME_DIST() over (partition by (case when percentCMRcompletion <> 0 then 1 else 0 end) order by percentCMRcompletion)*50,4) end as cmrcdf
--, case when costneteffectiverate = 0 then 0 else (CUME_DIST() over (partition by (case when costneteffectiverate <> 0 then 1 else 0 end) order by costneteffectiverate))*5 end as costcdf
into #score
from #report r



/*
select centerid, r.CostNetEffectiveRate, f.costavg, f.costsd,case when costneteffectiverate = 0 then 0 else n.[F(X)]*5 end as cdf
from #report r
cross apply #function f
cross apply dbo.Excel_Norm_Dist(r.CostNetEffectiveRate,f.costavg, f.costsd,1, case f.costavg when 0.5 then 50000 else 10000 end) n
where costneteffectiverate <> 0
order by centerid 
*/

if object_id('tempdb..#composite') is not null
drop table #composite

select r.centerid
, costcdf
, starcdf
, qualitycdf
, cmrcdf
, case when costpt + starpt + qualitypt + cmrpt = 0 then 0
	   else (costcdf + starcdf + qualitycdf + cmrcdf)/(costpt + starpt + qualitypt + cmrpt)*100 end as composite
into #composite
from #report r
join #score s on r.centerid = s.centerid

if object_id('tempdb..#percentrank') is not null
drop table #percentrank

select c.centerid, 
	   composite,
	   case when composite  = 0 then 0 
			when round(percent_rank() over (partition by (case when composite <> 0 then 1 else 0 end) order by composite),3) = 0 then 0.001
			else round(percent_rank() over (partition by (case when composite <> 0 then 1 else 0 end) order by composite),3) end as percentrank
into #percentrank
from #composite c





-- Pull the final report


select NCPDP_NABP as NCPDP
, [PharmacyName] as [Pharmacy Name]
, [Pharmacy State] as [Pharmacy State]
, Relationship_ID as [Relationship ID]
, Relationship_ID_Name as [Relationship Name]
, [TIP Opportunities] 
, [Completed TIPs] as [TIPs Completed]
, [Successful TIPs] as [TIPs Successful]
, NetEffectiveRate as [TIP Net Effective Rate]
-----------------------------
, [Cost TIPs Opportunity] as [Cost TIP Opportunities]
, [Cost Completed TIPs] as [Cost TIPs Completed]
, [Cost Successful TIPs] as [Cost TIPs Successful]
, CostNetEffectiveRate as [Cost TIP Net Effective Rate]
-----------------------------
, [Star TIPs Opportunity] as [Star TIP Opportunities]
, [Star Completed TIPs] as [Star TIPs Completed]
, [Star Successful TIPs] as [Star TIPs Successful]
, StarNetEffectiveRate as [Star TIP Net Effective Rate]
-----------------------------
, [Quality TIPs Opportunity] as [Quality TIP Opportunities]
, [Quality Completed TIPs] as [Quality TIPs Completed]
, [Quality Successful TIPs] as [Quality TIPs Successful]
, QualityNetEffectiveRate as [Quality TIP Net Effective Rate]
-----------------------------
, CMROpportunity as [CMR Opportunities]
, CMROffered as [CMR Offered]
, completedCMRs as [CMR Completed]
, percentCMRcompletion as [CMR Completion Rate]
-----------------------------
, EligiblePatient as [Eligible Patients]
, claimSubmitted as [Claims Submitted]
, case when sc.costcdf = 0 then '0' else cast(cast(sc.costcdf as decimal (9,4)) as varchar) end as [Cost Score]
, case when sc.starcdf = 0 then '0' else cast(cast(sc.starcdf as decimal (9,4)) as varchar) end as [Star Score]
, case when sc.qualitycdf = 0 then '0' else cast(cast(sc.qualitycdf as decimal (9,4)) as varchar) end as [Quality Score]
, case when sc.cmrcdf = 0 then '0' else cast(cast(sc.cmrcdf as decimal (9,4)) as varchar) end as [CMR Score]
, case when co.composite  <> '0' then cast(cast(round(co.composite,4) as decimal (9,4)) as varchar) 
	   when  r.costpt + r.starpt + r.qualitypt + r.cmrpt = 0 then 'N/A'
		when r.costpt + r.starpt + r.qualitypt + r.cmrpt <> 0  and co.costcdf + co.starcdf + co.qualitycdf + co.cmrcdf = 0 then '0'
	   end as [Composite Score]
, case when PERCENTRANK >=0.85 then '4'
			when PERCENTRANK >=0.5 and PERCENTRANK <0.85 then '3'
			when PERCENTRANK >=0.15 and PERCENTRANK <0.5 then '2'
			when PERCENTRANK >0 and PERCENTRANK <0.15 then '1'
			when PERCENTRANK =0 and r.costpt + r.starpt + r.qualitypt + r.cmrpt <> 0  then '0'
			else 'N/A' end as [Performance Score]
, case when pr.percentrank <> 0 then cast(cast(pr.percentrank*100 as decimal(5,1)) as varchar) + '%' 
		when  r.costpt + r.starpt + r.qualitypt + r.cmrpt = 0 then 'N/A'
		else '0' end as [Percentile Rank]
from #report r
join #score sc on sc.centerid = r.centerid
join #composite co on co.centerid = r.centerid
join #percentrank pr on pr.centerid = r.centerid 


end




