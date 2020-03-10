

CREATE proc [dbo].[UHC_weekly_organizationTIPs] 
as 
begin 


--if(object_ID('tempdb..#Calendar') is not null)
--begin
--drop table #Calendar
--end
--create table #Calendar (
Declare @Calendar Table (
PKDate date primary key, 
	-- Years
	calendar_year smallint,
	-- Quarters 
	calendar_quarter tinyint,  
	-- Months
	calendar_month tinyint, 
	calendar_month_name_long varchar(30), 
	-- Weeks
	calendar_week_in_year tinyint,  
	-- Days
	calendar_day_in_year smallint, 
	calendar_day_in_week tinyint,  -- The first of the month 
	calendar_day_in_month tinyint, 
	mdy_name_long varchar(30), 
	day_name_long varchar(10) 
	)

Declare @year char(4) = year(getdate()) 
Declare @dt_start date = '20150101', @dt_end date = '20201231', @total_days int, @i int = 0
SELECT @total_days = DATEDIFF(d, @dt_start, @dt_end) 

WHILE @i <= @total_days
	begin
	INSERT INTO @Calendar (PKDate) 
	SELECT CAST(DATEADD(d, @i, @dt_start) as DATE) 

	SET @i = @i + 1
	end

UPDATE @Calendar
SET 
      calendar_year = YEAR(PKDate), 
      calendar_quarter = DATEPART(q, PKDate),
      calendar_month = DATEPART(m, PKDate), 
      calendar_week_in_year = DATEPART(WK, PKDate), 
      calendar_day_in_year = DATEPART(dy, PKDate), 
      calendar_day_in_week = DATEPART(Weekday, PKDate),
      calendar_day_in_month = DATEPART(d, PKDate),
      day_name_long = datename(weekday, PKDate)

UPDATE @Calendar
SET 
      calendar_month_name_long = DATENAME(m, PKDate) + ' ' + CAST(calendar_year as CHAR(4)),
      mdy_name_long = DATENAME(m, PKDate) + ' ' + CAST(DATEPART( d, PKDate ) as varchar(2)) + ', '  + CAST(calendar_year as CHAR(4))


/*
select *
from #Calendar c
where 1=1
and c.calendar_year = year(cast(getdate() as date))
*/

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
, [Count of Completed TIPs] int
, [Count of Successful TIPs] int
)

declare @weekno int
--set @weekno = 1

set @weekno = (select c.calendar_week_in_year - 1
					from @Calendar c
					where 1=1
					and c.PKDate = cast(getdate() as date))
--begin


;with v as (
       select  t.tiptypeNM as [TIP Type]
			 , o.[Organization Category Size]
             , o.[Organization Name]
       from outcomesMTM.dbo.UHC_TipType t 
       , outcomesMTM.dbo.UHC_OrganizationRollup o 
)
, o as (
select @weekno as [Week #]
, cast(getdate() as date) as [File Delivery Date]
, t1.[Organization Category Size]
, t1.[Organization Name]
, t1.tiptypeNM as [TIP Type]
, cast(sum(t1.[Count of Completed TIPs]) as decimal) as [Count of Completed TIPs]
, cast(sum(t1.[Count of Successful TIPs]) as decimal) as [Count of Successful TIPs]
-- select *
from(
       select t.centerID
       , t.tiptypeNM
	   , [Organization Category Size]
       , o.[Organization Name]
       , cast(sum(t.[Completed TIPs]) as decimal) as [Count of Completed TIPs]
       , cast(sum(t.[Successful TIPs]) as decimal) as [Count of Successful TIPs]
       from (
              select row_number() over (partition by oc.orgID, ta.tipresultstatusID order by ta.[Completed TIPs] desc, ta.[Unfinished TIPs] desc, ta.[Review/resubmit Tips] desc, ta.[Rejected Tips] desc, ta.[currently active] desc, ta.[withdrawn] desc, ta.tipresultstatuscenterID desc) as [Rank] 
			  , ta.centerid
			  , ta.[Completed TIPs]
			  , ta.[Successful TIPs]
              , oc.orgid 
              , tdt.TipTypeNM
			  --select ta.*
              from outcomesMTM.dbo.tipActivityCenterReport ta
              join outcomesMTM.dbo.vw_UHC_Org2CenterRollup oc on oc.centerid = ta.centerid
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
              and cl.clientID = 105
			  and year(ta.activethru) = year(getdate()) 
			  and cast(ta.activethru as date) in (select c.PKDate
													 from @Calendar c
													 where 1=1
													 and c.calendar_week_in_year = @weekno) 						
       ) t
       join outcomesMTM.dbo.UHC_OrganizationRollup o on o.orgid = t.orgid 
       where 1 = 1
       and t.Rank = 1
       group by t.centerID, t.tiptypeNM, o.[Organization Category Size], o.[Organization Name]
) t1
join outcomesMTM.dbo.pharmacy p on p.centerid = t1.centerid
where 1 = 1
group by t1.[Organization Category Size], t1.[Organization Name]
, t1.tiptypeNM
)


insert into #UHCOrganizationTips (
[Week #]
, [File Delivery Date]
, [Organization Category Size]
, [Organization Name]
, [TIP Type]
, [Count of Completed TIPs]
, [Count of Successful TIPs]
)
select @weekno as [Week #]
, cast(getdate() as date) as [File Delivery Date]
, o.[Organization Category Size]
, v.[Organization Name]
, v.[TIP Type]
, isnull([Count of Completed TIPs], 0) as [Count of Completed TIPs]
, isnull([Count of Successful TIPs], 0) as [Count of Successful TIPs] 
from v
left join o on v.[TIP Type] = o.[TIP Type]
       and o.[Organization Name] = v.[Organization Name]
	   and o.[Organization Category Size] = v.[Organization Category Size]

select [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]
, [TIP Type]
, [Count of Completed TIPs]
, [Count of Successful TIPs]
from #UHCOrganizationTips u
join outcomesMTM.dbo.UHC_OrganizationRollup o on o.[Organization Name] = u.[Organization Name]

UNION ALL 

select [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]
, 'Total' as [TIP Type]
, cast(sum([Count of Completed TIPs]) as decimal) as [Count of Completed TIPs]
, cast(sum([Count of Successful TIPs]) as decimal) as [Count of Successful TIPs]
from #UHCOrganizationTips u
join outcomesMTM.dbo.UHC_OrganizationRollup o on o.[Organization Name] = u.[Organization Name]
where 1=1
GROUP BY  [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]

UNION ALL 

select [Week #]
, [File Delivery Date]
, o.[Organization Category Size]
, u.[Organization Name]
, 'Total Needs Refill and Needs 90-Day' as [TIP Type]
, cast(sum([Count of Completed TIPs]) as decimal) as [Count of Completed TIPs]
, cast(sum([Count of Successful TIPs]) as decimal) as [Count of Successful TIPs]
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


