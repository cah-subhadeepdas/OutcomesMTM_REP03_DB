


CREATE procedure [dbo].[U_PRESCRIPTIONDIMBATCH]
as 
begin
set nocount on;
set xact_abort on;


if(object_id('prescriptionDimDataLog') is null)
create table prescriptionDimDataLog (
prescriptionDataLogID int identity(1,1) 
, queueorder int  
, operation varchar(50)
, batchDate date  
, startDate datetime  
, endDate datetime
)


if(object_id('tempdb..#queueOrder') is not null)
drop table #queueOrder

create table #queueOrder (
queueOrderID int identity(1,1) primary key 
, queueOrder int 
)
insert into #queueOrder (queueOrder) 
select distinct queueOrder 
from prescriptionDeltaQueueStaging 
order by queueOrder

declare @queueOrder int = 0;
declare @maxCnt int = (select max(queueOrderID) from #queueOrder);
declare @cnt int = 1;
while(@cnt <= @maxCnt) 
begin 

	set @queueOrder = (select queueOrder from #queueOrder where 1=1 and queueOrder = @cnt)

	exec U_PRESCRIPTIONDIM @queueOrder

	set @cnt = @cnt + 1 

end--end loop


delete p 
from prescriptionDimDataLog p 
where 1=1 
and batchDate < dateadd(month,-1,cast(getdate() as date))

END














