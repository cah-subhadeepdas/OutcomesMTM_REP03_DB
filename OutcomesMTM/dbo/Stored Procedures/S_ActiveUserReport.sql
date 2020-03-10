

CREATE PROCEDURE [dbo].[S_ActiveUserReport] 
@chaincodes varchar(max) 
, @ncpdps varchar(max) = NULL
as 
begin 


select ph.NCPDP_NABP
, ph.centername as [Pharmacy Name]
, ch.chaincode as [Relationship ID]
, ch.chainnm as [Relationship Name]
, ph.Address1 as [Address]
, ph.AddressCity as [City]
, ph.AddressState as [State]
, ph.PHONE as [Phone]
, us.firstnm as [First Name]
, us.lastnm as [Last Name]
, us.email as [Email]
, us.dob as [dob]
, us.userid as [userid]
, us.username as [Username]
, us.roleTypeNM as [User Role]
, us.lastLoginDT as [User Last Login Date]
, us.requestDT as [Request Date]
, us.approvedDT as [Approved Date]
from OutcomesMTM.dbo.pharmacy ph
join OutcomesMTM.dbo.pharmacychain pc on pc.centerid = ph.centerid
join OutcomesMTM.dbo.Chain ch on ch.chainid = pc.chainid
left join (

	select u.userID
	, u.username
	, c.firstNM
	, c.lastNM
	, c.email
	, c.employeeID
	, c.dob
	, rt.roleTypeNM
	, u.lastLoginDT
	, uc.centerID
	, uc.requestDT
	, uc.approvedDT
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
and (exists(select 1
		   from STRING_SPLIT(@chaincodes, ',') 
		   where 1=1
		         and [value] = ch.chaincode)
		or exists(select 1
		   from STRING_SPLIT(@ncpdps, ',') 
		   where 1=1
		         and [value] = ph.NCPDP_NABP))


end



