




CREATE proc [dbo].[S_PublixWeeklyOpportunitySummary] 
as 
begin 



DECLARE @BEGIN VARCHAR(10)
DECLARE @END VARCHAR(10)
SET @BEGIN =  case when month(getdate()) = 1 then cast(year(getdate()) - 1 as varchar(4)) + '0101' else cast(year(getdate()) as varchar(4)) + '0101' end  --// Beginning of year (if current month is Jan. then beginning of last year)		
SET @END =  cast(GETDATE() as date)	 		--to date

DECLARE @BEGINWEEK VARCHAR(10)
DECLARE @ENDWEEK VARCHAR(10)
SET @BEGINWEEK =  cast(DATEADD(d,-7,GETDATE())as date) --// Beginning of week		
SET @ENDWEEK =  cast(GETDATE()as date)	--end of last week




select distinct ph.NCPDP_NABP
, replace(replace(replace(ph.centername,char(9),''),char(10),''),char(13),'') as [PharmacyName]
, isnull(cm.CMROpportunity,0) as [CMR Opportunities YTD]
, isnull(cm.[CMR Opportunities Weekly],0) 	as [CMR Opportunities Weekly]	
, isnull(cm.completedCMRs,0)  as [CMRs Delivered YTD]
, isnull(cm.[CMRs Delivered Weekly],0)  as [CMRs Delivered Weekly]
, isnull(ta.[TIP Opportunities YTD],0)  as [TIP Opportunities YTD]
, isnull(ta.[TIP Opportunities Weekly],0)  as [TIP Opportunities Weekly]
, isnull(ta.[Successful TIPs YTD],0)  as [Successful TIPs YTD]
, isnull(ta.[Successful TIPs Weekly],0)  as [Successful TIPs Weekly]
--select count(*) -- 82599
from outcomesMTM.dbo.pharmacy ph
join OutcomesMTM.dbo.NCPDP_Provider np on np.NCPDP_Provider_ID = ph.NCPDP_NABP
join (

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
	and pr.Relationship_ID = '302'

) pr on pr.centerid = ph.centerid and pr.[Rank] = 1
left join (

	select ta.centerid
	, cast(sum(ta.[TIP Opportunities]) as decimal) as [TIP Opportunities YTD]
	, cast(sum(ta.[Successful TIPs]) as decimal) as [Successful TIPs YTD]
	, cast(sum(ta.[TIP Opportunities Weekly]) as decimal)as [TIP Opportunities Weekly]
	, cast(sum(ta.[Successful TIPs Weekly]) as decimal)as [Successful TIPs Weekly]
	from (	
		select row_number() over (partition by tacr.tipresultstatusID order by tacr.[Completed TIPs] desc, tacr.[Unfinished TIPs] desc, tacr.[Review/resubmit Tips] desc, tacr.[Rejected Tips] desc, tacr.[currently active] desc, tacr.[withdrawn] desc, tacr.tipresultstatuscenterID desc) as [Rank] 
		, tacr.centerid
		, tacr.[TIP Opportunities]
		, CASE WHEN tacr.activethru > @END THEN 0 ELSE tacr.[Successful TIPs] END AS [Successful TIPs]
		, CASE WHEN isnull(tacr.activethru,@ENDWEEK) NOT BETWEEN @BEGINWEEK AND @ENDWEEK THEN 0 ELSE tacr.[TIP Opportunities] END AS [TIP Opportunities Weekly]
		, CASE WHEN tacr.activethru NOT BETWEEN @BEGINWEEK AND @ENDWEEK THEN 0 ELSE tacr.[Successful TIPs] END AS [Successful TIPs Weekly]
		from outcomesMTM.dbo.tipActivityCenterReport tacr
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

) ta on ta.centerid = pr.centerID
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

) pm on pm.centerid = pr.centerid
left join (
	
	select centerID
	, centerName						
	, count(distinct u.PatientID) as CMROpportunity
	, sum(u.[CMR Opportunities Weekly]) as [CMR Opportunities Weekly]			
	, sum(u.CMRCompleted) as completedCMRs
	, sum(u.[CMRs Delivered Weekly]) as [CMRs Delivered Weekly]
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
		, case when isnull(rp.activethru, '99991231') >= @BEGINWEEK AND isNull(rp.mtmServiceDT, @ENDWEEK) BETWEEN @BEGINWEEK AND @ENDWEEK THEN 1 ELSE 0 END AS [CMR Opportunities Weekly]
		, case when isnull(rp.activethru, '99991231') >= @BEGINWEEK AND rp.mtmServiceDT between @BEGINWEEK and @ENDWEEK AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 END as [CMRs Delivered Weekly]
        , case when rp.outcomesTermDate between @BEGIN and @END AND isNull(rp.mtmServiceDT, '99991231') not between @BEGIN and @END THEN 1 ELSE 0 END as Termed
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6, 12) AND rp.chainID = rp.claimChainID  THEN 1 ELSE 0 END as CMROffered
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 END as CMRCompleted
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID = 12 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as PatientRefused
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID = 18 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as UnableToReachPatient
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID = 5 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as CMRWithDrugProblems
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID = 6 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as CMRWithoutDrugProblems
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.cmrDeliveryTypeID = 1 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as CMRFace2Face
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.cmrDeliveryTypeID = 2 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as CMRPhone
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.cmrDeliveryTypeID = 3 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 end as CMRTelehealth
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.chainID <> rp.claimChainID THEN 1 ELSE 0 END as CMRMissed
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID = 5 AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 END as CMRRejected
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID = 2 AND rp.chainID = rp.claimChainID AND rp.resultTypeID in (5, 6) THEN 1 ELSE 0 END as CMRPendingApproval
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID = 6 and rp.paid = 0 AND rp.chainID = rp.claimChainID AND rp.resultTypeID in (5, 6) THEN 1 ELSE 0 END as CMRApprovedPendingPayment
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID = 6 and rp.paid = 1 AND rp.chainID = rp.claimChainID AND rp.resultTypeID in (5, 6) THEN 1 ELSE 0 END as CMRApprovedPaid
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.Language = 'EN' AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 END EnglishSPT
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.Language = 'SP' AND rp.chainID = rp.claimChainID THEN 1 ELSE 0 END SpanishSPT
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.chainID = rp.claimChainID THEN cast(rp.postHospitalDischarge as int) ELSE 0 END as postHospitalDischarge
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
	group by centerID, centerName						

) cm on cm.centerid = pr.centerID
where 1=1
and np.Active = 1
--order by ph.centerID

end





