



CREATE VIEW [dbo].[vw_EpicRx_ActiveUsers]
AS

select ph.NCPDP_NABP
, ch.chaincode as [Relationship ID]
, ch.chainnm as [Relationship Name]
, ph.centername as [Pharmacy Name]
, ph.Address1 as [Address]
, ph.AddressCity as [City]
, ph.AddressState as [State]
, ph.PHONE as [Phone]
, us.username as [Username]
, us.roleTypeNM as [User Role]
, us.lastLoginDT as [User Last Login Date]
from OutcomesMTM.dbo.pharmacy ph
join OutcomesMTM.dbo.pharmacychain pc on pc.centerid = ph.centerid
join OutcomesMTM.dbo.Chain ch on ch.chainid = pc.chainid
left join (

	select u.userID
	, u.username
	, rt.roleTypeNM
	, u.lastLoginDT
	, uc.centerID
	from OutcomesMTM.staging.users u
	join OutcomesMTM.staging.contact c on c.userID = u.userID
	join OutcomesMTM.staging.usercenter uc on uc.userID = u.userID
	join OutcomesMTM.staging.role r on r.userID = u.userID
	join OutcomesMTM.staging.roleType rt on rt.roleTypeID = r.roleTypeID
	where 1=1
	and u.active = 1
	and uc.active = 1
	and uc.approved = 1
	and r.active = 1
	and r.approved = 1
	and rt.active = 1

) us on us.centerID = ph.centerid
where 1=1
and ph.active = 1
and ch.chaincode = '455'


