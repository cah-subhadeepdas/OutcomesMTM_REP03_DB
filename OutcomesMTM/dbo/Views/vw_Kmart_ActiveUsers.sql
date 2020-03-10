



CREATE VIEW [dbo].[vw_Kmart_ActiveUsers]
AS


select ph.AddressState
, u.username
, c.firstNM
, c.lastNM
, c.email
, ph.centername
, ph.NCPDP_NABP
, uc.requestDT
, uc.approvedDT
, c.employeeID
, rt.roleTypeNM
, u.lastLoginDT
from OutcomesMTM.staging.users u
join OutcomesMTM.staging.contact c on c.userID = u.userID
join OutcomesMTM.staging.usercenter uc on uc.userID = u.userID
join OutcomesMTM.staging.role r on r.userID = u.userID
join OutcomesMTM.dbo.pharmacy ph on ph.centerid = uc.centerID
join OutcomesMTM.dbo.pharmacychain pc on pc.centerid = ph.centerid
join OutcomesMTM.dbo.Chain ch on ch.chainid = pc.chainid
join OutcomesMTM.staging.roleType rt on rt.roleTypeID = r.roleTypeID
where 1=1
and ph.active = 1
and ch.chaincode = '110'
and u.active = 1
and uc.active = 1
and uc.approved = 1
and r.active = 1
and r.approved = 1
and rt.active = 1
--order by u.userID


