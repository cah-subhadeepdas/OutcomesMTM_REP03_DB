


-- ==========================================================================================
-- Author:		Unknown
-- Create date: Unknown
-- Description:	SP created for APNS_Opportunity_File
-- ==========================================================================================
-- Change Log
-- ==========================================================================================
--   #		Date		Author			Description
--   --		--------	----------		----------------
--   1		06/20/2018	Lakshmi Dangeti    	TC-1682

-- ==========================================================================================
CREATE procedure [dbo].APNS_Opportunity_Report
AS
BEGIN

If object_id('tempdb..#TIPs') is not null
drop table #TIPs
SELECT t.patientid_all, t.First_Name, t.last_name, t.Opportunity, t.MTMFee, t.rank
Into #TIPs
FROM (SELECT rank() over (partition by tp.Patientid_All
              order by pr.activeAsOf desc, newid()) AS [rank]    
                , tp.patientid_all
				, tp.First_Name
				, tp.last_name
				, tp.reasonTypeDesc as Opportunity
				, r.serviceFee as MTMFee
    FROM  vw_patientTipDetailReport tp
		Join AOCWPAPSQL02.Outcomes.dbo.Patient pt on pt.patientid_all = tp.patientid_all
		Join AOCWPAPSQL02.Outcomes.dbo.tipresultstatus pst on tp.tipresultid = pst.tipresultid and pst.Tipstatusid = 1
		Join AOCWPAPSQL02.Outcomes.dbo.PatientPrimaryPharmacy ppp on ppp.patientid = pt.patientid 
		Join AOCWPAPSQL02.Outcomes.dbo.centerChain pc on pc.centerid = ppp.centerid and pc.active = 1
		Join Chain ch on ch.chainid = pc.chainid
		Join staging.rar r WITH (NOLOCK) on r.reasonTypeID = tp.reasontypeid and r.active = 1
		JOIN staging.resulttype rt WITH (NOLOCK)  ON rt.resulttypeid = r.resulttypeid AND rt.successful = 1
		JOIN staging.policyRAR pr WITH (NOLOCK) ON r.rarID = pr.rarID
	Where 1=1
		and pt.OutcomesTermDate >= Getdate()-1
		and ch.chaincode = '481'
		and tp.ecaLevelID in (1,2,3,4,5,6,7)
		and Getdate() >= cast(pr.activeasof as date) 
		and Getdate() < cast(isnull(pr.activethru,'99991231')as date)
		) T 
			WHERE 1=1 
			AND t.[rank] = 1
			

-------------------------------------------------------
If object_id('tempdb..#CMRs') is not null
Drop table #CMRs
SELECT t.patientid_all, t.First_Name, t.last_name, t.Opportunity, t.MTMFee, t.rank
Into #CMRs
FROM (SELECT rank() over (partition by PT.Patientid_All
              order by pr.activeAsOf desc, newid()) AS [rank]    
                , pt.patientid_all
				, pt.First_Name
				, pt.last_name
				, 'Need CMR' AS Opportunity
				, r.serviceFee as MTMFee
    FROM AOCWPAPSQL02.Outcomes.dbo.Patient pt 
		Join AOCWPAPSQL02.Outcomes.dbo.PatientPrimaryPharmacy ppp on ppp.patientid = pt.patientid
		Join AOCWPAPSQL02.Outcomes.dbo.centerChain pc on pc.centerid = ppp.centerid and pc.active = 1
		Join Chain ch on ch.chainid = pc.chainid
		JOIN staging.policyRAR pr WITH (NOLOCK) ON pr.policyID = pt.policyid
		Join staging.rar r WITH (NOLOCK) on r.RARID = pr.RARID and r.active = 1
		JOIN staging.resulttype rt WITH (NOLOCK)  ON rt.resulttypeid = r.resulttypeid AND rt.successful = 1
Where 1=1
		and pt.cmreligible = 1
		and pt.OutcomesTermDate >= Getdate()-1
		and ch.chaincode = '481'
		--and tp.ecaLevelID in (1,2,3,4,5,6,7)
 		and Getdate() >= cast(pr.activeasof as date) 
		and Getdate() < cast(isnull(pr.activethru,'99991231')as date)
		and not exists (
				select 1 
				from AOCWPAPSQL02.Outcomes.dbo.patientCMR c  with (nolock)
				where pt.patientid = c.patientid
				and c.CMRcompleted = 1
				)
		and r.reasonTypeID = 11
		and r.actionTypeID = 1
	) T 
		WHERE 1=1 
		AND t.[rank] = 1 



If object_id('tempdb..#Final') is not null
Drop table #Final
Select c.patientid_all, c.First_Name, c.last_name, c.Opportunity, c.MTMFee Into #Final from #CMRs c
UNION ALL
SELECT t.patientid_all, t.First_Name, t.last_name, t.Opportunity, t.MTMFee FROM #TIPs t
order by 1

Select * from #Final

END