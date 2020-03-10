


/* =========================================================
Created by : Santhosh KT
Create Date: 12/19/2019
Card: TC-3442
Modified by:
Modified Date:

========================================================= */


CREATE   PROCEDURE [reporting].[S_ValidationPrior_EncounterDate]
AS
BEGIN



    DECLARE @counter INT,
            @startDate DATE,
            @enddate DATE;
    SET @counter = MONTH(GETDATE());

    SET @startDate = CASE
                         WHEN @counter = 1 THEN
                             DATEADD(qq, DATEDIFF(qq, 0, GETDATE()) - 1, 0)
                         ELSE
                             DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)
                     END;
    SET @enddate = CASE
                       WHEN @counter = 1 THEN
                           DATEADD(mm, DATEDIFF(mm, -1, GETDATE()) - 1, -1)
                       ELSE
                           CAST(GETDATE() AS DATE)
                   END;

    --PRINT @startDate
    --PRINT @enddate



    DROP TABLE IF EXISTS #PMRT;
    SELECT PMR.*
    INTO #PMRT
    FROM [AOCWPAPSQL02].[outcomes].dbo.patientMaxRXDate PMR WITH (NOLOCK);



    DROP TABLE IF EXISTS #PROV;
    SELECT u.userID,
           c.firstNM,
           c.lastNM
    INTO #PROV
    FROM [AOCWPAPSQL02].[auth].[dbo].[users] u WITH (NOLOCK)
        LEFT JOIN [AOCWPAPSQL02].outcomes.dbo.contact c WITH (NOLOCK)
            ON u.userID = c.userID;



    DROP TABLE IF EXISTS #PRDT;
    SELECT PRD.*
    INTO #PRDT
    FROM [AOCWPAPSQL02].[outcomes].dbo.policyRxDate PRD WITH (NOLOCK);




    DROP TABLE IF EXISTS #Claim;
    SELECT DISTINCT
           c.claimID,
           c.patientid,
           c.mtmServiceDT,
           c.policyID,
           c.statusID,
           c.currentMedGpi,
           c.currentMedMetricQuantity,
           c.currentMedDaysSupply,
           c.newMedGpi,
           c.newMedMetricQuantity,
           c.newMedDaysSupply,
           c.reasonTypeID,
           c.actionTypeID,
           c.resultTypeID,
           c.tipResultID,
           c.immunizationDT,
           c.centerID,
           c.tipDetailID,
           c.isTipClaim,
           c.pharmacistID,
           c.newMedName,
           c.currentMedName
    INTO #Claim
    FROM claim c WITH (NOLOCK)
    WHERE 1 = 1
          --AND YEAR(c.mtmServiceDT) = YEAR(GETDATE()); --between '2018-08-29' and '2019-08-29'
          AND CAST(c.mtmServiceDT AS DATE)
          BETWEEN @startDate AND @enddate;

    CREATE NONCLUSTERED INDEX [IX_Claim_patientid_MtmserviceDT_Temp]
    ON [#Claim] (
                    [patientid],
                    [mtmServiceDT],
                    [newMedGpi]
                )
    INCLUDE (claimID); --WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]




    /*PrecriptionDIM Data*/
    DROP TABLE IF EXISTS #Prescription;
    SELECT DISTINCT
           pp.patientid,
           pp.RxDate,
           pp.NDC,
           pp.RxID
    INTO #Prescription
    FROM /*OutcomesMTM.dbo.prescriptionDim */ [AOCWPAPSQL02].[outcomes].dbo.prescription pp WITH (NOLOCK)
        /*WHERE EXISTS
    (
        SELECT 1 FROM #Claim cp WHERE cp.patientid = pp.patientid
    );*/
        JOIN #Claim CP WITH (NOLOCK)
            ON CP.patientid = pp.patientid;




    CREATE NONCLUSTERED INDEX [IX_Prescription_patientid_Temp]
    ON [#Prescription] --31sec
    (
        [patientid],
        [NDC]
    )
    INCLUDE (RxDate); --WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]




    /*Initiated new therapy*/
    DROP TABLE IF EXISTS #PRX;
    SELECT '1' AS ValidationRuleID,
           CP.claimID,
           CP.patientid,
           MAX(PR.RxDate) AS [Max RXDate],
           MIN(PR.RxDate) AS [Min RxDate]
    INTO #PRX
    FROM #Claim CP
        LEFT JOIN
        (
            SELECT pp.patientid,
                   pp.RxDate,
                   d.GPI
            FROM #Prescription pp WITH (NOLOCK)
                JOIN OutcomesMTM.dbo.Drug d WITH (NOLOCK)
                    ON d.NDC = pp.NDC
            WHERE 1 = 1
        ) PR
            ON CP.patientid = PR.patientid
               AND LEFT(LTRIM(RTRIM(PR.GPI)), 4) = LEFT(LTRIM(RTRIM(CP.newMedGpi)), 4)
               AND CAST(PR.RxDate AS DATE)
               BETWEEN DATEADD(DAY, -120, CAST(CP.mtmServiceDT AS DATE)) AND CAST(CP.mtmServiceDT AS DATE)
    WHERE 1 = 1
          AND CP.resultTypeID = '10'
          AND PR.RxDate <= CP.mtmServiceDT
    GROUP BY CP.claimID,
             CP.patientid;



    /*Discontinued therapy*/
    INSERT INTO #PRX
    SELECT '2' AS ValidationRuleID,
           CP.claimID,
           CP.patientid,
           MAX(PR.RxDate) AS [Max RXDate],
           MIN(PR.RxDate) AS [Min RxDate]
    FROM #Claim CP
        LEFT JOIN
        (
            SELECT pp.patientid,
                   pp.RxDate,
                   d.GPI
            FROM #Prescription pp WITH (NOLOCK)
                JOIN OutcomesMTM.dbo.Drug d WITH (NOLOCK)
                    ON d.NDC = pp.NDC
            WHERE 1 = 1
        ) PR
            ON CP.patientid = PR.patientid
               AND LEFT(LTRIM(RTRIM(PR.GPI)), 14) = LEFT(LTRIM(RTRIM(CP.newMedGpi)), 14)
               AND CAST(PR.RxDate AS DATE)
               BETWEEN DATEADD(DAY, -120, CAST(CP.mtmServiceDT AS DATE)) AND CAST(CP.mtmServiceDT AS DATE)
    WHERE 1 = 1
          AND CP.resultTypeID = '8'
          AND PR.RxDate < CP.mtmServiceDT
    GROUP BY CP.claimID,
             CP.patientid;


    /*Immunization (Need to run)*/
    INSERT INTO #PRX
    SELECT '3' AS ValidationRuleID,
           CP.claimID,
           CP.patientid,
           MAX(PR.RxDate) AS [Max RXDate],
           MIN(PR.RxDate) AS [Min RxDate]
    FROM #Claim CP
        LEFT JOIN
        (
            SELECT pp.patientid,
                   pp.RxDate,
                   d.GPI
            FROM #Prescription pp WITH (NOLOCK)
                JOIN OutcomesMTM.dbo.Drug d WITH (NOLOCK)
                    ON d.NDC = pp.NDC
            WHERE 1 = 1
        ) PR
            ON CP.patientid = PR.patientid
               AND LEFT(LTRIM(RTRIM(PR.GPI)), 14) = LEFT(LTRIM(RTRIM(CP.newMedGpi)), 14)
               AND CAST(PR.RxDate AS DATE)
               BETWEEN DATEADD(DAY, -120, CAST(CP.immunizationDT AS DATE)) AND CAST(CP.immunizationDT AS DATE)
    WHERE 1 = 1
          AND CP.resultTypeID = '1'
          AND PR.RxDate < CP.immunizationDT
    GROUP BY CP.claimID,
             CP.patientid;




    /*Increaased Dose*/
    INSERT INTO #PRX
    SELECT '4' AS ValidationRuleID,
           CP.claimID,
           CP.patientid,
           MAX(PR.RxDate) AS [Max RXDate],
           MIN(PR.RxDate) AS [Min RxDate]
    FROM #Claim CP
        LEFT JOIN
        (
            SELECT pp.patientid,
                   pp.RxDate,
                   d.GPI
            FROM #Prescription pp WITH (NOLOCK)
                JOIN OutcomesMTM.dbo.Drug d WITH (NOLOCK)
                    ON d.NDC = pp.NDC
            WHERE 1 = 1
        ) PR
            ON CP.patientid = PR.patientid
               AND LEFT(LTRIM(RTRIM(PR.GPI)), 14) = LEFT(LTRIM(RTRIM(CP.newMedGpi)), 14)
               AND CAST(PR.RxDate AS DATE)
               BETWEEN DATEADD(DAY, -120, CAST(CP.mtmServiceDT AS DATE)) AND CAST(CP.mtmServiceDT AS DATE)
    WHERE 1 = 1
          AND CP.resultTypeID = '9'
          AND PR.RxDate < CP.mtmServiceDT
    GROUP BY CP.claimID,
             CP.patientid;


    /*Initiated cost effective drug*/
    INSERT INTO #PRX
    SELECT '5' AS ValidationRuleID,
           CP.claimID,
           CP.patientid,
           MAX(PR.RxDate) AS [Max RXDate],
           MIN(PR.RxDate) AS [Min RxDate]
    FROM #Claim CP
        LEFT JOIN
        (
            SELECT pp.patientid,
                   pp.RxDate,
                   d.GPI
            FROM #Prescription pp WITH (NOLOCK)
                JOIN OutcomesMTM.dbo.Drug d WITH (NOLOCK)
                    ON d.NDC = pp.NDC
            WHERE 1 = 1
        ) PR
            ON CP.patientid = PR.patientid
               AND LEFT(LTRIM(RTRIM(PR.GPI)), 12) = LEFT(LTRIM(RTRIM(CP.newMedGpi)), 12)
               AND CAST(PR.RxDate AS DATE)
               BETWEEN DATEADD(DAY, -120, CAST(CP.mtmServiceDT AS DATE)) AND CAST(CP.mtmServiceDT AS DATE)
    WHERE 1 = 1
          AND CP.resultTypeID = '11'
          AND PR.RxDate < CP.mtmServiceDT
    GROUP BY CP.claimID,
             CP.patientid;



    /*Initiated new therapy*/
    INSERT INTO #PRX
    SELECT '6' AS ValidationRuleID,
           CP.claimID,
           CP.patientid,
           MAX(PR.RxDate) AS [Max RXDate],
           MIN(PR.RxDate) AS [Min RxDate]
    FROM #Claim CP
        LEFT JOIN
        (
            SELECT pp.patientid,
                   pp.RxDate,
                   d.GPI
            FROM #Prescription pp WITH (NOLOCK)
                JOIN OutcomesMTM.dbo.Drug d WITH (NOLOCK)
                    ON d.NDC = pp.NDC
            WHERE 1 = 1
        ) PR
            ON CP.patientid = PR.patientid
               AND LEFT(LTRIM(RTRIM(PR.GPI)), 4) = LEFT(LTRIM(RTRIM(CP.newMedGpi)), 4)
               AND CAST(PR.RxDate AS DATE)
               BETWEEN DATEADD(DAY, -120, CAST(CP.mtmServiceDT AS DATE)) AND CAST(CP.mtmServiceDT AS DATE)
    WHERE 1 = 1
          AND CP.resultTypeID = '10'
          AND PR.RxDate < CP.mtmServiceDT
    GROUP BY CP.claimID,
             CP.patientid;






    /*Decreased Dose*/
    INSERT INTO #PRX
    SELECT '7' AS ValidationRuleID,
           CP.claimID,
           CP.patientid,
           MAX(PR.RxDate) AS [Max RXDate],
           MIN(PR.RxDate) AS [Min RxDate]
    FROM #Claim CP
        LEFT JOIN
        (
            SELECT pp.patientid,
                   pp.RxDate,
                   d.GPI
            FROM #Prescription pp WITH (NOLOCK)
                JOIN OutcomesMTM.dbo.Drug d WITH (NOLOCK)
                    ON d.NDC = pp.NDC
            WHERE 1 = 1
        ) PR
            ON CP.patientid = PR.patientid
               AND LEFT(LTRIM(RTRIM(PR.GPI)), 14) = LEFT(LTRIM(RTRIM(CP.newMedGpi)), 14)
               AND CAST(PR.RxDate AS DATE)
               BETWEEN DATEADD(DAY, -120, CAST(CP.mtmServiceDT AS DATE)) AND CAST(CP.mtmServiceDT AS DATE)
    WHERE 1 = 1
          AND CP.resultTypeID = '7'
          AND PR.RxDate < CP.mtmServiceDT
    GROUP BY CP.claimID,
             CP.patientid;


    ------

    DROP TABLE IF EXISTS #PRX_new;
    SELECT DISTINCT
           #PRX.*,
           CASE
               WHEN #PRX.[Min RxDate] = PR.RxDate THEN
                   PR.Drug_Name_Strength
           END AS DrugMin,
           CASE
               WHEN #PRX.[Min RxDate] = PR.RxDate THEN
                   PR.GPI
           END AS GPIMin,
           CASE
               WHEN #PRX.[Max RXDate] = PR.RxDate THEN
                   PR.Drug_Name_Strength
           END AS DrugMax,
           CASE
               WHEN #PRX.[Max RXDate] = PR.RxDate THEN
                   PR.GPI
           END AS GPIMax
    INTO #PRX_new
    FROM #PRX WITH (NOLOCK)
        JOIN #Claim CP WITH (NOLOCK)
            ON #PRX.claimID = CP.claimID
               AND #PRX.patientid = CP.patientid
               AND CP.resultTypeID = (CASE
                                          WHEN #PRX.ValidationRuleID = '1' THEN
                                              '10'
                                          WHEN #PRX.ValidationRuleID = '2' THEN
                                              '8'
                                          WHEN #PRX.ValidationRuleID = '3' THEN
                                              '1'
                                          WHEN #PRX.ValidationRuleID = '4' THEN
                                              '9'
                                          WHEN #PRX.ValidationRuleID = '5' THEN
                                              '11'
                                          WHEN #PRX.ValidationRuleID = '6' THEN
                                              '10'
                                          WHEN #PRX.ValidationRuleID = '7' THEN
                                              '7'
                                      END
                                     )
        LEFT JOIN
        (
            SELECT pp.patientid,
                   pp.RxDate,
                   d.GPI,
                   d.Drug_Name_Strength
            FROM #Prescription pp WITH (NOLOCK)
                JOIN OutcomesMTM.dbo.Drug d WITH (NOLOCK)
                    ON d.NDC = pp.NDC
            WHERE 1 = 1
        ) PR
            ON CP.patientid = PR.patientid
               AND LEFT(LTRIM(RTRIM(PR.GPI)), 14) = LEFT(LTRIM(RTRIM(CP.newMedGpi)), 14)
               AND CAST(PR.RxDate AS DATE)
               BETWEEN DATEADD(DAY, -120, CAST(CP.mtmServiceDT AS DATE)) AND CAST(CP.mtmServiceDT AS DATE)
               AND PR.RxDate < CP.mtmServiceDT;


    DROP TABLE IF EXISTS #PRX_new_unique;
    SELECT Y.ValidationRuleID,
           Y.claimID,
           Y.patientid,
           Y.[Max RXDate],
           Y.[Min RxDate],
           STUFF(
                    (
                        SELECT ISNULL(DrugMin, '')
                        FROM #PRX_new
                        WHERE ValidationRuleID = Y.ValidationRuleID
                              AND claimID = Y.claimID
                              AND patientid = Y.patientid
                              AND [Max RXDate] = Y.[Max RXDate]
                              AND [Min RxDate] = Y.[Min RxDate]
                        FOR XML PATH(''), TYPE
                    ).value('(./text())[1]', 'VARCHAR(MAX)'),
                    1,
                    0,
                    ''
                ) AS DrugMin,
           STUFF(
                    (
                        SELECT ISNULL(GPIMin, '')
                        FROM #PRX_new
                        WHERE ValidationRuleID = Y.ValidationRuleID
                              AND claimID = Y.claimID
                              AND patientid = Y.patientid
                              AND [Max RXDate] = Y.[Max RXDate]
                              AND [Min RxDate] = Y.[Min RxDate]
                        FOR XML PATH(''), TYPE
                    ).value('(./text())[1]', 'VARCHAR(MAX)'),
                    1,
                    0,
                    ''
                ) AS GPIMin,
           STUFF(
                    (
                        SELECT ISNULL(DrugMax, '')
                        FROM #PRX_new
                        WHERE ValidationRuleID = Y.ValidationRuleID
                              AND claimID = Y.claimID
                              AND patientid = Y.patientid
                              AND [Max RXDate] = Y.[Max RXDate]
                              AND [Min RxDate] = Y.[Min RxDate]
                        FOR XML PATH(''), TYPE
                    ).value('(./text())[1]', 'VARCHAR(MAX)'),
                    1,
                    0,
                    ''
                ) AS DrugMax,
           STUFF(
                    (
                        SELECT ISNULL(GPIMax, '')
                        FROM #PRX_new
                        WHERE ValidationRuleID = Y.ValidationRuleID
                              AND claimID = Y.claimID
                              AND patientid = Y.patientid
                              AND [Max RXDate] = Y.[Max RXDate]
                              AND [Min RxDate] = Y.[Min RxDate]
                        FOR XML PATH(''), TYPE
                    ).value('(./text())[1]', 'VARCHAR(MAX)'),
                    1,
                    0,
                    ''
                ) AS GPIMax
    INTO #PRX_new_unique
    FROM #PRX_new Y WITH (NOLOCK)
    GROUP BY ValidationRuleID,
             claimID,
             patientid,
             [Max RXDate],
             [Min RxDate];




    --SELECT T.*
    --INTO #prefinal
    --FROM
    --(
    --    SELECT p.*,
    --           RANK() OVER (PARTITION BY p.claimID ORDER BY [Max RXDate] DESC) AS [Ranker]
    --    FROM #PRX_new_unique p
    --) T
    --WHERE 1 = 1
    --      AND T.Ranker = 1;



    /*Final Query*/
    DROP TABLE IF EXISTS #Final;
    SELECT T.*
    INTO #Final
    FROM
    (
        SELECT DISTINCT
               c.claimID,
               REPLACE(REPLACE(REPLACE(ph.centername, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS centername,
               REPLACE(REPLACE(REPLACE(ph.NCPDP_NABP, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS NCPDP_NABP,
               REPLACE(REPLACE(REPLACE(uc.firstNm, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS [ProvFirstName],
               REPLACE(REPLACE(REPLACE(uc.lastNM, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS [ProvLastName],
               REPLACE(REPLACE(REPLACE(p.PatientID_All, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS [MemberID],
               c.policyID,
               REPLACE(REPLACE(REPLACE(Po.policyName, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS policyName,
               REPLACE(REPLACE(REPLACE(p.First_Name, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS [PatFirstName],
               REPLACE(REPLACE(REPLACE(p.Last_Name, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS [PatLastName],
               REPLACE(REPLACE(REPLACE(re.reasonTypeDesc, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS reasonTypeDesc,
               REPLACE(REPLACE(REPLACE(at.actionNM, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS actionNM,
               REPLACE(REPLACE(REPLACE(rt.resultDesc, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS resultDesc,
               c.isTipClaim,
               REPLACE(REPLACE(REPLACE(td.tiptitle, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS tiptitle,
               CAST(trs.createdate AS DATE) AS [TIP Generation Date],
               c.mtmServiceDT,
               trs.tipstatusid,
               --,trs.tipresultstatusid 
               pr.maxrxdate AS [Max RXDate Policy],
               ptRX.maxDate AS [Max PatientRXDate],
               REPLACE(REPLACE(REPLACE(c.currentMedGpi, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS currentMedGpi,
               c.currentMedMetricQuantity,
               c.currentMedDaysSupply,
               REPLACE(REPLACE(REPLACE(c.newMedGpi, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS newMedGpi,
               c.newMedMetricQuantity,
               c.newMedDaysSupply,
               --,trs.activeenddate
               REPLACE(REPLACE(REPLACE(SA.DrugMin, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS [Medication Name for Min RxDate],
               REPLACE(REPLACE(REPLACE(SA.GPIMin, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS [Medication GPI for Min RxDate],
               REPLACE(REPLACE(REPLACE(SA.DrugMax, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS [Medication Name for Max RxDate],
               REPLACE(REPLACE(REPLACE(SA.GPIMax, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS [Medication GPI for Max RxDate],
               REPLACE(REPLACE(REPLACE(c.newMedName, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS [New Medication Name],
               REPLACE(REPLACE(REPLACE(c.currentMedName, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS [Current Medication Name],
               REPLACE(REPLACE(REPLACE(sta.statusNM, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') AS [claim status],
               '1' AS [New Validation Status],
               ISNULL(cv.validated, 0) AS [CurrentValidationStatus],
               SA.[Min RxDate] AS [First Fill of GPI within the look-back period],
               SA.[Max RXDate] AS [Last Fill of GPI within the look-back period],
               RANK() OVER (PARTITION BY c.claimID ORDER BY [Max RXDate] DESC) AS [Ranker]
        FROM #Claim c WITH (NOLOCK)
            LEFT JOIN #PROV uc
                ON c.pharmacistID = uc.userID
            JOIN OutcomesMTM.staging.reasonType re WITH (NOLOCK)
                ON re.reasonTypeID = c.reasonTypeID
            JOIN OutcomesMTM.staging.actionType at WITH (NOLOCK)
                ON at.actionTypeID = c.actionTypeID
            JOIN OutcomesMTM.staging.resultType rt WITH (NOLOCK)
                ON rt.resultTypeID = c.resultTypeID
            JOIN OutcomesMTM.staging.status s WITH (NOLOCK)
                ON s.statusID = c.statusID
            JOIN OutcomesMTM.dbo.patientDim p WITH (NOLOCK)
                ON p.PatientID = c.patientid
                   AND p.isCurrent = 1
            JOIN OutcomesMTM.dbo.pharmacy ph WITH (NOLOCK)
                ON ph.centerid = c.centerID
            JOIN OutcomesMTM.dbo.Policy Po WITH (NOLOCK)
                ON Po.policyID = c.policyID
            JOIN #PRX_new_unique SA
                ON SA.claimID = c.claimID
            LEFT JOIN OutcomesMTM.staging.tipresultstatus trs WITH (NOLOCK)
                ON trs.tipresultid = c.tipResultID
                   AND c.mtmServiceDT
                   BETWEEN trs.createdate AND trs.activeenddate
            LEFT JOIN OutcomesMTM.staging.claimValidation cv WITH (NOLOCK)
                ON cv.claimid = c.claimID
            LEFT JOIN staging.status sta
                ON sta.statusID = c.statusID
            LEFT JOIN dbo.#PMRT ptRX WITH (NOLOCK)
                ON p.PatientID = ptRX.patientID
            LEFT JOIN dbo.#PRDT pr WITH (NOLOCK)
                ON pr.policyid = Po.policyID
            LEFT JOIN OutcomesMTM.staging.TIPDetail_tip td WITH (NOLOCK)
                ON c.tipDetailID = td.tipdetailid
        --Left Join #PRX SA on SA.patientid=C.patientid


        WHERE 1 = 1
              AND rt.resultTypeID IN ( 4, 7, 8, 1, 9, 11, 10 )
              AND SA.[Max RXDate] IS NOT NULL
              AND SA.[Min RxDate] IS NOT NULL
    ) T
    WHERE T.Ranker = 1
    --AND c.claimID=117670034
    ORDER BY T.claimID;

    SELECT claimID,
           centername,
           NCPDP_NABP,
           ProvFirstName,
           ProvLastName,
           MemberID,
           policyID,
           policyName,
           PatFirstName,
           PatLastName,
           reasonTypeDesc,
           actionNM,
           resultDesc,
           isTipClaim,
           tiptitle,
           [TIP Generation Date],
           mtmServiceDT,
           tipstatusid,
           [Max RXDate Policy],
           [Max PatientRXDate],
           currentMedGpi,
           currentMedMetricQuantity,
           currentMedDaysSupply,
           newMedGpi,
           newMedMetricQuantity,
           newMedDaysSupply,
           [Medication Name for Min RxDate],
           [Medication GPI for Min RxDate],
           [Medication Name for Max RxDate],
           [Medication GPI for Max RxDate],
           [New Medication Name],
           [Current Medication Name],
           [claim status],
           [New Validation Status],
           [CurrentValidationStatus],
           [First Fill of GPI within the look-back period],
           [Last Fill of GPI within the look-back period]
    --Ranker
    FROM #Final;

END;

--EXEC [reporting].[S_ValidationPrior_EncounterDate]
