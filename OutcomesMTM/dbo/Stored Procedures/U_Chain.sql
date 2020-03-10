
create proc [dbo].[U_Chain]
as
begin
set nocount on;
set xact_abort on;


update ch
set ch.[chainID] = cs.[chainID]
	,ch.[chainCode] = cs.[chainCode]
	,ch.[chainNM] = cs.[chainNM]
--select count(*)
from outcomesMTM.dbo.Chain ch
join outcomesMTM.dbo.ChainStaging cs on cs.chainid = ch.chainid
where 1=1

delete ch
--select count(*)
from outcomesMTM.dbo.Chain ch
left join outcomesMTM.dbo.ChainStaging cs on cs.chainid = ch.chainid
where 1=1
and cs.chainid is null

insert into outcomesMTM.dbo.Chain ([chainid]
	,[chaincode]
	,[chainnm]
)
select cs.[chainid]
	,cs.[chaincode]
	,cs.[chainnm]
from outcomesMTM.dbo.Chain ch
right join outcomesMTM.dbo.ChainStaging cs on cs.chainid = ch.chainid
where 1=1
and ch.chainid is null

end 

