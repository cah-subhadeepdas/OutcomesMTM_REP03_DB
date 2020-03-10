

create proc [dbo].[U_TIPType]
as
begin
set nocount on;
set xact_abort on;

update tt
set tt.TIPTypeID = ts.TIPTypeID
       ,tt.TipType = ts.TipType
--select count(*)
from dbo.TIPType tt
join dbo.TIPTypeStaging ts on ts.TIPTypeID = tt.TIPTypeID
where 1=1

delete ts
--select count(*)
from dbo.TIPType tt
left join dbo.TIPTypeStaging ts on ts.TIPTypeID = tt.TIPTypeID
where 1=1
and ts.TIPTypeID is null


insert into dbo.TIPType([TIPTypeID], [TipType])
select ts.[TIPTypeID]
       ,ts.[TipType]
from dbo.TIPType tt
right join dbo.TIPTypeStaging ts on ts.TIPTypeID = tt.TIPTypeID
where 1=1
and tt.TIPTypeID is null


end


