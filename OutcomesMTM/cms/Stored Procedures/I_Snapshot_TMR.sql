
Create  procedure [cms].[I_Snapshot_TMR]
As

Begin
declare @ClientID int = 115; declare @ContractYear char(4) = '2019';    --/ for testing


drop table if exists #snapshot
select s.*
into #snapshot
from cms.vw_Snapshot s
where 1=1
and s.DataSetTypeID = 3
and s.ClientID = @ClientID
and s.ContractYear = @ContractYear


declare @SnapshotID int = ( select SnapshotID from #snapshot )
--print @snapshotid


	--// Update Snapshot Begin
	update s set 
		s.LastRunDate = getdate()
		, s.LastRunStatus = -1
	from cms.CMS_SnapshotTracker s
	where 1=1
	and s.SnapshotID = @SnapshotID


INSERT INTO [cms].[TMR]
           (

			   [PatientID]
			   ,[TMRDate]
			   ,[SnapshotID]
			   ,[CreateDT]
			   ,[ChangeDT]
		   )


	SELECT DISTINCT
	   [patientID] = stg.PatientID 
	  ,[TMRDate] = stg.Rundate
	  , 305 as   [SnapshotID] --s.SnapshotID
      ,[CreateDT] =  cast(cast(getdate() as datetime2) as datetime) 
      ,[ChangeDT] = cast(cast(getdate() as datetime2) as datetime)    -- same as createdate 
	FROM OutcomesMTM.cms.STG_TMR_SRC1 stg
	


	--// Update Snapshot Finish
	update s set 
		s.LastRunStatus = 1
	from cms.CMS_SnapshotTracker s
	where 1=1
	and s.SnapshotID = @SnapshotID

	END



