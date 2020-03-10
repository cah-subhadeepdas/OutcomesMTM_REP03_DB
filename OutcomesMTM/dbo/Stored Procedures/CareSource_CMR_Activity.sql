

CREATE   PROCEDURE [dbo].[CareSource_CMR_Activity] @ReportRunDate DATE
AS

/*
Created By:
Create date:
Desc:

Modified by:
Modified Date:
Desc:


*/

BEGIN

    SET NOCOUNT ON;

    --DECLARE @ReportRunDate DATE

    DECLARE @ReportStartDT DATE;
    DECLARE @LastdayPreQuarter DATE;
	--SET @ReportRunDate = '12-01-2019'--CAST(GETDATE() AS DATE)


    IF DATEPART(MONTH, @ReportRunDate) = 1
    BEGIN
        SET @ReportStartDT = CAST(DATEFROMPARTS(DATEPART(yyyy, @ReportRunDate) - 1, 1, 1) AS DATE);
        SET @LastdayPreQuarter = CAST(DATEADD(qq, DATEDIFF(qq, -1, @ReportRunDate) - 1, -1) AS DATE);

    END;
    ELSE
    BEGIN
        SET @ReportStartDT = CAST(DATEFROMPARTS(DATEPART(yyyy, @ReportRunDate), 1, 1) AS DATE);
        SET @LastdayPreQuarter = CAST(DATEADD(qq, DATEDIFF(qq, -1, @ReportRunDate) - 1, -1) AS DATE);
    END;

	--// test results
    --PRINT @ReportRunDate
    --PRINT @ReportStartDT
    --PRINT @LastdayPreQuarter


    --// Just in case Business would like to have custom date range
    --SET @ReportRunDate =''
    --SET @ReportStartDT = ''



    DROP TABLE IF EXISTS #patient;
    CREATE TABLE #Patient
    (
        [patientKey] BIGINT NOT NULL,
        [Ranker] INT
    );
    INSERT INTO #Patient
    (
        [patientKey],
        [Ranker]
    )
    SELECT [patientKey],
           [Ranker]
    FROM
    (
        SELECT *
        FROM
        (
            SELECT [patientKey],
                   [Ranker] = ROW_NUMBER() OVER (PARTITION BY t.PatientID ORDER BY t.activeAsOf DESC)
            FROM OutcomesMTM.dbo.patientDim t WITH (NOLOCK)
            WHERE 1 = 1
                  AND ISNULL(t.activeThru, GETDATE()) > @ReportStartDT
                  AND t.activeAsOf < @LastdayPreQuarter
        --or(t.activeThru is Null and t.activeThru >'2018-01-01' )

        ) ptd
        WHERE 1 = 1
              AND ptd.Ranker = 1
    ) Patient;
    CREATE CLUSTERED INDEX IDX ON #Patient ([patientKey]);

    DROP TABLE IF EXISTS ##Base;
    CREATE TABLE ##Base
    (
        NCPDP_NABP VARCHAR(50),
        PatientID INT,
        PolicyID INT,
        centerID BIGINT,
        chainid INT,
        CMROffered INT,
        CMRCompleted INT,
        UnableToReachPatient INT,
        CMRWithDrugProblems INT,
        CMRWithoutDrugProblems INT,
        CMRFace2Face INT,
        CMRPhone INT,
        CMRTelehealth INT,
        CMRMissed INT,
        mtmServiceDT DATETIME,
        resultTypeID INT,
        patientMTMCenterKey BIGINT,
        [patientKey] BIGINT,
		primaryPharmacy int
    );
    INSERT INTO ##Base
    SELECT Base.NCPDP_NABP,
           Base.PatientID,
           Base.PolicyID,
           Base.centerid,
           Base.chainid,
           Base.CMROffered,
           Base.CMRCompleted,
           Base.UnableToReachPatient,
           Base.CMRWithDrugProblems,
           Base.CMRWithoutDrugProblems,
           Base.CMRFace2Face,
           Base.CMRPhone,
           Base.CMRTelehealth,
           Base.CMRMissed,
           Base.mtmServiceDT,
           Base.resultTypeID,
           Base.patientMTMcenterKey,
           Base.[patientKey],
		   Base.primaryPharmacy
    FROM
    (
        SELECT ph.NCPDP_NABP,
               rp.PatientID,
               rp.PolicyID,
               ph.centerid,
               rp.chainid,
               rp.mtmServiceDT,
               rp.resultTypeID,
               rp.patientMTMcenterKey,
               pt.patientKey,
			   rp.primaryPharmacy,
               CASE
                   WHEN rp.statusID IN ( 2, 6 )
                        AND rp.resultTypeID IN ( 5, 6, 12 )
                        AND rp.chainid = rp.claimChainID THEN
                       1
                   ELSE
                       0
               END AS CMROffered,
               CASE
                   WHEN rp.statusID IN ( 2, 6 )
                        AND rp.resultTypeID IN ( 5, 6 )
                        AND rp.chainid = rp.claimChainID THEN
                       1
                   ELSE
                       0
               END AS CMRCompleted,
               CASE
                   WHEN rp.statusID IN ( 2, 6 )
                        AND rp.resultTypeID = 18
                        AND rp.chainid = rp.claimChainID THEN
                       1
                   ELSE
                       0
               END AS UnableToReachPatient,
               CASE
                   WHEN rp.statusID IN ( 2, 6 )
                        AND rp.resultTypeID = 5
                        AND rp.chainid = rp.claimChainID THEN
                       1
                   ELSE
                       0
               END AS CMRWithDrugProblems,
               CASE
                   WHEN rp.statusID IN ( 2, 6 )
                        AND rp.resultTypeID = 6
                        AND rp.chainid = rp.claimChainID THEN
                       1
                   ELSE
                       0
               END AS CMRWithoutDrugProblems,
               CASE
                   WHEN rp.cmrDeliveryTypeID = 1
                        AND rp.chainid = rp.claimChainID THEN
                       1
                   ELSE
                       0
               END AS CMRFace2Face,
               CASE
                   WHEN rp.cmrDeliveryTypeID = 2
                        AND rp.chainid = rp.claimChainID THEN
                       1
                   ELSE
                       0
               END AS CMRPhone,
               CASE
                   WHEN rp.cmrDeliveryTypeID = 3
                        AND rp.chainid = rp.claimChainID THEN
                       1
                   ELSE
                       0
               END AS CMRTelehealth,
               CASE
                   WHEN rp.statusID IN ( 2, 6 )
                        AND rp.resultTypeID IN ( 5, 6 )
                        AND rp.chainid <> rp.claimChainID THEN
                       1
                   ELSE
                       0
               END AS CMRMissed
        FROM dbo.vw_CMRActivityReport rp WITH (NOLOCK)
            JOIN #Patient pt
                ON pt.patientKey = rp.patientKey
            JOIN dbo.Policy p WITH (NOLOCK)
                ON p.policyID = rp.PolicyID
            JOIN dbo.pharmacy ph WITH (NOLOCK)
                ON ph.centerid = rp.centerid
        WHERE 1 = 1
			  --AND rp.primaryPharmacy = 1
              AND ISNULL(rp.activeThru, '99991231') >= @ReportStartDT
              AND CAST(rp.activeAsOF AS DATE) <= @LastdayPreQuarter
              AND CAST(rp.mtmServiceDT AS DATE)
              BETWEEN @ReportStartDT AND @LastdayPreQuarter
              AND p.policyID IN ( 758, 807, 577, 756, 755, 576, 390, 378, 498, 459, 671 )
    ) Base;

    CREATE NONCLUSTERED INDEX NIDX ON ##Base (NCPDP_NABP) INCLUDE (chainid);




END;