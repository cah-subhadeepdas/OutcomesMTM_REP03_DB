

CREATE procedure [dbo].[U_DXRESULTDIM]
as 
begin
set nocount on;
set xact_abort on;


if(object_id('tempdb..#queueOrder') is not null)
drop table #queueOrder
create table #queueOrder (
queueOrderID int identity(1,1) primary key 
, queueOrder int 
)
insert into #queueOrder (queueOrder) 
select distinct queueOrder 
from DXResultDeltaQueueStaging 
order by queueOrder


declare @queueOrder int = 0;
declare @maxCnt int = (select max(queueOrderID) from #queueOrder);
declare @cnt int = 1;
while(@cnt <= @maxCnt) 
begin 

	set @queueOrder = (select queueOrder from #queueOrder where 1=1 and queueOrder = @cnt)

	--DELETES
	update d  
	set d.activethru = s.queueDate
	, d.[isCurrent] = 1 
	--select count(*) 
	from DXResultDim d 
	join DXResultDeltaQueueStaging s on d.patientid = s.patientid
												and d.DXstateID = s.DXstateID
												and s.queueorder = @queueOrder
	where 1=1 
	and d.activethru is null 
	and ((s.isDelete = 1 
		  and s.isInsert = 0) 
		  or 
		 (s.active = 0))

	--UPDATES
	update d  
	set d.activethru = s.queueDate
	, d.[isCurrent] = 0 
	--select count(*) 
	from DXResultDim d 
	join DXResultDeltaQueueStaging s on d.patientid = s.patientid
												and d.DXstateID = s.DXstateID
												and s.queueorder = @queueOrder
	where 1=1 
	and d.activethru is null 
	and s.isDelete = 1 
	and s.isInsert = 1 
	and not (
		isnull(d.[DXresultID],0) = isnull(s.[DXresultID],0)
	)
	---------
	and s.active = 1
	---------

	insert into DXResultDim (
	DXresultID
	,DXstateID
	,PatientID
	,[activeAsOf] 
	,[isCurrent]
	) 
	select s.DXresultID
	,s.DXstateID
	,s.PatientID
	,s.[queueDate] 
	,1 as isCurrent
	--select count(*) 
	from DXResultDeltaQueueStaging s 
	where 1=1 
	and s.queueorder = @queueOrder
	and s.isInsert = 1 
	and not exists (
			select 1 
			from DXResultDim d1
			where 1=1 
			and d1.patientid = s.patientid 
			and d1.DXstateID = s.DXstateID 
			and d1.activeasof = s.queueDate
		)
	and not exists (
			select 1 
			from DXResultDim d2
			where 1=1 
			and d2.patientid = s.patientid 
			and d2.DXstateID = s.DXstateID 
			and d2.activethru is null 
		)
	---------
	and s.active = 1
	---------


set @cnt = @cnt + 1 

end--end loop



END










