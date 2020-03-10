





CREATE procedure [dbo].[S_PublixMonthlyOpportunitySummary] 
as 
begin 




DECLARE @BEGIN VARCHAR(10)
DECLARE @END VARCHAR(10)
SET @BEGIN = CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0)AS DATE) --First day of previous month
SET @END =  CAST(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)AS DATE)  		--Last day of previous month



select distinct ph.NCPDP_NABP
, replace(replace(replace(ph.centername,char(9),''),char(10),''),char(13),'') as [Pharmacy Name]
, isnull(ta.[TIP Opportunities],0)  as [TIP Opportunities]
, isnull(ta.[Successful TIPs],0)  as [Successful TIPs]
, case when isnull(ta.[TIP Opportunities],0) = 0 then 0 else cast(cast(ta.[Successful TIPs] as decimal)/cast(ta.[TIP Opportunities] as decimal) as decimal(5,2)) end as [TIP NER]
, isnull(cm.CMROpportunity,0) as [CMR Opportunities]
, isnull(cm.completedCMRs,0)  as [Completed CMRs]
, case when isnull(cm.CMROpportunity,0) = 0 then 0 else cast(cast(cm.completedCMRs as decimal)/cast(cm.CMROpportunity as decimal) as decimal(5,2)) end as [CMR Completion Rate]
, isnull(cl.claimSubmitted,0) as [Pharmacist Initiated Claims]
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
	, cast(sum(ta.[TIP Opportunities]) as decimal) as [TIP Opportunities]
	, cast(sum(ta.[Successful TIPs]) as decimal) as [Successful TIPs]
	from (	
		select row_number() over (partition by tacr.tipresultstatusID order by tacr.[Completed TIPs] desc, tacr.[Unfinished TIPs] desc, tacr.[Review/resubmit Tips] desc, tacr.[Rejected Tips] desc, tacr.[currently active] desc, tacr.[withdrawn] desc, tacr.tipresultstatuscenterID desc) as [Rank] 
		, tacr.centerid
		, tacr.[TIP Opportunities]
		, CASE WHEN tacr.activethru > @END THEN 0 ELSE tacr.[Successful TIPs] END AS [Successful TIPs]
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
	, sum(u.CMRCompleted) as completedCMRs
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
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6, 12) AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'')  THEN 1 ELSE 0 END as CMROffered
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'') THEN 1 ELSE 0 END as CMRCompleted
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID = 12 AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'') THEN 1 ELSE 0 end as PatientRefused
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID = 18 AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'') THEN 1 ELSE 0 end as UnableToReachPatient
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID = 5 AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'') THEN 1 ELSE 0 end as CMRWithDrugProblems
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID = 6 AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'') THEN 1 ELSE 0 end as CMRWithoutDrugProblems
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.cmrDeliveryTypeID = 1 AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'') THEN 1 ELSE 0 end as CMRFace2Face
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.cmrDeliveryTypeID = 2 AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'') THEN 1 ELSE 0 end as CMRPhone
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.cmrDeliveryTypeID = 3 AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'') THEN 1 ELSE 0 end as CMRTelehealth
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.chainID <> rp.claimChainID THEN 1 ELSE 0 END as CMRMissed
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID = 5 AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'') THEN 1 ELSE 0 END as CMRRejected
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID = 2 AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'') AND rp.resultTypeID in (5, 6) THEN 1 ELSE 0 END as CMRPendingApproval
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID = 6 and rp.paid = 0 AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'') AND rp.resultTypeID in (5, 6) THEN 1 ELSE 0 END as CMRApprovedPendingPayment
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID = 6 and rp.paid = 1 AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'') AND rp.resultTypeID in (5, 6) THEN 1 ELSE 0 END as CMRApprovedPaid
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.Language = 'EN' AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'') THEN 1 ELSE 0 END EnglishSPT
            , case when rp.mtmServiceDT between @BEGIN and @END AND rp.Language = 'SP' AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'') THEN 1 ELSE 0 END SpanishSPT
            , case when rp.mtmServiceDT between @BEGIN and @END AND ISNULL(rp.chainID,'') = ISNULL(rp.claimChainID,'') THEN cast(rp.postHospitalDischarge as int) ELSE 0 END as postHospitalDischarge
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
left join (
			select v.[centerid]
			, sum(v.claimSubmitted) as claimSubmitted
			from (
				select c.claimID
				, ph.centerid
				, 1 as claimSubmitted
				from outcomesMTM.dbo.ClaimActivityReport c
				join OutcomesMTM.dbo.pharmacy ph on ph.NCPDP_NABP = c.[MTM CenterID]
				where 1=1
				and c.mtmServiceDT between @BEGIN and @END
				and c.statusID not in (3,5)
				and c.policyID not in (574 ,575 ,298)
				and c.PharmacistClaim = 1
				and c.resulttypeID not in (12,13,16,18)
			) v
	where 1=1
	group by v.[centerid]

) cl on cl.[centerid] = pr.centerid
where 1=1
and np.Active = 1
--order by ph.centerID

end






