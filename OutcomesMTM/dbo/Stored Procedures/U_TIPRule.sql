

create proc [dbo].[U_TIPRule]
as
begin
set nocount on;
set xact_abort on;

update tr
set tr.[tipruleid] = ts.[tipruleid]
, tr.[tipdetailid] = ts.[tipdetailid]
, tr.[ruleid] = ts.[ruleid]
, tr.[ruletype] = ts.[ruletype]
, tr.[sort] = ts.[sort]
, tr.[concat] = ts.[concat]
, tr.[leftParen] = ts.[leftParen]
, tr.[rightParen] = ts.[rightParen]
, tr.[excludedrug] = ts.[excludedrug]
, tr.[active] = ts.[active]
, tr.[activeasof] = ts.[activeasof]
, tr.[activethru] = ts.[activethru]
--select count(*)
from dbo.TIPRule tr
join dbo.TIPRuleStaging ts on ts.tipruleid = tr.tipruleid
where 1=1

delete ts
--select count(*)
from dbo.TIPRule tr
left join dbo.TIPRuleStaging ts on ts.tipruleid = tr.tipruleid
where 1=1
and ts.tipruleid is null

insert into dbo.TIPRule ([tipruleid]
       ,[tipdetailid]
       ,[ruleid]
       ,[ruletype]
       ,[sort]
       ,[concat]
       ,[leftParen]
       ,[rightParen]
       ,[excludedrug]
       ,[active]
       ,[activeasof]
       ,[activethru]
)
select ts.[tipruleid]
       ,ts.[tipdetailid]
       ,ts.[ruleid]
       ,ts.[ruletype]
       ,ts.[sort]
       ,ts.[concat]
       ,ts.[leftParen]
       ,ts.[rightParen]
       ,ts.[excludedrug]
       ,ts.[active]
       ,ts.[activeasof]
       ,ts.[activethru]
from dbo.TIPRule tr
right join dbo.TIPRuleStaging ts on ts.tipruleid = tr.tipruleid
where 1=1
and tr.tipruleid is null


end

