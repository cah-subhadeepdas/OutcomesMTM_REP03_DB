
/*
 Modified as per TC- 1871 to update the chainrollup 
 Updated By: Vishal Deshmukh
 Date: 06/25/2018

*/
 
 /*Modified as per TC- 2955 to update the PolicyIDs 
 Updated By: Santhosh Kumar
 Date: 05/02/2019
 */

CREATE Procedure [dbo].[UHC_RetailerKey_PharmacyTIPs_30_Day] 
@string nvarchar(100)
as 
begin 

--declare @string nvarchar(100)

--set @string = '1'

--select * from #org

---------------------------------------------------------------------------------------------------------
--------------------------CHAINS -- Theses chains are not mapped as they are usually in chain rollup, this Ticket TC-1493  request for different
-- chains, but the attachment had different tab name with same chain names and different relationship id, to make this easy the Organization name is 
-- replaced with Tab Name
---------------------------------------------------------------------------------------------------------
--Below temp table was provided by Network Performance
if(object_ID('tempdb..#chainRollUp') is not null)
begin
drop table #chainRollUp
end
create table #chainRollUp (
ID int identity (1,1) primary key
, Preferred int
, [Organization Category Size] int
, [Organization Name] varchar(100)
, RelationshipID varchar(50)
, NABP varchar(50))

Insert into #ChainRollup select '1','2','Ahold','289',NULL
Insert into #ChainRollup select '1','2','Giant Of Maryland','075',NULL
Insert into #ChainRollup select '1','2','Giant Food Stores','415',NULL
Insert into #ChainRollup select '1','1','Albertsons','929',NULL
Insert into #ChainRollup select '1','1','Albertsons','003',NULL
Insert into #ChainRollup select '1','1','Albertsons',NULL,'999572'
Insert into #ChainRollup select '1','1','Albertsons',NULL,'999573'
Insert into #ChainRollup select '1','1','Albertsons',NULL,'999574'
Insert into #ChainRollup select '1','1','Albertsons','156',NULL
Insert into #ChainRollup select '1','1','Albertsons','301',NULL
Insert into #ChainRollup select '1','1','Albertsons','B62',NULL
Insert into #ChainRollup select '1','1','Albertsons','158',NULL
Insert into #ChainRollup select '1','1','Albertsons','227',NULL
Insert into #ChainRollup select '1','1','Albertsons','282',NULL
Insert into #ChainRollup select '1','1','Albertsons','027',NULL
Insert into #ChainRollup select '1','1','Albertsons','400',NULL
Insert into #ChainRollup select '1','1','Albertsons',NULL,'999507'
Insert into #ChainRollup select '1','1','Albertsons',NULL,'999511'
Insert into #ChainRollup select '1','1','Albertsons',NULL,'999512'
Insert into #ChainRollup select '1','1','Albertsons',NULL,'999517'
Insert into #ChainRollup select '1','1','Albertsons','C08',NULL
Insert into #ChainRollup select '1','1','Albertsons','319',NULL
Insert into #ChainRollup select '1','1','Albertsons','C31',NULL
Insert into #ChainRollup select '0','4','Cardinal','603',NULL
Insert into #ChainRollup select '0','4','Cardinal','A51',NULL
Insert into #ChainRollup select '0','4','Cardinal','931',NULL
Insert into #ChainRollup select '0','4','Cardinal','139',NULL
Insert into #ChainRollup select '0','4','Cardinal','307',NULL
Insert into #ChainRollup select '0','2','Costco','299',NULL
Insert into #ChainRollup select '0','1','CVS',NULL,'999104'
Insert into #ChainRollup select '0','1','CVS',NULL,'999818'
Insert into #ChainRollup select '0','1','CVS',NULL,'999682'
Insert into #ChainRollup select '0','1','CVS',NULL,'999690'
Insert into #ChainRollup select '0','1','CVS',NULL,'999689'
Insert into #ChainRollup select '0','1','CVS',NULL,'999688'
Insert into #ChainRollup select '0','1','CVS',NULL,'CVS1EAST'
Insert into #ChainRollup select '0','1','CVS',NULL,'CVS1WEST'
Insert into #ChainRollup select '0','1','CVS','177',NULL
Insert into #ChainRollup select '0','1','CVS','123',NULL
Insert into #ChainRollup select '0','1','CVS','039',NULL
Insert into #ChainRollup select '0','1','CVS','782',NULL
Insert into #ChainRollup select '0','1','CVS','608',NULL
Insert into #ChainRollup select '0','1','CVS','207',NULL
Insert into #ChainRollup select '0','1','CVS','673',NULL
Insert into #ChainRollup select '0','1','CVS','380',NULL
Insert into #ChainRollup select '0','1','CVS','008',NULL
Insert into #ChainRollup select '1','3','Hannaford','233',NULL
Insert into #ChainRollup select '1','3','Food Lion','862',NULL
Insert into #ChainRollup select '0','4','Elevate','638',NULL
Insert into #ChainRollup select '0','4','Elevate','904',NULL
Insert into #ChainRollup select '0','4','Epic','455',NULL
Insert into #ChainRollup select '0','2','Giant Eagle','248',NULL
Insert into #ChainRollup select '0','2','Giant Eagle',NULL,'999650'
Insert into #ChainRollup select '1','2','HEB','025',NULL
Insert into #ChainRollup select '1','2','Hy-Vee','097',NULL
Insert into #ChainRollup select '0','2','Kmart','110',NULL
Insert into #ChainRollup select '0','2','Meijer','213',NULL
Insert into #ChainRollup select '1','1','Publix','302',NULL
Insert into #ChainRollup select '0','1','RiteAid','181',NULL
Insert into #ChainRollup select '0','1','RiteAid','045',NULL
Insert into #ChainRollup select '0','1','RiteAid','056',NULL
Insert into #ChainRollup select '0','2','Sams','C11',NULL
Insert into #ChainRollup select '0','2','Shopko','246',NULL
Insert into #ChainRollup select '0','2','Shopko',NULL,'999974'
Insert into #ChainRollup select '0','2','Shopko',NULL,'999957'
Insert into #ChainRollup select '0','2','Southeastern','315',NULL
Insert into #ChainRollup select '0','2','Southeastern','292',NULL
Insert into #ChainRollup select '0','3','SuperValu','410',NULL
Insert into #ChainRollup select '0','3','SuperValu','285',NULL
Insert into #ChainRollup select '1','1','Kroger','108',NULL
Insert into #ChainRollup select '1','1','Kroger','113',NULL
Insert into #ChainRollup select '1','1','Kroger','199',NULL
Insert into #ChainRollup select '1','1','Kroger','273',NULL
Insert into #ChainRollup select '1','1','Kroger','043',NULL
Insert into #ChainRollup select '1','1','Kroger','495',NULL
Insert into #ChainRollup select '1','1','Kroger','069',NULL
Insert into #ChainRollup select '1','1','Kroger','071',NULL
Insert into #ChainRollup select '1','1','Kroger','817',NULL
Insert into #ChainRollup select '1','1','Kroger','602',NULL
Insert into #ChainRollup select '1','1','Kroger','A65',NULL
Insert into #ChainRollup select '1','1','Kroger','B67',NULL
Insert into #ChainRollup select '1','1','Kroger',NULL,'999546'
Insert into #ChainRollup select '1','1','Kroger',NULL,'999548'
Insert into #ChainRollup select '1','1','Kroger',NULL,'999549'
Insert into #ChainRollup select '1','1','Kroger',NULL,'999667'
Insert into #ChainRollup select '1','1','Kroger',NULL,'999668'
Insert into #ChainRollup select '1','1','Kroger',NULL,'999670'
Insert into #ChainRollup select '1','1','Kroger',NULL,'999671'
Insert into #ChainRollup select '1','1','Kroger',NULL,'999672'
Insert into #ChainRollup select '1','1','Kroger',NULL,'999673'
Insert into #ChainRollup select '1','1','Kroger',NULL,'999674'
Insert into #ChainRollup select '1','1','Kroger',NULL,'999669'
Insert into #ChainRollup select '1','1','Kroger',NULL,'999317'
Insert into #ChainRollup select '1','3','ThriftyWhite','216',NULL
Insert into #ChainRollup select '1','3','ThriftyWhite',NULL,'999656'
Insert into #ChainRollup select '1','1','Walgreens','226',NULL
Insert into #ChainRollup select '1','1','Walgreens','A10',NULL
Insert into #ChainRollup select '1','1','Walgreens','A13',NULL
Insert into #ChainRollup select '1','1','Walmart','229',NULL
Insert into #ChainRollup select '1','1','Walmart','229',NULL
Insert into #ChainRollup select '1','3','Wegmans','256',NULL



if(object_ID('tempdb..#org') is not null)
begin
drop table #org
end
create table #org (
orgID int identity (1,1) primary key
, [Organization Name] varchar(100)
, [Organization Category Size] int
)
insert into #org ([Organization Name], [Organization Category Size])
select distinct [organization Name]
, [Organization Category Size] 
from #chainrollup
where 1=1 


if(object_ID('tempdb..#Org2Center') is not null)
begin
drop table #Org2Center
end
create table #org2Center(
orgID int 
, centerid int
, NCPDP_NABP varchar (50) 
primary key (orgid, centerid) 
)
;with ch as (

       select cr.[Organization Name]
          , p.centerid
          , p.NCPDP_NABP 
       from #chainRollUp cr
       join OutcomesMTM.dbo.chain c on c.chainCode = cr.RelationshipID 
       join outcomesmtm.dbo.pharmacychain pc on pc.chainid = c.chainid
       join outcomesmtm.dbo.pharmacy p on p.centerid = pc.centerid and p.active=1
       where 1=1

),
ph as (

       select cr.[Organization Name], p.centerid, p.NCPDP_NABP
       from #chainRollUp cr
       join outcomesmtm.dbo.pharmacy p on p.NCPDP_NABP = cr.NABP and p.active=1
       where 1=1


)
insert into #Org2Center (orgid, centerid, NCPDP_NABP) 
select o.orgid, t.centerid, t.NCPDP_NABP  
from (
		select ch.[Organization Name], ch.centerid, ch.NCPDP_NABP
		from ch
		where 1=1
		union
		select ph.[Organization Name], ph.centerid, ph.NCPDP_NABP
		from ph
		where 1=1
) t
join #org o on o.[Organization Name] = t.[Organization Name]
where 1=1



if(object_ID('tempdb..#pharmacy') is not null)
begin
drop table #pharmacy
end

select c.chaincode as chainID
, c.chainnm as ChainName
, p.NCPDP_NABP as [Pharmacy NABP]
,p.centerid
, replace(replace(replace(p.centername, char(9),''),char(10),''), char(13),'') as [Pharmacy Name]
, p.Address1 as [Pharmacy Address]
, p.AddressCity as [Pharmacy City]
, p.AddressState as [Pharmacy State]
, p.AddressPostalCode as [Pharmacy Zip]
into #pharmacy
from outcomesMTM.dbo.pharmacy p 
join #org2Center oc on oc.centerid=p.centerid
left join outcomesMTM.dbo.pharmacychain pc on pc.centerid = p.centerid
left join outcomesMTM.dbo.Chain c on c.chainid = pc.chainid
where  oc.orgID in (select * from dbo.splitstring(@string))





if(object_ID('tempdb..#NeedsRefill') is not null)
begin
drop table #NeedsRefill
end
Select
p.centerid
, 'Needs Refill' as Tiptitle
, isnull(t1.[Total Opportunities], 0) as [Needs Refill Total Opportunities]
, isnull(t1.[Count of Opportunities > 7 days],0) as [Needs Refill Count of Opportunities > 7 days]
, isnull(t1.[Count of Completed TIPs],0) as [Needs Refill Count of Completed TIPs]
, isnull(t1.[Count of Successful TIPs],0) as [Needs Refill Count of Successful TIPs]
, isnull(t1.[Count of Active TIPs],0) as [Needs Refill Count of Active TIPs]
--, isnull(aa.CheckpointCount,0) as [Count of Open Checkpoints]
, isnull(t1.[% Completed],0.00) as [Needs Refill % Completed]
, isnull(t1.[% Success],0.00) as [Needs Refill % Success]
, isnull(t1.[% Net Effective],0.00) as [Needs Refill % Net Effective]
into #NeedsRefill
from outcomesMTM.dbo.pharmacy p 
 join
(
	select t.centerID
	--,t.tiptitle
	, cast(sum(t.[TIP Opportunities]) as decimal) as [Total Opportunities]
	, cast(sum(t.[7dayTip]) as decimal) as [Count of Opportunities > 7 days]
	, cast(sum(t.[Completed TIPs]) as decimal) as [Count of Completed TIPs]
	, cast(sum(t.[Successful TIPs]) as decimal) as [Count of Successful TIPs]
	, cast(sum(t.[currently active]) as decimal) as [Count of Active TIPs]
	, ISNULL(cast((cast(sum(t.[Completed TIPs]) as decimal)*100/NULLIF(cast(sum(t.[7dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[7dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
	from (
		select row_number() over (partition by ta.tipresultstatusID, ta.centerID order by ta.[Completed TIPs] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.tipresultstatuscenterID desc) as [Rank] 
		, ta.*
		, case when ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 7 then 1 else 0 end as [7dayTip]
		from outcomesMTM.dbo.tipActivityCenterReport ta
		join outcomesMTM.dbo.policy po on po.policyID = ta.policyid
		join outcomesMTM.dbo.contract co on co.ContractID = po.contractID
		join outcomesMTM.dbo.client cl on cl.clientID = co.ClientID

		where 1 = 1
		and (ta.primaryPharmacy = 1) -- or ta.[Completed TIPs] = 1)
		and ((year(cast(ta.activeasof as date)) =  year(getdate())) 
            or 
            (year(cast(ta.activethru as date)) = year(getdate())))
		and cl.clientID = 105
		and ta.tipdetailid in (1761,1760,1759)
		--and ta.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
		and ta.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                   --Updated Policies as per TC-2955 :- Santhosh

	) t

	where 1 = 1
	and t.Rank = 1
	group by t.centerID--,t.tiptitle
) t1 on p.centerid = t1.centerid
left join outcomesMTM.dbo.pharmacychain pc on pc.centerid = p.centerid
left join #org2Center oc on oc.centerid=pc.centerid
left join outcomesMTM.dbo.Chain c on c.chainid = pc.chainid
where 1 = 1
and  oc.orgID in (select * from dbo.splitstring(@string))



if(object_ID('tempdb..#Needs90Day') is not null)
begin
drop table #Needs90Day
end
Select
p.centerid
, 'Needs 90 Day Fill' as Tiptitle
, isnull(t1.[Total Opportunities], 0) as [Needs 90 Day Fill Total Opportunities]
, isnull(t1.[Count of Opportunities > 30 days],0) as [Needs 90 Day Fill Count of Opportunities > 30 days]
, isnull(t1.[Count of Completed TIPs],0) as [Needs 90 Day Fill Count of Completed TIPs]
, isnull(t1.[Count of Successful TIPs],0) as [Needs 90 Day Fill Count of Successful TIPs]
, isnull(t1.[Count of Active TIPs],0) as [Needs 90 Day Fill Count of Active TIPs]
--, isnull(aa.CheckpointCount,0) as [Count of Open Checkpoints]
, isnull(t1.[% Completed],0.00) as [Needs 90 Day Fill % Completed]
, isnull(t1.[% Success],0.00) as [Needs 90 Day Fill % Success]
, isnull(t1.[% Net Effective],0.00) as [Needs 90 Day Fill % Net Effective]
into #Needs90Day
from outcomesMTM.dbo.pharmacy p 
 join
(
	select t.centerID
	--,t.tiptitle
	, cast(sum(t.[TIP Opportunities]) as decimal) as [Total Opportunities]
	, cast(sum(t.[30dayTip]) as decimal) as [Count of Opportunities > 30 days]
	, cast(sum(t.[Completed TIPs]) as decimal) as [Count of Completed TIPs]
	, cast(sum(t.[Successful TIPs]) as decimal) as [Count of Successful TIPs]
	, cast(sum(t.[currently active]) as decimal) as [Count of Active TIPs]
	, ISNULL(cast((cast(sum(t.[Completed TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
	from (
		select row_number() over (partition by ta.tipresultstatusID, ta.centerID order by ta.[Completed TIPs] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.tipresultstatuscenterID desc) as [Rank] 
		, ta.*
		, case when ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 30 then 1 else 0 end as [30dayTip]
		from outcomesMTM.dbo.tipActivityCenterReport ta
		join outcomesMTM.dbo.policy po on po.policyID = ta.policyid
		join outcomesMTM.dbo.contract co on co.ContractID = po.contractID
		join outcomesMTM.dbo.client cl on cl.clientID = co.ClientID

		where 1 = 1
		and (ta.primaryPharmacy = 1) -- or ta.[Completed TIPs] = 1)
		and ((year(cast(ta.activeasof as date)) =  year(getdate())) 
            or 
            (year(cast(ta.activethru as date)) = year(getdate())))
		and cl.clientID = 105
		and ta.tipdetailid in (318,319,320,1857,1858,1859)
		--(406,407,408,409,410,411,412,413,414,415,438,439,440,482,483,484,488,489,548,549,553,554,1686,1687,1689,1780,1781,1782,1783,1784,1785,1786,1787,1788)
		--and ta.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
		and ta.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                          --Updated Policies as per TC-2955 :- Santhosh
 
	) t

	where 1 = 1
	and t.Rank = 1
	group by t.centerID--,t.tiptitle
) t1 on p.centerid = t1.centerid
left join outcomesMTM.dbo.pharmacychain pc on pc.centerid = p.centerid
left join #org2Center oc on oc.centerid=pc.centerid
left join outcomesMTM.dbo.Chain c on c.chainid = pc.chainid
where 1 = 1
and  oc.orgID in (select * from dbo.splitstring(@string))


if(object_ID('tempdb..#NeedsDrugTherapyStatinDiabetes') is not null)
begin
drop table #NeedsDrugTherapyStatinDiabetes
end

Select
p.centerid
, 'Needs Drug Therapy -Statin-Diabetes' as Tiptitle
, isnull(t1.[Total Opportunities], 0) as [Needs Drug Therapy - Statin - Diabetes Total Opportunities]
, isnull(t1.[Count of Opportunities > 30 days],0) as [Needs Drug Therapy - Statin - Diabetes Count of Opportunities > 30 days]
, isnull(t1.[Count of Completed TIPs],0) as [Needs Drug Therapy - Statin - Diabetes Count of Completed TIPs]
, isnull(t1.[Count of Successful TIPs],0) as [Needs Drug Therapy - Statin - Diabetes Count of Successful TIPs]
, isnull(t1.[Count of Active TIPs],0) as [Needs Drug Therapy - Statin - Diabetes Count of Active TIPs]
--, isnull(aa.CheckpointCount,0) as [Count of Open Checkpoints]
, isnull(t1.[% Completed],0.00) as [Needs Drug Therapy - Statin - Diabetes % Completed]
, isnull(t1.[% Success],0.00) as [Needs Drug Therapy - Statin - Diabetes % Success]
, isnull(t1.[% Net Effective],0.00) as [Needs Drug Therapy - Statin - Diabetes % Net Effective]
into #NeedsDrugTherapyStatinDiabetes
from outcomesMTM.dbo.pharmacy p 
 join
(
	select t.centerID
	--,t.tiptitle
	, cast(sum(t.[TIP Opportunities]) as decimal) as [Total Opportunities]
	, cast(sum(t.[30dayTip]) as decimal) as [Count of Opportunities > 30 days]
	, cast(sum(t.[Completed TIPs]) as decimal) as [Count of Completed TIPs]
	, cast(sum(t.[Successful TIPs]) as decimal) as [Count of Successful TIPs]
	, cast(sum(t.[currently active]) as decimal) as [Count of Active TIPs]
	, ISNULL(cast((cast(sum(t.[Completed TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
	from (
		select row_number() over (partition by ta.tipresultstatusID, ta.centerID order by ta.[Completed TIPs] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.tipresultstatuscenterID desc) as [Rank] 
		, ta.*
		, case when ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 30 then 1 else 0 end as [30dayTip]
		from outcomesMTM.dbo.tipActivityCenterReport ta
		join outcomesMTM.dbo.policy po on po.policyID = ta.policyid
		join outcomesMTM.dbo.contract co on co.ContractID = po.contractID
		join outcomesMTM.dbo.client cl on cl.clientID = co.ClientID

		where 1 = 1
		and (ta.primaryPharmacy = 1) -- or ta.[Completed TIPs] = 1)
		and ((year(cast(ta.activeasof as date)) =  year(getdate())) 
            or 
            (year(cast(ta.activethru as date)) = year(getdate())))
		and cl.clientID = 105
		and ta.tipdetailid in (650) --(246,244,247)
		--and ta.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
		and ta.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                       --Updated Policies as per TC-2955 :- Santhosh

	) t

	where 1 = 1
	and t.Rank = 1
	group by t.centerID--,t.tiptitle
) t1 on p.centerid = t1.centerid
left join outcomesMTM.dbo.pharmacychain pc on pc.centerid = p.centerid
left join #org2Center oc on oc.centerid=pc.centerid
left join outcomesMTM.dbo.Chain c on c.chainid = pc.chainid
where 1 = 1
and oc.orgID in (select * from dbo.splitstring(@string))


if(object_ID('tempdb..#NeedsDrugTherapyStatinCVD') is not null)
begin
drop table #NeedsDrugTherapyStatinCVD
end

Select
p.centerid
, 'Needs Drug Therapy-Statin-CVD' as Tiptitle
, isnull(t1.[Total Opportunities], 0) as [Needs Drug Therapy - Statin - CVD Total Opportunities]
, isnull(t1.[Count of Opportunities > 30 days],0) as [Needs Drug Therapy - Statin - CVD Count of Opportunities > 30 days]
, isnull(t1.[Count of Completed TIPs],0) as [Needs Drug Therapy - Statin - CVD Count of Completed TIPs]
, isnull(t1.[Count of Successful TIPs],0) as [Needs Drug Therapy - Statin - CVD Count of Successful TIPs]
, isnull(t1.[Count of Active TIPs],0) as [Needs Drug Therapy - Statin - CVD Count of Active TIPs]
--, isnull(aa.CheckpointCount,0) as [Count of Open Checkpoints]
, isnull(t1.[% Completed],0.00) as [Needs Drug Therapy - Statin - CVD % Completed]
, isnull(t1.[% Success],0.00) as [Needs Drug Therapy - Statin - CVD % Success]
, isnull(t1.[% Net Effective],0.00) as [Needs Drug Therapy - Statin - CVD % Net Effective]
into #NeedsDrugTherapyStatinCVD
from outcomesMTM.dbo.pharmacy p 
 join
(
	select t.centerID
	--,t.tiptitle
	, cast(sum(t.[TIP Opportunities]) as decimal) as [Total Opportunities]
	, cast(sum(t.[30dayTip]) as decimal) as [Count of Opportunities > 30 days]
	, cast(sum(t.[Completed TIPs]) as decimal) as [Count of Completed TIPs]
	, cast(sum(t.[Successful TIPs]) as decimal) as [Count of Successful TIPs]
	, cast(sum(t.[currently active]) as decimal) as [Count of Active TIPs]
	, ISNULL(cast((cast(sum(t.[Completed TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
	from (
		select row_number() over (partition by ta.tipresultstatusID, ta.centerID order by ta.[Completed TIPs] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.tipresultstatuscenterID desc) as [Rank] 
		, ta.*
		, case when ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 30 then 1 else 0 end as [30dayTip]
		from outcomesMTM.dbo.tipActivityCenterReport ta
		join outcomesMTM.dbo.policy po on po.policyID = ta.policyid
		join outcomesMTM.dbo.contract co on co.ContractID = po.contractID
		join outcomesMTM.dbo.client cl on cl.clientID = co.ClientID

		where 1 = 1
		and (ta.primaryPharmacy = 1) -- or ta.[Completed TIPs] = 1)
		and ((year(cast(ta.activeasof as date)) =  year(getdate())) 
            or 
            (year(cast(ta.activethru as date)) = year(getdate())))
		and cl.clientID = 105
		and ta.tipdetailid in (1901) 
		--and ta.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
		and ta.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                     --Updated Policies as per TC-2955 :- Santhosh

	) t

	where 1 = 1
	and t.Rank = 1
	group by t.centerID--,t.tiptitle
) t1 on p.centerid = t1.centerid
left join outcomesMTM.dbo.pharmacychain pc on pc.centerid = p.centerid
left join #org2Center oc on oc.centerid=pc.centerid
left join outcomesMTM.dbo.Chain c on c.chainid = pc.chainid
where 1 = 1
and oc.orgID in (select * from dbo.splitstring(@string))



if(object_ID('tempdb..#SuboptimalDrug') is not null)
begin
drop table #SuboptimalDrug
end

Select
p.centerid
, 'Suboptimal Drug - Low-Intensity Statin - CVD' as Tiptitle
, isnull(t1.[Total Opportunities], 0) as [Suboptimal Drug - Low-Intensity Statin - CVD Total Opportunities]
, isnull(t1.[Count of Opportunities > 30 days],0) as [Suboptimal Drug - Low-Intensity Statin - CVD Count of Opportunities > 30 days]
, isnull(t1.[Count of Completed TIPs],0) as [Suboptimal Drug - Low-Intensity Statin - CVD Count of Completed TIPs]
, isnull(t1.[Count of Successful TIPs],0) as [Suboptimal Drug - Low-Intensity Statin - CVD Count of Successful TIPs]
, isnull(t1.[Count of Active TIPs],0) as [Suboptimal Drug - Low-Intensity Statin - CVD Count of Active TIPs]
--, isnull(aa.CheckpointCount,0) as [Count of Open Checkpoints]
, isnull(t1.[% Completed],0.00) as [Suboptimal Drug - Low-Intensity Statin - CVD % Completed]
, isnull(t1.[% Success],0.00) as [Suboptimal Drug - Low-Intensity Statin - CVD % Success]
, isnull(t1.[% Net Effective],0.00) as [Suboptimal Drug - Low-Intensity Statin - CVD % Net Effective]
into #SuboptimalDrug
from outcomesMTM.dbo.pharmacy p 
 join
(
	select t.centerID
	--,t.tiptitle
	, cast(sum(t.[TIP Opportunities]) as decimal) as [Total Opportunities]
	, cast(sum(t.[30dayTip]) as decimal) as [Count of Opportunities > 30 days]
	, cast(sum(t.[Completed TIPs]) as decimal) as [Count of Completed TIPs]
	, cast(sum(t.[Successful TIPs]) as decimal) as [Count of Successful TIPs]
	, cast(sum(t.[currently active]) as decimal) as [Count of Active TIPs]
	, ISNULL(cast((cast(sum(t.[Completed TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
	from (
		select row_number() over (partition by ta.tipresultstatusID, ta.centerID order by ta.[Completed TIPs] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.tipresultstatuscenterID desc) as [Rank] 
		, ta.*
		, case when ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 30 then 1 else 0 end as [30dayTip]
		from outcomesMTM.dbo.tipActivityCenterReport ta
		join outcomesMTM.dbo.policy po on po.policyID = ta.policyid
		join outcomesMTM.dbo.contract co on co.ContractID = po.contractID
		join outcomesMTM.dbo.client cl on cl.clientID = co.ClientID

		where 1 = 1
		and (ta.primaryPharmacy = 1) -- or ta.[Completed TIPs] = 1)
		and ((year(cast(ta.activeasof as date)) =  year(getdate())) 
            or 
            (year(cast(ta.activethru as date)) = year(getdate())))
		and cl.clientID = 105
		and ta.tipdetailid in (1904) 
		--and ta.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
		and ta.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                           --Updated Policies as per TC-2955 :- Santhosh

	) t

	where 1 = 1
	and t.Rank = 1
	group by t.centerID--,t.tiptitle
) t1 on p.centerid = t1.centerid
left join outcomesMTM.dbo.pharmacychain pc on pc.centerid = p.centerid
left join #org2Center oc on oc.centerid=pc.centerid
left join outcomesMTM.dbo.Chain c on c.chainid = pc.chainid
where 1 = 1
and oc.orgID in (select * from dbo.splitstring(@string))



if(object_ID('tempdb..#NeedsMedSync') is not null)
begin
drop table #NeedsMedSync
end

Select
p.centerid
, 'Needs Medication Synchronization' as Tiptitle
, isnull(t1.[Total Opportunities], 0) as [Needs Medication Synchronization Total Opportunities]
, isnull(t1.[Count of Opportunities > 30 days],0) as [Needs Medication Synchronization Count of Opportunities > 30 days]
, isnull(t1.[Count of Completed TIPs],0) as [Needs Medication Synchronization Count of Completed TIPs]
, isnull(t1.[Count of Successful TIPs],0) as [Needs Medication Synchronization Count of Successful TIPs]
, isnull(t1.[Count of Active TIPs],0) as [Needs Medication Synchronization Count of Active TIPs]
--, isnull(aa.CheckpointCount,0) as [Count of Open Checkpoints]
, isnull(t1.[% Completed],0.00) as [Needs Medication Synchronization % Completed]
, isnull(t1.[% Success],0.00) as [Needs Medication Synchronization % Success]
, isnull(t1.[% Net Effective],0.00) as [Needs Medication Synchronization % Net Effective]
into #NeedsMedSync
from outcomesMTM.dbo.pharmacy p 
 join
(
	select t.centerID
	--,t.tiptitle
	, cast(sum(t.[TIP Opportunities]) as decimal) as [Total Opportunities]
	, cast(sum(t.[30dayTip]) as decimal) as [Count of Opportunities > 30 days]
	, cast(sum(t.[Completed TIPs]) as decimal) as [Count of Completed TIPs]
	, cast(sum(t.[Successful TIPs]) as decimal) as [Count of Successful TIPs]
	, cast(sum(t.[currently active]) as decimal) as [Count of Active TIPs]
	, ISNULL(cast((cast(sum(t.[Completed TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
	from (
		select row_number() over (partition by ta.tipresultstatusID, ta.centerID order by ta.[Completed TIPs] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.tipresultstatuscenterID desc) as [Rank] 
		, ta.*
		, case when ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 30 then 1 else 0 end as [30dayTip]
		from outcomesMTM.dbo.tipActivityCenterReport ta
		join outcomesMTM.dbo.policy po on po.policyID = ta.policyid
		join outcomesMTM.dbo.contract co on co.ContractID = po.contractID
		join outcomesMTM.dbo.client cl on cl.clientID = co.ClientID

		where 1 = 1
		and (ta.primaryPharmacy = 1) -- or ta.[Completed TIPs] = 1)
		and ((year(cast(ta.activeasof as date)) =  year(getdate())) 
            or 
            (year(cast(ta.activethru as date)) = year(getdate())))
		and cl.clientID = 105
		and ta.tipdetailid in (1768)
		--and ta.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
		and ta.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                                    --Updated Policies as per TC-2955 :- Santhosh

	) t

	where 1 = 1
	and t.Rank = 1
	group by t.centerID--,t.tiptitle
) t1 on p.centerid = t1.centerid
-- left join (
			-- select amq.centerID, count(amq.AdherenceMonitorQueueID) as CheckpointCount
			-- FROM outcomesMTM.dbo.AdherenceMonitorQueue amq with(nolock) 
			-- JOIN outcomesMTM.dbo.AdherenceMonitor am with(nolock) on am.AdherenceMonitorID = amq.AdherenceMonitorID
			-- join outcomesMTM.dbo.patientDim pd with(nolock) on pd.PatientID = am.PatientID
			-- join outcomesMTM.dbo.Policy po with(nolock) on po.policyID = pd.PolicyID
			-- join outcomesMTM.dbo.Contract co with(nolock) on co.contractID = po.contractID
			-- join outcomesMTM.dbo.Client cl with(nolock) on cl.clientID = co.clientID
			-- join outcomesMTM.dbo.pharmacy ph on ph.centerID = amq.centerID
			-- join outcomesMTM.dbo.pharmacychain pc on pc.centerid = ph.centerID
			-- join outcomesMTM.dbo.chain ch on ch.chainid = pc.chainid
			-- WHERE 1=1
			-- and amq.AdherenceMonitorQueueStatusID = 1
			-- AND cast(getdate() as date) between amq.QueueStart and amq.QueueEnd
			-- and pd.isCurrent = 1
			-- and cl.clientID = 105
			-- GROUP BY amq.centerID
-- ) aa on aa.centerID = p.centerID
left join outcomesMTM.dbo.pharmacychain pc on pc.centerid = p.centerid
left join #org2Center oc on oc.centerid=pc.centerid
left join outcomesMTM.dbo.Chain c on c.chainid = pc.chainid
where 1 = 1
and oc.orgID in (select * from dbo.splitstring(@string))



if(object_ID('tempdb..#AdherenceMonitoring') is not null)
begin
drop table #AdherenceMonitoring
end

Select
p.centerid
, 'Adherence Monitoring' as Tiptitle
, isnull(t1.[Total Opportunities], 0) as [Adherence Monitoring Total Opportunities]
, isnull(t1.[Count of Opportunities > 30 days],0) as [Adherence Monitoring Count of Opportunities > 30 days]
, isnull(t1.[Count of Completed TIPs],0) as [Adherence Monitoring Count of Completed TIPs]
, isnull(t1.[Count of Successful TIPs],0) as[Adherence Monitoring Count of Successful TIPs]
, isnull(t1.[Count of Active TIPs],0) as [Adherence Monitoring Count of Active TIPs]
, isnull(aa.CheckpointCount,0) as [Adherence Monitoring # of Open Checkpoints]
, isnull(t1.[% Completed],0.00) as [Adherence Monitoring % Completed]
, isnull(t1.[% Success],0.00) as [Adherence Monitoring % Success]
, isnull(t1.[% Net Effective],0.00) as [Adherence Monitoring % Net Effective]
into #AdherenceMonitoring
from outcomesMTM.dbo.pharmacy p 
 join
(
	select t.centerID
	--,t.tiptitle
	, cast(sum(t.[TIP Opportunities]) as decimal) as [Total Opportunities]
	, cast(sum(t.[30dayTip]) as decimal) as [Count of Opportunities > 30 days]
	, cast(sum(t.[Completed TIPs]) as decimal) as [Count of Completed TIPs]
	, cast(sum(t.[Successful TIPs]) as decimal) as [Count of Successful TIPs]
	, cast(sum(t.[currently active]) as decimal) as [Count of Active TIPs]
	, ISNULL(cast((cast(sum(t.[Completed TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
	, ISNULL(cast((cast(sum(t.[Successful TIPs]) as decimal)*100/NULLIF(cast(sum(t.[30dayTip]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
	from (
		select row_number() over (partition by ta.tipresultstatusID, ta.centerID order by ta.[Completed TIPs] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.tipresultstatuscenterID desc) as [Rank] 
		, ta.*
		, case when ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 30 then 1 else 0 end as [30dayTip]
		from outcomesMTM.dbo.tipActivityCenterReport ta
		join outcomesMTM.dbo.policy po on po.policyID = ta.policyid
		join outcomesMTM.dbo.contract co on co.ContractID = po.contractID
		join outcomesMTM.dbo.client cl on cl.clientID = co.ClientID

		where 1 = 1
		and (ta.primaryPharmacy = 1) -- or ta.[Completed TIPs] = 1)
		and ((year(cast(ta.activeasof as date)) =  year(getdate())) 
            or 
            (year(cast(ta.activethru as date)) = year(getdate())))
		and cl.clientID = 105
		and ta.tipdetailid in (393,394,395)
		--and ta.policyID in (761,583,667,616,733,582,763,413,414,415,501,416)
		and ta.policyid IN('998','940','941','958','962','965','973','974','982','988','1001','1004','1009','1010','977','1005','956','957','959','960','961','963'
,'964','966','967','968','969','970','971','976','978','979','980','981','983','984','985','986','987','989','990','991','992','993','994'
,'995','996','997','999','1000','1002','1003','1006','1007','1008','975','1011','1012','1013','1014','1015','972')                                                              --Updated Policies as per TC-2955 :- Santhosh

	) t

	where 1 = 1
	and t.Rank = 1
	group by t.centerID--,t.tiptitle
) t1 on p.centerid = t1.centerid
left join (
			select amq.centerID, count(amq.AdherenceMonitorQueueID) as CheckpointCount
			FROM outcomesMTM.dbo.AdherenceMonitorQueue amq with(nolock) 
			JOIN outcomesMTM.dbo.AdherenceMonitor am with(nolock) on am.AdherenceMonitorID = amq.AdherenceMonitorID
			join outcomesMTM.dbo.patientDim pd with(nolock) on pd.PatientID = am.PatientID
			join outcomesMTM.dbo.Policy po with(nolock) on po.policyID = pd.PolicyID
			join outcomesMTM.dbo.Contract co with(nolock) on co.contractID = po.contractID
			join outcomesMTM.dbo.Client cl with(nolock) on cl.clientID = co.clientID
			join outcomesMTM.dbo.pharmacy ph on ph.centerID = amq.centerID
			join outcomesMTM.dbo.pharmacychain pc on pc.centerid = ph.centerID
			join outcomesMTM.dbo.chain ch on ch.chainid = pc.chainid
			WHERE 1=1
			and amq.AdherenceMonitorQueueStatusID = 1
			AND cast(getdate() as date) between amq.QueueStart and amq.QueueEnd
			and pd.isCurrent = 1
			and cl.clientID = 105
			GROUP BY amq.centerID
) aa on aa.centerID = p.centerID
left join outcomesMTM.dbo.pharmacychain pc on pc.centerid = p.centerid
left join #org2Center oc on oc.centerid=pc.centerid
left join outcomesMTM.dbo.Chain c on c.chainid = pc.chainid
where 1 = 1
and oc.orgID in (select * from dbo.splitstring(@string))




Truncate table  [dbo].[UHC_RetailerKey_PharmacyTIPs_30] 
Insert into  [dbo].[UHC_RetailerKey_PharmacyTIPs_30] 
([ChainID],
[ChainName],
[Pharmacy NABP],
[CenterId],
[Pharmacy Name],
[Pharmacy Address],
[Pharmacy City],
[Pharmacy State],
[Pharmacy Zip],
[Needs Medication Synchronization],
[Needs Medication Synchronization Total Opportunities],
[Needs Medication Synchronization Count of Opportunities > 30 days],
[Needs Medication Synchronization Count of Completed TIPs],
[Needs Medication Synchronization Count of Successful TIPs],
[Needs Medication Synchronization Count of Active TIPs],
[Needs Medication Synchronization % Completed],
[Needs Medication Synchronization % Success],
[Needs Medication Synchronization % Net Effective],
[Adherence Monitoring],
[Adherence Monitoring Total Opportunities],
[Adherence Monitoring Count of Opportunities > 30 days],
[Adherence Monitoring Count of Completed TIPs],
[Adherence Monitoring Count of Successful TIPs],
[Adherence Monitoring Count of Active TIPs],
[Adherence Monitoring # of Open Checkpoints],
[Adherence Monitoring % Completed],
[Adherence Monitoring % Success],
[Adherence Monitoring % Net Effective],
[Needs 90 Day Fill],
[Needs 90 Day Fill Total Opportunities],
[Needs 90 Day Fill Count of Opportunities > 30 days],
[Needs 90 Day Fill Count of Completed TIPs],
[Needs 90 Day Fill Count of Successful TIPs],
[Needs 90 Day Fill Count of Active TIPs],
[Needs 90 Day Fill % Completed],
[Needs 90 Day Fill % Success],
[Needs 90 Day Fill % Net Effective],
[Needs Drug Therapy - Statin - CVD],
[Needs Drug Therapy - Statin - CVD Total Opportunities],
[Needs Drug Therapy - Statin - CVD Count of Opportunities > 30 days],
[Needs Drug Therapy - Statin - CVD Count of Completed TIPs],
[Needs Drug Therapy - Statin - CVD Count of Successful TIPs],
[Needs Drug Therapy - Statin - CVD Count of Active TIPs],
[Needs Drug Therapy - Statin - CVD % Completed],
[Needs Drug Therapy - Statin - CVD % Success],
[Needs Drug Therapy - Statin - CVD % Net Effective],
[Needs Drug Therapy - Statin - Diabetes],
[Needs Drug Therapy - Statin - Diabetes Total Opportunities],
[Needs Drug Therapy - Statin - Diabetes Count of Opportunities > 30 days],
[Needs Drug Therapy - Statin - Diabetes Count of Completed TIPs],
[Needs Drug Therapy - Statin - Diabetes Count of Successful TIPs],
[Needs Drug Therapy - Statin - Diabetes Count of Active TIPs],
[Needs Drug Therapy - Statin - Diabetes % Completed],
[Needs Drug Therapy - Statin - Diabetes % Success],
[Needs Drug Therapy - Statin - Diabetes % Net Effective],
[Needs Refill],
[Needs Refill Total Opportunities],
[Needs Refill Count of Opportunities > 7 days],
[Needs Refill Count of Completed TIPs],
[Needs Refill Count of Successful TIPs],
[Needs Refill Count of Active TIPs],
[Needs Refill % Completed],
[Needs Refill % Success],
[Needs Refill % Net Effective],
[Suboptimal Drug - Low-Intensity Statin - CVD],
[Suboptimal Drug - Low-Intensity Statin - CVD Total Opportunities],
[Suboptimal Drug - Low-Intensity Statin - CVD Count of Opportunities > 30 days],
[Suboptimal Drug - Low-Intensity Statin - CVD Count of Completed TIPs],
[Suboptimal Drug - Low-Intensity Statin - CVD Count of Successful TIPs],
[Suboptimal Drug - Low-Intensity Statin - CVD Count of Active TIPs],
[Suboptimal Drug - Low-Intensity Statin - CVD % Completed],
[Suboptimal Drug - Low-Intensity Statin - CVD % Success],
[Suboptimal Drug - Low-Intensity Statin - CVD % Net Effective]

)
select 
 cast(p.chainID as nvarchar(50)) as ChainID
,cast(p.ChainName as nvarchar(200)) as ChainName
,cast(p.[Pharmacy NABP] as nvarchar(50)) as [Pharmacy NABP]
,p.centerid as CenterId
,cast(p.[Pharmacy Name] as nvarchar(255)) as [Pharmacy Name]
,cast(p.[Pharmacy Address] as nvarchar(255)) as [Pharmacy Address]
,cast(p.[Pharmacy City] as nvarchar(100)) as  [Pharmacy City]
,cast(p.[Pharmacy State] as nvarchar(100)) as [Pharmacy State]
,cast(p.[Pharmacy Zip] as nvarchar(100)) as  [Pharmacy Zip] 

, isnull(NMS.tiptitle,'Needs Medication Synchronization') as [Needs Medication Synchronization]
, isnull(NMS.[Needs Medication Synchronization Total Opportunities],0) as [Needs Medication Synchronization Total Opportunities]
, isnull(NMS.[Needs Medication Synchronization Count of Opportunities > 30 days],0) as [Needs Medication Synchronization Count of Opportunities > 30 days]
, isnull(NMS.[Needs Medication Synchronization Count of Completed TIPs],0) as [Needs Medication Synchronization Count of Completed TIPs]
, isnull(NMS.[Needs Medication Synchronization Count of Successful TIPs],0) as [Needs Medication Synchronization Count of Successful TIPs]
, isnull(NMS.[Needs Medication Synchronization Count of Active TIPs],0) as [Needs Medication Synchronization Count of Active TIPs]
, isnull(cast(NMS.[Needs Medication Synchronization % Completed] as decimal(5,2)),0.00) as [Needs Medication Synchronization % Completed]
, isnull(cast(NMS.[Needs Medication Synchronization % Success] as decimal (5,2)) ,0.00) as [Needs Medication Synchronization % Success]
, isnull(cast(NMS.[Needs Medication Synchronization % Net Effective] as decimal(5,2)),0.00) as  [Needs Medication Synchronization % Net Effective]

, isNull(AM.tiptitle,'Adherence Monitoring') as [Adherence Monitoring]
, isnull(AM.[Adherence Monitoring Total Opportunities], 0) as [Adherence Monitoring Total Opportunities]
, isnull(AM.[Adherence Monitoring Count of Opportunities > 30 days],0) as [Adherence Monitoring Count of Opportunities > 30 days]
, isnull(AM.[Adherence Monitoring Count of Completed TIPs],0) as [Adherence Monitoring Count of Completed TIPs]
, isnull(AM.[Adherence Monitoring Count of Successful TIPs],0) as [Adherence Monitoring Count of Successful TIPs]
, isnull(AM.[Adherence Monitoring Count of Active TIPs],0) as [Adherence Monitoring Count of Active TIPs]
, isnull(cast(AM.[Adherence Monitoring # of Open Checkpoints] as int),0) as [Adherence Monitoring # of Open Checkpoints]
, isnull(cast(AM.[Adherence Monitoring % Completed] as decimal(5,2)),0.00) as [Adherence Monitoring % Completed]
, isnull(cast(AM.[Adherence Monitoring % Success] as decimal (5,2)) ,0.00) as [Adherence Monitoring % Success]
, isnull(cast(AM.[Adherence Monitoring % Net Effective] as decimal(5,2)),0.00) as  [Adherence Monitoring % Net Effective]

, isNull(NND.tiptitle,'Needs 90 Day Fill') as [Needs 90 Day Fill]
, isnull(NND.[Needs 90 Day Fill Total Opportunities], 0) as [Needs 90 Day Fill Total Opportunities]
, isnull(NND.[Needs 90 Day Fill Count of Opportunities > 30 days],0) as [Needs 90 Day Fill Count of Opportunities > 30 days]
, isnull(NND.[Needs 90 Day Fill Count of Completed TIPs],0) as [Needs 90 Day Fill Count of Completed TIPs]
, isnull(NND.[Needs 90 Day Fill Count of Successful TIPs],0) as [Needs 90 Day Fill Count of Successful TIPs]
, isnull(NND.[Needs 90 Day Fill Count of Active TIPs],0) as [Needs 90 Day Fill Count of Active TIPs]
, isnull(cast(NND.[Needs 90 Day Fill % Completed] as decimal(5,2)),0.00) as [Needs 90 Day Fill % Completed]
, isnull(cast(NND.[Needs 90 Day Fill % Success] as decimal (5,2)) ,0.00) as [Needs 90 Day Fill % Success]
, isnull(cast(NND.[Needs 90 Day Fill % Net Effective] as decimal(5,2)),0.00) as  [Needs 90 Day Fill % Net Effective]

, isNull(NDTSC.tiptitle,'Needs Drug Therapy-Statin-CVD') as [Needs Drug Therapy - Statin - CVD]
, isnull(NDTSC.[Needs Drug Therapy - Statin - CVD Total Opportunities], 0) as [Needs Drug Therapy - Statin - CVD Total Opportunities]
, isnull(NDTSC.[Needs Drug Therapy - Statin - CVD Count of Opportunities > 30 days],0) as [Needs Drug Therapy - Statin - CVD Count of Opportunities > 30 days]
, isnull(NDTSC.[Needs Drug Therapy - Statin - CVD Count of Completed TIPs],0) as [Needs Drug Therapy - Statin - CVD Count of Completed TIPs]
, isnull(NDTSC.[Needs Drug Therapy - Statin - CVD Count of Successful TIPs],0) as [Needs Drug Therapy - Statin - CVD Count of Successful TIPs]
, isnull(NDTSC.[Needs Drug Therapy - Statin - CVD Count of Active TIPs],0) as [Needs Drug Therapy - Statin - CVD Count of Active TIPs]
, isnull(cast(NDTSC.[Needs Drug Therapy - Statin - CVD % Completed] as decimal(5,2)),0.00) as [Needs Drug Therapy - Statin - CVD % Completed]
, isnull(cast(NDTSC.[Needs Drug Therapy - Statin - CVD % Success] as decimal (5,2)) ,0.00) as [Needs Drug Therapy - Statin - CVD % Success]
, isnull(cast(NDTSC.[Needs Drug Therapy - Statin - CVD % Net Effective] as decimal(5,2)),0.00) as  [Needs Drug Therapy - Statin - CVD % Net Effective]

, isNull(NDTSD.tiptitle,'Needs Drug Therapy -Statin-Diabetes') as [Needs Drug Therapy - Statin - Diabetes]
, isnull(NDTSD.[Needs Drug Therapy - Statin - Diabetes Total Opportunities], 0) as [Needs Drug Therapy - Statin - Diabetes Total Opportunities]
, isnull(NDTSD.[Needs Drug Therapy - Statin - Diabetes Count of Opportunities > 30 days],0) as [Needs Drug Therapy - Statin - Diabetes Count of Opportunities > 30 days]
, isnull(NDTSD.[Needs Drug Therapy - Statin - Diabetes Count of Completed TIPs],0) as [Needs Drug Therapy - Statin - Diabetes Count of Completed TIPs]
, isnull(NDTSD.[Needs Drug Therapy - Statin - Diabetes Count of Successful TIPs],0) as [Needs Drug Therapy - Statin - Diabetes Count of Successful TIPs]
, isnull(NDTSD.[Needs Drug Therapy - Statin - Diabetes Count of Active TIPs],0) as [Needs Drug Therapy - Statin - Diabetes Count of Active TIPs]
, isnull(cast(NDTSD.[Needs Drug Therapy - Statin - Diabetes % Completed] as decimal(5,2)),0.00) as [Needs Drug Therapy - Statin - Diabetes % Completed]
, isnull(cast(NDTSD.[Needs Drug Therapy - Statin - Diabetes % Success] as decimal (5,2)) ,0.00) as [Needs Drug Therapy - Statin - Diabetes % Success]
, isnull(cast(NDTSD.[Needs Drug Therapy - Statin - Diabetes % Net Effective] as decimal(5,2)),0.00) as  [Needs Drug Therapy - Statin - Diabetes % Net Effective]

, isNull(NR.tiptitle,'Needs Refill') as [Needs Refill]
, isnull(NR.[Needs Refill Total Opportunities], 0) as [Needs Refill Total Opportunities]
, isnull(NR.[Needs Refill Count of Opportunities > 7 days],0) as [Needs Refill Count of Opportunities > 7 days]
, isnull(NR.[Needs Refill Count of Completed TIPs],0) as [Needs Refill Count of Completed TIPs]
, isnull(NR.[Needs Refill Count of Successful TIPs],0) as [Needs Refill Count of Successful TIPs]
, isnull(NR.[Needs Refill Count of Active TIPs],0) as [Needs Refill Count of Active TIPs]
, isnull(cast(NR.[Needs Refill % Completed] as decimal(5,2)),0.00) as [Needs Refill % Completed]
, isnull(cast(NR.[Needs Refill % Success] as decimal (5,2)) ,0.00) as [Needs Refill % Success]
, isnull(cast(NR.[Needs Refill % Net Effective] as decimal(5,2)),0.00) as  [Needs Refill % Net Effective]

, isNull(SD.tiptitle,'Suboptimal Drug - Low-Intensity Statin - CVD') as [Suboptimal Drug - Low-Intensity Statin - CVD]
, isnull(SD.[Suboptimal Drug - Low-Intensity Statin - CVD Total Opportunities], 0) as [Suboptimal Drug - Low-Intensity Statin - CVD Total Opportunities]
, isnull(SD.[Suboptimal Drug - Low-Intensity Statin - CVD Count of Opportunities > 30 days],0) as [Suboptimal Drug - Low-Intensity Statin - CVD Count of Opportunities > 30 days]
, isnull(SD.[Suboptimal Drug - Low-Intensity Statin - CVD Count of Completed TIPs],0) as [Suboptimal Drug - Low-Intensity Statin - CVD Count of Completed TIPs]
, isnull(SD.[Suboptimal Drug - Low-Intensity Statin - CVD Count of Successful TIPs],0) as [Suboptimal Drug - Low-Intensity Statin - CVD Count of Successful TIPs]
, isnull(SD.[Suboptimal Drug - Low-Intensity Statin - CVD Count of Active TIPs],0) as [Suboptimal Drug - Low-Intensity Statin - CVD Count of Active TIPs]
, isnull(cast(SD.[Suboptimal Drug - Low-Intensity Statin - CVD % Completed] as decimal(5,2)),0.00) as [Suboptimal Drug - Low-Intensity Statin - CVD % Completed]
, isnull(cast(SD.[Suboptimal Drug - Low-Intensity Statin - CVD % Success] as decimal (5,2)) ,0.00) as [Suboptimal Drug - Low-Intensity Statin - CVD % Success]
, isnull(cast(SD.[Suboptimal Drug - Low-Intensity Statin - CVD % Net Effective] as decimal(5,2)),0.00) as  [Suboptimal Drug - Low-Intensity Statin - CVD % Net Effective]
from #pharmacy p
left join #NeedsMedSync NMS on NMS.centerid=p.centerid
left join #AdherenceMonitoring AM on AM.centerid=p.centerid
left join #Needs90Day NND on NND.centerid = p.centerid
left join #NeedsDrugTherapyStatinCVD NDTSC on NDTSC.centerid=p.centerid
left join #NeedsDrugTherapyStatinDiabetes NDTSD on NDTSD.centerid=p.centerid 
left join #NeedsRefill NR on NR.centerid=p.centerid
left join #SuboptimalDrug SD on SD.centerid=p.centerid


END

--select * from  [dbo].[UHC_RetailerKey_PharmacyTIPs_30]  where centerid =40030
--select * from #Needs90Day


