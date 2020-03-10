
CREATE proc [dbo].[U_ProviderChain]
as
begin
set nocount on;
set xact_abort on;

update pc
set pc.[NCPDP_Provider_ID] = ps.[NCPDP_Provider_ID]
	,pc.[chaincode] = ps.[chaincode]
--select count(*)
from outcomesMTM.dbo.ProviderChain pc
join outcomesMTM.dbo.ProviderChain_Staging ps on ps.NCPDP_Provider_ID = pc.NCPDP_Provider_ID
											and ps.chaincode = pc.chaincode
where 1=1


delete pc
--select count(*)
from outcomesMTM.dbo.ProviderChain pc
left join outcomesMTM.dbo.ProviderChain_Staging ps on ps.NCPDP_Provider_ID = pc.NCPDP_Provider_ID
											and ps.chaincode = pc.chaincode
where 1=1
and ps.NCPDP_Provider_ID is null


insert into outcomesMTM.dbo.ProviderChain (NCPDP_Provider_ID, chaincode)
select  ps.NCPDP_Provider_ID, ps.chaincode
from outcomesMTM.dbo.ProviderChain pc
right join outcomesMTM.dbo.ProviderChain_Staging ps on ps.NCPDP_Provider_ID = pc.NCPDP_Provider_ID
											and ps.chaincode = pc.chaincode
where 1=1
and pc.NCPDP_Provider_ID is null





end


