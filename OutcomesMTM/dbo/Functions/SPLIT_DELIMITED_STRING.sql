CREATE  FUNCTION [DBO].SPLIT_DELIMITED_STRING (@SQLQUERY_IN  VARCHAR(MAX),
                                              @DELIMITOR_IN VARCHAR(50))
RETURNS @RESULT TABLE(
  VALUE VARCHAR(MAX))
AS
  BEGIN
	  declare @DELIMITOR varchar(50) ;
	  declare @SQLQUERY varchar(MAX) ; 
	  set @DELIMITOR = lower(@DELIMITOR_IN) ; 
	  set @SQLQUERY = lower(replace(replace(@SQLQUERY_IN , CHAR(10) , ' ') , CHAR(13), ' ')) ; 

	  declare @RESULT_RAW TABLE(id int  identity(1,1) , VALUE VARCHAR(MAX)) ;

     
      DECLARE @DELIMITORPOSITION INT = CHARINDEX(@DELIMITOR, @SQLQUERY),
              @VALUE             VARCHAR(MAX),
              @STARTPOSITION     INT = 1
 
      IF @DELIMITORPOSITION = 0
        BEGIN
            INSERT INTO @RESULT_RAW
            --VALUES     (@SQLQUERY)
			VALUES (NULL)
 
            RETURN
        END
 
      SET @SQLQUERY = @SQLQUERY + @DELIMITOR
 
      WHILE @DELIMITORPOSITION > 0
        BEGIN
            SET @VALUE = SUBSTRING(@SQLQUERY, @STARTPOSITION,
                         @DELIMITORPOSITION - @STARTPOSITION)
 
            IF( @VALUE <> '' )
			BEGIN			 
				  INSERT INTO @RESULT_RAW
				  VALUES     (LEFT(@DELIMITOR,1) + substring(@VALUE , 0, charindex(' ', @VALUE)) )
			END
 
			
            SET @STARTPOSITION = @DELIMITORPOSITION + 1
            SET @DELIMITORPOSITION = CHARINDEX(@DELIMITOR, @SQLQUERY,
                                     @STARTPOSITION)
        END


		insert into @RESULT
		select distinct  VALUE from @RESULT_RAW
		where 1=1
		and ((id = 1 and VALUE is NULL)
		    or id > 1)
		--order by id
 
      RETURN
  END