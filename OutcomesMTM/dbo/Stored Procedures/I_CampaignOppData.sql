

 
CREATE   procedure [dbo].[I_CampaignOppData] (@ReportRunDate Date)
AS
BEGIN


--USE [OutcomesMTM]


DECLARE @BEGIN VARCHAR(10)
DECLARE @END VARCHAR(10)
--declare @ReportRunDate date = getdate()
select @BEGIN = cast(('01-01-' + cast(year(@ReportRunDate) as varchar(4)) ) as date)
SET @END = cast(dateadd(month, datediff(month , -1 , @ReportRunDate) - 1, -1) as date) 


truncate table  dbo.CampaignOppData ;

INSERT INTO [dbo].[CampaignOppData]
           ([NCPDP_NABP]
           ,[CampaignName]
           ,[RelationshipName]
           ,[CMROpportunity]
           ,[completedCMRs]
           ,[PrimaryCMRsAvailable]
           ,[CMRsAvailable]
           ,[CMRsScheduled]
           ,[TIP Opportunities]
           ,[TIPs Sucessful]
           ,[TIPs Available (Primary)]
           ,[TIPs Available])
select 
		distinct replace(replace(replace(replace(ph.NCPDP_NABP,char(9),''),char(10),''),char(13),''),' ','') as NCPDP_NABP
		, replace(replace(replace(c.CampaignName,char(9),''),char(10),''),char(13),'') as CampaignName
		, RelationshipName = ''
		, isnull(cm.CMROpportunity,0) as [CMROpportunity]
		, isnull(cm.completedCMRs,0) as [completedCMRs]
		, isnull(a.PrimaryCMRsAvailable,0) as [PrimaryCMRsAvailable]
		, isnull(a.[CMRsAvailable],0) as [CMRsAvailable]
		, isnull(cq.[CMRsScheduled],0) as [CMRsScheduled]
		, isnull(ta.[TIP Opportunities],0) as [TIP Opportunities]
		, isnull(ta.[Successful TIPs],0) as [TIPs Sucessful]
		--, case when c.tipids is not null then pm.PrimaryEligiblePatient else 0 end as [TIPs Available (Primary)]
		--, case when c.tipids is not null then pm.EligiblePatient else 0 end as [TIPs Available]
		, isnull(taa.[Primary Available],0) as [TIPs Available (Primary)]
		, isnull(taa.Available,0) as [TIPs Available]

from	staging.campaign c 
		join (		
				select	pm.centerid
						, count(distinct pt.patientID) as [EligiblePatient]
						, sum(case when isnull(pm.primaryPharmacy, 0) = 1 then 1 else 0 end) as [PrimaryEligiblePatient]
						, c.campaignname
				from	outcomesMTM.dbo.patientMTMCenterDim pm
						join 
							(
								select	distinct pt.patientID
										, pt.PolicyID
										,p.policyname
								from	outcomesMTM.dbo.patientDim pt
										join policy p on P.policyid=pt.policyID
								where	1=1
										and isnull(pt.activethru, '9999-12-31') >= @BEGIN 
										and p.policyid not in (574 ,575 ,298)
										and pt.activeasof <= @END 
										--and pt.policyid=830
							) pt on pt.patientID = pm.patientid
	     
						join staging.campaign c on c.policyid = pt.policyid
				where	1=1
						and isnull(pm.activethru, '9999-12-31') >= @BEGIN
						and pm.activeasof <= @END
				group by pm.centerid, c.campaignname
			) pm on pm.campaignname = c.campaignname
		join outcomesMTM.dbo.pharmacy ph on ph.centerid = pm.centerid
		join OutcomesMTM.dbo.NCPDP_Provider np on np.NCPDP_Provider_ID = ph.NCPDP_NABP
		join outcomesmtm.dbo.ProviderChain pc on pc.NCPDP_Provider_ID = np.NCPDP_Provider_ID
		left join 
				(
					select	centerID
							, c.campaignname				
							, count(distinct u.PatientID) as CMROpportunity			
							, sum(u.CMRCompleted) as completedCMRs
					from 
						(
							select	row_number() over (partition by rp.patientID, rp.centerID, rp.PolicyID 
														order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
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
									, case when rp.outcomesTermDate between @BEGIN and @END AND isNull(rp.mtmServiceDT, '9999-12-31') not between @BEGIN and @END THEN 1 ELSE 0 END as Termed
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
							from	vw_CMRActivityReport rp
									join patientDim pd on pd.patientKey = rp.patientKey
									join policy p on p.policyID = rp.policyID
									join pharmacy ph on ph.centerID = rp.centerID
									left join chain c on c.chainID = rp.chainID
							where	1=1
									AND isNull(rp.activethru, '9999-12-31') >= @BEGIN
									AND rp.activeasof <= @END
									and rp.primaryPharmacy = 1 --or (rp.primaryPharmacy = 0 and case when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6, 12, 18) AND rp.centerID = rp.claimcenterID THEN 1 ELSE 0 END = 1)) -- changed per TC-1621
										--30 day include
									AND (
											(rp.activethru IS NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @BEGIN THEN rp.activeasof ELSE @BEGIN END, @END) >= 30)
											OR
											(rp.activethru IS NOT NULL AND DATEDIFF(DAY, CASE WHEN rp.activeasof > @BEGIN THEN rp.activeasof ELSE @BEGIN END, CASE WHEN rp.activethru > @END THEN @END ELSE rp.activethru END) >= 30)
											OR
											(rp.mtmServiceDT BETWEEN @BEGIN AND @END AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6)) -- changed per tc-1621
											AND
											(rp.claimcenterID = rp.centerid)
										)  
						) u
						join staging.campaign c on c.policyid = u.policyid
					where	1 = 1
							and u.rank = 1
					group by centerID, campaignname				
				) cm on cm.centerid = ph.centerID and cm.campaignname = c.campaignname and c.tipids is null
		left join 
				(
				   select	cmr.campaignname	
						   ,cmr.centerid
						   ,count(distinct cmr.patientid) as [CMRsAvailable]
						   ,sum(case when isnull(cmr.primarypharmacy,0) = 1 then 1 else 0 end) as [PrimaryCMRsAvailable]
				   from(
							select	rp.PatientID
									 , c.campaignname	
									 , rp.centerid
									 , rp.primaryPharmacy
							from	vw_CMRActivityReport rp
									join patientDim pd on pd.patientKey = rp.patientKey
									join policy p on p.policyID = rp.policyID
									join pharmacy ph on ph.centerID = rp.centerID
									join staging.campaign c on c.policyid = rp.policyid
							where	1=1
									and rp.mtmservicedt is null
									and isNull(rp.activethru, '9999-12-31') > @END
									AND rp.activeasof <= @END
						) cmr
					where 1=1
					group by centerID,  campaignname	
					) a on a.campaignname = c.campaignname and a.centerid = ph.centerid and c.tipids is null
		left join	
				(
					select	cq.centerID
							, c.campaignname
							, count(distinct cq.patientid) as [CMRsScheduled]
					from	[staging].[cmrQueue] cq
							join staging.campaign c on c.policyid = cq.policyid
					where	1=1
							and cq.queueTypeID = 2
							and cq.scheduledate  > @END
					group by cq.centerid, c.campaignname
				) cq on cq.campaignname = c.campaignname and cq.centerid = ph.centerid and c.tipids is null
		left join 
				(
					select	ta.centerid
							, ta.campaignname
							, cast(sum(ta.[TIP Opportunities]) as decimal) as [TIP Opportunities]
							, cast(sum(ta.[Successful TIPs]) as decimal) as [Successful TIPs]
					from 
						(	
							select	row_number() over (partition by tacr.tipresultstatusID 
													order by tacr.[Completed TIPs] desc, tacr.[Unfinished TIPs] desc, tacr.[Review/resubmit Tips] desc
															, tacr.[Rejected Tips] desc, tacr.[currently active] desc, tacr.[withdrawn] desc, tacr.tipresultstatuscenterID desc) as [Rank] 
									, tacr.centerid
									, tacr.[TIP Opportunities]
									, c.campaignName
									, CASE WHEN tacr.activethru > @END THEN 0 ELSE tacr.[Completed TIPs] END AS [Completed TIPs]
									, CASE WHEN tacr.activethru > @END THEN 0 ELSE tacr.[Successful TIPs] END AS [Successful TIPs]
							from	outcomesMTM.dbo.tipActivityCenterReport tacr
									join staging.campaign c on c.policyid = tacr.policyid and tacr.tipdetailid in (select [value] from STRING_SPLIT(c.tipids, ',') )
							where	1=1
									and tacr.policyid not in (574, 575, 298)
									and tacr.primaryPharmacy = 1 --or tacr.[Completed TIPs] = 1  -- changed per tc-1621
									and tacr.activethru >= @BEGIN
									and tacr.activeasof <= @END
									AND ((tacr.activethru <= @end AND (tacr.[completed tips] = 1 or tacr.[unfinished tips] = 1 or tacr.[review/resubmit tips] = 1 or tacr.[rejected tips] = 1)) 
										OR datediff(day, case when tacr.activeasof > @begin then tacr.activeasof else @begin end, case when tacr.activethru > @end then @end else tacr.activethru end) > 30)
						) ta
					where 1=1
					and ta.Rank = 1
					group by ta.centerID, ta.campaignname
				) ta on ta.centerid = ph.centerID and ta.campaignname = c.campaignname
		left join 
				(
					select	ta.centerid
							, ta.campaignname
							, cast(sum(case when ta.[Primary] = 1 then ta.[Currently Active] else 0 end) as decimal) as [Primary Available]
							, cast(sum(ta.[Currently Active]) as decimal) as [Available]
					from 
						(	
							select	row_number() over (partition by tacr.tipresultstatusID 
													order by tacr.[currently active] desc,  tacr.[Unfinished TIPs] desc, tacr.[Review/resubmit Tips] desc
															, tacr.[Rejected Tips] desc, tacr.[withdrawn] desc, tacr.[Completed TIPs] desc, tacr.tipresultstatuscenterID desc) as [Rank] 
									, tacr.centerid
									, tacr.[TIP Opportunities]
									, c.campaignName
									, CASE WHEN isnull(tacr.primaryPharmacy,0) = 1 THEN 1 ELSE 0 END AS [Primary]
									, CASE WHEN tacr.activethru <= @END THEN 0 ELSE tacr.[currently active] END AS [Currently Active]
							from	outcomesMTM.dbo.tipActivityCenterReport tacr
									join staging.campaign c on c.policyid = tacr.policyid and tacr.tipdetailid in(select [value] from STRING_SPLIT(c.tipids, ','))
							where	1=1
									and c.policyid not in (574, 575, 298)
									--and (tacr.primaryPharmacy = 1 or tacr.[Completed TIPs] = 1)
									and tacr.[currently active] = 1
									and tacr.activethru >= @BEGIN
									and tacr.activeasof <= @END
									--AND ((tacr.activethru <= @end AND (tacr.[completed tips] = 1 or tacr.[unfinished tips] = 1 or tacr.[review/resubmit tips] = 1 or tacr.[rejected tips] = 1)) 
										--OR datediff(day, case when tacr.activeasof > @begin then tacr.activeasof else @begin end, case when tacr.activethru > @end then @end else tacr.activethru end) > 30)
						) ta
					where	1=1
							and ta.Rank = 1
					group by ta.centerID, ta.campaignname
				) taa on taa.centerid = ph.centerID and taa.campaignname = c.campaignname
where 1=1
and np.Active = 1
--and pc.chaincode = '097'
----group by c.campaignname, NCPDP_NABP
--order by campaignname

/*
select 
  STG.CampaignName
			, STG.Relationship_Name
			--, r.ncpdp_nabp
			, sum(STG.[CMROpportunity])					as [CMROpportunity]
			, sum(STG.[completedCMRs])					as [completedCMRs]
			, sum(STG.[PrimaryCMRsAvailable])			as [PrimaryCMRsAvailable]
			, sum(STG.[CMRsAvailable])					as [CMRsAvailable]
			, sum(STG.[CMRsScheduled])					as [CMRsScheduled]
			, sum(STG.[TIP Opportunities])				as [TIP Opportunities]
			, sum(STG.[TIPs Sucessful])					as [TIPs Sucessful]
			, sum(STG.[TIPs Available (Primary)])		as [TIPs Available (Primary)]
			, sum(STG.[TIPs Available])					as [TIPs Available]
from 
(
	select  
			 t.CampaignName
			, r.Relationship_Name
			, r.ncpdp_nabp
			, sum([CMROpportunity])					as [CMROpportunity]
			, sum([completedCMRs])					as [completedCMRs]
			, sum([PrimaryCMRsAvailable])			as [PrimaryCMRsAvailable]
			, sum([CMRsAvailable])					as [CMRsAvailable]
			, sum([CMRsScheduled])					as [CMRsScheduled]
			, sum([TIP Opportunities])				as [TIP Opportunities]
			, sum([TIPs Sucessful])					as [TIPs Sucessful]
			, sum([TIPs Available (Primary)])		as [TIPs Available (Primary)]
			, sum([TIPs Available])					as [TIPs Available]
	from	dbo.CampaignOppData  t
			left join staging.relationship r on r.ncpdp_nabp = t.ncpdp_nabp
	group by t.campaignname, r.relationship_name , r.ncpdp_nabp
--order by campaignname, relationship_name , r.ncpdp_nabp
) STG 
right join staging.relationship REL
ON STG.ncpdp_nabp = REL.ncpdp_nabp
where STG.CampaignName is not null
group by STG.CampaignName , STG.Relationship_Name
order by 1 , 2
*/

END
