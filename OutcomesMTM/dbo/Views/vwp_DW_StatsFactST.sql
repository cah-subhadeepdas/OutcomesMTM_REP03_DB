


CREATE view [dbo].[vwp_DW_StatsFactST]
as

select claimkey, 1 'FactAmt', mtmserviceDT, reasonCode as OriginID, 'reasonCode' OriginCol, 'DimClaim' OriginTbl, reasonTypeDesc OriginDesc
from dbo.DW_DimClaim 
where statusid in (2,6)
and policyid = 249
and mtmServiceDT >=  '20090401'

union all 

select  claimkey, 1 'FactAmt',  mtmserviceDT, actionCode as OriginID, 'actionCode' OriginCol,'DimClaim' OriginTbl, actionNM OriginDesc
from dbo.DW_DimClaim 
where statusid in (2,6)
and policyid = 249
and mtmServiceDT >=  '20090401'

union all

select  claimkey, 1 'FactAmt', mtmserviceDT, resultCode as OriginID, 'resultCode' OriginCol,'DimClaim' OriginTbl, resultDesc OriginDesc
from dbo.DW_DimClaim 
where statusid in (2,6)
and policyid = 249
and mtmServiceDT >=  '20090401'

union all

select  claimkey, 1 'FactAmt', mtmserviceDT, ecaLevelID as OriginID, 'ecaLevelID' OriginID, 'DimClaim' OriginTbl, ecaDesc OriginDesc
from dbo.DW_DimClaim 
where statusid in (2,6)
and policyid = 249
and mtmServiceDT >=  '20090401'

