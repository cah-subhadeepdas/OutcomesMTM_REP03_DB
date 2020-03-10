









CREATE proc [dbo].[S_Humana_EMTMIncentivePilot_Base] 
as 
begin 



DECLARE @BEGIN VARCHAR(10)
DECLARE @END VARCHAR(10)



SET @BEGIN =  cast(dateadd(qq,datediff(qq,0,getdate()),0) as date)
SET @END =  cast(getdate() as date)	 		





select distinct ph.NCPDP_NABP
, replace(replace(replace(ph.centername,char(9),''),char(10),''),char(13),'') as [PharmacyName]
, ph.addressState as [Pharmacy State]
, pr.Relationship_ID
, pr.Relationship_ID_Name
, isnull(ta.[TIP Opportunities],0) as [TIP Opportunities]
, isnull(ta.[Completed TIPs],0) as [Completed TIPs]
, isnull(ta.[Successful TIPs],0) as [Successful TIPs]
, isnull(ta.NetEffectiveRate,0) as NetEffectiveRate
from outcomesMTM.dbo.pharmacy ph
join OutcomesMTM.dbo.NCPDP_Provider np on np.NCPDP_Provider_ID = ph.NCPDP_NABP
left join (

	select row_number() over (partition by ph.centerID order by case when pr.Relationship_type = '02' then '99' else pr.Relationship_type end asc) as [Rank]
	, ph.centerid
	, pr.Relationship_Type
	, pr.Relationship_ID
	, pr.Relationship_ID_Name
	, pr.parent_organization_ID
	, pr.parent_organization_Name
	from outcomesmtm.dbo.providerRelationshipView pr
	join outcomesmtm.dbo.pharmacy ph on ph.NCPDP_NABP = pr.mtmCenterNumber
	where 1=1
	and pr.Relationship_Type in ('01', '05', '02')

) pr on pr.centerid = ph.centerid and pr.[Rank] = 1
left join (

	select ta.centerid
	, cast(sum(ta.[TIP Opportunities]) as decimal) as [TIP Opportunities]
	, cast(sum(ta.[Completed TIPs]) as decimal) as [Completed TIPs]
	, isnull(cast((cast(sum(ta.[Completed TIPs]) as decimal)/nullif(cast(sum(ta.[TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0) as TIPCompletionRate
	, cast(sum(ta.[Successful TIPs]) as decimal) as [Successful TIPs]
	, isnull(cast((cast(sum(ta.[Successful TIPs]) as decimal)/nullif(cast(sum(ta.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as TIPSuccessfulRate
	, isnull(cast((cast(sum(ta.[Successful TIPs]) as decimal)/nullif(cast(sum(ta.[TIP Opportunities]) as decimal), 0)) as decimal (5,2)), 0) as NetEffectiveRate
	from (	
		select tacr.centerid
		, tacr.[TIP Opportunities]
		, CASE WHEN tacr.activethru > @END THEN 0 ELSE tacr.[Completed TIPs] END AS [Completed TIPs]
		, CASE WHEN tacr.activethru > @END THEN 0 ELSE tacr.[Successful TIPs] END AS [Successful TIPs]
		from outcomesMTM.dbo.tipActivityCenterReport tacr
		where 1=1
		and tacr.policyid  in (735,736,737,738)
		and (tacr.primaryPharmacy = 1 or tacr.[Completed TIPs] =1)
		and tacr.activethru >= @BEGIN
		and tacr.activeasof <= @END
		AND ((tacr.activethru <= @END AND (tacr.[completed tips] = 1 or tacr.[unfinished tips] = 1 or tacr.[review/resubmit tips] = 1 or tacr.[rejected tips] = 1)) 
			OR datediff(day, case when tacr.activeasof > @BEGIN then tacr.activeasof else @BEGIN end, case when tacr.activethru > @END then @END else tacr.activethru end) > 30)
	) ta
	where 1=1
	group by ta.centerID

) ta on ta.centerid = ph.centerID
where 1=1
and np.Active = 1
and Relationship_ID in ('226', 'A10', 'A13', '181', '045', '056', '229', 'C11')
order by ph.NCPDP_NABP

end






