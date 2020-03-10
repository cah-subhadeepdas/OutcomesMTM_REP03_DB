CREATE procedure [dbo].[U_TIPRESULT_LOG]
as 
begin
set nocount on;
set xact_abort on;

--TIPResultDim 
update d  
set d.[activeThru] = s.queueDate
, d.[isCurrent] = case when (s.isInsert = 0 or s.active = 0) then 1 else 0 end 
--select count(*) 
from TIPResultDim d 
join TIPResultDeltaQueueStaging s on d.TIPResultid = s.TIPResultid 
where 1=1 
and d.activeThru is null 
and s.isDelete = 1 

insert into TIPResultDim (
[TIPresultid] 
,[TIPdetailid] 
,[patientid] 
,[GPI] 
,i.[repositoryid] 
,i.[fileid] 
,[activeAsOf] 
,[isCurrent]
) 
select s.[TIPresultid] 
,s.[TIPdetailid] 
,s.[patientid]
,s.[GPI] 
,s.[repositoryid] 
,s.[fileid] 
,s.[queueDate] 
,1 as isCurrent
--select count(*) 
from TIPResultDeltaQueueStaging s 
where 1=1 
and s.isInsert = 1
and s.active = 1  
and not exists (
		select 1 
		from TIPResultDim d
		where 1=1 
		and d.TIPResultID = s.TIPResultID 
		and d.activeasof = s.queueDate
	)


END




