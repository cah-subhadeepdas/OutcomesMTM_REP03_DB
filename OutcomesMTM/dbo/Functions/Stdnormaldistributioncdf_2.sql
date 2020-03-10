CREATE FUNCTION [dbo].[Stdnormaldistributioncdf_2] (@x FLOAT) 
returns FLOAT 
AS 
  BEGIN 
      DECLARE @Z FLOAT = Abs(@x) 

      IF ( @Z >= 15 ) -- value is too large no need to compute 
        BEGIN 
            IF @x > 0 
              RETURN 1; 

            RETURN 0; 
        END 

      -- Compute the Standard Normal Cummulative Distribution using  
      -- polinomial approximation 26.2.17 from Abramowitz & Stegun (1964) 
      DECLARE @p FLOAT = 0.2316419; 
      DECLARE @b1 FLOAT = 0.319381530; 
      DECLARE @b2 FLOAT = -0.356563782; 
      DECLARE @b3 FLOAT = 1.781477937; 
      DECLARE @b4 FLOAT = -1.821255978; 
      DECLARE @b5 FLOAT = 1.330274429; 
      DECLARE @t FLOAT = 1.0 / ( 1.0 + @p * @Z ); 
      -- For efficiency compute sequence of powers of @t (instead of calling POWER(@t,2), POWER(@t,3), etc.) 
      DECLARE @t2 FLOAT = @t * @t; 
      DECLARE @t3 FLOAT = @t2 * @t; 
      DECLARE @t4 FLOAT = @t3 * @t; 
      DECLARE @cd FLOAT = 1.0 - [dbo].[Stdnormaldistributionpdf](@Z) * ( 
                                  @b1 * @t + @b2 * @t2 + @b3 * @t3 + @b4 * @t4 + 
                                  @b5 * 
                                  @t4 * @t ) 

      IF @x > 0 
        RETURN @cd; 

      RETURN 1.0 - @cd; 
  END 
