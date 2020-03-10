
-- ==========================================================================================
-- Author:	Yuanpeng Li
-- Create date: 01/17/2019
-- Description:	
-- ==========================================================================================
-- Change Log
-- ==========================================================================================
--   #		Date		Author			Description
--   --		--------	----------		----------------
--   1		01/17/2019	Yuanpeng Li    	TC-2616

-- ==========================================================================================

CREATE proc [dbo].[S_ReportCard_Clinic_Scored] 
as 
begin 

-- #99_locations
if object_id('tempdb..#99_locations') is not null
		DROP TABLE #99_locations  
select	distinct dpc.ncpdp_nabp 
		, PH.centerid
into	#99_locations
from	AOCWPAPSQL02.[outcomes].[dbo].[directPrescriberCenter] as dpc
		left join [dbo].[pharmacy] as PH on dpc.ncpdp_nabp= ph.ncpdp_nabp
where dpc.ncpdp_nabp in 
	(
		select	distinct dpc.NCPDP_NABP
		from	AOCWPAPSQL02.[outcomes].[dbo].[directPrescriberCenter] as dpc 
				left join [dbo].[pharmacy] as PH on dpc.ncpdp_nabp= ph.ncpdp_nabp
		where	PH.NCPDP_NABP like '99%'
		group by dpc.NCPDP_NABP
		having count(distinct dpc.prescriberNPI) > 0 
	) 
create clustered index IDX on #99_locations (ncpdp_nabp, centerid)


DECLARE @BEGIN datetime2(3)
DECLARE @end datetime2(3)

SET @BEGIN =  cast(case when month(getdate()) = 1 then cast(year(getdate()) - 1 as varchar(4)) + '-01-01 00:00:00.000' else cast(year(getdate()) as varchar(4)) + '-01-01 00:00:00.000' end as datetime2(3))  --// Beginning of year (if current month is Jan. then beginning of last year)		
SET @end =  cast(cast(EOMONTH(Getdate(),-1) as varchar(10)) + ' 23:59:59.999' as datetime2(3))	 		--end of last month

--set @BEGIN = '2018-01-01 00:00:00.000'
--set @end = '2018-12-31 23:59:59.999'

-- #tipActivityCenterReport
if object_id('tempdb..#tipActivityCenterReport') is not null
		DROP TABLE #tipActivityCenterReport  
SELECT	*
INTO	#tipActivityCenterReport
FROM
	(
		SELECT	row_number() over (partition by tacr.ncpdp_nabp, tacr.tipresultstatusID order by tacr.[Completed TIPs] desc, tacr.[Unfinished TIPs] desc, tacr.[Review/resubmit Tips] desc, tacr.[Rejected Tips] desc, tacr.[currently active] desc, tacr.[withdrawn] desc, tacr.tipresultstatuscenterID desc) as [Rank] 
				, tacr.centerid
				, tacr.ncpdp_nabp
				, tacr.[TIP Opportunities]
				, CASE	when tacr.activethru > @end then 0 
						else tacr.[Completed TIPs] end as [Completed TIPs]
				, CASE	when tacr.activethru > @end then 0 
						else tacr.[Successful TIPs] end as [Successful TIPs]
				, case	when tacr.tiptype = 'COST' then 1 
						else 0 end as [Cost TIPs Opportunity]
				, case	when tacr.tiptype = 'COST' and tacr.activethru <= @end then tacr.[Completed TIPs] 
						else 0 end as [Cost Completed TIPs]
				, case	when tacr.tiptype = 'COST' and tacr.activethru <= @end then tacr.[Successful TIPs] 
						else 0 end as [Cost Successful TIPs]
				, case	when tacr.tiptype = 'STAR' then 1 
						else 0 end as [Star TIPs Opportunity]
				, case	when tacr.tiptype = 'STAR' and tacr.activethru <= @end then tacr.[Completed TIPs] 
						else 0 end as [Star Completed TIPs]
				, case	when tacr.tiptype = 'STAR' and tacr.activethru <= @end then tacr.[Successful TIPs] 
						else 0 end as [Star Successful TIPs]
				, case	when tacr.tiptype = 'QUALITY' then 1 
						else 0 end as [Quality TIPs Opportunity]
				, case	when tacr.tiptype = 'QUALITY' and tacr.activethru <= @end then tacr.[Completed TIPs]	
						else 0 end as [Quality Completed TIPs]
				, case	when tacr.tiptype = 'QUALITY' and tacr.activethru <= @end then tacr.[Successful TIPs] 
						else 0 end as [Quality Successful TIPs]
				, policyid
				, activethru
				, activeasof
				, [unfinished tips]
				, [review/resubmit tips]
				, [rejected tips]
		FROM	outcomesMTM.dbo.tipActivityCenterReport tacr with (nolock)
		WHERE	1 = 1
				and tacr.policyid not in (574, 575, 298)
				and tacr.activethru >= @BEGIN
				and tacr.activeasof <= @END
				AND (
						(
							tacr.activethru <= @END 
							AND (tacr.[completed tips] = 1 
							or tacr.[unfinished tips] = 1 
							or tacr.[review/resubmit tips] = 1
							or tacr.[rejected tips] = 1)
						) 
						or datediff(day, case	when tacr.activeasof >= @BEGIN then tacr.activeasof 
												else @BEGIN end
										, case	when tacr.activethru >= @end then @end 
												else tacr.activethru end) > 30
					)

	)	tipActivityCenterReport
WHERE	tipActivityCenterReport.Rank = 1
CREATE CLUSTERED INDEX IDX ON #tipActivityCenterReport (ncpdp_nabp)

-- #ta
if(object_ID('tempdb..#ta') is not null)
		DROP TABLE #ta
SELECT	* 
INTO	#ta
FROM
	(
		SELECT	ta.centerID
				, ta.ncpdp_nabp
				, sum(ta.[TIP Opportunities])	as [TIP Opportunities]
				, cast(sum(ta.[Completed TIPs]) as decimal)		as [Completed TIPs]
				, cast(sum(ta.[Successful TIPs]) as decimal)	as [Successful TIPs]
				, isnull(cast((cast(sum(ta.[Successful TIPs]) as decimal)/nullif(cast(sum(ta.[TIP Opportunities]) as decimal), 0)) as decimal (5,4)), 0)					as NetEffectiveRate
				-------
				, cast(sum(ta.[Cost TIPs Opportunity]) as decimal)	as [Cost TIPs Opportunity]
				, cast(sum(ta.[Cost Completed TIPs]) as decimal)	as [Cost Completed TIPs]
				, cast(sum(ta.[Cost Successful TIPs]) as decimal)	as [Cost Successful TIPs]
				, isnull(cast((cast(sum(ta.[Cost Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Cost TIPs Opportunity]) as decimal), 0)) as decimal (5,4)), 0)			as CostNetEffectiveRate
				-------
				, cast(sum(ta.[Star TIPs Opportunity]) as decimal)	as [Star TIPs Opportunity]
				, cast(sum(ta.[Star Completed TIPs]) as decimal)	as [Star Completed TIPs]
				, cast(sum(ta.[Star Successful TIPs]) as decimal)	as [Star Successful TIPs]
				, isnull(cast((cast(sum(ta.[Star Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Star TIPs Opportunity]) as decimal), 0)) as decimal (5,4)), 0)			as StarNetEffectiveRate
				--------
				, cast(sum(ta.[Quality TIPs Opportunity]) as decimal)	as [Quality TIPs Opportunity]
				, cast(sum(ta.[Quality Completed TIPs]) as decimal)		as [Quality Completed TIPs]
				, cast(sum(ta.[Quality Successful TIPs]) as decimal)	as [Quality Successful TIPs]
				, isnull(cast((cast(sum(ta.[Quality Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Quality TIPs Opportunity]) as decimal), 0)) as decimal (5,4)), 0)		as QualityNetEffectiveRate
		FROM 
			(	
				SELECT	tacr.centerID
						, tacr.ncpdp_nabp
						, tacr.[TIP Opportunities]
						, tacr.[Completed TIPs]
						, tacr.[Successful TIPs]
						, tacr.[Cost TIPs Opportunity]
						, tacr.[Cost Completed TIPs]
						, tacr.[Cost Successful TIPs]
						, tacr.[Star TIPs Opportunity]
						, tacr.[Star Completed TIPs]
						, tacr.[Star Successful TIPs]
						, tacr.[Quality TIPs Opportunity]
						, tacr.[Quality Completed TIPs]
						, tacr.[Quality Successful TIPs]

				FROM	#tipActivityCenterReport tacr
						join #99_locations lo with (nolock) on lo.centerid = tacr.centerid and lo.ncpdp_nabp = tacr.ncpdp_nabp
				WHERE	1=1
			)	ta
		WHERE	1=1
		group by ta.centerID , ta.ncpdp_nabp
	)	ta
create clustered index IDX on #ta (ncpdp_nabp, centerID)

---- #cm
If OBJECT_ID('tempdb..#cm') is not null
		DROP TABLE #cm
SELECT	*
INTO	#cm
FROM 
	(
		SELECT	centerID
				, centerName						
				, count(distinct u.PatientID) as CMROpportunity
				, sum(u.CMROffered) as CMROffered				
				, sum(u.CMRCompleted) as completedCMRs
				, case	when count(distinct u.PatientID) = 0 then 0 
						else cast((cast(sum(u.CMRCompleted) as decimal))/(cast(count(distinct u.PatientID) as decimal)) as decimal(5,4)) end as percentCMRcompletion	
		FROM 
			(
				SELECT	row_number() over (partition by rp.patientID, rp.centerid order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
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
						, case	when rp.outcomesTermDate between @BEGIN and @end AND isNull(rp.mtmServiceDT, '99991231') not between @BEGIN and @end then 1 
								else 0 end as Termed
						, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6, 12) AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'')  then 1 
								else 0 end as CMROffered
						, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'') then 1 
								else 0 end as CMRCompleted
						, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID in (2, 6) and rp.resultTypeID = 12 AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'') then 1 
								else 0 end as PatientRefused
						, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID in (2, 6) and rp.resultTypeID = 18 AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'') then 1 
								else 0 end as UnableToReachPatient
						, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID in (2, 6) and rp.resultTypeID = 5 AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'') then 1 
								else 0 end as CMRWithDrugProblems
						, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID in (2, 6) and rp.resultTypeID = 6 AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'') then 1 
								else 0 end as CMRWithoutDrugProblems
						, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.cmrDeliveryTypeID = 1 AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'') then 1 
								else 0 end as CMRFace2Face
						, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.cmrDeliveryTypeID = 2 AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'') then 1 
								else 0 end as CMRPhone
						, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.cmrDeliveryTypeID = 3 AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'') then 1 
								else 0 end as CMRTelehealth
						, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND rp.centerID <> rp.claimcenterID then 1 
								else 0 end as CMRMissed
						, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID = 5 AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'') then 1	
								else 0 end as CMRRejected
						, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID = 2 AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'') AND rp.resultTypeID in (5, 6) then 1 
								else 0 end as CMRPendingApproval
						, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID = 6 and rp.paid = 0 AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'') AND rp.resultTypeID in (5, 6) then 1 
								else 0 end as CMRApprovedPendingPayment
						, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID = 6 and rp.paid = 1 AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'') AND rp.resultTypeID in (5, 6) then 1 
								else 0 end as CMRApprovedPaid
						, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.Language = 'EN' AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'') then 1 
								else 0 end EnglishSPT
						, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.Language = 'SP' AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'') then 1 
								else 0 end SpanishSPT
						, case	when rp.mtmServiceDT between @BEGIN and @end AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'') then cast(rp.postHospitalDischarge as int) 
								else 0 end as postHospitalDischarge
				FROM	vw_CMRActivityReport rp with (nolock)
						join patientDim pd with (nolock)	on pd.patientKey = rp.patientKey
						join policy p with (nolock)			on p.policyID = rp.policyID
						join pharmacy ph with (nolock)		on ph.centerID = rp.centerID
						join #99_locations lo with (nolock)	on lo.centerID = ph.centerID
						left join chain c with (nolock)		on c.chainID = rp.chainID
				WHERE	1=1
						AND isNull(rp.activethru, '99991231') >= @BEGIN
						AND rp.activeasof <= @end
						AND (
								(rp.activethru IS NULL AND DATEDIFF(DAY, CASE	when rp.activeasof > @BEGIN then rp.activeasof 
																				else @BEGIN end, @end) >= 30)
								OR
								(rp.activethru IS NOT NULL AND DATEDIFF(DAY, CASE	when rp.activeasof > @BEGIN then rp.activeasof 
																					else @BEGIN end, 
																				CASE	when rp.activethru > @end then @end 
																						else rp.activethru end) >= 30)
								OR
								(rp.mtmServiceDT BETWEEN @BEGIN AND @end AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6))
								AND
								(rp.claimcenterID = rp.centerid)
							)
			)	u
		WHERE	1 = 1
				and u.rank = 1
		group by centerID, centerName	
	)	cm
create clustered index IDX on #cm (centerID)

-- #pt
DROP TABLE IF EXISTS tempdb.#pt
SELECT	*
INTO	#pt
FROM
	(
		SELECT	distinct pt.patientID
		--SELECT count(distinct pt.patientID)
		FROM	outcomesMTM.dbo.patientDim pt with (nolock)
		WHERE	1=1
				and isnull(pt.activethru, '99991231') >= @BEGIN
				and pt.policyid not in (574 ,575 ,298)
				and pt.activeasof <= @end
	)	pt
CREATE CLUSTERED INDEX IDX ON #pt (patientID)

-- #pm
If OBJECT_ID('tempdb..#pm') is not null
		DROP TABLE #pm
SELECT	*
INTO	#pm
FROM 
	(
		SELECT	pm.centerid
				, count(distinct pt.patientID) as [EligiblePatient]
		FROM	
				outcomesMTM.[dbo].[patientMTMCenterDim] pm
				join #pt pt on pt.patientID = pm.patientid
				join #99_locations lo with (nolock)				on lo.centerID = pm.centerID
		WHERE	1=1
				and isnull(pm.activethru, '99991231') >= @BEGIN
				and pm.activeasof <= @end
		group by pm.centerid
	)	pm
create clustered index IDX on #pm (centerid)

-- #cl
If OBJECT_ID('tempdb..#cl') is not null
		DROP TABLE #cl
SELECT	*
INTO	#cl
FROM 
	(
		SELECT	v.[MTM CenterID]
				, sum(v.claimSubmitted) as claimSubmitted
		FROM 
			(
				SELECT	c.claimID
						, c.[MTM CenterID]
						, 1 as claimSubmitted
				FROM	outcomesMTM.dbo.ClaimActivityReport c with (nolock)
						join #99_locations lo with (nolock) on lo.ncpdp_nabp = c.[MTM CenterID]
				WHERE	1=1
						and c.mtmServiceDT between @BEGIN and @end
						and c.statusID not in (3,5)
						and c.policyID not in (574 ,575 ,298)
			)	v
		WHERE	1=1
		group by v.[MTM CenterID]
	)	cl
create clustered index IDX on #cl ([MTM CenterID])

-- #report
If OBJECT_ID('tempdb..#report') is not null
		DROP TABLE #report
SELECT	distinct 
		ph.centerid
		, ph.NCPDP_NABP								as [MTM Center ID]
		, replace(replace(replace(ph.centername,char(9),''),char(10),''),char(13),'') as [PharmacyName]
		, ph.addressState							as [Pharmacy State]
		, isnull(ta.[TIP Opportunities],0)			as [TIP Opportunities]
		, isnull(ta.[Completed TIPs],0)				as [Completed TIPs]
		, isnull(ta.[Successful TIPs],0)			as [Successful TIPs]
		, isnull(ta.NetEffectiveRate,0)				as NetEffectiveRate
		-----------------------------
		, isnull(ta.[Cost TIPs Opportunity],0)		as [Cost TIPs Opportunity]
		, isnull(ta.[Cost Completed TIPs],0)		as [Cost Completed TIPs]
		, isnull(ta.[Cost Successful TIPs],0)		as [Cost Successful TIPs]
		, isnull(ta.CostNetEffectiveRate,0)			as CostNetEffectiveRate
		-----------------------------
		, isnull(ta.[Star TIPs Opportunity],0)		as [Star TIPs Opportunity]
		, isnull(ta.[Star Completed TIPs],0)		as [Star Completed TIPs]
		, isnull(ta.[Star Successful TIPs],0)		as [Star Successful TIPs]
		, isnull(ta.StarNetEffectiveRate,0)			as StarNetEffectiveRate
		-----------------------------
		, isnull(ta.[Quality TIPs Opportunity],0)	as [Quality TIPs Opportunity]
		, isnull(ta.[Quality Completed TIPs] ,0)	as [Quality Completed TIPs]
		, isnull(ta.[Quality Successful TIPs],0)	as [Quality Successful TIPs]
		, isnull(ta.QualityNetEffectiveRate,0)		as QualityNetEffectiveRate
		-----------------------------
		, isnull(cm.CMROpportunity ,0)				as CMROpportunity
		, isnull(cm.CMROffered ,0)					as CMROffered
		, isnull(cm.completedCMRs ,0)				as completedCMRs
		, isnull(cm.percentCMRcompletion,0)			as percentCMRcompletion
		-----------------------------
		, isnull(pm.EligiblePatient,0)				as EligiblePatient
		, isnull(cl.claimSubmitted,0)				as claimSubmitted
		-----------------------------
		, case	when isnull([Cost TIPs Opportunity],0) <> 0 then 5 
				else 0 end costpt
		, case	when isnull([Star TIPs Opportunity],0) <> 0 then 30 
				else 0 end starpt
		, case	when isnull([Quality TIPs Opportunity],0) <> 0 then 15 
				else 0 end qualitypt
		, case	when isnull(cm.CMROpportunity,0) <> 0 then 50 
				else 0 end cmrpt
INTO	#report
FROM	outcomesMTM.dbo.pharmacy ph with (nolock)
		left join OutcomesMTM.dbo.NCPDP_Provider np with (nolock) on np.NCPDP_Provider_ID = ph.NCPDP_NABP
		left join #ta as ta with (nolock) on ta.centerid = ph.centerid
		left join #cm as cm with (nolock) on cm.centerid = ph.centerid
		left join #pm as pm with (nolock) on pm.centerid = ph.centerid
		left join #cl as cl with (nolock) on cl.[MTM CenterID] = ph.NCPDP_NABP
WHERE	1=1
		--and np.Active = 1
create clustered index IDX on #report ([MTM Center ID])

-- #score
If object_id('tempdb..#score') is not null
		DROP TABLE #score
SELECT	centerID
		, case	when costneteffectiverate = 0 then 0 
				else round((CUME_DIST() over (partition by (case	when costneteffectiverate <> 0 then 1 
																	else 0 end) order by costneteffectiverate))*5,4) end as costcdf
		, case	when StarNetEffectiveRate = 0 then 0 
				else round((CUME_DIST() over (partition by (case	when StarNetEffectiveRate <> 0 then 1 
																	else 0 end) order by StarNetEffectiveRate))*30,4) end as starcdf
		, case	when QualityNetEffectiveRate = 0 then 0 
				else round(CUME_DIST() over (partition by (case		when QualityNetEffectiveRate <> 0 then 1 
																	else 0 end) order by QualityNetEffectiveRate)*15,4) end as qualitycdf
		, case	when percentCMRcompletion = 0 then 0 
				else round(CUME_DIST() over (partition by (case		when percentCMRcompletion <> 0 then 1 
																	else 0 end) order by percentCMRcompletion)*50,4) end as cmrcdf
INTO	#score
FROM	#report r
create clustered index IDX on #score (centerID)


-- #composite
if object_id('tempdb..#composite') is not null
		DROP TABLE #composite
SELECT	r.centerID
		, costcdf
		, starcdf
		, qualitycdf
		, cmrcdf
		, case	when costpt + starpt + qualitypt + cmrpt = 0 then 0
				else (costcdf + starcdf + qualitycdf + cmrcdf)/(costpt + starpt + qualitypt + cmrpt)*100 end as composite
INTO	#composite
FROM	#report r
		join #score s on r.centerID = s.centerID
create clustered index IDX on #composite (centerID)

-- #percentrank
if object_id('tempdb..#percentrank') is not null
		DROP TABLE #percentrank
SELECT	c.centerID
		, composite
		, case	when composite  = 0 then 0 
				when round(percent_rank() over (partition by (case	when composite <> 0 then 1 
																	else 0 end) order by composite),3) = 0 then 0.001
				else round(percent_rank() over (partition by (case	when composite <> 0 then 1 
																	else 0 end) order by composite),3) end as percentrank
INTO	#percentrank
FROM	#composite c
create clustered index IDX on #percentrank (centerID)


-- Pull the final report
SELECT	r.[MTM Center ID]
		, r.[PharmacyName]									as [MTM Center Name]
		, r.[Pharmacy State]								as [MTM Center State]
		, [TIP Opportunities] 
		, [Completed TIPs]									as [TIPs Completed]
		, [Successful TIPs]									as [TIPs Successful]
		, cast(cast([NetEffectiveRate]*100 as decimal(5,2)) as varchar) + '%'			as [TIP Net Effective Rate]
		-----------------------------
		, [Cost TIPs Opportunity] as [Cost TIP Opportunities]
		, [Cost Completed TIPs] as [Cost TIPs Completed]
		, [Cost Successful TIPs] as [Cost TIPs Successful]
		, cast(cast([CostNetEffectiveRate]*100 as decimal(5,2)) as varchar) + '%'		as [Cost TIP Net Effective Rate]
		-----------------------------
		, [Star TIPs Opportunity]							as [Star TIP Opportunities]
		, [Star Completed TIPs]								as [Star TIPs Completed]
		, [Star Successful TIPs]							as [Star TIPs Successful]
		, cast(cast([StarNetEffectiveRate]*100 as decimal(5,2)) as varchar) + '%'		as [Star TIP Net Effective Rate]
		-----------------------------
		, [Quality TIPs Opportunity]						as [Quality TIP Opportunities]
		, [Quality Completed TIPs]							as [Quality TIPs Completed]
		, [Quality Successful TIPs]							as [Quality TIPs Successful]
		, cast(cast([QualityNetEffectiveRate]*100 as decimal(5,2)) as varchar) + '%'	as [Quality TIP Net Effective Rate]
		-----------------------------
		, [CMROpportunity]									as [CMR Opportunities]
		, [CMROffered]										as [CMR Offered]
		, [completedCMRs]									as [CMR Completed]
		, cast(cast([percentCMRcompletion]*100 as decimal(5,2)) as varchar) + '%'		as [CMR Completion Rate]
		-----------------------------
		, [EligiblePatient]									as [Eligible Patients]
		, [claimSubmitted]									as [Claims Submitted]
		, case when sc.[costcdf] = 0 then '0' else cast(cast(sc.[costcdf] as decimal (9,4)) as varchar) end as [Cost Score]
		, case when sc.[starcdf] = 0 then '0' else cast(cast(sc.[starcdf] as decimal (9,4)) as varchar) end as [Star Score]
		, case when sc.[qualitycdf] = 0 then '0' else cast(cast(sc.[qualitycdf] as decimal (9,4)) as varchar) end as [Quality Score]
		, case when sc.[cmrcdf] = 0 then '0' else cast(cast(sc.[cmrcdf] as decimal (9,4)) as varchar) end as [CMR Score]
		, case when co.[composite]  <> '0' then cast(cast(round(co.[composite], 4) as decimal (9,4)) as varchar) 
			   when  r.[costpt] + r.[starpt] + r.[qualitypt] + r.[cmrpt] = 0 then 'N/A'
				when r.[costpt] + r.[starpt] + r.[qualitypt] + r.[cmrpt] <> 0  and co.[costcdf] + co.[starcdf] + co.[qualitycdf] + co.[cmrcdf] = 0 then '0'
			   end as [Composite Score]
		, case when PERCENTRANK >=0.85 then '4'
					when PERCENTRANK >=0.5 and PERCENTRANK <0.85 then '3'
					when PERCENTRANK >=0.15 and PERCENTRANK <0.5 then '2'
					when PERCENTRANK >0 and PERCENTRANK <0.15 then '1'
					when PERCENTRANK =0 and r.costpt + r.starpt + r.qualitypt + r.cmrpt <> 0  then '0'
					else 'N/A' end as [Performance Score]
		, case when pr.percentrank <> 0 then cast(cast(pr.percentrank*100 as decimal(5,1)) as varchar) + '%' 
				when  r.[costpt] + r.[starpt] + r.[qualitypt] + r.[cmrpt] = 0 then 'N/A'
				else '0' end as [Percentile Rank]
FROM	#report r
		join #99_locations lo on lo.ncpdp_nabp = r.[MTM Center ID]
		join #score sc on sc.centerID = r.centerID
		join #composite co on co.centerID = r.centerID
		join #percentrank pr on pr.centerID = r.centerID 


end



