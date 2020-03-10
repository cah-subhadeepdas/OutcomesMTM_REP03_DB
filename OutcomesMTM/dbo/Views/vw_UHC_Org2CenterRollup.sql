


CREATE VIEW [dbo].[vw_UHC_Org2CenterRollup]
AS

select o.OrgID, t.centerid
from [UHC_OrganizationRollup] o
join (

       select cr.[Organization Name]
	   , p.centerid 
       from [UHC_ChainRollUp] cr
       join chain c on c.chainCode = cr.RelationshipID 
       join pharmacychain pc on pc.chainid = c.chainid
       join pharmacy p on p.centerid = pc.centerid
       where 1=1

	   union all

       select cr.[Organization Name], p.centerid
       from [UHC_ChainRollUp] cr
       join pharmacy p on p.NCPDP_NABP = cr.NABP
       where 1=1

) t on o.[Organization Name] = t.[Organization Name]
where 1=1

