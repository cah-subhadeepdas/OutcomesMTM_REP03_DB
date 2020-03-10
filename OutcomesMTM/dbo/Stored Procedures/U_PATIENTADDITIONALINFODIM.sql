



CREATE procedure [dbo].[U_PATIENTADDITIONALINFODIM]
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
from patientAdditionalInfoDeltaQueueStaging 
order by queueOrder

--Disabling index
ALTER INDEX [UK_patientAdditionalInfoDIM_activeasof] ON [dbo].[patientAdditionalInfoDim] DISABLE
ALTER INDEX [UK_patientAdditionalInfoDIM_activethru] ON [dbo].[patientAdditionalInfoDim] DISABLE

declare @queueOrder int = 0;
declare @maxCnt int = (select max(queueOrderID) from #queueOrder);
declare @cnt int = 1;
while(@cnt <= @maxCnt) 
begin 

	set @queueOrder = (select queueOrder from #queueOrder where 1=1 and queueOrder = @cnt)

	--patientAdditionalInfoAdditionalInfoDim
	--DELETES
	update d  
	set d.activethru = s.queueDate 
	, d.isCurrent = 1   
	--select count(*) 
	from patientAdditionalInfoDim d 
	join patientAdditionalInfoDeltaQueueStaging s on d.patientid = s.patientid and s.queueorder = @queueOrder 
	where 1=1 
	and d.activethru is null 
	and s.isDelete = 1
	and s.isInsert = 0

	--UPDATES
	update d  
	set d.activethru = s.queueDate 
	, d.isCurrent = 0
	--select count(*) 
	from patientAdditionalInfoDim d 
	join patientAdditionalInfoDeltaQueueStaging s on d.patientid = s.patientid and s.queueorder = @queueOrder 
	where 1=1 
	and d.activethru is null 
	and s.isDelete = 1
	and s.isInsert = 1
	and not (
		isnull(d.[PatientAdditionalInfoID],0) = isnull(s.[PatientAdditionalInfoID],0)
		and isnull(cast(d.[additionalinfoxml] as varchar(max)),'') = isnull(cast(s.[additionalinfoxml] as varchar(max)),'')
	)
 
	--UPSERTS
	insert into patientAdditionalInfoDim (
	[patientAdditionalInfoID] 
	,[patientid] 
	,[additionalinfoxml]  
	,[activeAsOf] 
	,[isCurrent]
	) 
	select s.[patientAdditionalInfoID] 
	,s.[patientid] 
	,s.[additionalinfoxml] 
	,s.queueDate as activeasof 
	,1 as isCurrent
	--select count(*) 
	from patientAdditionalInfoDeltaQueueStaging s 
	where 1=1 
	and s.queueorder = @queueOrder 
	and s.isinsert = 1
	and not exists (
			select 1 
			from patientAdditionalInfoDim d1
			where 1=1 
			and d1.patientid = s.patientid 
			and d1.activeasof = s.queueDate
		)
	and not exists (
			select 1 
			from patientAdditionalInfoDim d2
			where 1=1 
			and d2.patientid = s.patientid 
			and d2.activethru is null 
		)


set @cnt = @cnt + 1 

end--end loop

--Enabling Index
ALTER INDEX [UK_patientAdditionalInfoDIM_activeasof] ON [dbo].[patientAdditionalInfoDim] REBUILD
ALTER INDEX [UK_patientAdditionalInfoDIM_activethru] ON [dbo].[patientAdditionalInfoDim] REBUILD

END









