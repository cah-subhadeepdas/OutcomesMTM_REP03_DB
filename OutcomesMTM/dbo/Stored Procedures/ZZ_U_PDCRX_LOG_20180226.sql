
CREATE procedure [dbo].[ZZ_U_PDCRX_LOG_20180226]
as 
begin
set nocount on;
set xact_abort on;

update d  
set d.[activeThru] = s.queueDate
, d.[isCurrent] = case when s.isInsert = 0 then 1 else 0 end
--select count(*) 
from PDCRxDim d 
join PDCRxDeltaQueueStaging s on d.PDCRxid = s.PDCRxid 
where 1=1 
and d.activeThru is null 
and s.isDelete = 1 

insert into PDCRxDim (
PDCRXID
,PDCruleID 
,PatientID 
,RXID
,[activeAsOf] 
,[isCurrent]
) 
select s.PDCRXID
,s.PDCruleID 
,s.PatientID 
,s.RXID
,s.[queueDate] 
,1 as isCurrent
--select count(*) 
from PDCRxDeltaQueueStaging s 
where 1=1 
and s.isInsert = 1
and not exists (
		select 1 
		from PDCRxDim d
		where 1=1 
		and d.PDCrxid = s.PDCrxid 
		and d.activeasof = s.queueDate
	)


END





