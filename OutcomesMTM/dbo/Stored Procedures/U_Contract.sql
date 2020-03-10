
create proc [dbo].[U_Contract]
as
begin
set nocount on;
set xact_abort on;


update co
set co.[contractID] = cs.[contractID]
	,co.[contractName] = cs.[contractName]
	,co.[clientID] = cs.[clientID]
--select count(*)
from outcomesMTM.dbo.Contract co
join outcomesMTM.dbo.ContractStaging cs on cs.contractID = co.contractID
where 1=1


delete co
--select count(*)
from outcomesMTM.dbo.Contract co
left join outcomesMTM.dbo.ContractStaging cs on cs.contractID = co.contractID
where 1=1
and cs.contractID is null

insert into outcomesMTM.dbo.Contract ([contractID]
	,[contractName]
	,[clientID]
)
select cs.[contractID]
	,cs.[contractName]
	,cs.[clientID]
from outcomesMTM.dbo.Contract co
right join outcomesMTM.dbo.ContractStaging cs on cs.contractID = co.contractID
where 1=1
and co.contractID is null


end 

