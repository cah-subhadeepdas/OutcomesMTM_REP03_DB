
create proc [dbo].[U_Client]
as
begin
set nocount on;
set xact_abort on;

update cl
set	cl.[clientID] = cs.[clientID]
	,cl.[clientName] = cs.[clientName]
--select count(*)
from outcomesMTM.dbo.Client cl
join outcomesMTM.dbo.ClientStaging cs on cs.clientID = cl.clientID
where 1=1


delete cl
--select count(*)
from outcomesMTM.dbo.Client cl
left join outcomesMTM.dbo.ClientStaging cs on cs.clientID = cl.clientID
where 1=1
and cs.clientID is null


insert into outcomesMTM.dbo.Client([clientID]
	,[clientName]
)
select cs.[clientID]
	,cs.[clientName]
from outcomesMTM.dbo.Client cl
right join outcomesMTM.dbo.ClientStaging cs on cs.clientID = cl.clientID
where 1=1
and cl.clientID is null



end

