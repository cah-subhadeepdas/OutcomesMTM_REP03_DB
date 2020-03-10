


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
--   2      02/24/2020	Yuanpeng Li	TC-3484
-- ==========================================================================================


CREATE   proc [dbo].[S_ReportCard_Pharmacy_Scored_TC3484] 
as 
begin 



DECLARE @BEGIN datetime2(3)
DECLARE @END datetime2(3)



/*
select cast(year(getdate()) as varchar(4)) + '0101'
,cast(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as date)

*/

--SET @BEGIN =  case when month(getdate()) = 1 then cast(year(getdate()) - 1 as varchar(4)) + '0101' else cast(year(getdate()) as varchar(4)) + '0101' end  --// Beginning of year (if current month is Jan. then beginning of last year)		
--SET @END =  cast(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as date)	 		--end of last month

set @BEGIN = '2019-01-01 00:00:00.000'
set @END = '2019-12-31 23:59:59.599'


-- Only consider Real pharmacy, virtual pharmacy going to be excluded  
-- Virtual pharmacy: Any pharamcy NCPDP_NABP starts with 99 
DROP TABLE if exists #Virtual_Phamarcy  
select	distinct dpc.ncpdp_nabp 
		, PH.centerid
into	#Virtual_Phamarcy
from	AOCWPAPSQL02.[outcomes].[dbo].[directPrescriberCenter] as dpc
		left join AOCWPAPSQL02.[outcomes].[dbo].[pharmacy] as PH on dpc.ncpdp_nabp= ph.ncpdp_nabp
where dpc.ncpdp_nabp in 
	(
		select	distinct dpc.NCPDP_NABP
		from	AOCWPAPSQL02.[outcomes].[dbo].[directPrescriberCenter] as dpc 
				left join AOCWPAPSQL02.[outcomes].[dbo].[pharmacy] as PH on dpc.ncpdp_nabp= ph.ncpdp_nabp
		where	PH.NCPDP_NABP like '99%'
		group by dpc.NCPDP_NABP
		having count(distinct dpc.prescriberNPI) > 0 
	) 
create clustered index IDX on #Virtual_Phamarcy (ncpdp_nabp, centerid)

-----------------------------------------------------------------------------------------------------------
-- TIP section --
-----------------------------------------------------------------------------------------------------------

-- Tip completed at patient's Primary Pharmacy
drop table if exists #TIPPrimaryPharmacy
select	*
into	#TIPPrimaryPharmacy
from
	(

		select	row_number() over (partition by tacr.centerid, tacr.tipresultstatusID order by tacr.[Completed TIPs] desc, tacr.[Unfinished TIPs] desc, tacr.[Review/resubmit Tips] desc, tacr.[Rejected Tips] desc, tacr.[currently active] desc, tacr.[withdrawn] desc, tacr.tipresultstatuscenterID desc) as [Rank] 
				, tacr.patientid

				-- Primary Tier --
				, convert(varchar(50),tacr.centerid)											as [Primary centerid]
				, tacr.[TIP Opportunities]														as [Primary centerid TIP Opportunities]
				, CASE	WHEN tacr.activethru <= cast(@END as date) THEN tacr.[Completed TIPs] 
						ELSE 0 END																as [Primary centerid TIPs Completed]
				, CASE	WHEN tacr.activethru <= cast(@END as date) THEN tacr.[Successful TIPs] 
						ELSE 0 END																as [Primary centerid TIPs Successful]
				, case	when tacr.tiptype in ('COST', 'QUALITY') then 1 
						else 0 end																as [Primary centerid Cost Quality TIP Opportunities] 
				, case	when tacr.tiptype in ('COST', 'QUALITY') and tacr.activethru <= cast(@END as date) then tacr.[Completed TIPs] 
						else 0 end																as [Primary centerid Cost Quality TIPs Completed]			
				, case	when tacr.tiptype in ('COST', 'QUALITY') and tacr.activethru <= cast(@END as date) then tacr.[Successful TIPs] 
						else 0 end																as [Primary centerid Cost Quality TIPs Successful]		
				, case	when tacr.tiptype = 'STAR' then 1 
						else 0 end																as [Primary centerid Star TIP Opportunities]														
				, case	when tacr.tiptype = 'STAR' and tacr.activethru <= cast(@END as date) then tacr.[Completed TIPs] 
						else 0 end																as [Primary centerid Star TIPs Completed]
				, case	when tacr.tiptype = 'STAR' and tacr.activethru <= cast(@END as date) then tacr.[Successful TIPs] 
						else 0 end																as [Primary centerid Star TIPs Successful]

				-- Service Tier --
				, convert(varchar(50),null)												as [service centerid]
				, 0							as [Service centerid TIP Opportunities]																													
				, 0							as [Service centerid TIPs Completed]
				, 0							as [Service centerid TIPs Successful]
				, 0							as [Service centerid Cost Quality TIP Opportunities] 
				, 0							as [Service centerid Cost Quality TIPs Completed]
				, 0							as [Service centerid Cost Quality TIPs Successful]
				, 0							as [Service centerid Star TIP Opportunities]
				, 0							as [Service centerid Star TIPs Completed]
				, 0							as [Service centerid Star TIPs Successful]

		from	outcomesMTM.dbo.tipActivityCenterReport tacr
				left join #Virtual_Phamarcy vp on tacr.centerid = vp.centerid
		where	1=1
				and vp.centerid is null
				and tacr.policyid not in (574, 575, 298)
				and tacr.primaryPharmacy = 1 
				and isnull(tacr.activethru, cast(@END as date)) between cast(@BEGIN as date) and cast(@END as date) 
				and tacr.activeasof between cast(@BEGIN as date) and cast(@END as date)
				AND ((tacr.activethru <= cast(@END as date) AND (tacr.[completed tips] = 1 or tacr.[unfinished tips] = 1 or tacr.[review/resubmit tips] = 1 or tacr.[rejected tips] = 1)) 
				OR datediff(day, case when tacr.activeasof > cast(@BEGIN as date) then tacr.activeasof else cast(@BEGIN as date) end, case when tacr.activethru > cast(@END as date) then cast(@END as date) else tacr.activethru end) > 7)		
	)	TIP
where TIP.rank = 1


-- Tip completed at patient's non Primary Pharmacy 
drop table if exists #TIP_OutChain_Pharmacy
select	*
into	#TIP_OutChain_Pharmacy
from
	(
		select	row_number() over (partition by tacr.centerid, tacr.tipresultstatusID order by tacr.[Completed TIPs] desc, tacr.[Unfinished TIPs] desc, tacr.[Review/resubmit Tips] desc, tacr.[Rejected Tips] desc, tacr.[currently active] desc, tacr.[withdrawn] desc, tacr.tipresultstatuscenterID desc) as [Rank] 
				, tacr.patientid

				-- Primary Tier --
				, convert(varchar(50), ph.centerid)				as [Primary centerid]
				, 1												as [Primary centerid TIP Opportunities]	
				, 0												as [Primary centerid TIPs Completed]
				, 0												as [Primary centerid TIPs Successful]	
				, case	when tacr.tiptype in ('COST', 'QUALITY') then 1 
						else 0 end								as [Primary centerid Cost Quality TIP Opportunities] 
				, 0												as [Primary centerid Cost Quality TIPs Completed]
				, 0												as [Primary centerid Cost Quality TIPs Successful]
				, case	when tacr.tiptype = 'STAR' then 1 
						else 0 end								as [Primary centerid Star TIP Opportunities]
				, 0												as [Primary centerid Star TIPs Completed]
				, 0												as [Primary centerid Star TIPs Successful]

				-- Service Tier --
				, convert(varchar(50), tacr.centerid)			as [service centerid]
				, 1												as [Service centerid TIP Opportunities]			
				, CASE	WHEN tacr.activethru <= cast(@END as date) THEN tacr.[Completed TIPs] 
						ELSE 0 END								AS [Service centerid TIPs Completed]
				, CASE	WHEN tacr.activethru <= cast(@END as date) THEN tacr.[Successful TIPs] 
						ELSE 0  END								AS [Service centerid TIPs Successful]
				, case	when tacr.tiptype in ('COST', 'QUALITY') then 1 
						else 0 end								as [Service centerid Cost Quality TIP Opportunities] 
				, case	when tacr.tiptype in ('COST', 'QUALITY') and tacr.activethru <= cast(@END as date) then tacr.[Completed TIPs] 
						else 0 end								as [Service centerid Cost Quality TIPs Completed]			--TC-3538 Removed by Li
				, case	when tacr.tiptype in ('COST', 'QUALITY') and tacr.activethru <= cast(@END as date) then tacr.[Successful TIPs] 
						else 0 end								as [Service centerid Cost Quality TIPs Successful]		--TC-3538 Removed by Li
				, case	when tacr.tiptype = 'STAR' then 1 
						else 0 end								as [Service centerid Star TIP Opportunities]														--TC-3538 Removed by Li
				, case	when tacr.tiptype = 'STAR' and tacr.activethru <= cast(@END as date) then tacr.[Completed TIPs] 
						else 0 end								as [Service centerid Star TIPs Completed]
				, case	when tacr.tiptype = 'STAR' and tacr.activethru <= cast(@END as date) then tacr.[Successful TIPs] 
						else 0 end								as [Service centerid Star TIPs Successful]

		from	outcomesMTM.dbo.tipActivityCenterReport tacr
				left join [dbo].patientMTMCenterDim ppd on ppd.patientid = tacr.patientid and  tacr.activethru between ppd.activeAsOf and ISNULL(ppd.activeThru, '9999-12-31') and ppd.primaryPharmacy = 1
				left join dbo.pharmacy ph on ph.centerid = ppd.centerid
				left join #Virtual_Phamarcy vp on tacr.centerid = vp.centerid

		where	1=1
				and vp.centerid is null
				and tacr.policyid not in (574, 575, 298)
				and tacr.primaryPharmacy = 0 
				and isnull(tacr.activethru, cast(@END as date)) between cast(@BEGIN as date) and cast(@END as date) 
				and tacr.activeasof between cast(@BEGIN as date) and cast(@END as date)
				and tacr.[completed tips] = 1
				and tacr.[Successful TIPs] = 1
	)	TIP
where TIP.rank = 1



-- Union All TIPs
DROP TABLE IF EXISTS #UnionTIP
select	*
into	#UnionTIP
from
	(
		SELECT	*
		FROM	#TIPPrimaryPharmacy t 
		UNION ALL
		SELECT	*
		FROM	#TIP_OutChain_Pharmacy t 
	)	Tip




-- Sum All TIPs by Primary OrgID and Service OrgID
drop table if exists #TIPCount
select	*
into	#TIPCount
from
	(
		select	f.[Primary centerid]											as [centerid]
				, sum(f.[Primary centerid TIP Opportunities])					as [TIP Opportunities]
				, sum(f.[Primary centerid TIPs Completed])						as [TIPs Completed]
				, sum(f.[Primary centerid TIPs Successful])						as [TIPs Successful]
				, sum(f.[Primary centerid Cost Quality TIP Opportunities])		as [Cost Quality TIP Opportunities]
				, sum(f.[Primary centerid Cost Quality TIPs Completed])			as [Cost Quality TIPs Completed]
				, sum(f.[Primary centerid Cost Quality TIPs Successful])		as [Cost Quality TIPs Successful]
				, sum(f.[Primary centerid Star TIP Opportunities])				as [Star TIP Opportunities]
				, sum(f.[Primary centerid Star TIPs Completed])					as [Star TIPs Completed]
				, sum(f.[Primary centerid Star TIPs Successful])				as [Star TIPs Successful]
		from	#UnionTIP f
		where	f.[Primary centerid] is not null
		group by f.[Primary centerid]
		union all
		select	f.[Service centerid]											as [centerid]
				, sum(f.[Service centerid TIP Opportunities])					as [TIP Opportunities]
				, sum(f.[Service centerid TIPs Completed])						as [TIPs Completed]
				, sum(f.[Service centerid TIPs Successful])						as [TIPs Successful]
				, sum(f.[Service centerid Cost Quality TIP Opportunities])		as [Cost Quality TIP Opportunities]
				, sum(f.[Service centerid Cost Quality TIPs Completed])			as [Cost Quality TIPs Completed]
				, sum(f.[Service centerid Cost Quality TIPs Successful])		as [Cost Quality TIPs Successful]
				, sum(f.[Service centerid Star TIP Opportunities])				as [Star TIP Opportunities]
				, sum(f.[Service centerid Star TIPs Completed])					as [Star TIPs Completed]
				, sum(f.[Service centerid Star TIPs Successful])				as [Star TIPs Successful]
		from	#UnionTIP f
		where	f.[Service centerid] is not null
		group by f.[Service centerid]
	)	TIP



-- Sum TIPs by OrgID
drop table if exists #TIPCount_Sum
select	*
into	#TIPCount_Sum
from
(
select	centerid
		, sum([TIP Opportunities])	as [TIP Opportunities]
		, sum([TIPs Completed])		as [TIPs Completed]
		, sum([TIPs Successful])	as [TIPs Successful]
		, CASE	WHEN sum([TIP Opportunities]) = 0 then '0.00%'
				ELSE CONVERT(varchar, isnull(cast((cast(sum([TIPs Successful]) as decimal) * 100/nullif(cast(sum([TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0)) + '%' end as [TIP Net Effective Rate]
		
		, sum([Cost Quality TIP Opportunities])	as [Cost Quality TIP Opportunities]
		, sum([Cost Quality TIPs Completed])	as [Cost Quality TIPs Completed]
		, sum([Cost Quality TIPs Successful])	as [Cost Quality TIPs Successful]
		, CASE	WHEN sum([Cost Quality TIP Opportunities]) = 0 then '0.00%'
				ELSE CONVERT(varchar, isnull(cast((cast(sum([Cost Quality TIPs Successful]) as decimal) * 100/nullif(cast(sum([Cost Quality TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0)) + '%' end as [Cost Quality TIP Net Effective Rate]		
		
		, sum([Star TIP Opportunities])			as [Star TIP Opportunities]
		, sum([Star TIPs Completed])			as [Star TIPs Completed]
		, sum([Star TIPs Successful])			as [Star TIPs Successful]
		, CASE	WHEN sum([Star TIP Opportunities]) = 0 then '0.00%'
				ELSE CONVERT(varchar, isnull(cast((cast(sum([Star TIPs Successful]) as decimal) * 100/nullif(cast(sum([Star TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0)) + '%' end as [Star TIPs Net Effective Rate]
from	#TIPCount
group by centerid
)	TIP



-----------------------------------------------------------------------------------------------------------
-- CMR section --
-----------------------------------------------------------------------------------------------------------

-- CMR completed at patient's Primary Pharmacy
DROP TABLE IF EXISTS #CMR_PrimaryPharmacy
SELECT	*
INTO	#CMR_PrimaryPharmacy
FROM
	(
		select	row_number() over (partition by rp.patientID order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
				, rp.patientid

				-- Primary Tier --
				, rp.centerid				as [Primary center]
				, 1							as [Primary center CMR Opportunities]
				, case	when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) and ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') THEN 1 
						ELSE 0 END			as [Primary center CMR Attempted]
				, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'') then 1 
						else 0 end			as [Primary center CMR completed]

				-- Service Tier --
				, null						as [Service center]
				, 0							as [Service center CMR Opportunities]
				, 0							as [Service center CMR Attempted]
				, 0							as [Service center CMR completed]
		from	vw_CMRActivityReport rp		
				left join #Virtual_Phamarcy vp on rp.centerid = vp.centerid
		where	1=1
				AND vp.centerid is null
				AND rp.activeAsOF between @BEGIN and @end
				and isnull(rp.activethru, cast(@END as date)) between cast(@BEGIN as date) and cast(@END as date) 
				AND cast(rp.activeAsOF as date) <= isNull(rp.activethru, @END)
				AND isNULL(rp.mtmServiceDT, @END) > rp.activeAsOF 
				AND (rp.mtmServiceDT is null or rp.mtmServiceDT between @BEGIN and @end)

				AND (
						(
							DATEDIFF(DAY, rp.activeasof, isNull(rp.activethru, @END)) >= 30 
						)
						or
						(
							rp.mtmServiceDT is not null AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) --and DATEDIFF(DAY, rp.activeasof, rp.mtmServiceDT) < 30
						)
					)
	)	CMR
where	CMR.rank = 1


-- CMR completed at patient's non Primary Pharmacy 
DROP TABLE IF EXISTS #CMR_NonPrimaryPharmacy
SELECT	*
INTO	#CMR_NonPrimaryPharmacy
FROM
	(
		select	row_number() over (partition by rp.patientID order by isNull(rp.resultTypeID, 90), rp.mtmserviceDT desc, rp.patientKey, rp.patientMTMCenterKey) as rank
				, rp.patientid

				-- Primary Tier --				
				, ppd.centerid				as [Primary center]
				, 1							as [Primary center CMR Opportunities]
				, 0							as [Primary center CMR Attempted]
				, 0							as [Primary center CMR completed]

				-- Service Tier --
				, rp.centerid				as [Service center]
				, 1							as [Service center CMR Opportunities]
				, case	when rp.mtmServiceDT between @BEGIN and @END AND rp.statusID in (2, 6) AND ISNULL(rp.centerID,'') = ISNULL(rp.claimcenterID,'') THEN 1 
						ELSE 0 END			as [Service center CMRAttempted]
				, case	when rp.mtmServiceDT between @BEGIN and @end AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6) AND isNull(rp.centerID,'') = isNull(rp.claimcenterID,'') then 1 
						else 0 end			as [Service center CMR completed]
		from	vw_CMRActivityReport rp
				left join [dbo].patientMTMCenterDim ppd on ppd.patientid = rp.patientid and  rp.activethru between ppd.activeAsOf and ISNULL(ppd.activeThru, '9999-12-31') and ppd.primaryPharmacy = 1
				left join #Virtual_Phamarcy vp on rp.centerid = vp.centerid
		where	1=1
				AND vp.centerid is null
				AND rp.activeAsOF between @BEGIN and @end
				and isnull(rp.activethru, cast(@END as date)) between cast(@BEGIN as date) and cast(@END as date) 
				AND cast(rp.activeAsOF as date) <= isNull(rp.activethru, cast(@END as date))
				AND isNULL(rp.mtmServiceDT, @END) > rp.activeAsOF 
				AND (rp.mtmServiceDT is null or rp.mtmServiceDT between @BEGIN and @end)
				AND rp.statusID in (2, 6) and rp.resultTypeID in (5, 6)
	)	CMR
where	CMR.rank = 1


DROP TABLE IF EXISTS #UnionCMR
SELECT	*
INTO	#UnionCMR
FROM
	(
		SELECT	*
		FROM	#CMR_PrimaryPharmacy 
		UNION ALL
		SELECT	*
		FROM	#CMR_NonPrimaryPharmacy 
	)	CMR

drop table if exists #CMRCount
select	*
into	#CMRCount
from
	(
		select	f.[Primary center]							as [centerid]
				, sum(f.[Primary center CMR Opportunities])	as [CMR Opportunities]
				, sum(f.[Primary center CMR Attempted])		as [CMRs Attempted]
				, sum(f.[Primary center CMR completed])		as [CMRs completed]
		from	#UnionCMR f
		where	f.[Primary center] is not null 
		group by f.[Primary center] 
		union all
		select	f.[Service center]							as [centerid]
				, sum(f.[Service center CMR Opportunities])	as [CMR Opportunities]
				, sum(f.[Service center CMR Attempted])		as [CMRs Attempted]
				, sum(f.[Service center CMR completed])		as [CMRs completed]
		from	#UnionCMR f
		where	f.[Service center] is not null 
		group by f.[Service center]
	)	CMR


drop table if exists #CMRCount_Sum
select	*
into	#CMRCount_Sum
from
	(
		select	[centerid]
				, sum([CMR Opportunities])		as [CMR Opportunities]
				, sum([CMRs Attempted])			as [CMRs Attempted]
				, sum([CMRs Completed])			as [CMRs Completed]
				, case	when sum([CMR Opportunities]) = 0 then '0.00%'	
						else CONVERT(varchar, isnull(cast((cast(sum([CMRs completed]) as decimal) * 100/nullif(cast(sum([CMR Opportunities]) as decimal),0)) as decimal(5,2)),0)) + '%'  end as [CMR Completion Rate]	
		from	#CMRCount
		group by [centerid]
	)	TIP



-----------------------------------------------------------------------------------------------------------
-- AMP section --
-----------------------------------------------------------------------------------------------------------
drop table if exists #AMP_Checkpoint
create table #AMP_Checkpoint
(
	TotalOpportunities_CheckpointCount int null, 
	TotalCompleted_CheckpointCount int null, 
	TotalSuccessful_CheckpointCount int null , 
	PatientID int null , 
	PatientID_ALL varchar(100) null , 
	centerid int null 
)


if MONTH(@BEGIN) in (1,2,3) 
BEGIN
insert into #AMP_Checkpoint ( TotalOpportunities_CheckpointCount , TotalCompleted_CheckpointCount , TotalSuccessful_CheckpointCount , PatientID , PatientID_ALL ,  centerid )
SELECT	rp.TotalOpportunities_CheckpointCount --sum(rp.TotalOpportunities_CheckpointCount)  as TotalOpportunities_CheckpointCount
		, rp.TotalCompleted_CheckpointCount --sum(rp.TotalCompleted_CheckpointCount) as TotalCompleted_CheckpointCount
		, rp.TotalSuccessful_CheckpointCount --sum(rp.TotalSuccessful_CheckpointCount) as TotalSuccessful_CheckpointCount
		, Pat.PatientID
		, rp.patientid_all
		, ph.centerid				
FROM	dbo.ampcheckpoint_previousyear rp with(nolock)					
		join policy p  with(nolock) on p.policyID = rp.policyID					
		join pharmacy ph on ph.ncpdp_nabp = rp.ncpdp_nabp
		left join 
				(
					select	pt.PatientID 
							, pt.PatientID_All 
							, pt.PolicyID 
							, ranker = ROW_NUMBER() over (partition by pt.PatientID order by pt.ActiveAsOf desc)
					from	outcomesmtm.dbo.patientdim pt			
					where	1=1								
							and pt.OutcomesEligibilityDate >= @BEGIN
							and pt.OutcomesEligibilityDate <= @END
				)	Pat on Pat.PatientID_All = rp.PatientID_All and Pat.ranker = 1		
WHERE	1=1  
			--group by  rp.patientid_all , oc.orgID	
				
END	

else --if MONTH(@BEGIN) NOT in (1,2,3)
BEGIN
insert into #AMP_Checkpoint (TotalOpportunities_CheckpointCount , TotalCompleted_CheckpointCount , TotalSuccessful_CheckpointCount , PatientID , PatientID_ALL ,  centerid )
SELECT	rp.TotalOpportunities_CheckpointCount --sum(rp.TotalOpportunities_CheckpointCount)  as TotalOpportunities_CheckpointCount
		, rp.TotalCompleted_CheckpointCount --sum(rp.TotalCompleted_CheckpointCount) as TotalCompleted_CheckpointCount
		, rp.TotalSuccessful_CheckpointCount --sum(rp.TotalSuccessful_CheckpointCount) as TotalSuccessful_CheckpointCount
		, Pat.PatientID
		, rp.patientid_all
		, ph.centerid				
FROM	dbo.ampcheckpoint_currentyear rp with(nolock)					
		join policy p  with(nolock) on p.policyID = rp.policyID					
		join pharmacy ph on ph.ncpdp_nabp = rp.ncpdp_nabp
		left join 
				(
					select	pt.PatientID 
							, pt.PatientID_All 
							, pt.PolicyID 
							, ranker = ROW_NUMBER() over (partition by pt.PatientID order by pt.ActiveAsOf desc)
					from	outcomesmtm.dbo.patientdim pt			
					where	1=1								
							and pt.OutcomesEligibilityDate >= @BEGIN
							and pt.OutcomesEligibilityDate <= @END
				)	Pat on Pat.PatientID_All = rp.PatientID_All and Pat.ranker = 1
			
WHERE	1=1  
--group by  rp.patientid_all , oc.orgID	
END


drop table if exists #AMP_Checkpoint_PatientSummary
select	sum(rp.TotalOpportunities_CheckpointCount)  as TotalOpportunities_CheckpointCount
		, sum(rp.TotalCompleted_CheckpointCount)	as TotalCompleted_CheckpointCount
		, sum(rp.TotalSuccessful_CheckpointCount)	as TotalSuccessful_CheckpointCount					
		, rp.patientid_all
		, rp.centerid
into	#AMP_Checkpoint_PatientSummary
from	#AMP_Checkpoint rp
group by  rp.patientid_all , rp.centerid


drop table if exists #AMP_Final
select	centerid	
		, [AMP Checkpoint Opportunities]
		, [AMP Checkpoints Completed]
		, [AMP Checkpoints Successful]		
		, case when [AMP Checkpoint Opportunities] > 0  then cast(FORMAT(([AMP Checkpoints Completed] * 100.0/[AMP Checkpoint Opportunities]) , 'N2') as varchar(50) ) + '%' else '0 %' end as [AMP Checkpoints Completion Rate]
		, case when [AMP Checkpoints Completed] > 0 then cast(FORMAT(([AMP Checkpoints Successful] * 100.0/[AMP Checkpoints Completed]) , 'N2') as varchar(50) ) + '%' else '0 %' end as [AMP Checkpoints Success Rate]
		, case when [AMP Checkpoint Opportunities] > 0  then cast(FORMAT(([AMP Checkpoints Successful] * 100.0/[AMP Checkpoint Opportunities]) , 'N2') as varchar(50) ) + '%' else '0 %' end as [AMP Checkpoints Net Effective Rate]
into	#AMP_Final
from 
	(
		select	AMP.centerid
				, sum(AMP.TotalOpportunities_CheckpointCount) as [AMP Checkpoint Opportunities]
				, sum(AMP.TotalCompleted_CheckpointCount) as [AMP Checkpoints Completed]
				, sum(AMP.TotalSuccessful_CheckpointCount) as [AMP Checkpoints Successful]						
		from	#AMP_Checkpoint_PatientSummary AMP
		group by  AMP.centerid
	)	AMP_Summarized



--------------------------------------------------------------------------------------------------------------------------------
-- #Report
drop table if exists #report 
select	*
into	#report
from
	(
		select	distinct ph.centerid
				, ph.NCPDP_NABP
				, replace(replace(replace(ph.centername,char(9),''),char(10),''),char(13),'') as [PharmacyName]
				, ph.addressState as [Pharmacy State]
				, pr.Relationship_ID
				, pr.Relationship_ID_Name
				, isnull(ta.[TIP Opportunities],0)						as [TIP Opportunities]
				, isnull(ta.[TIPs Completed],0)							as [TIPs Completed]
				, isnull(ta.[TIPs Successful],0)						as [TIPs Successful]
				, isnull(ta.[TIP Net Effective Rate],'0.00%')					as [TIP Net Effective Rate]
				-----------------------------
				, isnull(ta.[Cost Quality TIP Opportunities],0)			as [Cost Quality TIP Opportunities]
				, isnull(ta.[Cost Quality TIPs Completed],0)			as [Cost Quality TIPs Completed]
				, isnull(ta.[Cost Quality TIPs Successful],0)			as [Cost Quality TIPs Successful]
				, isnull(ta.[Cost Quality TIP Net Effective Rate],'0.00%')	as [Cost Quality TIP Net Effective Rate]
				-----------------------------
				, isnull(ta.[Star TIP Opportunities],0)					as [Star TIP Opportunities]
				, isnull(ta.[Star TIPs Completed],0)					as [Star TIPs Completed]
				, isnull(ta.[Star TIPs Successful],0)					as [Star TIPs Successful]
				, isnull(ta.[Star TIPs Net Effective Rate],'0.00%')			as [Star TIPs Net Effective Rate]
				-----------------------------
				,isnull(cm.[CMR Opportunities] ,0)						as [CMR Opportunities]
				,isnull(cm.[CMRs Attempted] ,0)							as [CMRs Attempted]
				,isnull(cm.[CMRs completed] ,0)							as [CMRs completed]
				,isnull(cm.[CMR Completion Rate],'0.00%')						as [CMR Completion Rate]
				-----------------------------
				, isnull(af.[AMP Checkpoint Opportunities], 0)			as [AMP Checkpoint Opportunities]
				, isnull(af.[AMP Checkpoints Completed], 0)				as [AMP Checkpoints Completed]
				, isnull(af.[AMP Checkpoints Successful], 0)			as [AMP Checkpoints Successful]
				, isnull(af.[AMP Checkpoints Net Effective Rate], '0.00%')		as [AMP Checkpoints Net Effective Rate]
				-----------------------------
				, case when isnull(ta.[Cost Quality TIP Opportunities],0) <> 0 then 15 else 0 end costqualitypt
				, case when isnull(ta.[Star TIP Opportunities],0) <> 0 then 35 else 0 end starpt
				, case when isnull(cm.[CMR Opportunities],0) <> 0 then 50 else 0 end cmrpt
		from	outcomesMTM.dbo.pharmacy ph
				join OutcomesMTM.dbo.NCPDP_Provider np on np.NCPDP_Provider_ID = ph.NCPDP_NABP
				left join 
						(
							select	row_number() over (partition by ph.centerID order by case when pr.Relationship_type = '02' then '99' else pr.Relationship_type end asc) as [Rank]
									, ph.centerid
									, pr.Relationship_Type
									, pr.Relationship_ID
									, pr.Relationship_ID_Name
									, pr.parent_organization_ID
									, pr.parent_organization_Name
							from	outcomesmtm.dbo.providerRelationshipView pr
									join outcomesmtm.dbo.pharmacy ph on ph.NCPDP_NABP = pr.mtmCenterNumber
							where	1=1
									and pr.Relationship_Type in ('01', '05', '02')

						)	pr on pr.centerid = ph.centerid and pr.[Rank] = 1
				left join #TIPCount_Sum ta on ta.centerid = ph.centerid
				left join #CMRCount_Sum cm on cm.centerid = ph.centerID
				left join #AMP_Final af on af.centerid = ph.centerid 
				
		where	1=1
				and np.Active = 1
	) report


drop table if exists #score
select	centerid
		, [Cost Quality TIP Net Effective Rate]
		, case	when [Cost Quality TIP Net Effective Rate] = '0.00%' then 0 
				else round((CUME_DIST() over (partition by (case when [Cost Quality TIP Net Effective Rate] <> '0.00%' then 1 else 0 end) order by [Cost Quality TIP Net Effective Rate]))*15,4) end	as costqualitycdf
		, case	when [Star TIPs Net Effective Rate] = '0.00%' then 0 
				else round((CUME_DIST() over (partition by (case when [Star TIPs Net Effective Rate] <> '0.00%' then 1 else 0 end) order by [Star TIPs Net Effective Rate]))*35,4) end				as starcdf
		, case	when [CMR Completion Rate] = '0.00%' then 0 
				else round((CUME_DIST() over (partition by (case when [CMR Completion Rate] <> '0.00%' then 1 else 0 end) order by [CMR Completion Rate]))*50,4) end								as cmrcdf
into	#score
from	#report r

--select * From #Score s where s.centerid = 52659

drop table if exists #composite
select	r.centerid
		, costqualitycdf
		, starcdf
		, cmrcdf
		, costqualitypt
		, starpt
		, cmrpt
		, case	when costqualitypt + starpt + cmrpt = 0 then 0
				else ((costqualitycdf + starcdf + cmrcdf)/(costqualitypt + starpt + cmrpt))*100 end as composite
into	#composite
from	#report r
		join #score s on r.centerid = s.centerid

--select * From #composite c where c.centerid = 52659

drop table if exists #percentrank
select	c.centerid 
		, composite
		, case	when composite  = 0 then 0 
				when round(percent_rank() over (partition by (case when composite <> 0 then 1 else 0 end) order by composite),3) = 0 then 0.001
				else round(percent_rank() over (partition by (case when composite <> 0 then 1 else 0 end) order by composite),3) end as percentrank
into	#percentrank
from	#composite c




-- Final report
select	r.NCPDP_NABP								as [NCPDP]
		, r.[PharmacyName]							as [Pharmacy Name]
		, r.[Pharmacy State]						as [Pharmacy State]
		, r.Relationship_ID							as [Relationship ID]
		, r.Relationship_ID_Name					as [Relationship Name]
		, r.[TIP Opportunities]						as [TIP Opportunities]
		, r.[TIPs Completed]						as [TIPs Completed]
		, r.[TIPs Successful]						as [TIPs Successful]
		, r.[TIP Net Effective Rate]				as [TIP Net Effective Rate]
		-----------------------------
		, r.[Cost Quality TIP Opportunities]		as [Cost Quality TIP Opportunities]
		, r.[Cost Quality TIPs Completed]			as [Cost Quality TIPs Completed]
		, r.[Cost Quality TIPs Successful]			as [Cost Quality TIPs Successful]
		, r.[Cost Quality TIP Net Effective Rate]	as [Cost Quality TIP Net Effective Rate]
		-----------------------------
		, r.[Star TIP Opportunities]				as [Star TIP Opportunities]
		, r.[Star TIPs Completed]					as [Star TIPs Completed]
		, r.[Star TIPs Successful]					as [Star TIPs Successful]
		, r.[Star TIPs Net Effective Rate]			as [Star TIP Net Effective Rate]

		, r.[AMP Checkpoint Opportunities]			as [AMP Checkpoint Opportunities]
		, r.[AMP Checkpoints Completed]				as [AMP Checkpoints Completed]
		, r.[AMP Checkpoints Successful]			as [AMP Checkpoints Successful]
		, r.[AMP Checkpoints Net Effective Rate]		as [AMP Checkpoints Net Effective Rate]
		-----------------------------
		, r.[CMR Opportunities]						as [CMR Opportunities]
		, r.[CMRs Attempted]						as [CMRs Attempted]
		, r.[CMRs completed]						as [CMRs Completed]
		, r.[CMR Completion Rate]					as [CMR Completion Rate]
		, pv.[Patient Volume]						
		, pa.[Patient Activity]
		-----------------------------
		, case	when sc.costqualitycdf = 0 then '0' else cast(cast(sc.costqualitycdf as decimal (9,4)) as varchar) end	as [Cost Quality Score]
		, case	when sc.starcdf = 0 then '0' else cast(cast(sc.starcdf as decimal (9,4)) as varchar) end				as [Star Score]
		, case	when sc.cmrcdf = 0 then '0' else cast(cast(sc.cmrcdf as decimal (9,4)) as varchar) end					as [CMR Score]
		, case	when co.composite  <> '0' then cast(cast(round(co.composite,4) as decimal (9,4)) as varchar) 
				when  r.costqualitypt + r.starpt + r.cmrpt = 0 then 'N/A'
				when r.costqualitypt + r.starpt + r.cmrpt <> 0  and co.costqualitycdf + co.starcdf + co.cmrcdf = 0 then '0'
				end																										as [Composite Score]
		, case	when PERCENTRANK >=0.85 then '4'
				when PERCENTRANK >=0.5 and PERCENTRANK <0.85 then '3'
				when PERCENTRANK >=0.15 and PERCENTRANK <0.5 then '2'
				when PERCENTRANK >0 and PERCENTRANK <0.15 then '1'
				when PERCENTRANK =0 and r.costqualitypt + r.starpt +r.cmrpt <> 0  then '0'
				else 'N/A' end																							as [Performance Score]
		, case	when pr.percentrank <> 0 then cast(cast(pr.percentrank*100 as decimal(5,1)) as varchar) + '%' 
				when  r.costqualitypt + r.starpt + r.cmrpt = 0 then 'N/A'
				else '0' end																							as [Percentile Rank]
from	#report r
		join #score sc on sc.centerid = r.centerid
		join #composite co on co.centerid = r.centerid
		join #percentrank pr on pr.centerid = r.centerid 
		left join 
		(
			select	pv.[centerid]
					, count(distinct pv.patientID) as [Patient Volume]
			from
			(
				select	tip.[Primary centerid] as [centerid]
						, tip.patientid
				from	#UnionTIP tip
				union all
				select	cmr.[Primary center] as [centerid]
						, cmr.patientid
				from	#UnionCMR cmr
			)	pv
			group by pv.[centerid]
		)	pv on pv.[centerid] = r.[centerid]
		left join 
		(
			select	pa.[centerid]
					, count(distinct pa.patientID) as [Patient Activity]
			from
			(
				select	tip.[Primary centerid]	as [centerid]
						, tip.patientid
				from	#UnionTIP tip
				where	tip.[Primary centerid TIPs Completed] = 1 or tip.[Service centerid TIPs Completed] = 1
				union all
				select	cmr.[Primary center] as [centerid]
						, cmr.patientid
				from	#UnionCMR cmr
				where	cmr.[Primary center CMR Attempted] = 1 or cmr.[Service center CMR Attempted] = 1
			)	pa
			group by pa.[centerid]
		)	pa on pa.[centerid] = r.[centerid]


end


