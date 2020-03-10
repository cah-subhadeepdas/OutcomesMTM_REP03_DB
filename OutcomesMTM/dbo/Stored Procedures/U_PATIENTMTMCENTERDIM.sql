


CREATE procedure [dbo].[U_PATIENTMTMCENTERDIM]
as 
begin
set nocount on;
set xact_abort on;

if(object_id('tempdb..#queueOrder') is not null)
drop table #queueOrder
create table #queueOrder (
queueOrderID int identity(1,1) primary key 
, queueOrder int 
)
insert into #queueOrder (queueOrder) 
select distinct queueOrder 
from patientMTMCenterDeltaQueueStaging 
order by queueOrder


declare @queueOrder int = 0;
declare @maxCnt int = (select max(queueOrderID) from #queueOrder);
declare @cnt int = 1;
while(@cnt <= @maxCnt) 
begin 

	set @queueOrder = (select queueOrder from #queueOrder where 1=1 and queueOrder = @cnt)

	--patientMTMCenterDim
	--DELETES
	update d  
	set d.activethru = s.queueDate
	--select count(*) 
	from patientMTMCenterDim d 
	join patientMTMCenterDeltaQueueStaging s on d.patientid = s.patientid 
												and d.centerid = s.centerid 
												and s.queueorder = @queueOrder 
	where 1=1 
	and d.activethru is null 
	and s.isDelete = 1 
	and s.isInsert = 0 

	--UPDATES
	update d  
	set d.activethru = s.queueDate
	--select count(*) 
	from patientMTMCenterDim d 
	join patientMTMCenterDeltaQueueStaging s on d.patientid = s.patientid 
												and d.centerid = s.centerid 
												and s.queueorder = @queueOrder 
	where 1=1 
	and d.activethru is null 
	and s.isDelete = 1 
	and s.isInsert = 1
	and not (
		isnull(d.patientMTMcenterid,0) = isnull(s.patientMTMcenterid,0)
		and isnull(d.primarypharmacy,0) = isnull(s.primarypharmacy,0)
	)

	--UPSERTS
	insert into patientMTMCenterDim (
	patientmtmcenterID
	,patientid
	,centerid
	,primaryPharmacy
	,activeasof
	) 
	select s.patientmtmcenterID
	,s.patientid
	,s.centerid
	,s.primaryPharmacy
	,s.queueDate as activeasof 
	--select count(*) 
	from patientMTMCenterDeltaQueueStaging s 
	where 1=1 
	and s.queueorder = @queueOrder 
	and s.isinsert = 1
	and not exists (
			select 1 
			from patientMTMCenterDim d1
			where 1=1 
			and d1.patientid = s.patientid 
			and d1.centerid = s.centerid 
			and d1.activeasof = s.queueDate
		)
	and not exists (
			select 1 
			from patientMTMCenterDim d2
			where 1=1 
			and d2.patientid = s.patientid 
			and d2.centerid = s.centerid 
			and d2.activethru is null 
		)


set @cnt = @cnt + 1 

end--end loop


END









