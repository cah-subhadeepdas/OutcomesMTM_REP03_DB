
create proc [dbo].[U_Policy]
as
begin
set nocount on;
set xact_abort on;

update po
set po.[policyID] = ps.[policyID]
	,po.[policyName] = ps.[policyName]
	,po.[contractID] = ps.[contractID]
	,po.[policyTypeID] = ps.[policyTypeID]
	,po.[IsMedicarePolicy] = ps.[IsMedicarePolicy]
--select count(*)
from outcomesMTM.dbo.Policy po
join outcomesMTM.dbo.PolicyStaging ps on ps.policyID = po.policyID
where 1=1


delete po
--select count(*)
from outcomesMTM.dbo.Policy po
left join outcomesMTM.dbo.PolicyStaging ps on ps.policyID = po.policyID
where 1=1
and ps.policyID is null

insert into outcomesMTM.dbo.policy ([policyID]
	,[policyName]
	,[contractID]
	,[policyTypeID]
	,[IsMedicarePolicy]
)
select ps.[policyID]
	,ps.[policyName]
	,ps.[contractID]
	,ps.[policyTypeID]
	,ps.[IsMedicarePolicy]
from outcomesMTM.dbo.Policy po
right join outcomesMTM.dbo.PolicyStaging ps on ps.policyID = po.policyID
where 1=1
and po.policyID is null

end

