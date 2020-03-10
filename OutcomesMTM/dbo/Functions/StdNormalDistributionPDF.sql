
CREATE FUNCTION [dbo].[StdNormalDistributionPDF] 
( 
  @x FLOAT 
) 
RETURNS FLOAT 
AS 
BEGIN 
  DECLARE @pi FLOAT = 3.141592653589793238462643383; 
   
  -- The standard normal probability corresponding to @x 
  RETURN EXP(-0.5*@x*@x)/SQRT(2.0*@pi); 
END