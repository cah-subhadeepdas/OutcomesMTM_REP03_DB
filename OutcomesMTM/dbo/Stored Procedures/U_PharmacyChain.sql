
create proc [dbo].[U_PharmacyChain]
as
begin
set nocount on;
set xact_abort on;

update pc
set pc.[PharmacyChainID] = ps.[PharmacyChainID]
	,pc.[centerid] = ps.[centerid]
	,pc.[chainid] = ps.[chainid]
--select count(*)
from outcomesMTM.dbo.pharmacychain pc
join outcomesMTM.dbo.pharmacychainStaging ps on ps.PharmacyChainID = pc.PharmacyChainID
where 1=1

delete pc
--select count(*)
from outcomesMTM.dbo.pharmacychain pc
left join outcomesMTM.dbo.pharmacychainStaging ps on ps.PharmacyChainID = pc.PharmacyChainID
where 1=1
and ps.PharmacyChainID is null

insert into outcomesMTM.dbo.pharmacychain ([PharmacyChainID]
	,[centerid]
	,[chainid]
)
select ps.[PharmacyChainID]
	,ps.[centerid]
	,ps.[chainid]
from outcomesMTM.dbo.pharmacychain pc
right join outcomesMTM.dbo.pharmacychainStaging ps on ps.PharmacyChainID = pc.PharmacyChainID
where 1=1
and pc.PharmacyChainID is null

end 

