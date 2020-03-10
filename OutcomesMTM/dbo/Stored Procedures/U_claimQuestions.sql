CREATE PROC [dbo].[U_claimQuestions] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    --drop table #tempupdate
    CREATE TABLE #tempupdate
    (
        id              INT IDENTITY (1,1) PRIMARY KEY,
        claimQuestionId INT
    )

    INSERT INTO #tempupdate WITH (TABLOCK)
        (
            claimQuestionId
        )
    SELECT p.claimQuestionId
    FROM dbo.claimQuestions p
    JOIN staging.claimQuestions s ON s.claimQuestionId = p.claimQuestionId
    WHERE 1 = 1
      AND NOT (isnull(p.reasonTypeId, 0) = isnull(s.reasonTypeId, 0)
        AND isnull(p.actionTypeId, 0) = isnull(s.actionTypeId, 0)
        AND isnull(p.resultTypeId, 0) = isnull(s.resultTypeId, 0)
        AND isnull(p.question, '') = isnull(s.question, '')
        AND isnull(p.questionType, '') = isnull(s.questionType, '')
        AND isnull(p.answerList, '') = isnull(s.answerList, '')
        AND isnull(p.tipOnly, 0) = isnull(s.tipOnly, 0)
        AND isnull(p.activeAsOf, '19000101') = isnull(s.activeAsOf, '19000101')
        AND isnull(p.activeThru, '99991231') = isnull(s.activeThru, '99991231')
        AND isnull(p.sortOrder, 0) = isnull(s.sortOrder, 0)
        AND isnull(p.groupId, 0) = isnull(s.groupId, 0))

    CREATE NONCLUSTERED INDEX ind_1 ON #tempupdate (claimQuestionId)

    DECLARE @batch INT = 500000
    DECLARE @mincnt BIGINT = 1
    DECLARE @maxcnt BIGINT = (SELECT TOP 1 id FROM #tempupdate ORDER BY id DESC)
    WHILE (@mincnt <= @maxcnt)
    BEGIN
        UPDATE p
        SET p.reasonTypeId = s.reasonTypeId
          , p.actionTypeId = s.actionTypeId
          , p.mtmserviceDT = s.mtmserviceDT
          , p.resultTypeId = s.resultTypeId
          , p.question     = s.question
          , p.questionType = s.questionType
          , p.answerList   = s.answerList
          , p.tipOnly      = s.tipOnly
          , p.activeAsOf   = s.activeAsOf
          , p.activeThru   = s.activeThru
          , p.sortOrder    = s.sortOrder
          , p.groupId      = s.groupId
          --select COUNT(*)
        FROM dbo.claimQuestions p
        JOIN staging.claimQuestions s ON s.claimQuestionId = p.claimQuestionId
        JOIN #tempupdate t ON t.claimQuestionId = s.claimQuestionId
        WHERE 1 = 1
          AND t.id >= @mincnt
          AND t.id < @mincnt + @batch

        SET @mincnt = @mincnt + @batch
    END

    ---------

    DECLARE @temp INT

    SET @temp = (SELECT 1)
    WHILE (@@ROWCOUNT > 0) BEGIN
        INSERT INTO claimQuestions
            (
                claimQuestionId
            ,   reasonTypeId
            ,   actionTypeId
            ,   resultTypeId
            ,   question
            ,   questionType
            ,   answerList
            ,   tipOnly
            ,   activeAsOf
            ,   activeThru
            ,   sortOrder
            ,   groupId
            )
        SELECT TOP (@batch) claimQuestionId
             , reasonTypeId
             , actionTypeId
             , resultTypeId
             , question
             , questionType
             , answerList
             , tipOnly
             , activeAsOf
             , activeThru
             , sortOrder
             , groupId
        FROM staging.claimQuestions s
        WHERE 1 = 1
          AND NOT exists(
                SELECT 1
                FROM dbo.claimQuestions p
                WHERE 1 = 1
                  AND s.claimQuestionId = p.claimQuestionId
            )
    END

    ----------

    SET @temp = (SELECT 1)
    WHILE (@@ROWCOUNT > 0) BEGIN
        DELETE TOP (@batch) p
            --select COUNT(*)
        FROM dbo.claimQuestions p
        WHERE 1 = 1
          AND NOT exists(SELECT 1 FROM staging.claimQuestions s WHERE 1 = 1 AND s.claimQuestionId = p.claimQuestionId)

    END

END