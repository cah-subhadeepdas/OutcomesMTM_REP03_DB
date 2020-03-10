









CREATE proc [dbo].[S_ReportCard_BROOKSHIRE_PHARMACY] 
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





select distinct ph.centerid --*
, ph.NCPDP_NABP --*
, replace(replace(replace(ph.centername,char(9),''),char(10),''),char(13),'') as [PharmacyName] --*
, ph.addressState as [Pharmacy State]--*
-------------------------
, pr.Relationship_Type --*
, pr.Relationship_ID --*
, pr.Relationship_ID_Name --*
--, pr.parent_organization_ID
--, pr.parent_organization_Name
---------------------
, isnull(ta.[TIP Opportunities],0) as [TIP Opportunities] --*
, isnull(ta.[Completed TIPs],0) as [Completed TIPs]--*
--, isnull(ta.TIPCompletionRate,0) as TIPCompletionRate
, isnull(ta.[Successful TIPs],0) as [Successful TIPs]--*
--, isnull(ta.TIPSuccessfulRate,0)  as TIPSuccessfulRate
, isnull(ta.NetEffectiveRate,0) as NetEffectiveRate--*
---------------
, isnull(ta.[Cost TIPs Opportunity],0) as [Cost TIPs Opportunity]--*
, isnull(ta.[Cost Completed TIPs],0) as [Cost Completed TIPs]--*
--, isnull(ta.CostTIPCompletionRate,0) as CostTIPCompletionRate
, isnull(ta.[Cost Successful TIPs],0) as [Cost Successful TIPs]--*
--, isnull(ta.CostTIPSuccessfulRate,0) as CostTIPSuccessfulRate
, isnull(ta.CostNetEffectiveRate,0) as CostNetEffectiveRate--*
----------------
, isnull(ta.[Star TIPs Opportunity],0) as [Star TIPs Opportunity]--*
, isnull(ta.[Star Completed TIPs],0) as [Star Completed TIPs]--*
--, isnull(ta.StarTIPCompletionRate,0) as StarTIPCompletionRate
, isnull(ta.[Star Successful TIPs],0) as [Star Successful TIPs]--*
--, isnull(ta.StarTIPSuccessfulRate,0) as StarTIPSuccessfulRate
, isnull(ta.StarNetEffectiveRate,0) as StarNetEffectiveRate--*
-------------------------
, isnull(ta.[Quality TIPs Opportunity],0) as [Quality TIPs Opportunity]--*
, isnull(ta.[Quality Completed TIPs] ,0) as [Quality Completed TIPs]--*
--, isnull(ta.QualityTIPCompletionRate ,0) as QualityTIPCompletionRate
, isnull(ta.[Quality Successful TIPs],0) as [Quality Successful TIPs]--*
--, isnull(ta.QualityTIPSuccessfulRate,0) as QualityTIPSuccessfulRate
, isnull(ta.QualityNetEffectiveRate,0) as QualityNetEffectiveRate--*
-----------------------
,isnull(cm.CMROpportunity ,0) as CMROpportunity --*
,isnull(cm.CMROffered ,0) as CMROffered--*
--,isnull(cm.percentCMRoffered,0) as percentCMRoffered
,isnull(cm.completedCMRs ,0) as completedCMRs--*
--,isnull(cm.percentCMRcompletion,0) as percentCMRcompletion
,isnull(cm.CMRNetEffectiveRate,0) as CMRNetEffectiveRate--*
---------------------------
, isnull(pm.EligiblePatient,0) as EligiblePatient--*
, isnull(cl.claimSubmitted,0) as claimSubmitted--*
--, isnull(cl.DTPClaims,0) as DTPClaims
/*, isnull(cl.DTPpercentage,0) as DTPpercentage
, isnull(cl.ValidationOpportunity ,0) as ValidationOpportunity
, isnull(cl.ValidationSuccess,0) as ValidationSuccess
----------------------------
, isnull(cl.[PatientConsults],0) as [PatientConsults]
, isnull(cl.[PatientRefusals],0) as [PatientRefusals]
, isnull(cl.[PatientUnableToReach],0)  as  [PatientUnableToReach]
, isnull(cl.PatientSuccessRate,0) as PatientSuccessRate
------------------------------
, isnull(cl.[PrescriberConsults],0) as [PrescriberConsults]
, isnull(cl.[PrescriberRefusals],0) as [PrescriberRefusals]
, isnull(cl.[PrescriberUnableToReach],0) as [PrescriberUnableToReach]
, isnull(cl.PrescriberSuccessRate ,0) as PrescriberSuccessRate*/
--select count(*) -- 82599
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
		from outcomesMTM.dbo.tipActivityCenterReport tacr with (nolock)
		left join OutcomesMTM.staging.tipresultstatus trs with (nolock)        /*TC-2117*/
		on tacr.tipresultstatusid=trs.tipresultstatusid
        left join OutcomesMTM.staging.tipresultstatuscenter ts with (nolock)
        on trs.tipresultstatusid=ts.tipresultstatusid
		left Join [dbo].[claim] c on trs.claimid=c.claimID
		
		
			
		where 1=1
		

		and (
			      ( tacr.primaryPharmacy = 1 --or (tacr.primaryPharmacy = 0 and case when c.mtmServiceDT between @BEGIN and @END AND c.statusID in (2, 6) and c.resultTypeID in (5, 6, 12, 18) AND c.centerID = ts.centerID THEN 1 ELSE 0 END = 1)) -- add this code after or condition
			--and rp.primaryPharmacy = 1 
                --30 day include
                   AND (
                         (tacr.activethru IS NULL AND DATEDIFF(DAY, CASE WHEN tacr.activeasof > @BEGIN THEN tacr.activeasof ELSE @BEGIN END, @END) >= 30)
                        OR
                         (tacr.activethru IS NOT NULL AND DATEDIFF(DAY, CASE WHEN tacr.activeasof > @BEGIN THEN tacr.activeasof ELSE @BEGIN END, CASE WHEN tacr.activethru > @END THEN @END ELSE tacr.activethru END) >= 30)
                        OR
                         ((C.mtmServiceDT BETWEEN @BEGIN AND @END) --AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6))
                        AND
                         (ts.centerID = c.centerid))
					   )
					)
					or



					(
					  tacr.primaryPharmacy =0 
					  and 	  (c.mtmServiceDT BETWEEN @BEGIN AND @END) --AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6))
                        AND
                        (ts.centerID = c.centerid)
					
					 )
				)
				





		--and tacr.primaryPharmacy = 1 
		--and (tacr.primaryPharmacy = 1 or tacr.[Completed TIPs] = 1)
		
		
		
		
		
		
		
		
		
		and tacr.policyid not in (574, 575, 298)
		and tacr.activethru >= @BEGIN
		and tacr.activeasof <= @END
		--AND ((tacr.activethru <= @END AND (tacr.[completed tips] = 1 or tacr.[unfinished tips] = 1 or tacr.[review/resubmit tips] = 1 or tacr.[rejected tips] = 1)) 
		--OR datediff(day, case when tacr.activeasof > @BEGIN then tacr.activeasof else @BEGIN end, case when tacr.activethru > @END then @END else tacr.activethru end) > 30)
	) ta
	where 1=1
	and ta.Rank = 1
	group by ta.centerID

) ta on ta.centerid = ph.centerID
left join (		

	select pm.centerid, count(distinct pt.patientID) as [EligiblePatient]
	from outcomesMTM.dbo.patientMTMCenterDim pm with (nolock)
	join (

		select distinct pt.patientID
		--select count(distinct pt.patientID)
		from outcomesMTM.dbo.patientDim pt with (nolock)
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
		from outcomesMTM.dbo.ClaimActivityReport c with (nolock)
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
	, case when count(distinct u.PatientID) = 0 then 0 else cast((cast(sum(u.CMRCompleted) as decimal))/(cast(count(distinct u.PatientID) as decimal)) as decimal(5,2)) end as [CMRNetEffectiveRate]	
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
            from vw_CMRActivityReport rp with (nolock)
            join patientDim pd with (nolock) on pd.patientKey = rp.patientKey
            join policy p  with (nolock) on p.policyID = rp.policyID
            join pharmacy ph  with (nolock) on ph.centerID = rp.centerID
            left join chain c  with (nolock) on c.chainID = rp.chainID
		     where 1=1
            AND isNull(rp.activethru, '99991231') >= @BEGIN
            AND rp.activeasof <= @END
			and (
			      ( rp.primaryPharmacy = 1 --or (rp.primaryPharmacy = 0 and case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6, 12, 18) AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END = 1)) -- add this code after or condition
			--and rp.primaryPharmacy = 1 
                --30 day include
                   AND (
                         (rp.activethru IS NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @BEGIN THEN rp.activeasof ELSE @BEGIN END, @END) >= 30)
                        OR
                         (rp.activethru IS NOT NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @BEGIN THEN rp.activeasof ELSE @BEGIN END, CASE WHEN rp.activethru > @END THEN @END ELSE rp.activethru END) >= 30)
                        OR
                         ((rp.mtmServiceDT BETWEEN @BEGIN AND @END) --AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6))
                        AND
                         (rp.claimcenterID = rp.centerid))
					   )
					)
					or

					(
					  rp.primaryPharmacy =0 and 
					  (rp.mtmServiceDT BETWEEN @BEGIN AND @END) --AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6))
                        AND
                        (rp.claimcenterID = rp.centerid)
					
					 )
				)








	) u
	where 1 = 1
	and u.rank = 1

	group by centerID, centerName						

) cm on cm.centerid = ph.centerID
where 1=1
and np.Active = 1
and Relationship_ID='453'
order by ph.centerID








End

-- Exec [S_ReportCard_BROOKSHIRE_PHARMACY]