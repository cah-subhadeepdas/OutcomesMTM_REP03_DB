



CREATE procedure [dbo].[U_PATIENTSERVICETYPEDIM]
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
from patientServiceTypeDeltaQueueStaging 
order by queueOrder


declare @queueOrder int = 0;
declare @maxCnt int = (select max(queueOrderID) from #queueOrder);
declare @cnt int = 1;
while(@cnt <= @maxCnt) 
begin 

	set @queueOrder = (select queueOrder from #queueOrder where 1=1 and queueOrder = @cnt)

	--patientServiceTypeDim 
	--DELETES
	update d  
	set d.activethru = s.queueDate
	--select count(*) 
	from patientServiceTypeDim d 
	join patientServiceTypeDeltaQueueStaging s on d.patientid = s.patientid
												  and d.servicetypeid = s.servicetypeid 
												  and s.queueorder = @queueOrder  
	where 1=1 
	and d.activethru is null 
	and s.isDelete = 1 
	and s.isInsert = 0

	--UPDATES
	update d  
	set d.activethru = s.queueDate
	--select count(*) 
	from patientServiceTypeDim d 
	join patientServiceTypeDeltaQueueStaging s on d.patientid = s.patientid
												  and d.servicetypeid = s.servicetypeid  
												  and s.queueorder = @queueOrder 
	where 1=1 
	and d.activethru is null 
	and s.isDelete = 1 
	and s.isInsert = 1
	and not (
		isnull(d.[patientServiceTypeID],0) = isnull(s.[patientServiceTypeID],0)
	)


	--UPSERTS
	insert into patientServiceTypeDim (
	[patientServiceTypeID] 
	,[patientID] 
	,[serviceTypeID] 
	,[activeAsOf] 
	) 
	select s.[patientServiceTypeID] 
	,s.[patientID] 
	,s.[serviceTypeID] 
	,s.queueDate as activeasof 
	--select count(*) 
	from patientServiceTypeDeltaQueueStaging s 
	where 1=1 
	and s.queueorder = @queueOrder 
	and s.isinsert = 1
	and not exists (
			select 1 
			from patientServiceTypeDim d1
			where 1=1 
			and d1.patientid = s.patientid
			and d1.servicetypeid = s.servicetypeid
			and d1.activeasof = s.queueDate
		)
	and not exists (
			select 1 
			from patientServiceTypeDim d2
			where 1=1 
			and d2.patientid = s.patientid
			and d2.servicetypeid = s.servicetypeid
			and d2.activethru is null 
		)

set @cnt = @cnt + 1 

end--end loop

END









