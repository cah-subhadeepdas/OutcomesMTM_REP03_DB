
create proc [dbo].[U_AdherenceMonitorQueueStatus]
as
begin
set nocount on;
set xact_abort on;


update am
set	am.[AdherenceMonitorQueueStatusID] = a.[AdherenceMonitorQueueStatusID]
	,am.[AdherenceMonitorQueueStatus] = a.[AdherenceMonitorQueueStatus]
	,am.[AdherenceMonitorQueueStatusDescription] = a.[AdherenceMonitorQueueStatusDescription]
--select count(*)
from outcomesMTM.dbo.AdherenceMonitorQueueStatus am
join outcomesMTM.dbo.AdherenceMonitorQueueStatusStaging a on a.AdherenceMonitorQueueStatusID = am.AdherenceMonitorQueueStatusID
where 1=1
	
delete am
--select count(*)
from outcomesMTM.dbo.AdherenceMonitorQueueStatus am
left join outcomesMTM.dbo.AdherenceMonitorQueueStatusStaging a on a.AdherenceMonitorQueueStatusID = am.AdherenceMonitorQueueStatusID
where 1=1
and a.AdherenceMonitorQueueStatusID is null

insert into outcomesMTM.dbo.AdherenceMonitorQueueStatus ([AdherenceMonitorQueueStatusID]
	,[AdherenceMonitorQueueStatus]
	,[AdherenceMonitorQueueStatusDescription]
)
select a.[AdherenceMonitorQueueStatusID]
	,a.[AdherenceMonitorQueueStatus]
	,a.[AdherenceMonitorQueueStatusDescription]
from outcomesMTM.dbo.AdherenceMonitorQueueStatus am
right join outcomesMTM.dbo.AdherenceMonitorQueueStatusStaging a on a.AdherenceMonitorQueueStatusID = am.AdherenceMonitorQueueStatusID
where 1=1
and am.AdherenceMonitorQueueStatusID is null




end 


