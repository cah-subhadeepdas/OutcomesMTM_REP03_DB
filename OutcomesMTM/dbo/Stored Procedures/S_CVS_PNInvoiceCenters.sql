

-- ==========================================================================================
-- Author:	Ram
-- Create date: 
-- Description:	CVS PN Invoice Report
-- ==========================================================================================
-- Change Log
-- ==========================================================================================
--   #		Date		Author			Description
--   --		--------	----------		----------------
--   1		01/23/2020	Ram Ravi    	TC-3561 (2020 Client List Updates)


-- ==========================================================================================


CREATE proc [dbo].[S_CVS_PNInvoiceCenters] 
as 
begin 


DECLARE @BEGIN datetime
DECLARE @END datetime


SET @BEGIN = dateadd(yy, datediff(yy,0, getdate()), 0)
--cast(getdate()-7 as date)	--Data to be fetched from last Thursday (Job is scheduled to run every Thursday so a 7 day difference)
SET @END = dateadd(yy, datediff(yy,0, getdate())+1, -1)
--cast(getdate()-1 as date) --Data to be fetched until Wednesday (the day before the job run)


----Pull the required data for the CVS Patients
if object_id('tempdb..#condata') is not null
drop table #condata
select pd.*
into #condata
from outcomesmtm.dbo.patientmtmcenterdim pd
join outcomesmtm.dbo.patientdim pt
	on pt.PatientID = pd.patientid and pt.iscurrent = 1 and pt.ClientID in (146,147,148,149,150,151,152,153,154,155,156,164,165,166,215,216,218,219,220,221,222,223,224,225)
where 1=1
and isnull(pd.activethru, getdate()) between @BEGIN and @END

----Consolidate the data based on the centers
if object_id('tempdb..#centers') is not null
drop table #centers
select patientid, centerid
,activefrom = min(activeasof),activethru = max(coalesce(activethru,@END))
into #centers
from
		(
			select patientid,centerid, activeasof,activethru
			, island = row_number() over (partition by patientid order by activeasof)
					- row_number() over (partition by patientid,centerid order by activeasof )
			from #condata
		)
			t1 group by patientid, centerid

---- Pull the centers that were dropped in the last week
select *
from #centers
where 1=1
and cast(isnull(activethru, getdate()) as date) between @BEGIN + 1 and @END


end







