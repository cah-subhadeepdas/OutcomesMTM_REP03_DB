
--select * from #SnapshotTrackerQueue

CREATE   proc [cms].[U_SFRequest_Queue]
as 

begin

begin  tran

drop table if exists #SnapshotTrackerQueue

declare @cnt int ,   @datasettypeid int = 2 --Beneficiary 
declare @ClientId int , @ContractYear int , @SnapshotId int

--Set the ValidClientIdContractYear flag to 0 if the clientid is not valid or contractyear is smaller than 2017
update d
 set d.ValidClientIdContractYear = 0 
from [cms].[SFRequest_Queue] d 
where 1=1
and ( NOT EXISTS (select c.clientid from dbo.client c where c.clientID = d.ClientID)
	OR d.ContractYear < 2017)


--de-duplicating when multiple SFRequest files or multiple combo of client/contractyear are queued up to be processed. Only the latest one will be processed.	
-- ProcessStatusID = 0 (ready for process) , -2 (inprocess) , 1 (completed)
update d
set d.LastModifiedDT = getdate(), 
	d.IsDuplicate = 0, --this record will be processed for the SF and SF QA export
	d.ProcessStatusID = -2 ,  --in process
	d.ProcessStartDT = getdate()
from [cms].[SFRequest_Queue] d  
join (select ClientID , ContractYear , max(QueueID) as maxQueueID  from [cms].[SFRequest_Queue] 
		where CreateDT is not null and ProcessStatusID = 0 and  ProcessFinishDT is null and ValidClientIdContractYear = 1
		 group by ClientID , ContractYear ) s 
on d.QueueID = s.maxQueueID
AND d.ProcessFinishDT is null


/*
--update the latest snapshotid from the snapshottracker table which matches the queued SF Request
-- ProcessStatusID = 0 (ready for process) , -2 (inprocess) , 1 (completed)
update d
set d.LastModifiedDT = getdate(),
	d.SnapshotID = s.maxSnapshotID, 
	d.ProcessStatusID = -2 --in process
from [cms].[SFRequest_Queue] d 
join (select QueueID , ClientID , ContractYear  from [cms].[SFRequest_Queue] 
		where CreateDT is not null and ProcessStatusID = 0 and IsDuplicate = 0 and  ProcessFinishDT is null and ValidClientIdContractYear = 1) SFRQ 
on d.QueueID = SFRQ.QueueID and d.ProcessFinishDT is null
left join (select ClientID , ContractYear , max(SnapshotID) as maxSnapshotID from cms.CMS_SnapshotTracker
		 where DataSetTypeID = @datasettypeid and ActiveThruDT > getdate() group by ClientID , ContractYear) s 
on s.ClientID = SFRQ.ClientID and s.ContractYear = SFRQ.ContractYear 
*/


truncate table cmsETL.SnapshotTrackerQueue

-- (If no matching snapshotid was found above and the ovewriteSnapshot = N) or ovewriteSnapshot = Y then take a new snapshot
insert into cmsETL.SnapshotTrackerQueue (SFRQueueid , clientid , contractyear , SnapshotID , OverwriteSnapshot)
select SFRQ.Queueid , SFRQ.clientid , SFRQ.contractyear , CMS.SnapshotID , SFRQ.OverwriteSnapshot
from [cms].[SFRequest_Queue] SFRQ
left join cms.CMS_SnapshotTracker CMS 
	on	SFRQ.clientid = CMS.ClientID 
	and SFRQ.contractyear = CMS.ContractYear 
	and CMS.DataSetTypeID = @datasettypeid 
	and CMS.ActiveThruDT > getdate()	
where 1=1
and SFRQ.CreateDT is not null and SFRQ.IsDuplicate = 0  and SFRQ.ProcessStatusID = -2 and  SFRQ.ProcessFinishDT is null and SFRQ.ValidClientIdContractYear = 1
and ( ( SFRQ.OverwriteSnapshot = 'N'  and CMS.SnapshotID is null) --no matching snapshot exists , so new one needs to be taken and that goes to the #SnapshotTrackerQueue
	  OR  SFRQ.OverwriteSnapshot = 'Y' ) --new snapshot has to be taken and that goes to the #SnapshotTrackerQueue

 
set @cnt = 1
-- Create Snapshots for each of the records in #SnapshotTrackerQueue (for OverwriteSnapshot = N) 
while (@cnt <= (select max(id) from cmsETL.SnapshotTrackerQueue) )
begin 	
	select @ClientId = clientid , @ContractYear = contractyear , @SnapshotId = SnapshotId from cmsETL.SnapshotTrackerQueue where id = @cnt

	--Deactivate an existing Snapshot if it exists in  cms.CMS_SnapshotTracker before creating for a new snapshot
	update cms
	set cms.ActiveThruDT = getdate()
	from cms.CMS_SnapshotTracker cms 
	join (select ClientID , ContractYear , max(SnapshotID) as maxSnapshotID from cms.CMS_SnapshotTracker 
				where DataSetTypeID = @datasettypeid and ClientID = @ClientID and ContractYear = @ContractYear and ActiveThruDT > getdate()
				group by ClientID , ContractYear) stg 
			on cms.SnapshotID = stg.maxSnapshotID
		


	--Now create a new snapshot
	EXEC [cms].[I_SnapshotTracker] @datasettypeid , @ClientId , @ContractYear  
	set @cnt = @cnt + 1
	
end 

-- update the snapshotid back in SFRequest_Queue after new snapshots were taken
	update SFRQ
	set SFRQ.LastModifiedDT = getdate(),
		SFRQ.SnapshotID = CMS.maxSnapshotID,
		SFRQ.ProcessStatusID = case when SFRQ.OverwriteSnapshot = 'N' and STQ.id is null then -2 else 1 end, --If Export has to be called then keep the status as -2 (inprocess) else update to 1 (when SnapshotTracker was updated)
		SFRQ.ProcessFinishDT = case when SFRQ.OverwriteSnapshot = 'N' and STQ.id is null then null else getdate() end, --If Export has to be called then keep the ProcessFinishDT blank else update to getdate() (when SnapshotTracker was updated)
		SFRQ.SnapshotRunTime = cast(DATEPART(yyyy,ST.LastRunDate) as varchar(4)) +  RIGHT('0' + cast(DATEPART(mm, ST.LastRunDate) as varchar(2)),2)  
								+  RIGHT('0' + cast(DATEPART(dd, ST.LastRunDate) as varchar(2)),2) +  RIGHT('0' + cast(DATEPART(hour, ST.LastRunDate) as varchar(2)),2) 
								+  RIGHT('0' + cast(DATEPART(minute, ST.LastRunDate) as varchar(2)),2) +  RIGHT('0' + cast(DATEPART(second, ST.LastRunDate) as varchar(2)),2) , 
		SFRQ.OnlyDoSFExport = case when SFRQ.OverwriteSnapshot = 'N' and STQ.id is null then 1 else 0 end --if no matching STQ record means no new snapshot was taken and only SF Export is needed
    from [cms].[SFRequest_Queue] SFRQ
	join (select ClientID , ContractYear , max(SnapshotID) as maxSnapshotID from cms.CMS_SnapshotTracker 
			where DataSetTypeID = @datasettypeid and  ActiveThruDT > getdate() group by ClientID , ContractYear) CMS 
		 on CMS.ClientID = SFRQ.ClientID and CMS.ContractYear = SFRQ.ContractYear
	join cms.CMS_SnapshotTracker ST on ST.SnapshotID = CMS.maxSnapshotID
	left join cmsETL.SnapshotTrackerQueue STQ on SFRQ.QueueID = STQ.SFRQueueid 
	where 1=1
	and SFRQ.CreateDT is not null and SFRQ.ProcessStatusID = -2 and SFRQ.IsDuplicate = 0 and SFRQ.ValidClientIdContractYear = 1
	
commit tran		

end

