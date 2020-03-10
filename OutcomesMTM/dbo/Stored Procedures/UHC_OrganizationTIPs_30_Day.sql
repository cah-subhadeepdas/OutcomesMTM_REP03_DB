


CREATE proc [dbo].[UHC_OrganizationTIPs_30_Day] 
@clientid varchar(max) 
, @policyids varchar(max) = NULL
as 
begin 

if (object_id('tempdb..#UHCOrganizationTips') is not null)
begin
drop table #UHCOrganizationTips
end
create table #UHCOrganizationTips (
[Week #] int
, [File Delivery Date] date
, [Organization Category Size] int
, [Organization Name] varchar(100)
, [TIP Type] varchar(100)
, [Total Opportunities] int
, [Count of Opportunities w/ Aging Criteria] int
, [Count of Completed TIPs] int
, [Count of Successful TIPs] int
, [Count of Active TIPs] int
, [% Completed] decimal (5,2)
, [% Success] decimal (5,2)
, [% Net Effective] decimal (5,4)
, [Count of Validation] int
, [Count of Validated Claims] int
, [Count of Payable Claims] int
, [Count of Processed Claims] int)

;with v as (
       select  t.tiptypeNM as [TIP Type]
			 , o.[Organization Category Size]
             , o.[Organization Name]
       from outcomesMTM.dbo.UHC_TipType t 
       , outcomesMTM.dbo.UHC_OrganizationRollup o 
)
, o as (
select datepart(week, getdate()) as [Week #]
, cast(getdate() as date) as [File Delivery Date]
, t1.[Organization Category Size]
, t1.[Organization Name]
, t1.tiptypeNM as [TIP Type]
, cast(sum(t1.[Total Opportunities]) as decimal) as [Total Opportunities]
, cast(sum(t1.[Count of Opportunities w/ Aging Criteria]) as decimal) as [Count of Opportunities w/ Aging Criteria]
, cast(sum(t1.[Count of Completed TIPs]) as decimal) as [Count of Completed TIPs]
, cast(sum(t1.[Count of Successful TIPs]) as decimal) as [Count of Successful TIPs]
, cast(sum(t1.[Count of Active TIPs]) as decimal) as [Count of Active TIPs]
, ISNULL(cast((cast(sum(t1.[Count of Completed TIPs]) as decimal)/NULLIF(cast(sum(t1.[Count of Opportunities w/ Aging Criteria]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
, ISNULL(cast((cast(sum(t1.[Count of Successful TIPs]) as decimal)/NULLIF(cast(sum(t1.[Count of Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
, ISNULL(cast((cast(sum(t1.[Count of Successful TIPs]) as decimal)/NULLIF(cast(sum(t1.[Count of Opportunities w/ Aging Criteria]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
-- select *
from(
       select t.centerID
       , t.tiptypeNM
	   , [Organization Category Size]
       , o.[Organization Name]
       , cast(sum(t.[TIP Opportunities]) as decimal) as [Total Opportunities]
       , cast(sum(t.[Aging Criteria]) as decimal) as [Count of Opportunities w/ Aging Criteria]
       , cast(sum(t.[Completed TIPs]) as decimal) as [Count of Completed TIPs]
       , cast(sum(t.[Successful TIPs]) as decimal) as [Count of Successful TIPs]
       , cast(sum(t.[currently active]) as decimal) as [Count of Active TIPs]
       from (
              select row_number() over (partition by oc.orgID, ta.tipresultstatusID order by ta.[Completed TIPs] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.tipresultstatuscenterID desc) as [Rank] 
              , ta.*
			  , case when ta.tipdetailid not in (1759, 1760, 1761) and (ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 30) then 1 else 0 end as [30dayTip]
              , case when ta.tipdetailid in (1759, 1760, 1761) and (ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 7) then 1 else 0 end as [7dayTip]
			  , case when (ta.tipdetailid not in (1759, 1760, 1761) and (ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 30))
						or (ta.tipdetailid in (1759, 1760, 1761) and (ta.[TIP Activity] = 1 or datediff(day,ta.activeasof,ta.activethru) >= 7))
						then 1 else 0 end as [Aging Criteria]
              , oc.orgid 
              , tdt.TipTypeNM
              from outcomesMTM.dbo.tipActivityCenterReport ta
              join outcomesMTM.[dbo].[vw_UHC_Org2CenterRollup] oc on oc.centerid = ta.centerid
              join (
                                  select td.tipdetailID, tt.TipTypeID, tt.TipTypeNM
                    from outcomesMTM.dbo.UHC_TipDetail td
                    join outcomesMTM.dbo.UHC_TipType tt on tt.TipTypeID = td.tipTypeID
                    where 1=1 
                       ) tdt on tdt.tipdetailID = ta.tipdetailid
              join outcomesMTM.dbo.policy po on po.policyID = ta.policyid
			  join outcomesMTM.dbo.contract co on co.ContractID = po.contractID
			  join outcomesMTM.dbo.client cl on cl.clientID = co.ClientID
			  where 1 = 1
              and (ta.primaryPharmacy = 1 or ta.[Completed TIPs] = 1)
              and ((year(cast(ta.activeasof as date)) = year(getdate())) 
                             or 
                              (year(cast(ta.activethru as date)) = year(getdate())))
              and (exists(select 1
						  from STRING_SPLIT(@clientid, ',') 
						  where 1=1
								and [value] = cl.clientid)
				  or exists(select 1
						    from STRING_SPLIT(@policyids, ',') 
						    where 1=1
								 and [value] = po.policyid))			
       ) t
       join outcomesMTM.dbo.UHC_OrganizationRollup o on o.orgid = t.orgid 
       where 1 = 1
       and t.Rank = 1
       group by t.centerID, t.tiptypeNM, o.[Organization Category Size], o.[Organization Name]
) t1
join outcomesMTM.dbo.pharmacy p on p.centerid = t1.centerid
left join outcomesMTM.dbo.pharmacychain pc on pc.centerid = p.centerid
left join outcomesMTM.dbo.Chain c on c.chainid = pc.chainid
where 1 = 1
group by t1.[Organization Category Size], t1.[Organization Name]
, t1.tiptypeNM
)
, oo as (
select datepart(week, getdate()) as [Week #]
, cast(getdate() as date) as [File Delivery Date]
, t1.[Organization Category Size]
, t1.[Organization Name]
, t1.tiptypeNM as [TIP Type]
, cast(sum(t1.[Count of Validation]) as decimal) as [Count of Validation]
, cast(sum(t1.[Count of Validated Claims]) as decimal) as [Count of Validated Claims]
, cast(sum(t1.[Count of Payable Claims]) as decimal) as [Count of Payable Claims]
, cast(sum(t1.[Count of Processed Claims]) as decimal) as [Count of Processed Claims]
from (

		select t.centerID
		, t.tiptypeNM
		, o.[Organization Category Size]
		, o.[Organization Name]
		, cast(sum(t.ValidatedClaims) as decimal) as [Count of Validation]
		, cast(sum(t.validate) as decimal) as [Count of Validated Claims]
		, cast(sum(t.payabled) as decimal) as [Count of Payable Claims]
		, cast(sum(t.Process) as decimal) as [Count of Processed Claims]
		from (

				select c.claimID
				, case when cv.validated = 1 and cv.payable = 1 and cv.processed = 1
						then 1 else 0 end as ValidatedClaims
				, case when cv.validated = 1 then 1 else 0 end as Validate
				, case when cv.payable = 1 then 1 else 0 end as Payabled
				, case when cv.processed = 1 then 1 else 0 end as Process
				, c.centerID
				, oc.orgID
				, tdt.TipTypeNM
				, cv.validated
				, cv.processed
				, cv.payable
				from dbo.claim c
				join staging.claimvalidation cv on cv.claimID = c.claimID
				join [dbo].[vw_UHC_Org2CenterRollup] oc on oc.centerID = c.centerID
				join (

					   select td.tipdetailID, tt.TipTypeID, tt.TipTypeNM
					   from dbo.UHC_TipDetail td
					   join dbo.UHC_TipType tt on tt.TipTypeID = td.tipTypeID
					   where 1=1 

					 ) tdt on tdt.tipdetailID = c.tipdetailid
				join dbo.policy po on po.policyID = c.policyid
				join dbo.contract co on co.ContractID = po.contractID
				join dbo.client cl on cl.clientID = co.ClientID
				where 1=1
				and cl.clientID = 105
				and c.statusID = 6
				and cv.active = 1
				and (year(cast(c.mtmserviceDT as date)) = year(cast(getdate() as date))
					or (cast(c.mtmserviceDT as date) is null))

		) t
		join dbo.UHC_OrganizationRollup o on o.orgid = t.orgid 
		where 1 = 1
		group by t.centerID
		, t.tiptypeNM
		, o.[Organization Category Size]
		, o.[Organization Name]

) t1
where 1=1
group by t1.[Organization Category Size]
, t1.[Organization Name]
, t1.tiptypeNM
)


insert into #UHCOrganizationTips (
[Week #]
, [File Delivery Date]
, [Organization Category Size]
, [Organization Name]
, [TIP Type]
, [Total Opportunities]
, [Count of Opportunities w/ Aging Criteria]
, [Count of Completed TIPs]
, [Count of Successful TIPs]
, [Count of Active TIPs]
, [% Completed]
, [% Success]
, [% Net Effective]
, [Count of Validation]
, [Count of Validated Claims]
, [Count of Payable Claims]
, [Count of Processed Claims]
)
select datepart(week, getdate()) as [Week #]
, cast(getdate() as date) as [File Delivery Date]
, o.[Organization Category Size]
, v.[Organization Name]
, v.[TIP Type]
, isnull([Total Opportunities], 0) as [Total Opportunities]
, isnull([Count of Opportunities w/ Aging Criteria], 0) as [Count of Opportunities w/ Aging Criteria]
, isnull([Count of Completed TIPs], 0) as [Count of Completed TIPs]
, isnull([Count of Successful TIPs], 0) as [Count of Successful TIPs]
, isnull([Count of Active TIPs], 0) as [Count of Active TIPs]
, isnull([% Completed], 0) as [% Completed]
, isnull([% Success], 0) as [% Success] 
, isnull([% Net Effective], 0) as [% Net Effective] 
, isnull([Count of Validation], 0) as [Count of Validation]
, isnull([Count of Validated Claims], 0) as [Count of Validated Claims]
, isnull([Count of Payable Claims], 0) as [Count of Payable Claims]
, isnull([Count of Processed Claims], 0) as [Count of Processed Claims]
from v
left join o on v.[TIP Type] = o.[TIP Type]
       and o.[Organization Name] = v.[Organization Name]
left join oo on v.[TIP Type] = oo.[TIP Type]
       and oo.[Organization Name] = v.[Organization Name]


select [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]
, [TIP Type]
, [Total Opportunities]
, [Count of Opportunities w/ Aging Criteria]
, [Count of Completed TIPs]
, [Count of Successful TIPs]
, [Count of Active TIPs]
, [% Completed]
, [% Success]
, [% Net Effective]
, [Count of Validation]
, [Count of Validated Claims]
, [Count of Payable Claims]
, [Count of Processed Claims]
from #UHCOrganizationTips u
join outcomesMTM.dbo.UHC_OrganizationRollup o on o.[Organization Name] = u.[Organization Name]


UNION 

select [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]
, 'Total' as [TIP Type]
, cast(sum([Total Opportunities]) as decimal) as [Total Opportunities]
, cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal) as [Count of Opportunities w/ Aging Criteria]
, cast(sum([Count of Completed TIPs]) as decimal) as [Count of Completed TIPs]
, cast(sum([Count of Successful TIPs]) as decimal) as [Count of Successful TIPs]
, cast(sum([Count of Active TIPs]) as decimal) as [Count of Active TIPs]
, ISNULL(cast((cast(sum([Count of Completed TIPs]) as decimal)/NULLIF(cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
, ISNULL(cast((cast(sum([Count of Successful TIPs]) as decimal)/NULLIF(cast(sum([Count of Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
, ISNULL(cast((cast(sum([Count of Successful TIPs]) as decimal)/NULLIF(cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
, cast(sum([Count of Validation]) as decimal) as [Count of Validation]
, cast(sum([Count of Validated Claims]) as decimal) as [Count of Validated Claims]
, cast(sum([Count of Payable Claims]) as decimal) as [Count of Payable Claims]
, cast(sum([Count of Processed Claims]) as decimal) as [Count of Processed Claims]
from #UHCOrganizationTips u
join outcomesMTM.dbo.UHC_OrganizationRollup o on o.[Organization Name] = u.[Organization Name]
GROUP BY  [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]

UNION

select [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]
, 'Total Underuse' as [TIP Type]
, cast(sum([Total Opportunities]) as decimal) as [Total Opportunities]
, cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal) as [Count of Opportunities w/ Aging Criteria]
, cast(sum([Count of Completed TIPs]) as decimal) as [Count of Completed TIPs]
, cast(sum([Count of Successful TIPs]) as decimal) as [Count of Successful TIPs]
, cast(sum([Count of Active TIPs]) as decimal) as [Count of Active TIPs]
, ISNULL(cast((cast(sum([Count of Completed TIPs]) as decimal)/NULLIF(cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
, ISNULL(cast((cast(sum([Count of Successful TIPs]) as decimal)/NULLIF(cast(sum([Count of Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
, ISNULL(cast((cast(sum([Count of Successful TIPs]) as decimal)/NULLIF(cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
, cast(sum([Count of Validation]) as decimal) as [Count of Validation]
, cast(sum([Count of Validated Claims]) as decimal) as [Count of Validated Claims]
, cast(sum([Count of Payable Claims]) as decimal) as [Count of Payable Claims]
, cast(sum([Count of Processed Claims]) as decimal) as [Count of Processed Claims]
from #UHCOrganizationTips u
join outcomesMTM.dbo.UHC_OrganizationRollup o on o.[Organization Name] = u.[Organization Name]
where 1=1
and u.[TIP Type] in ('Underuse Diabetes', 'Underuse Hypertension', 'Underuse Statin')
GROUP BY  [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]

UNION

select [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]
, 'Total Check-In' as [TIP Type]
, cast(sum([Total Opportunities]) as decimal) as [Total Opportunities]
, cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal) as [Count of Opportunities w/ Aging Criteria]
, cast(sum([Count of Completed TIPs]) as decimal) as [Count of Completed TIPs]
, cast(sum([Count of Successful TIPs]) as decimal) as [Count of Successful TIPs]
, cast(sum([Count of Active TIPs]) as decimal) as [Count of Active TIPs]
, ISNULL(cast((cast(sum([Count of Completed TIPs]) as decimal)/NULLIF(cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
, ISNULL(cast((cast(sum([Count of Successful TIPs]) as decimal)/NULLIF(cast(sum([Count of Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
, ISNULL(cast((cast(sum([Count of Successful TIPs]) as decimal)/NULLIF(cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
, cast(sum([Count of Validation]) as decimal) as [Count of Validation]
, cast(sum([Count of Validated Claims]) as decimal) as [Count of Validated Claims]
, cast(sum([Count of Payable Claims]) as decimal) as [Count of Payable Claims]
, cast(sum([Count of Processed Claims]) as decimal) as [Count of Processed Claims]
from #UHCOrganizationTips u
join outcomesMTM.dbo.UHC_OrganizationRollup o on o.[Organization Name] = u.[Organization Name]
where 1=1
and u.[TIP Type] in ('Check-In Diabetes'
				   , 'Check-In Hypertension'
				   , 'Check-In Statin')
GROUP BY  [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]

UNION

select [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]
, 'Total Adherence Monitoring' as [TIP Type]
, cast(sum([Total Opportunities]) as decimal) as [Total Opportunities]
, cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal) as [Count of Opportunities w/ Aging Criteria]
, cast(sum([Count of Completed TIPs]) as decimal) as [Count of Completed TIPs]
, cast(sum([Count of Successful TIPs]) as decimal) as [Count of Successful TIPs]
, cast(sum([Count of Active TIPs]) as decimal) as [Count of Active TIPs]
, ISNULL(cast((cast(sum([Count of Completed TIPs]) as decimal)/NULLIF(cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
, ISNULL(cast((cast(sum([Count of Successful TIPs]) as decimal)/NULLIF(cast(sum([Count of Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
, ISNULL(cast((cast(sum([Count of Successful TIPs]) as decimal)/NULLIF(cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
, cast(sum([Count of Validation]) as decimal) as [Count of Validation]
, cast(sum([Count of Validated Claims]) as decimal) as [Count of Validated Claims]
, cast(sum([Count of Payable Claims]) as decimal) as [Count of Payable Claims]
, cast(sum([Count of Processed Claims]) as decimal) as [Count of Processed Claims]
from #UHCOrganizationTips u
join outcomesMTM.dbo.UHC_OrganizationRollup o on o.[Organization Name] = u.[Organization Name]
where 1=1
and u.[TIP Type] in ('Adherence Monitoring Diabetes'
				   , 'Adherence Monitoring Hypertension'
				   , 'Adherence Monitoring Statin')
GROUP BY  [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]

UNION

select [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]
, 'Total Needs 90-day Fill' as [TIP Type]
, cast(sum([Total Opportunities]) as decimal) as [Total Opportunities]
, cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal) as [Count of Opportunities w/ Aging Criteria]
, cast(sum([Count of Completed TIPs]) as decimal) as [Count of Completed TIPs]
, cast(sum([Count of Successful TIPs]) as decimal) as [Count of Successful TIPs]
, cast(sum([Count of Active TIPs]) as decimal) as [Count of Active TIPs]
, ISNULL(cast((cast(sum([Count of Completed TIPs]) as decimal)/NULLIF(cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
, ISNULL(cast((cast(sum([Count of Successful TIPs]) as decimal)/NULLIF(cast(sum([Count of Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
, ISNULL(cast((cast(sum([Count of Successful TIPs]) as decimal)/NULLIF(cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
, cast(sum([Count of Validation]) as decimal) as [Count of Validation]
, cast(sum([Count of Validated Claims]) as decimal) as [Count of Validated Claims]
, cast(sum([Count of Payable Claims]) as decimal) as [Count of Payable Claims]
, cast(sum([Count of Processed Claims]) as decimal) as [Count of Processed Claims]
from #UHCOrganizationTips u
join outcomesMTM.dbo.UHC_OrganizationRollup o on o.[Organization Name] = u.[Organization Name]
where 1=1
and u.[TIP Type] in ( 'Needs 90-day fill (Diabetes)'
				   , 'Needs 90-day fill (Hypertension)'
				   , 'Needs 90-day fill (Statin)')
GROUP BY  [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]

UNION

select [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]
, 'Total Needs Refill' as [TIP Type]
, cast(sum([Total Opportunities]) as decimal) as [Total Opportunities]
, cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal) as [Count of Opportunities w/ Aging Criteria]
, cast(sum([Count of Completed TIPs]) as decimal) as [Count of Completed TIPs]
, cast(sum([Count of Successful TIPs]) as decimal) as [Count of Successful TIPs]
, cast(sum([Count of Active TIPs]) as decimal) as [Count of Active TIPs]
, ISNULL(cast((cast(sum([Count of Completed TIPs]) as decimal)/NULLIF(cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
, ISNULL(cast((cast(sum([Count of Successful TIPs]) as decimal)/NULLIF(cast(sum([Count of Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
, ISNULL(cast((cast(sum([Count of Successful TIPs]) as decimal)/NULLIF(cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
, cast(sum([Count of Validation]) as decimal) as [Count of Validation]
, cast(sum([Count of Validated Claims]) as decimal) as [Count of Validated Claims]
, cast(sum([Count of Payable Claims]) as decimal) as [Count of Payable Claims]
, cast(sum([Count of Processed Claims]) as decimal) as [Count of Processed Claims]
from #UHCOrganizationTips u
join outcomesMTM.dbo.UHC_OrganizationRollup o on o.[Organization Name] = u.[Organization Name]
where 1=1
and u.[TIP Type] in ('Needs Refill')
GROUP BY  [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]

UNION

select [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]
, 'Total Needs Refill and Needs 90-day' as [TIP Type]
, cast(sum([Total Opportunities]) as decimal) as [Total Opportunities]
, cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal) as [Count of Opportunities w/ Aging Criteria]
, cast(sum([Count of Completed TIPs]) as decimal) as [Count of Completed TIPs]
, cast(sum([Count of Successful TIPs]) as decimal) as [Count of Successful TIPs]
, cast(sum([Count of Active TIPs]) as decimal) as [Count of Active TIPs]
, ISNULL(cast((cast(sum([Count of Completed TIPs]) as decimal)/NULLIF(cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal), 0)) as decimal (5,2)), 0) as [% Completed]
, ISNULL(cast((cast(sum([Count of Successful TIPs]) as decimal)/NULLIF(cast(sum([Count of Completed TIPs]) as decimal), 0)) as decimal (5,2)), 0) as [% Success]
, ISNULL(cast((cast(sum([Count of Successful TIPs]) as decimal)/NULLIF(cast(sum([Count of Opportunities w/ Aging Criteria]) as decimal), 0)) as decimal (5,2)), 0) as [% Net Effective]
, cast(sum([Count of Validation]) as decimal) as [Count of Validation]
, cast(sum([Count of Validated Claims]) as decimal) as [Count of Validated Claims]
, cast(sum([Count of Payable Claims]) as decimal) as [Count of Payable Claims]
, cast(sum([Count of Processed Claims]) as decimal) as [Count of Processed Claims]
from #UHCOrganizationTips u
join outcomesMTM.dbo.UHC_OrganizationRollup o on o.[Organization Name] = u.[Organization Name]
where 1=1
and u.[TIP Type] in ('Needs Refill'
					, 'Needs 90-day fill (Diabetes)'
				    , 'Needs 90-day fill (Hypertension)'
				    , 'Needs 90-day fill (Statin)')
GROUP BY  [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]
order by [Week #], u.[Organization Name], o.[Organization Category Size], [TIP Type]

end





