CREATE FUNCTION [dbo].[Stdnormaldistributioncdf_1] (@x FLOAT) 
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
      -- polinomial approximation 26.2.18 from Abramowitz & Stegun (1964) 
      DECLARE @c1 FLOAT = 0.196854; 
      DECLARE @c2 FLOAT = 0.115194; 
      DECLARE @c3 FLOAT = 0.000344; 
      DECLARE @c4 FLOAT = 0.019527; 
      -- For efficiency compute sequence of powers of @Z (instead of calling POWER(@Z,2), POWER(@Z,3), etc.) 
      DECLARE @Z2 FLOAT = @Z * @Z; 
      DECLARE @Z3 FLOAT = @Z2 * @Z; 
      DECLARE @cd FLOAT = 1.0 - 0.5 * Power(1 + @c1 * @Z + @c2 * @Z2 + @c3 * @Z3 
                                            + 
                                            @c4 * @Z3 * @Z, -4) 

      IF @x > 0 
        RETURN @cd; 

      RETURN 1.0 - @cd; 
  END 
