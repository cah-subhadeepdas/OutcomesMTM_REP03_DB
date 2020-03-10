
/*
TC-2623 ---  Subha Das	--- 1/24/2019 ---	Updated the logic to pull only primary patients . Also modified the Begindate and EndDate logic for the automated report.

*/ 



CREATE proc [dbo].[S_ReportCard_Pharmacy_CMR_Alberstons] 
as 
begin 



DECLARE @BEGIN VARCHAR(10)
DECLARE @END VARCHAR(10)


----Adhoc request for last calender year
--SET @BEGIN =  cast(cast(year(getdate()) - 1 as varchar(4)) + '-01-01' as date)
--SET @END =  cast(cast(year(getdate()) - 1 as varchar(4)) + '-12-31' as date)

--Automated Job Run properties (current year)
SET @BEGIN =  cast(cast(year(getdate())  as varchar(4)) + '-01-01' as date)	
SET @END =  cast(getdate() as date)



select distinct ph.centerid
, ph.NCPDP_NABP
, replace(replace(replace(ph.centername,char(9),''),char(10),''),char(13),'') as [PharmacyName]
, ph.addressState as [Pharmacy State]
-------------------------
, pr.Relationship_Type
, pr.Relationship_ID
, pr.Relationship_ID_Name
, pr.parent_organization_ID
, pr.parent_organization_Name
---------------------
, cm.CMROpportunity
, cm.CMROffered
, cm.percentCMRoffered
, cm.completedCMRs
, cm.percentCMRcompletion
, cm.CMRNetEffectiveRate
---------------------------
--select count(*) -- 82599
from outcomesMTM.dbo.pharmacy ph
join OutcomesMTM.dbo.pharmacychain pc on pc.centerid = ph.centerid
--JOIN [OutcomesMTM].[dbo].[patientPrimaryPharmacyDim] ppp  ON pc.centerid = ppp.centerid and ppp.primarypharmacy = 1
join OutcomesMTM.dbo.Chain ch on ch.chainid	 = pc.chainid
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
	, isnull(cast((cast(sum(ta.[Completed TIPs]) as decimal)/nullif(cast(sum(ta.[TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0) as TIPCompletionRate
	, cast(sum(ta.[Successful TIPs]) as decimal) as [Successful TIPs]
	, isnull(cast((cast(sum(ta.[Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as TIPSuccessfulRate
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
	, sum(v.DTPClaims) as DTPClaims
	, isnull(cast((cast(sum(v.DTPClaims) as decimal)/nullif(cast(sum(v.claimSubmitted) as decimal), 0)) as decimal (5,2)), 0) as [DTPpercentage]
	, sum(v.[ValidationOpportunity]) as [ValidationOpportunity]
	, sum(v.[ValidationSuccess]) as [ValidationSuccess]
	, sum(v.[PatientConsults]) as [PatientConsults]
	, sum(v.[PatientRefusals]) as [PatientRefusals]
	, sum(v.[PatientUnableToReach]) as [PatientUnableToReach]
	, isnull(cast((cast(sum(v.[PatientRefusals]) as decimal) + cast(sum(v.[PatientUnableToReach]) as decimal))/ nullif(cast(sum(v.[PatientConsults]) as decimal), 0) as decimal (5,2)), 0) as [PatientSuccessRate]
	, sum(v.[PrescriberConsults]) as [PrescriberConsults]
	, sum(v.[PrescriberRefusals]) as [PrescriberRefusals]
	, sum(v.[PrescriberUnableToReach]) as [PrescriberUnableToReach]
	, isnull(cast((cast(sum(v.[PrescriberRefusals]) as decimal) + cast(sum(v.[PrescriberUnableToReach]) as decimal))/ nullif(cast(sum(v.[PrescriberConsults]) as decimal), 0) as decimal (5,2)), 0) as [PrescriberSuccessRate]
	from (
		select c.claimID
		, c.[MTM CenterID]
		, 1 as claimSubmitted
		, case when c.resulttypeID not in (12, 13, 16, 18) and c.actiontypeID <> 3 then 1 else 0 end as [DTPClaims]
		, case when c.validated is not null then 1 else 0 end as [ValidationOpportunity]
		, case when c.validated = 1 then 1 else 0 end as [ValidationSuccess]
		, case when c.actiontypeID in (1, 2, 3, 17) then 1 else 0 end as [PatientConsults]
		, case when c.actiontypeID in (1, 2, 3, 17) and c.resulttypeID = 12 then 1 else 0 end as [PatientRefusals]
		, case when c.actiontypeID in (1, 2, 3, 17) and c.resulttypeID = 18 then 1 else 0 end as [PatientUnableToReach]
		, case when c.actiontypeID = 4 then 1 else 0 end as [PrescriberConsults]
		, case when c.actiontypeID = 4 and c.resulttypeID = 13 then 1 else 0 end as [PrescriberRefusals]
		, case when c.actiontypeID = 4 and c.resulttypeID = 16 then 1 else 0 end as [PrescriberUnableToReach]
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
	, case when sum(u.CMROffered) = 0 then 0 else cast((cast(sum(u.CMRCompleted) as decimal))/(cast(sum(u.CMROffered) as decimal)) as decimal(5,2)) end as percentCMRcompletion
	, case when count(distinct u.PatientID) = 0 or sum(u.CMROffered) = 0 then 0 else (cast((cast(sum(u.CMRCompleted) as decimal))/(cast(sum(u.CMROffered) as decimal)) as decimal(5,2)) *	cast((cast(sum(u.CMROffered) as decimal))/(cast(count(distinct u.PatientID) as decimal)) as decimal(5,2))) end as [CMRNetEffectiveRate]	
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
			and (rp.primaryPharmacy = 1 /* or (rp.primaryPharmacy = 0 and case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6, 12, 18) AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END = 1)*/) --only considering primary patients
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

) cm on cm.centerid = ph.centerID
where 1=1
and np.Active = 1
and (ch.chaincode in('929','003','156','301','B62','158','227','282','027','400','C08','319') or ph.NCPDP_NABP in('999507','999511','999512','999517','999572','999573','999574'))
order by ph.centerID

end





