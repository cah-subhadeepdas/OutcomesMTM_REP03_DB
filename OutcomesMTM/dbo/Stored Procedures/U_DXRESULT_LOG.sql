CREATE procedure [dbo].[U_DXRESULT_LOG]
as 
begin
set nocount on;
set xact_abort on;

--DxResultDim 
update d  
set d.[activeThru] = s.queueDate
, d.[isCurrent] = case when (s.isInsert = 0 or s.active = 0) then 1 else 0 end 
--select count(*) 
from DxResultDim d 
join DxResultDeltaQueueStaging s on d.DxResultid = s.DxResultid 
where 1=1 
and d.activeThru is null 
and s.isDelete = 1 

insert into DxResultDim (
[dxresultid] 
,[dxstateid] 
,[patientid] 
,[activeAsOf] 
,[isCurrent]
) 
select s.[dxresultid] 
,s.[dxstateid] 
,s.[patientid]
,s.[queueDate] 
,1 as isCurrent
--select count(*) 
from DxResultDeltaQueueStaging s 
where 1=1
and s.isInsert = 1
and s.active = 1  
and not exists (
		select 1 
		from DxResultDim d
		where 1=1 
		and d.DxResultID = s.DxResultID 
		and d.activeasof = s.queueDate
	)

END




