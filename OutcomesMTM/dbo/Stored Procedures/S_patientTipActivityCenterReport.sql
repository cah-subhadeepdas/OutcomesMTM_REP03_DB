
CREATE PROCEDURE [dbo].[S_patientTipActivityCenterReport] AS

BEGIN

DECLARE @Today AS DATETIME = GETDATE()

SELECT 
    t.tipresultstatuscenterid 
   ,t.tipresultstatusid  
   ,t.patientid 
   ,t.centerid 
   ,t.tipdetailid  
   ,t.policyid 
   ,CASE 
       WHEN ISNULL(td.StarTip, 0) = 1 
          THEN 'STAR' 
       WHEN ISNULL(td.StarTip, 0) = 0 
        AND td.reasonTypeID = 2 
          THEN 'COST' 
       ELSE 'QUALITY' 
    END AS tiptype 
   ,CASE 
       WHEN DATEDIFF(DAY, CAST(t.activeasof AS DATE),CAST(t.activethru AS DATE)) < 30 
        AND t.claimid IS NULL 
        AND t.tipstatusid IS NULL 
          THEN 0 
       ELSE 1 
    END AS [30dayrule] 
   ,1 AS [TIP Opportunities]
   ,CASE 
       WHEN t.claimid IS NOT NULL 
         OR t.tipstatusid IS NOT NULL 
          THEN 1 
       ELSE 0 
    END AS [TIP Activity]
   ,CASE 
       WHEN t.claimstatusid = 6 
          THEN 1 
       ELSE 0 
    END AS [Approved TIPs]
   ,CASE 
       WHEN t.claimstatusid = 2 
          THEN 1 
       ELSE 0 
    END AS [Pending Approval TIPs]
   ,CASE 
       WHEN t.claimstatusid = 4 
          THEN 1 
       ELSE 0 
    END AS [Review/resubmit TIPs]
   ,CASE 
       WHEN t.claimstatusid = 5 
          THEN 1 
       ELSE 0 
    END AS [Rejected TIPs]
   ,CASE 
       WHEN t.claimstatusid = 1 
          THEN 1 
       ELSE 0 
    END AS [Unfinished TIPs]
   ,CASE 
       WHEN t.tipstatusid IS NOT NULL 
          THEN 1 
       ELSE 0 
    END AS [No intervention Necessary TIPs]
   ,CASE 
       WHEN t.tipstatusid IS NOT NULL 
         OR t.claimstatusid IN (2, 6)
          THEN 1 
       ELSE 0 
    END AS [Completed TIPs]
   ,CASE 
       WHEN t.tipstatusid IS NULL 
        AND t.claimstatusid IN (2, 6) 
        AND t.resultTypeID NOT IN (12, 13, 16, 18)  
          THEN 1 
       ELSE 0 
    END AS [Successful TIPs]
   ,CASE 
    WHEN t.tipstatusid IS NULL 
     AND t.claimstatusid = 6 
     AND t.resultTypeID NOT IN (12, 13, 16, 18) 
     AND ISNULL(t.paid, 0) = 0 
       THEN 1 
     ELSE 0 
    END AS [Successful Approved TIPs]
   ,CASE 
       WHEN t.tipstatusid IS NULL 
        AND t.claimstatusid = 6 
        AND t.resultTypeID NOT IN (12, 13, 16, 18) 
        AND ISNULL(t.paid, 0) <> 0 
          THEN 1 
       ELSE 0 
    END AS [Successful Paid TIPs]
   ,CASE 
       WHEN t.tipstatusid IS NULL 
        AND t.claimstatusid = 2 
        AND t.resultTypeID NOT IN (12, 13, 16, 18) 
          THEN 1 
       ELSE 0 
    END AS [Successful Pending Approval TIPs]
   ,CASE 
       WHEN t.tipstatusid IS NOT NULL 
         OR (    t.claimstatusid IN (2, 6) 
             AND t.resultTypeID IN (12, 13, 16, 18)) 
          THEN 1 
       ELSE 0 
    END AS [Unsuccessful TIPs]
   ,CASE 
       WHEN t.claimstatusid IN (2, 6) 
        AND t.resulttypeid = 13
          THEN 1 
       ELSE 0 
    END AS [Prescriber Refusal TIPs]
   ,CASE 
       WHEN t.claimstatusid IN (2, 6) 
        AND t.resulttypeid = 16
          THEN 1 
       ELSE 0 
    END AS [Unable to reach prescriber after 3 attempts]
   ,CASE 
       WHEN t.claimstatusid IN (2, 6) 
        AND t.resulttypeid = 12 
          THEN 1 
       ELSE 0 
    END AS [Patient Refusal TIPs]
   ,CASE 
       WHEN t.claimstatusid IN (2, 6) 
        AND t.resulttypeid = 18 
          THEN 1 
       ELSE 0 
    END AS [Patient Unable to Reach TIPs]
   ,ISNULL(ppp.primaryPharmacy,0) AS primaryPharmacy   
   ,CAST(t.activeasof AS DATE) AS activeasof
   ,CAST(t.activethru AS DATE) AS activethru
   ,CASE 
       WHEN t.claimid IS NULL 
        AND t.tipstatusid IS NULL 
        AND t.active = 1 
          THEN 1 
       ELSE 0 
    END AS [currently active]
   ,CASE 
       WHEN t.claimid IS NULL 
        AND t.tipstatusid IS NULL 
        AND t.active = 0 
          THEN 1 
       ELSE 0 
    END AS [withdrawn]
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
FROM (
      SELECT 
          ts.tipresultstatuscenterid
         ,ts.tipresultstatusid 
         ,ts.patientid 
         ,ts.centerid  
         ,ts.tipresultid 
         ,ts.tipdetailid  
         ,ts.policyid 
         ,ts.activeasof   
         ,ts.activethru 
         ,ts.claimid 
         ,ts.statusid AS claimstatusid  
         ,ts.resulttypeid 
         ,ts.paid 
         ,ts.tipstatusid  
         ,ts.active
         ,ts.chainid 
         ,ts.centername
         ,ts.chainnm
         ,ts.ncpdp_nabp
         ,ts.parent_organization_id
         ,ts.parent_organization_name
         ,ts.patientid_all
         ,po.policyname
         ,ts.relationship_id
         ,ts.relationship_id_name
         ,ts.relationship_type
         ,ts.tiptitle
      FROM (
            SELECT 
                ROW_NUMBER() OVER (PARTITION BY trsc.tipresultstatuscenterid 
                                   ORDER BY c.createdt DESC, i.createdate DESC) AS [rank]  
               ,trsc.tipresultstatuscenterid
               ,trs.tipresultstatusid 
               ,trsc.centerid 
               ,trs.tipresultid
               ,a.patientid 
               ,a.tipdetailid  
               ,COALESCE(c.policyID, pt.policyid) AS policyID
               ,trsc.createdate AS activeasof   
               ,COALESCE(trsc.activeenddate, @Today) AS activethru 
               ,c.claimid
               ,c.statusid 
               ,c.resulttypeid 
               ,c.paid 
               ,CASE 
                   WHEN c.claimid IS NOT NULL 
                      THEN NULL 
                   ELSE i.tipstatusid 
                END AS tipstatusid 
               ,trsc.active
               ,phc.chainid 
               ,pt.patientid_all
               ,ch.chainnm
               ,ph.centername
               ,ph.ncpdp_nabp
               ,td.tiptitle
               ,ncpdp.parent_organization_id
               ,ncpdp.parent_organization_name
               ,ncpdp.relationship_id
               ,ncpdp.relationship_id_name
               ,ncpdp.relationship_type
            FROM staging.tipresultstatus trs WITH (NOLOCK) 
               JOIN staging.tipresultstatuscenter trsc WITH (NOLOCK) 
                  ON trsc.tipresultstatusid = trs.tipresultstatusid 
               JOIN dbo.tipresultDim a 
                  ON a.tipresultid = trs.tipresultid 
                 AND a.iscurrent = 1
               JOIN dbo.patientDim pt WITH (NOLOCK) 
                  ON pt.patientid = a.patientid 
                 AND @Today >= pt.activeAsOf 
                 AND @Today <= ISNULL(pt.activeThru, @Today)
               JOIN staging.tipDetail_tip td WITH (NOLOCK) 
                  ON td.tipdetailID = a.tipdetailID
               LEFT JOIN dbo.pharmacychain phc WITH (NOLOCK) 
                  ON phc.centerid = trsc.centerid 
               LEFT JOIN dbo.chain ch WITH (NOLOCK) 
                  ON phc.chainID = ch.chainID
               LEFT JOIN dbo.pharmacy ph WITH (NOLOCK) 
                  ON trsc.centerid = ph.centerID
               LEFT JOIN dbo.providerRelationshipViewstaging ncpdp 
                  ON ncpdp.mtmCenterNumber = ph.NCPDP_NABP 
                 AND ch.chaincode=ncpdp.Relationship_ID
               LEFT JOIN (
                          SELECT 
                              c.claimid
                             ,c.tipresultid 
                             ,c.statusid 
                             ,c.resulttypeid 
                             ,c.paid 
                             ,c.createdt 
                             ,c.centerid
                             ,c.policyID 
                          FROM dbo.claim c WITH (NOLOCK) 
                             --JOIN dbo.claimstatus cs WITH (NOLOCK) 
                             --   ON cs.claimid = c.claimid 
                             --  AND cs.active = 1
                             --JOIN staging.[status] s WITH (NOLOCK) 
                             --   ON s.statusid = c.statusID
                             --JOIN claims.dbo.claimmtmcenter mc WITH (NOLOCK) ON mc.claimid = c.claimid  AND mc.active = 1 
                          WHERE c.tipresultid IS NOT NULL 
                            AND c.statusid <> 3
                         ) c 
                  ON c.tipresultid = trs.tipresultid 
                 AND c.centerid = trsc.centerid 
                 AND c.createdt >= trsc.createdate 
                 AND c.createdt < COALESCE(trsc.activeenddate, @Today)
               LEFT JOIN (
                          SELECT 
                              trs.tipresultid
                             ,trs.tipstatusid  
                             ,trsc.centerid 
                             ,trsc.createdate 
                           FROM staging.tipresultstatus trs WITH (NOLOCK) 
                              JOIN staging.tipresultstatuscenter trsc WITH (NOLOCK) 
                                 ON trsc.tipresultstatusid = trs.tipresultstatusid 
                              JOIN staging.tipstatus ts WITH (NOLOCK) 
                                 ON ts.tipstatusid = trs.tipstatusid 
                           WHERE tipstatustypeid = 2 
                          ) i 
                  ON i.tipresultid = trs.tipresultid 
                 AND i.centerid = trsc.centerid 
                 AND i.createdate >= trsc.createdate 
                 AND i.createdate < COALESCE(trsc.activeenddate, @Today) 
               WHERE trs.tipstatusid = 1 
           ) ts
         JOIN dbo.Policy po WITH (NOLOCK) 
            ON po.policyID = ts.policyID
      WHERE [rank] = 1
     ) t 
   JOIN staging.TIPDetail_tip td WITH (NOLOCK) 
      ON td.tipdetailid = t.tipdetailid 
   LEFT JOIN staging.patientPrimaryPharmacy ppp 
      ON ppp.patientid = t.patientid 
     AND ppp.centerid = t.centerid 
     AND ppp.primaryPharmacy = 1
                                                                                                                                                 
END
