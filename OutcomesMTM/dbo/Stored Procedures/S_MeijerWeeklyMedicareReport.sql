

CREATE procedure [dbo].[S_MeijerWeeklyMedicareReport]
as
begin



declare @BEGIN date = dateadd(yy,DATEDIFF(yy,0,getdate()),0) -- first day of the year
declare @END date = getdate()
declare @LASTWEEKBEGIN date = dateadd(wk,datediff(wk,6,getdate()),3) --last Thursday
declare @LASTWEEKEND date = dateadd(wk,datediff(wk,6,getdate()),9) -- this Wednesday

select  NCPDP = NCPDP_NABP																			
	  , [Pharmacy Name]= replace(replace(replace(ph.centername,char(9),''),char(10),''),char(13),'')			
	  , [Open Primary CMR Opps] = isnull(needcmr,0)																
	  , [Total CMR Opportunities YTD] = isnull(cm.CMROpportunity,0)														
	  , [Offered Last Week] = isnull(CMROffered,0)														
	  , [Offer Rate LW] = isnull(case when needcmr+CMROffered = 0 then 0 else cast((cast(CMROffered as decimal))/(cast(needcmr+CMROffered as decimal)) as decimal(5,2)) end,0) 
	  , [Successful CMRs YTD] = isnull(cm.successfulCMR,0)															
	  , [Total CMR Completion Rate] = isnull(case when cm.successfulCMR = 0 then 0 else cast((cast(cm.successfulCMR as decimal))/(cast(cm.CMROpportunity as decimal)) as decimal(5,2)) end,0) 
	  , [TIP Opportunity YTD] = isnull([TIP Opportunities],0)												
	  , [Completed TIPs YTD] = isnull([Completed TIPs],0)														
	  , [TIP Completion Rate] = isnull(TIPCompletionRate,0)													
	  , [Successful TIPs YTD] = isnull([Successful TIPs],0)													
	  , [Successful TIP Rate] = isnull(TIPSuccessfulRate,0)													
	  , [TIP Net Effective Rate] = isnull(NetEffectiveRate,0)															
	  , [Medicare CMR Opportunities YTD] = isnull(cm1.CMROpportunity,0)																										
	  , [Medicare Successful CMR YTD] = isnull(cm1.completedCMRs,0)												
	  , [Medicare CMR Completion Rate] = isnull(case when cm1.CMROpportunity = 0 then 0 else cast((cast(cm1.completedCMRs as decimal))/(cast(cm1.CMROpportunity as decimal)) as decimal(5,2)) end,0)
	  , [Medicare Primary CMR Opportunities YTD] = isnull(cm1.PrimaryCMROpportunity,0)												
	  , [Medicare Successful Primary CMRs YTD] = isnull(cm1.PrimarycompletedCMRs,0)												
	  , [Medicare Primary CMR Completion Rate] = isnull(case when cm1.PrimaryCMROpportunity = 0 then 0 else cast((cast(cm1.primarycompletedCMRs as decimal))/(cast(cm1.PrimaryCMROpportunity as decimal)) as decimal(5,2)) end,0) 
	  , [Primary TIP Opportunity YTD] = isnull([Primary TIP Opportunities],0)											
	  , [Primary Completed TIPs YTD] = isnull([Primary Completed TIPs],0)													
	  , [Primary TIP Completion Rate] = isnull(primaryTIPCompletionRate,0)												
	  , [Successful Primary TIPs YTD] = isnull([Primary Successful TIPs],0)											
	  , [Successful Primary TIP Rate] = isnull(primaryTIPSuccessfulRate,0)												
from outcomesmtm.dbo.pharmacy ph
join outcomesmtm.dbo.pharmacychain pc on pc.centerid = ph.centerid
join outcomesmtm.dbo.chain ch on ch.chainid = pc.chainid 
left join ( 
		
		select count(patientid_all) as needcmr
				,centerid 
		from (  
				select distinct pt.patientid_all,pt.policyid,m.centerid
				from OutcomesMTM.dbo.patientdim pt
				join outcomesmtm.dbo.Policy p on pt.PolicyID = p.PolicyID
				join OutcomesMTM.dbo.patientmtmcenterdim m on pt.PatientID = m.patientid
				join outcomesmtm.dbo.pharmacy ph on ph.centerid = m.centerid 
				join outcomesmtm.dbo.pharmacychain pc on pc.centerid = ph.centerid
				join outcomesmtm.dbo.chain ch on ch.chainid = pc.chainid 
				where 1=1
				and chaincode = '213'
				and pt.isCurrent = 1
				and m.activethru is null
				and pt.CMReligible = 1
				and m.primaryPharmacy = 1
				and not exists (select 1 from
								[aocwpapsql02].outcomes.dbo.patientCMR c
								where c.CMRcompleted = 1
								and c.patientid = pt.PatientID) 
						)pt
		group by centerid )pt  on pt.centerid = ph.centerid
left join (
	
	select centerID
	, centerName						
	, count(distinct u.PatientID) as CMROpportunity
	, sum(u.CMROffered) as CMROffered				
	, sum(u.SuccessfulCMR) as successfulCMR
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
        , case when rp.mtmServiceDT between @LASTWEEKBEGIN and @LASTWEEKEND AND rp.statusID in (2, 6) AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'')  THEN 1 ELSE 0 END as CMROffered
        , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'') THEN 1 ELSE 0 END as SuccessfulCMR
        , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.chainID = rp.claimChainID AND primarypharmacy = 1 THEN 1 ELSE 0 END as primarySuccessfulCMR
            from vw_CMRActivityReport rp
            join patientDim pd on pd.patientKey = rp.patientKey
            join policy p on p.policyID = rp.policyID
            join pharmacy ph on ph.centerID = rp.centerID
            left join chain c on c.chainID = rp.chainID
            where 1=1
            AND isNull(rp.activethru, '99991231') >= @BEGIN
            AND rp.activeasof <= @END
			and (rp.primaryPharmacy = 1 or (rp.primaryPharmacy = 0 and case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6, 12, 18) AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END = 1))
                --30 day include
                AND (
                        (rp.activethru IS NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @BEGIN THEN rp.activeasof ELSE @BEGIN END, @END) >= 30)
                        OR
                        (rp.activethru IS NOT NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @BEGIN THEN rp.activeasof ELSE @BEGIN END, CASE WHEN rp.activethru > @END THEN @END ELSE rp.activethru END) >= 30)
                        OR
                        (rp.mtmServiceDT BETWEEN @BEGIN AND @END)
                        AND
                        (rp.claimcenterID = rp.centerid)
                    )

	) u
	where 1 = 1
	and u.rank = 1
	group by centerID,centername
	) cm on cm.centerid = ph.centerID	
left join (

	select ta.centerid
	, cast(sum(ta.[TIP Opportunities]) as decimal) as [TIP Opportunities]
	, cast(sum(ta.[Completed TIPs]) as decimal) as [Completed TIPs]
	, isnull(cast((cast(sum(ta.[Completed TIPs]) as decimal)/nullif(cast(sum(ta.[TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0) as TIPCompletionRate
	, cast(sum(ta.[Successful TIPs]) as decimal) as [Successful TIPs]
	, isnull(cast((cast(sum(ta.[Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as TIPSuccessfulRate
	, isnull(cast((cast(sum(ta.[Successful TIPs]) as decimal)/nullif(cast(sum(ta.[TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0) as NetEffectiveRate
	, cast(sum(ta.[primary TIP opportunities]) as decimal) as [Primary TIP Opportunities]
	, cast(sum(ta.[Primary Completed TIPS]) as decimal) as [Primary Completed TIPs]
	, isnull(cast((cast(sum(ta.[Primary Completed TIPS]) as decimal)/nullif(cast(sum(ta.[primary TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0) as primaryTIPCompletionRate
	, cast(sum(ta.[Primary Successful TIPS]) as decimal) as [Primary Successful TIPs]
	, isnull(cast((cast(sum(ta.[Primary Successful TIPS]) as decimal)/nullif(cast(sum(ta.[primary Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as primaryTIPSuccessfulRate

	from (	
		select row_number() over (partition by tacr.tipresultstatusID order by tacr.[Completed TIPs] desc, tacr.[Unfinished TIPs] desc, tacr.[Review/resubmit Tips] desc, tacr.[Rejected Tips] desc, tacr.[currently active] desc, tacr.[withdrawn] desc, tacr.tipresultstatuscenterID desc) as [Rank] 
		, tacr.centerid
		, tacr.[TIP Opportunities]
		, case when primaryPharmacy =1 then tacr.[TIP Opportunities] else 0 end as [primary TIP opportunities]
		, CASE WHEN tacr.activethru > @END THEN 0 ELSE tacr.[Completed TIPs] END AS [Completed TIPs]
		, CASE WHEN tacr.activethru > @END THEN 0 ELSE tacr.[Successful TIPs] END AS [Successful TIPs]
		, CASE WHEN tacr.activethru > @END OR tacr.primaryPharmacy = 0 THEN 0 ELSE tacr.[Completed TIPs] END AS [Primary Completed TIPS]
		, CASE WHEN tacr.activethru > @END OR tacr.primarypharmacy = 0 THEN 0 ELSE tacr.[Successful TIPs] END AS [Primary Successful TIPS]
		from outcomesMTM.dbo.tipActivityCenterReport tacr
		where 1=1
		and (tacr.primaryPharmacy = 1 or tacr.[Completed TIPs] = 1)
		and tacr.activethru >= @BEGIN
		and tacr.activeasof <= @END
		AND ((tacr.activethru <= @end AND (tacr.[completed tips] = 1 or tacr.[unfinished tips] = 1 or tacr.[review/resubmit tips] = 1 or tacr.[rejected tips] = 1)) 
			OR datediff(day, case when tacr.activeasof > @begin then tacr.activeasof else @begin end, case when tacr.activethru > @end then @end else tacr.activethru end) > 30)
	) ta
	where 1=1
	and ta.Rank = 1
	group by ta.centerID

) ta on ta.centerid = ph.centerID
left join (
	
	select centerID
	, centerName						
	, count(distinct u.PatientID) as CMROpportunity		
	, sum(u.CMRCompleted) as completedCMRs
	, sum(u.primaryopp) as PrimaryCMROpportunity
	, sum(u.primaryCMRCompleted) as primarycompletedCMRs
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
		, case when primaryPharmacy = 1 then 1 else 0 end as primaryopp
        , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6, 12) AND rp.chainID = rp.claimChainID  THEN 1 ELSE 0 END as CMROffered
        , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 END as CMRCompleted
		, case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) and primarypharmacy = 1 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 END as primaryCMRCompleted
            from vw_CMRActivityReport rp
            join patientDim pd on pd.patientKey = rp.patientKey
            join policy p on p.policyID = rp.policyID
            join pharmacy ph on ph.centerID = rp.centerID
            left join chain c on c.chainID = rp.chainID
            where 1=1
			AND p.IsMedicarePolicy = 1
            AND isNull(rp.activethru, '99991231') >= @BEGIN
            AND rp.activeasof <= @END
			and (rp.primaryPharmacy = 1 or (rp.primaryPharmacy = 0 and case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6, 12, 18) AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END = 1))
                --30 day include
                AND (
                        (rp.activethru IS NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @BEGIN THEN rp.activeasof ELSE @BEGIN END, @END) >= 30)
                        OR
                        (rp.activethru IS NOT NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @BEGIN THEN rp.activeasof ELSE @BEGIN END, CASE WHEN rp.activethru > @END THEN @END ELSE rp.activethru END) >= 30)
                        OR
                        (rp.mtmServiceDT BETWEEN @BEGIN AND @END)
                        AND
                        (rp.claimcenterID = rp.centerid)
                    )

	) u
	where 1 = 1
	and u.rank = 1
	group by centerID, centerName						

) cm1 on cm1.centerid = ph.centerID
where 1=1
and chaincode = '213'
and ph.active = 1
order by NCPDP_NABP


End 

