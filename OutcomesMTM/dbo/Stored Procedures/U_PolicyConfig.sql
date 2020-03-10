
create proc [dbo].[U_PolicyConfig]
as
begin
set nocount on;
set xact_abort on;


update pc
set pc.[policyConfigID] = ps.[policyConfigID]
	,pc.[policyID] = ps.[policyID]
	,pc.[addUnlistedPatient] = ps.[addUnlistedPatient]
	,pc.[QA] = ps.[QA]
	,pc.[insightActive] = ps.[insightActive]
	,pc.[connectActive] = ps.[connectActive]
	,pc.[activeAsOf] = ps.[activeAsOf]
	,pc.[activeThru] = ps.[activeThru]
--select count(*)
from outcomesMTM.dbo.PolicyConfig pc
join outcomesMTM.dbo.PolicyConfigStaging ps on ps.policyConfigID = pc.policyConfigID
where 1=1

delete pc
--select (*)
from outcomesMTM.dbo.PolicyConfig pc
left join outcomesMTM.dbo.PolicyConfigStaging ps on ps.policyConfigID = pc.policyConfigID
where 1=1
and ps.policyConfigID is null

insert into outcomesMTM.dbo.PolicyConfig ([policyConfigID]
	,[policyID]
	,[addUnlistedPatient]
	,[QA]
	,[insightActive]
	,[connectActive]
	,[activeAsOf]
	,[activeThru]
) 
select ps.[policyConfigID]
	,ps.[policyID]
	,ps.[addUnlistedPatient]
	,ps.[QA]
	,ps.[insightActive]
	,ps.[connectActive]
	,ps.[activeAsOf]
	,ps.[activeThru]
from outcomesMTM.dbo.PolicyConfig pc
right join outcomesMTM.dbo.PolicyConfigStaging ps on ps.policyConfigID = pc.policyConfigID
where 1=1
and pc.policyConfigID is null


end

