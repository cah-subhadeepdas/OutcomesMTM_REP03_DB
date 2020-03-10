
create proc [dbo].[U_Pharmacy]
as
begin
set nocount on;
set xact_abort on;



update ph
set ph.[centerid] = ps.[centerid]
	,ph.[centername] = ps.[centername]
	,ph.[legacykey] = ps.[legacykey]
	,ph.[roledesc] = ps.[roledesc]
	,ph.[NCPDP_NABP] = ps.[NCPDP_NABP]
	,ph.[NPI] = ps.[NPI]
	,ph.[FEDERALTAXID] = ps.[FEDERALTAXID]
	,ph.[PHONE] = ps.[PHONE]
	,ph.[FAX] = ps.[FAX]
	,ph.[EMAIL] = ps.[EMAIL]
	,ph.[AddressName] = ps.[AddressName]
	,ph.[Address1] = ps.[Address1]
	,ph.[Address2] = ps.[Address2]
	,ph.[AddressCity] = ps.[AddressCity]
	,ph.[AddressState] = ps.[AddressState]
	,ph.[AddressPostalCode] = ps.[AddressPostalCode]
	,ph.[contracted] = ps.[contracted]
	,ph.[active] = ps.[active]
--select count(*)
from outcomesMTM.dbo.pharmacy ph
join outcomesMTM.dbo.pharmacyStaging ps on ps.centerid = ph.centerID
where 1=1


delete ph
--select count(*)
from outcomesMTM.dbo.pharmacy ph
left join outcomesMTM.dbo.pharmacyStaging ps on ps.centerID = ph.centerID
where 1=1
and ps.centerID is null

insert into outcomesMTM.dbo.pharmacy ([centerid] 
	,[centername] 
	,[legacykey] 
	,[roledesc] 
	,[NCPDP_NABP] 
	,[NPI] 
	,[FEDERALTAXID] 
	,[PHONE] 
	,[FAX]
	,[EMAIL] 
	,[AddressName] 
	,[Address1] 
	,[Address2] 
	,[AddressCity] 
	,[AddressState] 
	,[AddressPostalCode] 
	,[contracted] 
	,[active]
) 
select ps.[centerid] 
	,ps.[centername] 
	,ps.[legacykey] 
	,ps.[roledesc] 
	,ps.[NCPDP_NABP] 
	,ps.[NPI] 
	,ps.[FEDERALTAXID] 
	,ps.[PHONE] 
	,ps.[FAX]
	,ps.[EMAIL] 
	,ps.[AddressName] 
	,ps.[Address1] 
	,ps.[Address2] 
	,ps.[AddressCity] 
	,ps.[AddressState] 
	,ps.[AddressPostalCode] 
	,ps.[contracted] 
	,ps.[active]
from outcomesMTM.dbo.pharmacy ph
right join outcomesMTM.dbo.pharmacyStaging ps on ps.centerID = ph.centerID
where 1=1
and ph.centerID is null

end

