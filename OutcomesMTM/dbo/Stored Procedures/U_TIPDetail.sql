
create proc [dbo].[U_TIPDetail]
as
begin
set nocount on;
set xact_abort on;

update td
set td.[tipdetailid] = ts.[tipdetailid]
	,td.[tiptitle] = ts.[tiptitle]
	,td.[active] = ts.[active]
	,td.[createdate] = ts.[createdate]
--select count(*)
from outcomesMTM.dbo.TIPDetail td
join outcomesMTM.dbo.TIPDetailStaging ts on ts.tipdetailid = td.tipdetailid
where 1=1

delete ts
--select count(*)
from outcomesMTM.dbo.TIPDetail td
left join outcomesMTM.dbo.TIPDetailStaging ts on ts.tipdetailid = td.tipdetailid
where 1=1
and ts.tipdetailid is null

insert into outcomesMTM.dbo.TIPDetail ([tipdetailid]
	,[tiptitle]
	,[active]
	,[createdate]
)
select ts.[tipdetailid]
	,ts.[tiptitle]
	,ts.[active]
	,ts.[createdate]
from outcomesMTM.dbo.TIPDetail td
right join outcomesMTM.dbo.TIPDetailStaging ts on ts.tipdetailid = td.tipdetailid
where 1=1
and td.tipdetailid is null

end

