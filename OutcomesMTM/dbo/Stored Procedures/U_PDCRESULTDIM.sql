

CREATE procedure [dbo].[U_PDCRESULTDIM]
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
from PDCResultDeltaQueueStaging 
order by queueOrder


declare @queueOrder int = 0;
declare @maxCnt int = (select max(queueOrderID) from #queueOrder);
declare @cnt int = 1;
while(@cnt <= @maxCnt) 
begin 

	set @queueOrder = (select queueOrder from #queueOrder where 1=1 and queueOrder = @cnt)

	--DELETES
	update d  
	set d.activethru = s.queueDate
	, d.[isCurrent] = 1 
	--select count(*) 
	from PDCResultDim d 
	join PDCResultDeltaQueueStaging s on d.patientid = s.patientid
												and d.pdcRuleID = s.pdcRuleID
												and s.queueorder = @queueOrder
	where 1=1 
	and d.activethru is null 
	and ((s.isDelete = 1 
		  and s.isInsert = 0) 
		  or 
		 (s.active = 0))

	--UPDATES
	update d  
	set d.activethru = s.queueDate
	, d.[isCurrent] = 0 
	--select count(*) 
	from PDCResultDim d 
	join PDCResultDeltaQueueStaging s on d.patientid = s.patientid
												and d.pdcRuleID = s.pdcRuleID
												and s.queueorder = @queueOrder
	where 1=1 
	and d.activethru is null 
	and s.isDelete = 1 
	and s.isInsert = 1 
	and not (
		isnull(d.[PDCresultID],0) = isnull(s.[PDCresultID],0)
		and isnull(d.[coveredDays],0) = isnull(s.[coveredDays],0)
		and isnull(d.[minIndexDate],'19000101') = isnull(s.[minIndexDate],'19000101')
		and isnull(d.[maxIndexDate],'19000101') = isnull(s.[maxIndexDate],'19000101')
		and isnull(d.[GPI],'') = isnull(s.[GPI],'')
	)
	---------
	and s.active = 1
	---------

	--Disabling Index
	--ALTER INDEX [UK_PDCResultDim_activeasof] ON [dbo].[PDCResultDim] DISABLE
	--ALTER INDEX [UK_PDCResultDim_activethru] ON [dbo].[PDCResultDim] DISABLE

	insert into PDCResultDim (
	PDCresultID
	,PDCruleID
	,PatientID
	,coveredDays
	,minIndexDate
	,maxIndexDate
	,GPI
	,[activeAsOf] 
	,[isCurrent]
	) 
	select s.PDCresultID
	,s.PDCruleID
	,s.PatientID
	,s.coveredDays
	,s.minIndexDate
	,s.maxIndexDate
	,s.GPI
	,s.[queueDate] 
	,1 as isCurrent
	--select count(*) 
	from PDCResultDeltaQueueStaging s 
	where 1=1 
	and s.queueorder = @queueOrder
	and s.isInsert = 1 
	and not exists (
			select 1 
			from PDCResultDim d1
			where 1=1 
			and d1.patientid = s.patientid 
			and d1.pdcRuleID = s.pdcRuleID 
			and d1.activeasof = s.queueDate
		)
	and not exists (
			select 1 
			from PDCResultDim d2
			where 1=1 
			and d2.patientid = s.patientid 
			and d2.pdcRuleID = s.pdcRuleID 
			and d2.activethru is null 
		)
	---------
	and s.active = 1
	---------

	----Enabling Index
	--ALTER INDEX [UK_PDCResultDim_activeasof] ON [dbo].[PDCResultDim] REBUILD
	--ALTER INDEX [UK_PDCResultDim_activethru] ON [dbo].[PDCResultDim] REBUILD

set @cnt = @cnt + 1 

end--end loop



END










