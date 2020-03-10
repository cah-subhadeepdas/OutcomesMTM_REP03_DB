


CREATE procedure [dbo].[ZZ_U_ADHERENCEMONITORDIM]
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
from AdherenceMonitorDeltaQueueStaging 
order by queueOrder


declare @queueOrder int = 0;
declare @maxCnt int = (select max(queueOrderID) from #queueOrder);
declare @cnt int = 1;
while(@cnt <= @maxCnt) 
begin 

	set @queueOrder = (select queueOrder from #queueOrder where 1=1 and queueOrder = @cnt)

	--AdherenceMonitorDim 
	--DELETES
	update d  
	set d.activethru = s.queueDate
	, d.[isCurrent] = 1 
	--select count(*) 
	from AdherenceMonitorDim d 
	join AdherenceMonitorDeltaQueueStaging s on d.patientid = s.patientid
												and d.tipdetailid = s.tipdetailid
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
	from AdherenceMonitorDim d 
	join AdherenceMonitorDeltaQueueStaging s on d.patientid = s.patientid
												and d.tipdetailid = s.tipdetailid
												and s.queueorder = @queueOrder
	where 1=1 
	and d.activethru is null 
	and s.isDelete = 1 
	and s.isInsert = 1 
	and not (
		isnull(d.[AdherenceMonitorID],0) = isnull(s.[AdherenceMonitorID],0)
		and isnull(d.[GPI],'') = isnull(s.[GPI],'')
		and isnull(d.[CurrentPDC],0.0) = isnull(s.[CurrentPDC],0.0)
		and isnull(d.[DaysMissed],0) = isnull(s.[DaysMissed],0)
		and isnull(d.[AllowableDays],0) = isnull(s.[AllowableDays],0)
		and isnull(d.[BonusEligible],0) = isnull(s.[BonusEligible],0)
		and isnull(d.[YearofUse],0) = isnull(s.[YearofUse],0)
		and isnull(d.[repositoryArchiveid],0) = isnull(s.[repositoryArchiveid],0)
		and isnull(d.[fileid],0) = isnull(s.[fileid],0)
	)
	---------
	and s.active = 1
	---------

	--UPSERTS
	insert into AdherenceMonitorDim (
	[AdherenceMonitorID] 
	,[PatientID] 
	,[tipdetailID] 
	,[GPI] 
	,[CurrentPDC] 
	,[DaysMissed] 
	,[AllowableDays] 
	,[BonusEligible] 
	,[YearofUse] 
	,[repositoryArchiveid] 
	,[fileid] 
	,[activeAsOf] 
	,[isCurrent]
	) 
	select s.[AdherenceMonitorID] 
	,s.[PatientID] 
	,s.[tipdetailID] 
	,s.[GPI] 
	,s.[CurrentPDC] 
	,s.[DaysMissed] 
	,s.[AllowableDays] 
	,s.[BonusEligible] 
	,s.[YearofUse] 
	,s.[repositoryArchiveid] 
	,s.[fileid] 
	,s.[queueDate] 
	,1 as isCurrent
	--select count(*) 
	from AdherenceMonitorDeltaQueueStaging s 
	where 1=1 
	and s.queueorder = @queueOrder
	and s.isInsert = 1 
	and not exists (
			select 1 
			from AdherenceMonitorDim d1
			where 1=1 
			and d1.patientid = s.patientid 
			and d1.tipdetailid = s.tipdetailid 
			and d1.activeasof = s.queueDate
		)
	and not exists (
			select 1 
			from AdherenceMonitorDim d2
			where 1=1 
			and d2.patientid = s.patientid 
			and d2.tipdetailid = s.tipdetailid 
			and d2.activethru is null 
		)
	---------
	and s.active = 1
	---------



set @cnt = @cnt + 1 

end--end loop



END









