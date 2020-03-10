CREATE PROC [dbo].[U_claimQuestionAnswers] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    --drop table #tempupdate
    CREATE TABLE #tempupdate
    (
        id                    INT IDENTITY (1,1) PRIMARY KEY,
        claimQuestionAnswerId INT
    )

    INSERT INTO #tempupdate WITH (TABLOCK)
        (
            claimQuestionAnswerId
        )
    SELECT p.claimQuestionAnswerId
    FROM dbo.claimQuestionAnswers p
    JOIN staging.claimQuestionAnswers s ON s.claimQuestionAnswerId = p.claimQuestionAnswerId
    WHERE 1 = 1
      AND NOT (isnull(p.claimId, 0) = isnull(s.claimId, 0)
        AND isnull(p.claimQuestionId, 0) = isnull(s.claimQuestionId, 0)
        AND isnull(p.answer, 0) = isnull(s.answer, 0)
        )

    CREATE NONCLUSTERED INDEX ind_1 ON #tempupdate (claimQuestionAnswerId)

    DECLARE @batch INT = 500000
    DECLARE @mincnt BIGINT = 1
    DECLARE @maxcnt BIGINT = (SELECT TOP 1 id FROM #tempupdate ORDER BY id DESC)
    WHILE (@mincnt <= @maxcnt)
    BEGIN
        UPDATE p
        SET p.claimId         = s.claimId
          , p.claimQuestionId = s.claimQuestionId
          , p.answer          = s.answer
          --select COUNT(*)
        FROM dbo.claimQuestionAnswers p
        JOIN staging.claimQuestionAnswers s ON s.claimQuestionAnswerId = p.claimQuestionAnswerId
        JOIN #tempupdate t ON t.claimQuestionAnswerId = s.claimQuestionAnswerId
        WHERE 1 = 1
          AND t.id >= @mincnt
          AND t.id < @mincnt + @batch

        SET @mincnt = @mincnt + @batch
    END

    ---------

    DECLARE @temp INT

    SET @temp = (SELECT 1)
    WHILE (@@ROWCOUNT > 0) BEGIN
        INSERT INTO claimQuestionAnswers
            (
                claimQuestionAnswerId
            ,   claimId
            ,   claimQuestionId
            ,   answer
            )
        SELECT TOP (@batch) claimQuestionAnswerId
             , claimId
             , claimQuestionId
             , answer

        FROM staging.claimQuestionAnswers s
        WHERE 1 = 1
          AND NOT exists(
                SELECT 1
                FROM dbo.claimQuestionAnswers p
                WHERE 1 = 1
                  AND s.claimQuestionAnswerId = p.claimQuestionAnswerId
            )
    END

    ----------

    SET @temp = (SELECT 1)
    WHILE (@@ROWCOUNT > 0) BEGIN
        DELETE TOP (@batch) p
            --select COUNT(*)
        FROM dbo.claimQuestionAnswers p
        WHERE 1 = 1
          AND NOT exists(SELECT 1 FROM staging.claimQuestionAnswers s WHERE 1 = 1 AND s.claimQuestionAnswerId = p.claimQuestionAnswerId)

    END

END