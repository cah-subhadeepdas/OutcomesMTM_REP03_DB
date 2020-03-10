


CREATE procedure [dbo].[U_PATIENTPRIMARYPHARMACYDIM]
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
from patientPrimaryPharmacyDeltaQueueStaging 
order by queueOrder


declare @queueOrder int = 0;
declare @maxCnt int = (select max(queueOrderID) from #queueOrder);
declare @cnt int = 1;
while(@cnt <= @maxCnt) 
begin 

	set @queueOrder = (select queueOrder from #queueOrder where 1=1 and queueOrder = @cnt)

	--patientPrimaryPharmacyDim
	--DELETES
	update d  
	set d.activethru = s.queueDate
	--select count(*) 
	from patientPrimaryPharmacyDim d 
	join patientPrimaryPharmacyDeltaQueueStaging s on d.patientid = s.patientid 
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
	from patientPrimaryPharmacyDim d 
	join patientPrimaryPharmacyDeltaQueueStaging s on d.patientid = s.patientid 
													  and d.centerid = s.centerid 
													  and s.queueorder = @queueOrder 
	where 1=1 
	and d.activethru is null 
	and s.isDelete = 1 
	and s.isInsert = 1 
	and not (
		isnull(d.[patientPrimaryPharmacyID],0) = isnull(s.[patientPrimaryPharmacyID],0)
		and isnull(d.[primaryPharmacy],0) = isnull(s.[primaryPharmacy],0)
	)

	--Disabling index 
	ALTER INDEX [UK_patientPrimaryPharmacyDim_activeasof] ON [dbo].[patientPrimaryPharmacyDim] DISABLE
	ALTER INDEX [UK_patientPrimaryPharmacyDim_activethru] ON [dbo].[patientPrimaryPharmacyDim] DISABLE
	ALTER INDEX [ind_patientPrimaryPharmacyID] ON [dbo].[patientPrimaryPharmacyDim] DISABLE

	--UPSERTS
	insert into patientPrimaryPharmacyDim (
	[patientPrimaryPharmacyID] 
	,[patientid] 
	,[centerid] 
	,[primaryPharmacy] 
	,[activeAsOf] 
	) 
	select s.[patientPrimaryPharmacyID] 
	,s.[patientid] 
	,s.[centerid] 
	,s.[primaryPharmacy] 
	,s.queueDate as activeasof 
	--select count(*) 
	from patientPrimaryPharmacyDeltaQueueStaging s 
	where 1=1 
	and s.queueorder = @queueOrder 
	and s.isinsert = 1
	and not exists (
			select 1 
			from patientPrimaryPharmacyDim d1
			where 1=1 
			and d1.patientid = s.patientid 
			and d1.centerid = s.centerid 
			and d1.activeasof = s.queueDate
		)
	and not exists (
			select 1 
			from patientPrimaryPharmacyDim d2
			where 1=1 
			and d2.patientid = s.patientid 
			and d2.centerid = s.centerid 
			and d2.activethru is null 
		)

    -- Enabling Index
	ALTER INDEX [UK_patientPrimaryPharmacyDim_activeasof] ON [dbo].[patientPrimaryPharmacyDim] REBUILD
	ALTER INDEX [UK_patientPrimaryPharmacyDim_activethru] ON [dbo].[patientPrimaryPharmacyDim] REBUILD
	ALTER INDEX [ind_patientPrimaryPharmacyID] ON [dbo].[patientPrimaryPharmacyDim] REBUILD

set @cnt = @cnt + 1 

end--end loop



END









