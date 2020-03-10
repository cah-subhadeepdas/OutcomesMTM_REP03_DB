CREATE procedure [dbo].[U_DXRX_LOG]
as 
begin
set nocount on;
set xact_abort on;


update d  
set d.[activeThru] = s.queueDate
, d.[isCurrent] = case when s.isInsert = 0 then 1 else 0 end 
--select count(*) 
from DxRxDim d 
join DxRxDeltaQueueStaging s on d.DxRxid = s.DxRxid 
where 1=1 
and d.activeThru is null 
and s.isDelete = 1 

insert into DxRxDim (
[dxrxid] 
,[DXstateid] 
,[patientid]
,[rxid] 
,[activeAsOf] 
,[isCurrent]
) 
select s.[dxrxid] 
,s.[DXstateid] 
,s.[patientid]
,s.[rxid]
,s.[queueDate] 
,1 as isCurrent
--select count(*) 
from DxRxDeltaQueueStaging s 
where 1=1 
and s.isInsert = 1
and not exists (
		select 1 
		from DxRxDim d
		where 1=1 
		and d.dxrxid = s.dxrxid 
		and d.activeasof = s.queueDate
	)


END





