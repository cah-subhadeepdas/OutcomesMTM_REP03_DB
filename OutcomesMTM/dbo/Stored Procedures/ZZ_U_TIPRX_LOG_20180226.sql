CREATE procedure [dbo].[ZZ_U_TIPRX_LOG_20180226]
as 
begin
set nocount on;
set xact_abort on;

update d  
set d.[activeThru] = s.queueDate
, d.[isCurrent] = case when s.isInsert = 0 then 1 else 0 end 
--select count(*) 
from TIPRxDim d 
join TIPRxDeltaQueueStaging s on d.TIPRxid = s.TIPRxid 
where 1=1 
and d.activeThru is null 
and s.isDelete = 1 

insert into TIPRxDim (
[TIPRXID] 
,[TIPDetailID] 
,[patientID]
,[RXID] 
,[RuleTypeID]  
,[activeAsOf] 
,[isCurrent]
) 
select s.[TIPRXID] 
,s.[TIPDetailID] 
,s.[patientID] 
,s.[RXID] 
,s.[RuleTypeID] 
,s.[queueDate] 
,1 as isCurrent
--select count(*) 
from TIPRxDeltaQueueStaging s 
where 1=1 
and s.isInsert = 1
and not exists (
		select 1 
		from TIPRxDim d
		where 1=1 
		and d.TIPrxid = s.TIPrxid 
		and d.activeasof = s.queueDate
	)

END




