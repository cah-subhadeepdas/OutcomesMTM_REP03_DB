
CREATE    PROCEDURE [cms].[I_Snapshot_CMR] 
	@ClientID int ,
	@ContractYear int
AS

--// declare @ClientID int = 156; declare @ContractYear char(4) = '2018';


drop table if exists #snapshot
select s.*
into #snapshot
--from cms.CMS_SnapshotTracker s
from cms.vw_Snapshot s
where 1=1
and s.DataSetTypeID = 1
and cast(s.ActiveFromDT as date) >= '2019-01-25' 
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




drop table if exists #CMR_INSERTED
create table #CMR__INSERTED
(
	CMRID int
	, SnapshotID int
)



	BEGIN TRAN



	INSERT INTO cms.CMR
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
      ,[CMRWithSPT]
      ,[CMROffer]
      ,[CMRID_Source]
      ,[CognitivelyImpairedIndicator]
      ,[MethodOfDeliveryCode]
      ,[ProviderCode]
      ,[RecipientCode]
      ,[AuthorizedRepresentative]
      ,[Topic01]
      ,[Topic02]
      ,[Topic03]
      ,[Topic04]
      ,[Topic05]
      ,[MAPCount]
      ,[SPTDate]
      ,[LTC]
      ,[SnapshotID]
      ,[CreateDT]
      ,[ChangeDT]
	  ,[SPTReturnDate]
	  ,[CMRSuccess]
	)
	--OUTPUT INSERTED.CMRID, INSERTED.SnapshotID INTO #CMR__INSERTED

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
      ,[CMRWithSPT]
      ,[CMROffer]
      ,[CMRID_Source]
      ,[CognitivelyImpairedIndicator]
      ,[MethodOfDeliveryCode]
      ,[ProviderCode]
      ,[RecipientCode]
      ,[AuthorizedRepresentative]
      ,[Topic01]
      ,[Topic02]
      ,[Topic03]
      ,[Topic04]
      ,[Topic05]
      ,[MAPCount]
      ,[SPTDate]
      ,[LTC]
	  ,[SnapshotID] = s.SnapshotID
      ,[CreateDT] =  cast(cast(getdate() as datetime2) as datetime)
      ,[ChangeDT] = cast(cast(stg.LoadDT as datetime2) as datetime)
	  ,stg.SPTReturnDate
	  ,stg.CMRSuccess
     
	--// select top 100 *
	FROM OutcomesMTM.cmsETL.Snapshot_CMR_FromConnect stg
	join #snapshot s
		on s.ClientID = stg.ClientID
		and s.ContractYear = stg.ContractYear
	WHERE 1=1
	and s.SnapshotID = @SnapshotID
	and not exists (
		select 1
		from OutcomesMTM.cms.CMR b
		where 1=1
		and b.SnapshotID = s.SnapshotID
		)


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







