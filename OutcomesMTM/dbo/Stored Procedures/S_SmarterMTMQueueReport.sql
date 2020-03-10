
CREATE procedure [dbo].[S_SmarterMTMQueueReport]
AS
BEGIN

   SET NOCOUNT ON;
   SET XACT_ABORT ON;

   SELECT DISTINCT 
	    sb.smarterMTMQueueBucketID
	   ,sbp.policyid 
	   ,sb.bucketDesc AS [BucketName]
	   ,sb.bucketNote
	   ,pt.PatientID_All
	   ,pt.PatientID
	   ,pt.First_Name
	   ,pt.Last_Name
	   ,pt.DOB
	   ,pt.Phone
	   ,t.[tipcnt]
	   ,CASE 
          WHEN c.CMRcompleted IS NULL OR c.CMRcompleted = 0 
             THEN 'Y' 
          ELSE 'N' 
       END AS [cmr]
	   ,pt.CMReligible
	   ,ph.NCPDP_NABP AS [primaryPharmacyNABP]
	   ,ph.centername AS [primaryPharmacyName]
	   ,ppp.pctFillatCenter
	   ,CASE 
          WHEN a.Admonitorcnt IS NULL 
             THEN 'N' 
          ELSE 'Y' 
       END AS [CheckpointDue]
	   ,q.Rank
   FROM outcomesMTM.staging.smarterMTMQueueBucket sb
      JOIN outcomesMTM.staging.smarterMTMQueueBucketPatient sbp 
	      ON sbp.smarterMTMQueueBucketID = sb.smarterMTMQueueBucketID
      JOIN outcomesMTM.dbo.patientDim pt 
	      ON pt.PatientID = sbp.patientID
        AND pt.isCurrent = 1
      JOIN outcomesMTM.staging.staging_patientPrimaryPharmacy ppp 
	      ON ppp.patientid = pt.PatientID
	     AND ppp.primaryPharmacy = 1
      JOIN outcomesMTM.dbo.pharmacy ph 
	      ON ph.centerID = ppp.centerID
      JOIN outcomesMTM.dbo.MTMOpportunitiesReportRank q 
	      ON q.centerid = ph.centerid
	     AND q.patientid = pt.PatientID
      LEFT JOIN (SELECT 
                     m.patientid
                    ,q.centerid
                    ,COUNT(*) AS ADmonitorcnt 
                 FROM outcomesMTM.dbo.AdherenceMonitorQueue q
                    JOIN outcomesMTM.dbo.AdherenceMonitor m 
                       ON m.AdherenceMonitorID = q.AdherenceMonitorID
                 WHERE 1=1 
                   AND q.AdherenceMonitorQueueStatusID = 1
                   AND q.adherenceMonitorYear = YEAR(GETDATE())
                 GROUP BY m.patientid, q.centerid 
                ) a 
	      ON pt.patientid = a.patientid 
	     AND a.centerid = ph.centerid
      LEFT JOIN (SELECT 
                     t.centerid
                    ,t.patientid
                    ,SUM(tipcnt) AS tipcnt
	              FROM (SELECT 
                           tr.patientid
                          , trsc.centerid
                          , 1 AS tipcnt
		                 FROM outcomesMTM.dbo.tipresultDim tr WITH (NOLOCK) 
   		                 JOIN outcomesMTM.staging.tipdetail_tip td WITH (NOLOCK) 
                             ON td.tipdetailid = tr.tipdetailid   
	   	                 JOIN outcomesMTM.staging.tipresultstatus trs WITH (NOLOCK) 
                             ON trs.tipresultid = tr.tipresultid 
		                    JOIN outcomesMTM.staging.tipresultstatuscenter trsc WITH (NOLOCK) 
                             ON trs.tipresultstatusid = trsc.tipresultstatusid
		                    JOIN outcomesMTM.staging.tipstatus ts WITH (NOLOCK) 
                             ON ts.tipstatusid = trs.tipstatusid
		                    JOIN outcomesMTM.staging.tipstatustype tst WITH (NOLOCK) 
                             ON tst.tipstatustypeid = ts.tipstatustypeid 
		                 WHERE 1=1     
		                   AND tr.activethru IS NULL
                         AND trs.active = 1  
                         AND trsc.active = 1   
                         AND tst.tipstatustypeid in (1,3)     
	                   ) T 
	              WHERE 1=1 
	              GROUP BY 
                     t.patientid
                    ,t.centerid
                ) t 
	      ON t.patientid = pt.patientid 
	     AND t.centerid = ph.centerid  
      LEFT JOIN outcomesMTM.staging.patientCMR c 
	      ON c.patientid = pt.patientid 
        AND c.cmrcompleted = 1 
   WHERE 1=1
     AND sb.active = 1
     AND pt.activeAsOf <= ISNULL(c.CMRoffereddate, '2050/12/31')
     AND ISNULL(pt.activeThru, '2075/01/01') >= ISNULL(c.CMRoffereddate, '2050/12/31')

END



