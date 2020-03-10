
create proc [dbo].[U_AdherenceMonitorQueue]
as
begin
set nocount on;
set xact_abort on;


update am
set am.[AdherenceMonitorQueueID] = a.[AdherenceMonitorQueueID]
	,am.[centerID] = a.[centerID]
	,am.[AdherenceMonitorID] = a.[AdherenceMonitorID]
	,am.[AdherenceMonitorYear] = a.[AdherenceMonitorYear]
	,am.[AdherenceMonitorQuarter] = a.[AdherenceMonitorQuarter]
	,am.[AdherenceMonitorQueueStatusID] = a.[AdherenceMonitorQueueStatusID]
	,am.[QueueStart] = a.[QueueStart]
	,am.[QueueEnd] = a.[QueueEnd]
	,am.[claimID] = a.[claimID]
	,am.[ModifyDT] = a.[ModifyDT]
from outcomesMTM.dbo.AdherenceMonitorQueue am
join outcomesMTM.dbo.AdherenceMonitorQueueStaging a on a.AdherenceMonitorQueueID = am.AdherenceMonitorQueueID
where 1=1


delete am
--select count(*)
from outcomesMTM.dbo.AdherenceMonitorQueue am
left join outcomesMTM.dbo.AdherenceMonitorQueueStaging a on a.AdherenceMonitorQueueID = am.AdherenceMonitorQueueID
where 1=1
and a.AdherenceMonitorQueueID is null


insert into outcomesMTM.dbo.AdherenceMonitorQueue ([AdherenceMonitorQueueID]
	,[centerID]
	,[AdherenceMonitorID]
	,[AdherenceMonitorYear]
	,[AdherenceMonitorQuarter]
	,[AdherenceMonitorQueueStatusID]
	,[QueueStart]
	,[QueueEnd]
	,[claimID]
	,[ModifyDT]
)
select a.[AdherenceMonitorQueueID]
	,a.[centerID]
	,a.[AdherenceMonitorID]
	,a.[AdherenceMonitorYear]
	,a.[AdherenceMonitorQuarter]
	,a.[AdherenceMonitorQueueStatusID]
	,a.[QueueStart]
	,a.[QueueEnd]
	,a.[claimID]
	,a.[ModifyDT]
from outcomesMTM.dbo.AdherenceMonitorQueue am
right join outcomesMTM.dbo.AdherenceMonitorQueueStaging a on a.AdherenceMonitorQueueID = am.AdherenceMonitorQueueID
where 1=1
and am.AdherenceMonitorQueueID is null


end 

