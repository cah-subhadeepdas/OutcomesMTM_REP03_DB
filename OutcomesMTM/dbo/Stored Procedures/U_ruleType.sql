

create proc [dbo].[U_ruleType]
as
begin
set nocount on;
set xact_abort on;

update rt
set rt.ruletypeid = rs.ruletypeid
       ,rt.ruletype = rs.ruletype
--select count(*)
from dbo.ruleType rt
join dbo.ruleTypeStaging rs on rs.ruletypeid = rt.ruletypeid
where 1=1

delete rs
--select count(*)
from dbo.ruleType rt
left join dbo.ruleTypeStaging rs on rs.ruletypeid = rt.ruletypeid
where 1=1
and rs.ruletypeid is null


insert into dbo.ruleType ([ruletypeid], [ruletype])
select rs.[ruletypeid]
       ,rs.[ruletype]
from dbo.ruleType rt
right join dbo.ruleTypeStaging rs on rs.ruletypeid = rt.ruletypeid
where 1=1
and rt.ruletypeid is null


end


