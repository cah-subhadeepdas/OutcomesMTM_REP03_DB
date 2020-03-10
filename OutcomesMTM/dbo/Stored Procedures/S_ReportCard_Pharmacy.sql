


CREATE   PROC [dbo].[S_ReportCard_Pharmacy]
(
    @begindt DATE = NULL,
    @enddt DATE = NULL
)
AS
BEGIN

    /*
--=========================================================================================
Original Card: Unknown
Created BY: Unknown
Card: Unknown

Modified Date: 12/13/2019
Modified By: Pranay BR
Desc: TC-3433 & TC-3437 has a dependencies on this procedure. This original store produce script has no change. I have modified hardcoded values into paramaters only. 


--==========================================================================================
*/


    DECLARE @BEGIN VARCHAR(10);
    DECLARE @END VARCHAR(10);


    /*
select cast(year(getdate()) as varchar(4)) + '0101'
,cast(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as date)

*/

    --Added Parameters, TC-3433 & TC-3437
    --Start
    IF (@begindt IS NULL AND @enddt IS NULL)
    BEGIN

        SET @BEGIN = CASE
                         WHEN MONTH(GETDATE()) = 1 THEN
                             CAST(YEAR(GETDATE()) - 1 AS VARCHAR(4)) + '0101'
                         ELSE
                             CAST(YEAR(GETDATE()) AS VARCHAR(4)) + '0101'
                     END; --// Beginning of year (if current month is Jan. then beginning of last year)		
        SET @END = CAST(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE()) - 1, -1) AS DATE); --end of last month

    END;

    ELSE
    BEGIN

        SET @BEGIN = CASE
                         WHEN MONTH(GETDATE()) = 1 THEN
                             CAST(YEAR(GETDATE()) - 1 AS VARCHAR(4)) + '0101'
                         ELSE
                             CAST(YEAR(GETDATE()) AS VARCHAR(4)) + '0101'
                     END; --// Beginning of year (if current month is Jan. then beginning of last year)		
        SET @END = @enddt; --end of last month
    END;

    --End



    SELECT DISTINCT
           ph.centerid,
           ph.NCPDP_NABP,
           REPLACE(REPLACE(REPLACE(ph.centername, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS [PharmacyName],
           ph.AddressState AS [Pharmacy State],
           -------------------------
           pr.Relationship_Type,
           pr.Relationship_ID,
           pr.Relationship_ID_Name,
           pr.parent_organization_ID,
           pr.parent_organization_Name,
           ---------------------
           ISNULL(ta.[TIP Opportunities], 0) AS [TIP Opportunities],
           ISNULL(ta.[Completed TIPs], 0) AS [Completed TIPs],
           ISNULL(ta.TIPCompletionRate, 0) AS TIPCompletionRate,
           ISNULL(ta.[Successful TIPs], 0) AS [Successful TIPs],
           ISNULL(ta.TIPSuccessfulRate, 0) AS TIPSuccessfulRate,
           ISNULL(ta.NetEffectiveRate, 0) AS NetEffectiveRate,
           ---------------
           ISNULL(ta.[Cost TIPs Opportunity], 0) AS [Cost TIPs Opportunity],
           ISNULL(ta.[Cost Completed TIPs], 0) AS [Cost Completed TIPs],
           ISNULL(ta.CostTIPCompletionRate, 0) AS CostTIPCompletionRate,
           ISNULL(ta.[Cost Successful TIPs], 0) AS [Cost Successful TIPs],
           ISNULL(ta.CostTIPSuccessfulRate, 0) AS CostTIPSuccessfulRate,
           ISNULL(ta.CostNetEffectiveRate, 0) AS CostNetEffectiveRate,
           ----------------
           ISNULL(ta.[Star TIPs Opportunity], 0) AS [Star TIPs Opportunity],
           ISNULL(ta.[Star Completed TIPs], 0) AS [Star Completed TIPs],
           ISNULL(ta.StarTIPCompletionRate, 0) AS StarTIPCompletionRate,
           ISNULL(ta.[Star Successful TIPs], 0) AS [Star Successful TIPs],
           ISNULL(ta.StarTIPSuccessfulRate, 0) AS StarTIPSuccessfulRate,
           ISNULL(ta.StarNetEffectiveRate, 0) AS StarNetEffectiveRate,
           -------------------------
           ISNULL(ta.[Quality TIPs Opportunity], 0) AS [Quality TIPs Opportunity],
           ISNULL(ta.[Quality Completed TIPs], 0) AS [Quality Completed TIPs],
           ISNULL(ta.QualityTIPCompletionRate, 0) AS QualityTIPCompletionRate,
           ISNULL(ta.[Quality Successful TIPs], 0) AS [Quality Successful TIPs],
           ISNULL(ta.QualityTIPSuccessfulRate, 0) AS QualityTIPSuccessfulRate,
           ISNULL(ta.QualityNetEffectiveRate, 0) AS QualityNetEffectiveRate,
           -----------------------
           ISNULL(cm.CMROpportunity, 0) AS CMROpportunity,
           ISNULL(cm.CMROffered, 0) AS CMROffered,
           ISNULL(cm.percentCMRoffered, 0) AS percentCMRoffered,
           ISNULL(cm.completedCMRs, 0) AS completedCMRs,
           ISNULL(cm.percentCMRcompletion, 0) AS percentCMRcompletion,
           ISNULL(cm.CMRNetEffectiveRate, 0) AS CMRNetEffectiveRate,
           ---------------------------
           ISNULL(pm.EligiblePatient, 0) AS EligiblePatient,
           ISNULL(cl.claimSubmitted, 0) AS claimSubmitted,
           ISNULL(cl.DTPClaims, 0) AS DTPClaims,
           ISNULL(cl.DTPpercentage, 0) AS DTPpercentage,
           ISNULL(cl.ValidationOpportunity, 0) AS ValidationOpportunity,
           ISNULL(cl.ValidationSuccess, 0) AS ValidationSuccess,
           ----------------------------
           ISNULL(cl.[PatientConsults], 0) AS [PatientConsults],
           ISNULL(cl.[PatientRefusals], 0) AS [PatientRefusals],
           ISNULL(cl.[PatientUnableToReach], 0) AS [PatientUnableToReach],
           ISNULL(cl.PatientSuccessRate, 0) AS PatientSuccessRate,
           ------------------------------
           ISNULL(cl.[PrescriberConsults], 0) AS [PrescriberConsults],
           ISNULL(cl.[PrescriberRefusals], 0) AS [PrescriberRefusals],
           ISNULL(cl.[PrescriberUnableToReach], 0) AS [PrescriberUnableToReach],
           ISNULL(cl.PrescriberSuccessRate, 0) AS PrescriberSuccessRate
    --select count(*) -- 82599
    FROM OutcomesMTM.dbo.pharmacy ph
        JOIN OutcomesMTM.dbo.NCPDP_Provider np
            ON np.NCPDP_Provider_ID = ph.NCPDP_NABP
        LEFT JOIN
        (
            SELECT ROW_NUMBER() OVER (PARTITION BY ph.centerid
                                      ORDER BY CASE
                                                   WHEN pr.Relationship_Type = '02' THEN
                                                       '99'
                                                   ELSE
                                                       pr.Relationship_Type
                                               END ASC
                                     ) AS [Rank],
                   ph.centerid,
                   pr.Relationship_Type,
                   pr.Relationship_ID,
                   pr.Relationship_ID_Name,
                   pr.parent_organization_ID,
                   pr.parent_organization_Name
            FROM OutcomesMTM.dbo.providerRelationshipView pr
                JOIN OutcomesMTM.dbo.pharmacy ph
                    ON ph.NCPDP_NABP = pr.mtmCenterNumber
            WHERE 1 = 1
                  AND pr.Relationship_Type IN ( '01', '05', '02' )
        ) pr
            ON pr.centerid = ph.centerid
               AND pr.[Rank] = 1
        LEFT JOIN
        (
            SELECT ta.centerid,
                   CAST(SUM(ta.[TIP Opportunities]) AS DECIMAL) AS [TIP Opportunities],
                   CAST(SUM(ta.[Completed TIPs]) AS DECIMAL) AS [Completed TIPs],
                   ISNULL(
                             CAST((CAST(SUM(ta.[Completed TIPs]) AS DECIMAL)
                                   / NULLIF(CAST(SUM(ta.[TIP Opportunities]) AS DECIMAL), 0)
                                  ) AS DECIMAL(5, 2)),
                             0
                         ) AS TIPCompletionRate,
                   CAST(SUM(ta.[Successful TIPs]) AS DECIMAL) AS [Successful TIPs],
                   ISNULL(
                             CAST((CAST(SUM(ta.[Successful TIPs]) AS DECIMAL)
                                   / NULLIF(CAST(SUM(ta.[Completed TIPs]) AS DECIMAL), 0)
                                  ) AS DECIMAL(5, 2)),
                             0
                         ) AS TIPSuccessfulRate,
                   ISNULL(
                             CAST((CAST(SUM(ta.[Successful TIPs]) AS DECIMAL)
                                   / NULLIF(CAST(SUM(ta.[TIP Opportunities]) AS DECIMAL), 0)
                                  ) AS DECIMAL(5, 2)),
                             0
                         ) AS NetEffectiveRate,
                   -------
                   CAST(SUM(ta.[Cost TIPs Opportunity]) AS DECIMAL) AS [Cost TIPs Opportunity],
                   CAST(SUM(ta.[Cost Completed TIPs]) AS DECIMAL) AS [Cost Completed TIPs],
                   ISNULL(
                             CAST((CAST(SUM(ta.[Cost Completed TIPs]) AS DECIMAL)
                                   / NULLIF(CAST(SUM(ta.[Cost TIPs Opportunity]) AS DECIMAL), 0)
                                  ) AS DECIMAL(5, 2)),
                             0
                         ) AS CostTIPCompletionRate,
                   CAST(SUM(ta.[Cost Successful TIPs]) AS DECIMAL) AS [Cost Successful TIPs],
                   ISNULL(
                             CAST((CAST(SUM(ta.[Cost Successful TIPs]) AS DECIMAL)
                                   / NULLIF(CAST(SUM(ta.[Cost Completed TIPs]) AS DECIMAL), 0)
                                  ) AS DECIMAL(5, 2)),
                             0
                         ) AS CostTIPSuccessfulRate,
                   ISNULL(
                             CAST((CAST(SUM(ta.[Cost Successful TIPs]) AS DECIMAL)
                                   / NULLIF(CAST(SUM(ta.[Cost TIPs Opportunity]) AS DECIMAL), 0)
                                  ) AS DECIMAL(5, 2)),
                             0
                         ) AS CostNetEffectiveRate,
                   -------
                   CAST(SUM(ta.[Star TIPs Opportunity]) AS DECIMAL) AS [Star TIPs Opportunity],
                   CAST(SUM(ta.[Star Completed TIPs]) AS DECIMAL) AS [Star Completed TIPs],
                   ISNULL(
                             CAST((CAST(SUM(ta.[Star Completed TIPs]) AS DECIMAL)
                                   / NULLIF(CAST(SUM(ta.[Star TIPs Opportunity]) AS DECIMAL), 0)
                                  ) AS DECIMAL(5, 2)),
                             0
                         ) AS StarTIPCompletionRate,
                   CAST(SUM(ta.[Star Successful TIPs]) AS DECIMAL) AS [Star Successful TIPs],
                   ISNULL(
                             CAST((CAST(SUM(ta.[Star Successful TIPs]) AS DECIMAL)
                                   / NULLIF(CAST(SUM(ta.[Star Completed TIPs]) AS DECIMAL), 0)
                                  ) AS DECIMAL(5, 2)),
                             0
                         ) AS StarTIPSuccessfulRate,
                   ISNULL(
                             CAST((CAST(SUM(ta.[Star Successful TIPs]) AS DECIMAL)
                                   / NULLIF(CAST(SUM(ta.[Star TIPs Opportunity]) AS DECIMAL), 0)
                                  ) AS DECIMAL(5, 2)),
                             0
                         ) AS StarNetEffectiveRate,
                   --------
                   CAST(SUM(ta.[Quality TIPs Opportunity]) AS DECIMAL) AS [Quality TIPs Opportunity],
                   CAST(SUM(ta.[Quality Completed TIPs]) AS DECIMAL) AS [Quality Completed TIPs],
                   ISNULL(
                             CAST((CAST(SUM(ta.[Quality Completed TIPs]) AS DECIMAL)
                                   / NULLIF(CAST(SUM(ta.[Quality TIPs Opportunity]) AS DECIMAL), 0)
                                  ) AS DECIMAL(5, 2)),
                             0
                         ) AS QualityTIPCompletionRate,
                   CAST(SUM(ta.[Quality Successful TIPs]) AS DECIMAL) AS [Quality Successful TIPs],
                   ISNULL(
                             CAST((CAST(SUM(ta.[Quality Successful TIPs]) AS DECIMAL)
                                   / NULLIF(CAST(SUM(ta.[Quality Completed TIPs]) AS DECIMAL), 0)
                                  ) AS DECIMAL(5, 2)),
                             0
                         ) AS QualityTIPSuccessfulRate,
                   ISNULL(
                             CAST((CAST(SUM(ta.[Quality Successful TIPs]) AS DECIMAL)
                                   / NULLIF(CAST(SUM(ta.[Quality TIPs Opportunity]) AS DECIMAL), 0)
                                  ) AS DECIMAL(5, 2)),
                             0
                         ) AS QualityNetEffectiveRate
            FROM
            (
                SELECT ROW_NUMBER() OVER (PARTITION BY tacr.tipresultstatusid
                                          ORDER BY tacr.[Completed TIPs] DESC,
                                                   tacr.[Unfinished TIPs] DESC,
                                                   tacr.[Review/resubmit TIPs] DESC,
                                                   tacr.[Rejected TIPs] DESC,
                                                   tacr.[currently active] DESC,
                                                   tacr.[withdrawn] DESC,
                                                   tacr.tipresultstatuscenterID DESC
                                         ) AS [Rank],
                       tacr.centerid,
                       tacr.[TIP Opportunities],
                       CASE
                           WHEN tacr.activethru > @END THEN
                               0
                           ELSE
                               tacr.[Completed TIPs]
                       END AS [Completed TIPs],
                       CASE
                           WHEN tacr.activethru > @END THEN
                               0
                           ELSE
                               tacr.[Successful TIPs]
                       END AS [Successful TIPs],
                       CASE
                           WHEN tacr.tiptype = 'COST' THEN
                               1
                           ELSE
                               0
                       END AS [Cost TIPs Opportunity],
                       CASE
                           WHEN tacr.tiptype = 'COST'
                                AND tacr.activethru <= @END THEN
                               tacr.[Completed TIPs]
                           ELSE
                               0
                       END AS [Cost Completed TIPs],
                       CASE
                           WHEN tacr.tiptype = 'COST'
                                AND tacr.activethru <= @END THEN
                               tacr.[Successful TIPs]
                           ELSE
                               0
                       END AS [Cost Successful TIPs],
                       CASE
                           WHEN tacr.tiptype = 'STAR' THEN
                               1
                           ELSE
                               0
                       END AS [Star TIPs Opportunity],
                       CASE
                           WHEN tacr.tiptype = 'STAR'
                                AND tacr.activethru <= @END THEN
                               tacr.[Completed TIPs]
                           ELSE
                               0
                       END AS [Star Completed TIPs],
                       CASE
                           WHEN tacr.tiptype = 'STAR'
                                AND tacr.activethru <= @END THEN
                               tacr.[Successful TIPs]
                           ELSE
                               0
                       END AS [Star Successful TIPs],
                       CASE
                           WHEN tacr.tiptype = 'QUALITY' THEN
                               1
                           ELSE
                               0
                       END AS [Quality TIPs Opportunity],
                       CASE
                           WHEN tacr.tiptype = 'QUALITY'
                                AND tacr.activethru <= @END THEN
                               tacr.[Completed TIPs]
                           ELSE
                               0
                       END AS [Quality Completed TIPs],
                       CASE
                           WHEN tacr.tiptype = 'QUALITY'
                                AND tacr.activethru <= @END THEN
                               tacr.[Successful TIPs]
                           ELSE
                               0
                       END AS [Quality Successful TIPs]
                FROM OutcomesMTM.dbo.tipActivityCenterReport tacr
                WHERE 1 = 1
                      AND tacr.policyid NOT IN ( 574, 575, 298 )
                      AND tacr.primaryPharmacy = 1
                      AND tacr.activethru >= @BEGIN
                      AND tacr.activeasof <= @END
                      AND
                      (
                          (
                              tacr.activethru <= @END
                              AND
                              (
                                  tacr.[Completed TIPs] = 1
                                  OR tacr.[Unfinished TIPs] = 1
                                  OR tacr.[Review/resubmit TIPs] = 1
                                  OR tacr.[Rejected TIPs] = 1
                              )
                          )
                          OR DATEDIFF(   DAY,
                                         CASE
                                             WHEN tacr.activeasof > @BEGIN THEN
                                                 tacr.activeasof
                                             ELSE
                                                 @BEGIN
                                         END,
                                         CASE
                                             WHEN tacr.activethru > @END THEN
                                                 @END
                                             ELSE
                                                 tacr.activethru
                                         END
                                     ) > 30
                      )
            ) ta
            WHERE 1 = 1
                  AND ta.Rank = 1
            GROUP BY ta.centerid
        ) ta
            ON ta.centerid = ph.centerid
        LEFT JOIN
        (
            SELECT pm.centerid,
                   COUNT(DISTINCT pt.PatientID) AS [EligiblePatient]
            FROM OutcomesMTM.dbo.patientMTMCenterDim pm
                JOIN
                (
                    SELECT DISTINCT
                           pt.PatientID
                    --select count(distinct pt.patientID)
                    FROM OutcomesMTM.dbo.patientDim pt
                    WHERE 1 = 1
                          AND ISNULL(pt.activeThru, '99991231') >= @BEGIN
                          AND pt.PolicyID NOT IN ( 574, 575, 298 )
                          AND pt.activeAsOf <= @END
                ) pt
                    ON pt.PatientID = pm.patientid
            WHERE 1 = 1
                  AND ISNULL(pm.activethru, '99991231') >= @BEGIN
                  AND pm.activeasof <= @END
            GROUP BY pm.centerid
        ) pm
            ON pm.centerid = ph.centerid
        LEFT JOIN
        (
            SELECT v.[MTM CenterID],
                   SUM(v.claimSubmitted) AS claimSubmitted,
                   SUM(v.DTPClaims) AS DTPClaims,
                   ISNULL(
                             CAST((CAST(SUM(v.DTPClaims) AS DECIMAL)
                                   / NULLIF(CAST(SUM(v.claimSubmitted) AS DECIMAL), 0)
                                  ) AS DECIMAL(5, 2)),
                             0
                         ) AS [DTPpercentage],
                   SUM(v.[ValidationOpportunity]) AS [ValidationOpportunity],
                   SUM(v.[ValidationSuccess]) AS [ValidationSuccess],
                   SUM(v.[PatientConsults]) AS [PatientConsults],
                   SUM(v.[PatientRefusals]) AS [PatientRefusals],
                   SUM(v.[PatientUnableToReach]) AS [PatientUnableToReach],
                   ISNULL(
                             CAST((CAST(SUM(v.[PatientRefusals]) AS DECIMAL)
                                   + CAST(SUM(v.[PatientUnableToReach]) AS DECIMAL)
                                  )
                                  / NULLIF(CAST(SUM(v.[PatientConsults]) AS DECIMAL), 0) AS DECIMAL(5, 2)),
                             0
                         ) AS [PatientSuccessRate],
                   SUM(v.[PrescriberConsults]) AS [PrescriberConsults],
                   SUM(v.[PrescriberRefusals]) AS [PrescriberRefusals],
                   SUM(v.[PrescriberUnableToReach]) AS [PrescriberUnableToReach],
                   ISNULL(
                             CAST((CAST(SUM(v.[PrescriberRefusals]) AS DECIMAL)
                                   + CAST(SUM(v.[PrescriberUnableToReach]) AS DECIMAL)
                                  )
                                  / NULLIF(CAST(SUM(v.[PrescriberConsults]) AS DECIMAL), 0) AS DECIMAL(5, 2)),
                             0
                         ) AS [PrescriberSuccessRate]
            FROM
            (
                SELECT c.claimID,
                       c.[MTM CenterID],
                       1 AS claimSubmitted,
                       CASE
                           WHEN c.resulttypeID NOT IN ( 12, 13, 16, 18 )
                                AND c.actiontypeID <> 3 THEN
                               1
                           ELSE
                               0
                       END AS [DTPClaims],
                       CASE
                           WHEN c.validated IS NOT NULL THEN
                               1
                           ELSE
                               0
                       END AS [ValidationOpportunity],
                       CASE
                           WHEN c.validated = 1 THEN
                               1
                           ELSE
                               0
                       END AS [ValidationSuccess],
                       CASE
                           WHEN c.actiontypeID IN ( 1, 2, 3, 17 ) THEN
                               1
                           ELSE
                               0
                       END AS [PatientConsults],
                       CASE
                           WHEN c.actiontypeID IN ( 1, 2, 3, 17 )
                                AND c.resulttypeID = 12 THEN
                               1
                           ELSE
                               0
                       END AS [PatientRefusals],
                       CASE
                           WHEN c.actiontypeID IN ( 1, 2, 3, 17 )
                                AND c.resulttypeID = 18 THEN
                               1
                           ELSE
                               0
                       END AS [PatientUnableToReach],
                       CASE
                           WHEN c.actiontypeID = 4 THEN
                               1
                           ELSE
                               0
                       END AS [PrescriberConsults],
                       CASE
                           WHEN c.actiontypeID = 4
                                AND c.resulttypeID = 13 THEN
                               1
                           ELSE
                               0
                       END AS [PrescriberRefusals],
                       CASE
                           WHEN c.actiontypeID = 4
                                AND c.resulttypeID = 16 THEN
                               1
                           ELSE
                               0
                       END AS [PrescriberUnableToReach]
                FROM OutcomesMTM.dbo.ClaimActivityReport c
                WHERE 1 = 1
                      AND c.mtmserviceDT
                      BETWEEN @BEGIN AND @END
                      AND c.statusID NOT IN ( 3, 5 )
                      AND c.policyID NOT IN ( 574, 575, 298 )
            ) v
            WHERE 1 = 1
            GROUP BY v.[MTM CenterID]
        ) cl
            ON cl.[MTM CenterID] = ph.NCPDP_NABP
        LEFT JOIN
        (
            SELECT centerid,
                   centername,
                   COUNT(DISTINCT u.PatientID) AS CMROpportunity,
                   SUM(u.CMROffered) AS CMROffered,
                   SUM(u.CMRCompleted) AS completedCMRs,
                   CASE
                       WHEN COUNT(DISTINCT u.PatientID) = 0 THEN
                           0
                       ELSE
                           CAST((CAST(SUM(u.CMROffered) AS DECIMAL)) / (CAST(COUNT(DISTINCT u.PatientID) AS DECIMAL)) AS DECIMAL(5, 2))
                   END AS percentCMRoffered,
                   CASE
                       WHEN SUM(u.CMROffered) = 0 THEN
                           0
                       ELSE
                           CAST((CAST(SUM(u.CMRCompleted) AS DECIMAL)) / (CAST(SUM(u.CMROffered) AS DECIMAL)) AS DECIMAL(5, 2))
                   END AS percentCMRcompletion,
                   CASE
                       WHEN COUNT(DISTINCT u.PatientID) = 0 THEN
                           0
                       ELSE
                           CAST((CAST(SUM(u.CMRCompleted) AS DECIMAL)) / (CAST(COUNT(DISTINCT u.PatientID) AS DECIMAL)) AS DECIMAL(5, 2))
                   END AS [CMRNetEffectiveRate]
            --, case when count(distinct u.PatientID) = 0 or sum(u.CMROffered) = 0 then 0 else (cast((cast(sum(u.CMRCompleted) as decimal))/(cast(sum(u.CMROffered) as decimal)) as decimal(5,2)) *	cast((cast(sum(u.CMROffered) as decimal))/(cast(count(distinct u.PatientID) as decimal)) as decimal(5,2))) end as [CMRNetEffectiveRate]	
            FROM
            (
                SELECT ROW_NUMBER() OVER (PARTITION BY rp.PatientID,
                                                       rp.centerid
                                          ORDER BY ISNULL(rp.resultTypeID, 90),
                                                   rp.mtmServiceDT DESC,
                                                   rp.patientKey,
                                                   rp.patientMTMcenterKey
                                         ) AS rank,
                       rp.PatientID,
                       rp.PolicyID,
                       rp.CMSContractNumber,
                       rp.centerid,
                       ph.centername,
                       rp.chainid,
                       rp.primaryPharmacy,
                       rp.CMREligible,
                       rp.mtmServiceDT,
                       rp.resultTypeID,
                       rp.cmrDeliveryTypeID,
                       rp.statusID,
                       rp.paid,
                       rp.Language,
                       rp.activeAsOF,
                       rp.activeThru,
                       CASE
                           WHEN rp.outcomesTermDate
                                BETWEEN @BEGIN AND @END
                                AND ISNULL(rp.mtmServiceDT, '99991231') NOT
                                BETWEEN @BEGIN AND @END THEN
                               1
                           ELSE
                               0
                       END AS Termed,
                       CASE
                           WHEN rp.mtmServiceDT
                                BETWEEN @BEGIN AND @END
                                AND rp.statusID IN ( 2, 6 )
                                AND rp.resultTypeID IN ( 5, 6, 12 )
                                AND ISNULL(rp.centerid, '') = ISNULL(rp.claimcenterID, '') THEN
                               1
                           ELSE
                               0
                       END AS CMROffered,
                       CASE
                           WHEN rp.mtmServiceDT
                                BETWEEN @BEGIN AND @END
                                AND rp.statusID IN ( 2, 6 )
                                AND rp.resultTypeID IN ( 5, 6 )
                                AND ISNULL(rp.centerid, '') = ISNULL(rp.claimcenterID, '') THEN
                               1
                           ELSE
                               0
                       END AS CMRCompleted,
                       CASE
                           WHEN rp.mtmServiceDT
                                BETWEEN @BEGIN AND @END
                                AND rp.statusID IN ( 2, 6 )
                                AND rp.resultTypeID = 12
                                AND ISNULL(rp.centerid, '') = ISNULL(rp.claimcenterID, '') THEN
                               1
                           ELSE
                               0
                       END AS PatientRefused,
                       CASE
                           WHEN rp.mtmServiceDT
                                BETWEEN @BEGIN AND @END
                                AND rp.statusID IN ( 2, 6 )
                                AND rp.resultTypeID = 18
                                AND ISNULL(rp.centerid, '') = ISNULL(rp.claimcenterID, '') THEN
                               1
                           ELSE
                               0
                       END AS UnableToReachPatient,
                       CASE
                           WHEN rp.mtmServiceDT
                                BETWEEN @BEGIN AND @END
                                AND rp.statusID IN ( 2, 6 )
                                AND rp.resultTypeID = 5
                                AND ISNULL(rp.centerid, '') = ISNULL(rp.claimcenterID, '') THEN
                               1
                           ELSE
                               0
                       END AS CMRWithDrugProblems,
                       CASE
                           WHEN rp.mtmServiceDT
                                BETWEEN @BEGIN AND @END
                                AND rp.statusID IN ( 2, 6 )
                                AND rp.resultTypeID = 6
                                AND ISNULL(rp.centerid, '') = ISNULL(rp.claimcenterID, '') THEN
                               1
                           ELSE
                               0
                       END AS CMRWithoutDrugProblems,
                       CASE
                           WHEN rp.mtmServiceDT
                                BETWEEN @BEGIN AND @END
                                AND rp.cmrDeliveryTypeID = 1
                                AND ISNULL(rp.centerid, '') = ISNULL(rp.claimcenterID, '') THEN
                               1
                           ELSE
                               0
                       END AS CMRFace2Face,
                       CASE
                           WHEN rp.mtmServiceDT
                                BETWEEN @BEGIN AND @END
                                AND rp.cmrDeliveryTypeID = 2
                                AND ISNULL(rp.centerid, '') = ISNULL(rp.claimcenterID, '') THEN
                               1
                           ELSE
                               0
                       END AS CMRPhone,
                       CASE
                           WHEN rp.mtmServiceDT
                                BETWEEN @BEGIN AND @END
                                AND rp.cmrDeliveryTypeID = 3
                                AND ISNULL(rp.centerid, '') = ISNULL(rp.claimcenterID, '') THEN
                               1
                           ELSE
                               0
                       END AS CMRTelehealth,
                       CASE
                           WHEN rp.mtmServiceDT
                                BETWEEN @BEGIN AND @END
                                AND rp.statusID IN ( 2, 6 )
                                AND rp.resultTypeID IN ( 5, 6 )
                                AND rp.centerid <> rp.claimcenterID THEN
                               1
                           ELSE
                               0
                       END AS CMRMissed,
                       CASE
                           WHEN rp.mtmServiceDT
                                BETWEEN @BEGIN AND @END
                                AND rp.statusID = 5
                                AND ISNULL(rp.centerid, '') = ISNULL(rp.claimcenterID, '') THEN
                               1
                           ELSE
                               0
                       END AS CMRRejected,
                       CASE
                           WHEN rp.mtmServiceDT
                                BETWEEN @BEGIN AND @END
                                AND rp.statusID = 2
                                AND ISNULL(rp.centerid, '') = ISNULL(rp.claimcenterID, '')
                                AND rp.resultTypeID IN ( 5, 6 ) THEN
                               1
                           ELSE
                               0
                       END AS CMRPendingApproval,
                       CASE
                           WHEN rp.mtmServiceDT
                                BETWEEN @BEGIN AND @END
                                AND rp.statusID = 6
                                AND rp.paid = 0
                                AND ISNULL(rp.centerid, '') = ISNULL(rp.claimcenterID, '')
                                AND rp.resultTypeID IN ( 5, 6 ) THEN
                               1
                           ELSE
                               0
                       END AS CMRApprovedPendingPayment,
                       CASE
                           WHEN rp.mtmServiceDT
                                BETWEEN @BEGIN AND @END
                                AND rp.statusID = 6
                                AND rp.paid = 1
                                AND ISNULL(rp.centerid, '') = ISNULL(rp.claimcenterID, '')
                                AND rp.resultTypeID IN ( 5, 6 ) THEN
                               1
                           ELSE
                               0
                       END AS CMRApprovedPaid,
                       CASE
                           WHEN rp.mtmServiceDT
                                BETWEEN @BEGIN AND @END
                                AND rp.Language = 'EN'
                                AND ISNULL(rp.centerid, '') = ISNULL(rp.claimcenterID, '') THEN
                               1
                           ELSE
                               0
                       END EnglishSPT,
                       CASE
                           WHEN rp.mtmServiceDT
                                BETWEEN @BEGIN AND @END
                                AND rp.Language = 'SP'
                                AND ISNULL(rp.centerid, '') = ISNULL(rp.claimcenterID, '') THEN
                               1
                           ELSE
                               0
                       END SpanishSPT,
                       CASE
                           WHEN rp.mtmServiceDT
                                BETWEEN @BEGIN AND @END
                                AND ISNULL(rp.centerid, '') = ISNULL(rp.claimcenterID, '') THEN
                               CAST(rp.postHospitalDischarge AS INT)
                           ELSE
                               0
                       END AS postHospitalDischarge
                FROM vw_CMRActivityReport rp
                    JOIN patientDim pd
                        ON pd.patientKey = rp.patientKey
                    JOIN Policy p
                        ON p.policyID = rp.PolicyID
                    JOIN pharmacy ph
                        ON ph.centerid = rp.centerid
                    LEFT JOIN Chain c
                        ON c.chainid = rp.chainid
                WHERE 1 = 1
                      AND ISNULL(rp.activeThru, '99991231') >= @BEGIN
                      AND rp.activeAsOF <= @END
                      AND rp.primaryPharmacy = 1
                      --30 day include
                      AND
                      (
                          (
                              rp.activeThru IS NULL
                              AND DATEDIFF(   DAY,
                                              CASE
                                                  WHEN rp.activeAsOF > @BEGIN THEN
                                                      rp.activeAsOF
                                                  ELSE
                                                      @BEGIN
                                              END,
                                              @END
                                          ) >= 30
                          )
                          OR
                          (
                              rp.activeThru IS NOT NULL
                              AND DATEDIFF(   DAY,
                                              CASE
                                                  WHEN rp.activeAsOF > @BEGIN THEN
                                                      rp.activeAsOF
                                                  ELSE
                                                      @BEGIN
                                              END,
                                              CASE
                                                  WHEN rp.activeThru > @END THEN
                                                      @END
                                                  ELSE
                                                      rp.activeThru
                                              END
                                          ) >= 30
                          )
                          OR (
                                 rp.mtmServiceDT
                      BETWEEN @BEGIN AND @END
                                 AND rp.statusID IN ( 2, 6 )
                                 AND rp.resultTypeID IN ( 5, 6 )
                             )
                             AND (rp.claimcenterID = rp.centerid)
                      )
            ) u
            WHERE 1 = 1
                  AND u.rank = 1
            GROUP BY centerid,
                     centername
        ) cm
            ON cm.centerid = ph.centerid
    WHERE 1 = 1
          AND np.Active = 1
    ORDER BY ph.centerid;

END;







