
create proc [dbo].[U_AdherenceMonitor]
as
begin
set nocount on;
set xact_abort on;


update am
set am.[AdherenceMonitorID] = a.[AdherenceMonitorID]
	,am.[PatientID] = a.[PatientID]
	,am.[tipdetailID] = a.[tipdetailID]
	,am.[GPI] = a.[GPI]
	,am.[CurrentPDC] = a.[CurrentPDC]
	,am.[DaysMissed] = a.[DaysMissed]
	,am.[AllowableDays] = a.[AllowableDays]
	,am.[BonusEligible] = a.[BonusEligible]
	,am.[YearofUse] = a.[YearofUse]
	,am.[active] = a.[active]
--select count(*)
from outcomesMTM.dbo.AdherenceMonitor am
join outcomesMTM.dbo.AdherenceMonitorStaging a on a.AdherenceMonitorID = am.AdherenceMonitorID
where 1=1


delete am
--select count(*)
from outcomesMTM.dbo.AdherenceMonitor am
left join outcomesMTM.dbo.AdherenceMonitorStaging a on a.AdherenceMonitorID = am.AdherenceMonitorID
where 1=1
and a.AdherenceMonitorID is null

insert into outcomesMTM.dbo.AdherenceMonitor ([AdherenceMonitorID]
	,[PatientID]
	,[tipdetailID]
	,[GPI]
	,[CurrentPDC]
	,[DaysMissed]
	,[AllowableDays]
	,[BonusEligible]
	,[YearofUse]
	,[active]
)
select a.[AdherenceMonitorID]
	,a.[PatientID]
	,a.[tipdetailID]
	,a.[GPI]
	,a.[CurrentPDC]
	,a.[DaysMissed]
	,a.[AllowableDays]
	,a.[BonusEligible]
	,a.[YearofUse]
	,a.[active]
from outcomesMTM.dbo.AdherenceMonitor am
right join outcomesMTM.dbo.AdherenceMonitorStaging a on a.AdherenceMonitorID = am.AdherenceMonitorID
where 1=1
and am.AdherenceMonitorID is null




end


