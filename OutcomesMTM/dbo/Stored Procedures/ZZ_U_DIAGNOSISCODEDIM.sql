



CREATE procedure [dbo].[ZZ_U_DIAGNOSISCODEDIM]
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
from diagnosisCodeDeltaQueueStaging 
order by queueOrder


declare @queueOrder int = 0;
declare @maxCnt int = (select max(queueOrderID) from #queueOrder);
declare @cnt int = 1;
while(@cnt <= @maxCnt) 
begin 

	set @queueOrder = (select queueOrder from #queueOrder where 1=1 and queueOrder = @cnt)

	--diagnosisCodeDim
	--DELETES
	update d  
	set d.activethru = s.queueDate 
	, d.isCurrent = 1 
	--select count(*) 
	from diagnosisCodeDim d 
	join diagnosisCodeDeltaQueueStaging s on d.[PatientID] = s.[PatientID]
											 and d.[ICDCodeID] = s.[ICDCodeID]
											 and d.[diagnosisDate] = s.[diagnosisDate]
											 and s.queueorder = @queueOrder
	where 1=1 
	and d.activethru is null 
	and s.isDelete = 1
	and s.isInsert = 0

	--UPDATES
	update d  
	set d.activethru = s.queueDate 
	, d.isCurrent = 0
	--select count(*) 
	from diagnosisCodeDim d 
	join diagnosisCodeDeltaQueueStaging s on d.[PatientID] = s.[PatientID]
											 and d.[ICDCodeID] = s.[ICDCodeID]
											 and d.[diagnosisDate] = s.[diagnosisDate]
											 and s.queueorder = @queueOrder
	where 1=1 
	and d.activethru is null 
	and s.isDelete = 1
	and s.isInsert = 1
	and not (
		isnull(d.diagnosisCodeid,0) = isnull(s.diagnosisCodeid,0)
		and isnull(d.active,0) = isnull(s.active,0) 
		and isnull(d.prid,0) = isnull(s.prid,0) 
	)

	--UPSERTS
	insert into diagnosisCodeDim (
	[diagnosisCodeID] 
	,[PatientID] 
	,[ICDCodeID] 
	,[diagnosisDate] 
	,[prid] 
	,[active] 
	,[activeAsOf] 
	,[isCurrent]
	) 
	select s.[diagnosisCodeID] 
	,s.[PatientID] 
	,s.[ICDCodeID] 
	,s.[diagnosisDate] 
	,s.[prid] 
	,s.[active] 
	,s.queueDate as activeasof 
	,1 as isCurrent
	--select count(*) 
	from diagnosisCodeDeltaQueueStaging s 
	where 1=1 
	and s.queueorder = @queueOrder
	and s.isinsert = 1
	and not exists (
			select 1 
			from diagnosisCodeDim d1
			where 1=1 
			and d1.[PatientID] = s.[PatientID]
			and d1.[ICDCodeID] = s.[ICDCodeID]
			and d1.[diagnosisDate] = s.[diagnosisDate]
			and d1.activeasof = s.queueDate
		)
	and not exists (
			select 1 
			from diagnosisCodeDim d2
			where 1=1 
			and d2.[PatientID] = s.[PatientID]
			and d2.[ICDCodeID] = s.[ICDCodeID]
			and d2.[diagnosisDate] = s.[diagnosisDate]
			and d2.activethru is null 
		)


	-----------
	-----------
	-----------



	if(object_id('tempdb..#tempRepository') is not null)
	drop table #tempRepository
	create table #tempRepository (
	diagnosisCodeKey bigint primary key 
	, diagnosisCodeid int 
	, repositoryArchiveID bigint 
	, fileid int  
	, isDelete bit 
	, isInsert bit 
	, queuedate datetime  
	, activeKey bit 
	)

	insert into #tempRepository with (tablock) (diagnosisCodeKey, diagnosisCodeid, repositoryArchiveID, fileid, isDelete, isInsert, queuedate, activeKey)
	select d.diagnosisCodeKey
	, s.diagnosisCodeid 
	, s.repositoryarchiveid
	, s.fileid
	, s.isDelete
	, s.isInsert
	, s.queueDate 
	, 1 as activeKey 
	from diagnosisCodeDeltaQueueStaging s 
	join diagnosisCodeDim d on d.[PatientID] = s.[PatientID]
							and d.[ICDCodeID] = s.[ICDCodeID]
							and d.[diagnosisDate] = s.[diagnosisDate]
							and s.queueorder = @queueOrder
	where 1=1 
	and d.activethru is null 
	and s.isInsert = 1  
	and not exists (select 1 
					from diagnosisCodeRepositoryDim r 
					where 1=1 
					and r.diagnosisCodekey = d.diagnosisCodekey 
					and isnull(r.repositoryArchiveID,0) = isnull(s.repositoryArchiveID,0) 
					and isnull(r.fileid,0) = isnull(s.fileid,0)
					and r.activethru is null) 


	insert into #tempRepository with (tablock) (diagnosisCodeKey, diagnosisCodeid, repositoryArchiveID, fileid, isDelete, isInsert, queuedate, activeKey)
	select d.diagnosisCodeKey
	, s.diagnosisCodeid 
	, s.repositoryarchiveid
	, s.fileid
	, s.isDelete
	, s.isInsert
	, s.queueDate 
	, 0 as activeKey 
	from diagnosisCodeDeltaQueueStaging s 
	join diagnosisCodeDim d on d.[PatientID] = s.[PatientID]
							and d.[ICDCodeID] = s.[ICDCodeID]
							and d.[diagnosisDate] = s.[diagnosisDate]
							and s.queueorder = @queueOrder
	join diagnosisCodeRepositoryDim r on r.diagnosisCodeKey = d.diagnosisCodeKey 
								   and r.activethru is null  
	where 1=1 
	and ((s.isDelete = 1 and s.isinsert = 0) 
		  or 
		 (s.isDelete = 1  and exists (select 1 
									  from #tempRepository t 
									  where 1=1 
									  and t.diagnosisCodeid = s.diagnosisCodeid 
									  and t.diagnosisCodeKey <> d.diagnosisCodekey))) 
   

	------------------------------------

	--2: update true deletes
	update d  
	set d.[activeThru] = s.queueDate
	, d.[isCurrent] = 1 
	--select count(*) 
	from diagnosisCodeRepositoryDim d 
	join #tempRepository s on s.diagnosisCodekey = d.diagnosisCodekey  
	where 1=1 
	and d.activeThru is null 
	and s.isDelete = 1 
	and s.isInsert = 0 
	and s.activeKey = 0 
	and not exists (
			select 1 
			from diagnosisCodeRepositoryDim d1
			where 1=1 
			and d1.diagnosisCodekey = s.diagnosisCodekey  
			and d1.activeasof = s.queueDate 
		)
	 and not exists (
			select 1 
			from diagnosisCodeRepositoryDim d2
			where 1=1 
			and d2.diagnosisCodekey = s.diagnosisCodekey  
			and d2.activethru = s.queueDate 
		)

	--3: only inactivate updates where data has changed
	--the and not represents all of the audit columns 
	update d  
	set d.[activeThru] = s.queueDate
	, d.[isCurrent] = 0
	--select count(*) 
	from diagnosisCodeRepositoryDim d 
	join #tempRepository s on s.diagnosisCodekey = d.diagnosisCodekey  
	where 1=1 
	and d.activeThru is null 
	and s.isDelete = 1 
	and s.isInsert = 1 
	and s.activeKey = 0 
	and not exists (
			select 1 
			from diagnosisCodeRepositoryDim d1
			where 1=1 
			and d1.diagnosisCodekey = s.diagnosisCodekey  
			and d1.activeasof = s.queueDate 
		)
	and not exists (
			select 1 
			from diagnosisCodeRepositoryDim d2
			where 1=1 
			and d2.diagnosisCodekey = s.diagnosisCodekey  
			and d2.activethru = s.queueDate 
		)

	--4: only insert updates that have been turned off or new inserts 
	--the (d.activethru is null or d.activethru = s.queueDate) is to handle 
	--if a new repository archive file turns off the record
	insert into diagnosisCodeRepositoryDim (
	diagnosisCodekey
	,repositoryarchiveid
	,fileid   
	,activeasof 
	,iscurrent
	) 
	select s.diagnosisCodekey
	,s.repositoryarchiveid
	,s.fileid   
	,s.queueDate as activeasof 
	,1 as isCurrent
	--select count(*) 
	from #tempRepository s
	where 1=1 
	and s.isinsert = 1
	and s.activeKey = 1 
	and not exists (
			select 1 
			from diagnosisCodeRepositoryDim d1
			where 1=1 
			and d1.diagnosisCodekey = s.diagnosisCodekey  
			and d1.activeasof = s.queueDate
		)
	and not exists (
			select 1 
			from diagnosisCodeRepositoryDim d2
			where 1=1 
			and d2.diagnosisCodekey = s.diagnosisCodekey  
			and d2.activethru is null 
		)



	set @cnt = @cnt + 1 

end--end loop



END









