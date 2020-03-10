



Create     PROCEDURE [cms].[I_Snapshot_DTP] 
	@ClientID int ,
	@ContractYear int
AS




--// declare @ClientID int = 156; declare @ContractYear char(4) = '2018';    --/ for testing


drop table if exists #snapshot
select s.*
into #snapshot
from cms.vw_Snapshot s
where 1=1
and s.DataSetTypeID = 4
and s.ClientID = @ClientID
and s.ContractYear = @ContractYear


BEGIN TRY


declare @SnapshotID int = ( select SnapshotID from #snapshot )


	--// Update Snapshot Begin
	update s set 
		s.LastRunDate = getdate()
		, s.LastRunStatus = -1
	from cms.CMS_SnapshotTracker s
	where 1=1
	and s.SnapshotID = @SnapshotID


drop table if exists #DTP_INSERTED
create table #DTP__INSERTED
(
	DTPID int,
	SnapshotID int
)



	BEGIN TRAN



	INSERT INTO cms.DTP
	(
	   [ClaimID]
      ,[MTMServiceDT]
      ,[ReasonCode]
      ,[ActionCode]
      ,[ResultCode]
      ,[ClaimStatus]
      ,[ClaimStatusDT]
      ,[PatientID]
      ,[PharmacyID]
      ,[NCPDP_NABP]
      ,[DTPRecommendation]
      ,[GPI]
      ,[MedName]
      ,[SuccessfulResult]
	  ,[SnapshotID] 
      ,[CreateDT] 
      ,[ChangeDT]

	)
	OUTPUT INSERTED.DTPID, INSERTED.SnapshotID INTO #DTP__INSERTED

	SELECT DISTINCT
	   [ClaimID]
      ,[MTMServiceDT]
      ,[ReasonCode]
      ,[ActionCode]
      ,[ResultCode]
      ,[ClaimStatus]
      ,[ClaimStatusDT]
      ,[PatientID]
      ,[PharmacyID]
      ,[NCPDP_NABP]
      ,[DTPRecommendation]
      ,[GPI]
      ,[MedName]
      ,[SuccessfulResult]
	  ,[SnapshotID] = s.SnapshotID
      ,[CreateDT] =  cast(cast(getdate() as datetime2) as datetime)
      ,[ChangeDT] = cast(cast(stg.LoadDT as datetime2) as datetime)

	FROM OutcomesMTM.cmsETL.Snapshot_DTP_FromConnect stg
	join #snapshot s
	on s.ClientID = stg.ClientID
	and s.ContractYear = stg.ContractYear
	WHERE 1=1
	and s.SnapshotID = @SnapshotID
	and not exists (
						select 1
						from OutcomesMTM.cms.DTP b
						where 1=1
						and b.SnapshotID = s.SnapshotID
					)


	--// Update Snapshot Finish
	update s set 
		s.LastRunStatus = 1
	from cms.CMS_SnapshotTracker s
	where 1=1
	and s.SnapshotID = @SnapshotID



	COMMIT TRAN


END TRY


BEGIN CATCH
	
	IF(@@TRANCOUNT > 0)
		ROLLBACK TRAN;

	THROW;

END CATCH






