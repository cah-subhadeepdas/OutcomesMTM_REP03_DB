CREATE FUNCTION dbo.NORMAL_PDF
-- Normal Distribution - Returns two bits of information:
--  NPDF(X) - The Normal Probability Density Function's value at given mean and std deviation
--  SNPDF(X) - The Standard Normal Probability Density Function's value (mean=0, std dev=1)
(
    @X          FLOAT       -- Point at which function is to be evaluated
    ,@Mean      FLOAT       -- Mean of the Normal Distribution
    ,@StdDev    FLOAT       -- Standard Deviation of the Normal Distribution
)
RETURNS TABLE WITH SCHEMABINDING
RETURN
SELECT X        = @X
    ,Mean       = @Mean
    ,StdDev     = @StdDev
    -- Normal Probability Density Function for Mean and Standard Deviation
    ,[NPDF(X)]  = EXP(-0.5*(@X-@Mean)*(@X-@Mean) /
                    (@StdDev*@StdDev))/(SQRT(2.*PI())*@StdDev)
    -- Standard Normal Probability Density function for Mean=0 and StdDev=1
    ,[SNPDF(X)] = EXP(-0.5*@X*@X)/SQRT(2.*PI());