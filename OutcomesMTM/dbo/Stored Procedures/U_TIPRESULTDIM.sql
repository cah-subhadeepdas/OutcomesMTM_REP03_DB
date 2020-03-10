

CREATE procedure [dbo].[U_TIPRESULTDIM]
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
from TIPResultDeltaQueueStaging 
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
	from TIPResultDim d 
	join TIPResultDeltaQueueStaging s on d.patientid = s.patientid
												and d.TIPDetailID = s.TIPDetailID
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
	from TIPResultDim d 
	join TIPResultDeltaQueueStaging s on d.patientid = s.patientid
												and d.TIPDetailID = s.TIPDetailID
												and s.queueorder = @queueOrder
	where 1=1 
	and d.activethru is null 
	and s.isDelete = 1 
	and s.isInsert = 1 
	and not (
		isnull(d.[TIPresultID],0) = isnull(s.[TIPresultID],0)
		and isnull(d.[GPI],'') = isnull(s.[GPI],'')
		and isnull(d.[repositoryid],0) = isnull(s.[repositoryid],0)
		and isnull(d.[fileid],0) = isnull(s.[fileid],0)
	)
	---------
	and s.active = 1
	---------

	insert into TIPResultDim (
	TIPresultID
	,TIPDetailID
	,PatientID
	,[GPI]
	,[repositoryid]
	,[fileid]
	,[activeAsOf] 
	,[isCurrent]
	) 
	select s.TIPresultID
	,s.TIPDetailID
	,s.PatientID
	,s.[GPI]
	,s.[repositoryid]
	,s.[fileid]
	,s.[queueDate] 
	,1 as isCurrent
	--select count(*) 
	from TIPResultDeltaQueueStaging s 
	where 1=1 
	and s.queueorder = @queueOrder
	and s.isInsert = 1 
	and not exists (
			select 1 
			from TIPResultDim d1
			where 1=1 
			and d1.patientid = s.patientid 
			and d1.TIPDetailID = s.TIPDetailID 
			and d1.activeasof = s.queueDate
		)
	and not exists (
			select 1 
			from TIPResultDim d2
			where 1=1 
			and d2.patientid = s.patientid 
			and d2.TIPDetailID = s.TIPDetailID 
			and d2.activethru is null 
		)
	---------
	and s.active = 1
	---------


set @cnt = @cnt + 1 

end--end loop



END










