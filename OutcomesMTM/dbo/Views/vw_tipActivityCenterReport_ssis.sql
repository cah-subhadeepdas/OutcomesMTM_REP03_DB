


CREATE VIEW [dbo].[vw_tipActivityCenterReport_ssis] 
AS 

   SELECT 
       t.tipresultstatuscenterid 
      ,t.tipresultstatusid  
      ,t.patientid 
      ,t.centerid 
      ,t.tipdetailid  
      ,t.policyid 
      ,CASE WHEN ISNULL(td.StarTip,0) = 1 THEN 'STAR' WHEN ISNULL(td.StarTip,0) = 0 AND td.reasonTypeID = 2 THEN 'COST' ELSE 'QUALITY' END AS tiptype 
      ,CASE WHEN DATEDIFF(DAY,CAST(t.activeasof AS DATE),CAST(t.activethru AS DATE)) < 30 AND t.claimid IS NULL AND t.tipstatusid IS NULL THEN 0 ELSE 1 END AS [30dayrule] 
      ,1 AS [TIP Opportunities]
      ,CASE WHEN t.claimid IS NOT NULL OR t.tipstatusid IS NOT NULL THEN 1 ELSE 0 END AS [TIP Activity]
      ,CASE WHEN t.claimstatusid = 6 THEN 1 ELSE 0 END AS [Approved TIPs]
      ,CASE WHEN t.claimstatusid = 2 THEN 1 ELSE 0 END AS [Pending Approval TIPs]
      ,CASE WHEN t.claimstatusid = 4 THEN 1 ELSE 0 END AS [Review/resubmit TIPs]
      ,CASE WHEN t.claimstatusid = 5 THEN 1 ELSE 0 END AS [Rejected TIPs]
      ,CASE WHEN t.claimstatusid = 1 THEN 1 ELSE 0 END AS [Unfinished TIPs]
      ,CASE WHEN t.tipstatusid IS NOT NULL THEN 1 ELSE 0 END AS [No intervention Necessary TIPs]
      ,CASE WHEN (t.tipstatusid IS NOT NULL OR (t.claimstatusid IN (2,6))) THEN 1 ELSE 0 END AS [Completed TIPs]
      ,CASE WHEN t.tipstatusid IS NULL AND t.claimstatusid IN (2,6) AND t.resultTypeID not IN (12,13,16,18)  THEN 1 ELSE 0 END AS [Successful TIPs]
      ,CASE WHEN t.tipstatusid IS NULL AND t.claimstatusid = 6 AND t.resultTypeID not IN (12,13,16,18) AND ISNULL(t.paid, 0) = 0 THEN 1 ELSE 0 END AS [Successful Approved TIPs]
      ,CASE WHEN t.tipstatusid IS NULL AND t.claimstatusid = 6 AND t.resultTypeID not IN (12,13,16,18) AND ISNULL(t.paid, 0) <> 0 THEN 1 ELSE 0 END AS [Successful Paid TIPs]
      ,CASE WHEN t.tipstatusid IS NULL AND t.claimstatusid = 2 AND t.resultTypeID not IN (12,13,16,18) THEN 1 ELSE 0 END AS [Successful Pending Approval TIPs]
      ,CASE WHEN t.tipstatusid IS NOT NULL OR (t.claimstatusid IN (2,6) AND t.resultTypeID IN (12,13,16,18)) THEN 1 ELSE 0 END AS [Unsuccessful TIPs]
      ,CASE WHEN t.claimstatusid IN (2,6) AND t.resulttypeid = 13           THEN 1 ELSE 0 END AS [Prescriber Refusal TIPs]
      ,CASE WHEN t.claimstatusid IN (2,6) AND t.resulttypeid = 16           THEN 1 ELSE 0 END AS [Unable to reach prescriber after 3 attempts]
      ,CASE WHEN t.claimstatusid IN (2,6) AND t.resulttypeid = 12           THEN 1 ELSE 0 END AS [Patient Refusal TIPs]
      ,CASE WHEN t.claimstatusid IN (2,6) AND t.resulttypeid = 18           THEN 1 ELSE 0 END AS [Patient Unable to Reach TIPs]
      ,ISNULL(ppp.primaryPharmacy,0) AS primaryPharmacy   
      ,CAST(t.activeasof AS DATE) AS activeasof
      ,CAST(t.activethru AS DATE) AS activethru
      ,CASE WHEN t.claimid IS NULL AND t.tipstatusid IS NULL AND t.active = 1 THEN 1 ELSE 0 END AS [currently active]
      ,CASE WHEN t.claimid IS NULL AND t.tipstatusid IS NULL AND t.active = 0 THEN 1 ELSE 0 END AS [withdrawn]
      ,t.chainid 
      ,t.centername
      ,t.chainnm
      ,t.ncpdp_nabp
      ,t.parent_organization_id
      ,t.parent_organization_name
      ,t.patientid_all
      ,t.policyname
      ,t.relationship_id
      ,t.relationship_id_name
      ,t.relationship_type
      ,t.tiptitle 
   from (SELECT 
             TDM.tipresultstatuscenterid
            ,TDM.tipresultstatusid 
            ,TDM.patientid 
            ,TDM.centerid  
            ,TDM.tipresultid 
            ,TDM.tipdetailid  
            ,TDM.policyid 
            ,TDM.activeasof   
            ,TDM.activethru 
            ,TDM.claimid 
            ,TDM.statusid AS claimstatusid  
            ,TDM.resulttypeid 
            ,TDM.paid 
            ,TDM.tipstatusid  
            ,TDM.active
            ,TDM.chainid 
            ,TDM.centername
            ,TDM.chainnm
            ,TDM.ncpdp_nabp
            ,TDM.parent_organization_id
            ,TDM.parent_organization_name
            ,TDM.patientid_all
            ,po.policyname
            ,TDM.relationship_id
            ,TDM.relationship_id_name
            ,TDM.relationship_type
            ,TDM.tiptitle
         from (SELECT *
               FROM staging.Temp_DeleteMe
              ) TDM
         JOIN policy po WITH (NOLOCK) 
            ON po.policyID = TDM.policyID
         WHERE[rank] = 1
        ) t 
   JOIN staging.tipdetail_tip td with (nolock) 
      ON td.tipdetailid = t.tipdetailid 
   LEFT JOIN patientPrimaryPharmacyDim ppp 
      ON ppp.patientid = t.patientid 
     AND ppp.centerid = t.centerid 
     AND ppp.primaryPharmacy = 1

