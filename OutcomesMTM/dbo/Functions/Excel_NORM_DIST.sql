
CREATE FUNCTION [dbo].[Excel_NORM_DIST]
-- Excel Normal Distribution - Returns either:
--  Probability Density Function (PDF) or 
--  Cumulative Distribution Function (CDF)
(
    @X          FLOAT   -- Point at which function is to be evaluated
    ,@Mean      FLOAT   -- Mean of the Normal Distribution
    ,@StdDev    FLOAT   -- Standard Deviation of the Normal Distribution
    ,@CumDist   TINYINT -- =0 for Probability Density, =1 for Cumulative Density
    ,@Intervals INT = NULL
) 
RETURNS TABLE WITH SCHEMABINDING
RETURN
WITH CalculateIntervals AS
(
    -- Total intervals (default is about 100 per standard deviation)
    SELECT Intervals = ISNULL(@Intervals, 1000) * ABS(@Mean - @X) / @StdDev
        -- Number of intervals per standard deviation
        ,Interval    = ISNULL(@Intervals, 1000)
), 
    Tally (n) AS
(
    -- Up to 10,000 row tally table
    SELECT TOP (SELECT CAST(Intervals AS INT) FROM CalculateIntervals)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
    FROM (VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) a(n)
    CROSS JOIN (VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) b(n)
    CROSS JOIN (VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) c(n)
    CROSS JOIN (VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) d(n)
)
-- PDF 
SELECT X, Mean, StdDev, [F(X)]=[NPDF(X)]
FROM
(
    SELECT X        = @X
        ,Mean       = @Mean
        ,StdDev     = @StdDev
        ,[NPDF(X)]
    FROM dbo.NORMAL_PDF(@X, @Mean, @StdDev)
) a
WHERE @CumDist = 0
UNION ALL
-- CDF where X = mean
SELECT X        = @X
    ,Mean       = @Mean
    ,StdDev     = @StdDev
    ,[CDF(X)]   = 0.5
WHERE @CumDist = 1 AND @X = @Mean
UNION ALL
-- CDF where X  mean
SELECT X, Mean, StdDev, [CDF(X)]
FROM
(
    SELECT X        = @X
        ,Mean       = @Mean
        ,StdDev     = @StdDev
        --                  SUM the rectangles
        ,[CDF(X)]   = 0.5 + SUM(
                                -- Add to or remove from CDF at mean (0.5)
                                SIGN(@X - @Mean) *
                                -- Width x Height = NPDF(AvgX) 
                                Width * d.[NPDF(X)]
                                )
    FROM CalculateIntervals a
    CROSS JOIN Tally b
    CROSS APPLY
    (
        SELECT Pos1     = @Mean + (@StdDev/Interval) * (n - 1.) * SIGN(@X - @Mean)
            ,Pos2       = @Mean + (@StdDev/Interval) * (n + 0.) * SIGN(@X - @Mean)
            ,Width      = ABS(@Mean - @X)/Intervals
    ) c
    --                         -- Average height --
    CROSS APPLY dbo.NORMAL_PDF(0.5 * (Pos1 + Pos2), @Mean, @StdDev) d
) a
WHERE @CumDist = 1 AND @X<>@Mean;

