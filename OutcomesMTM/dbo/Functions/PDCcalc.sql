


CREATE FUNCTION [dbo].[PDCcalc](
@minIndexDate date
, @maxIndexDate date 
, @coveredDays int
, @targetedPDC decimal(20,2))  
RETURNS TABLE
AS RETURN
(

select datediff(d, @minIndexDate, @maxIndexDate)+1 as daysInPeriod 
, (datediff(d, @minIndexDate, @maxIndexDate)+1) - @coveredDays as daysMissed
, @coveredDays/cast(datediff(d,@minIndexDate,@maxIndexDate)+1 as decimal(20,2)) as PDC
, datediff(d, @maxIndexDate, (cast(year(@maxIndexDate) as varchar)+'1231'))+1 as daysLeftinYear
, case when @targetedPDC is not null 
	   then (((datediff(d, @maxIndexDate, (cast(year(@maxIndexDate) as varchar)+'1231'))+1)+@coveredDays)
				-(@targetedPDC * ((datediff(d, @maxIndexDate, (cast(year(@maxIndexDate) as varchar)+'1231'))+1)
								   +(datediff(d, @minIndexDate, @maxIndexDate)+1)))) 
	   else null end as daysAllowedtoMiss
, case when @targetedPDC is not null 
	   then (datediff(d, @maxIndexDate, (cast(year(@maxIndexDate) as varchar)+'1231'))+1)
			-(((datediff(d, @maxIndexDate, (cast(year(@maxIndexDate) as varchar)+'1231'))+1)+@coveredDays)
			-(@targetedPDC * ((datediff(d, @maxIndexDate, (cast(year(@maxIndexDate) as varchar)+'1231'))+1)
								+(datediff(d, @minIndexDate, @maxIndexDate)+1)))) 
	   else null end as daysNeededtoCover 
, case when @targetedPDC is not null 
	   then ((datediff(d, @maxIndexDate, (cast(year(@maxIndexDate) as varchar)+'1231'))+1)
			-(((datediff(d, @maxIndexDate, (cast(year(@maxIndexDate) as varchar)+'1231'))+1)+@coveredDays)
			-(@targetedPDC * ((datediff(d, @maxIndexDate, (cast(year(@maxIndexDate) as varchar)+'1231'))+1)
								+(datediff(d, @minIndexDate, @maxIndexDate)+1)))))
			/((datediff(d, @maxIndexDate, (cast(year(@maxIndexDate) as varchar)+'1231'))+1)) 
	   else null end as ratioDaysCoverdtoDaysLeftinYear
where 1=1 

)


