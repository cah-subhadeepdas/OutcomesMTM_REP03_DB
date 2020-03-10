


create      PROCEDURE [cms].[I_Snapshot_CMROffer] 	
	@FileLoadId int
AS

BEGIN TRY

BEGIN TRAN

--declare @FileLoadId int = 1

declare   @ClientID int ,	@ContractYear int , @Return varchar(100)


----Throw an error if any of the clientid is invalid.
IF (select count(*) from (select OMTM_CLIENT_ID from cmsETL.CMROfferFileLoadStage where FileLoadId =  @FileLoadId group by OMTM_CLIENT_ID) cms left join dbo.Client c on c.clientID = cms.[OMTM_CLIENT_ID] where  cms.OMTM_CLIENT_ID is null  ) > 0
		BEGIN
			SET @Return = 'ClientId is not valid; FileloadId : ' + cast(@FileLoadId as varchar) + ' ingest was rolled back.';  --// can customize return message
			THROW 51000, @Return, 1;
		END

ELSE
BEGIN
-- Insert the master record to the SnapshotTracker
insert into [OutcomesMTM].[cms].[CMS_SnapshotTracker] ([DataSetTypeID] , [ClientID] , [ContractYear] , [LastRunStatus])
select top 1  6 , [OMTM_CLIENT_ID] , year([CMR_OFFER_DATE]) , -1 from cmsETL.CMROfferFileLoadStage where FileLoadId =  @FileLoadId 



select  top 1  @ClientID =  [OMTM_CLIENT_ID],  @ContractYear = year([CMR_OFFER_DATE])   from cmsETL.CMROfferFileLoadStage where FileLoadId =  @FileLoadId 


drop table if exists #snapshot
select top 1 
       s.[SnapshotID]
      ,s.[DataSetTypeID]
      ,s.[ClientID]
      ,s.[ContractYear]
      ,s.[ActiveFromDT]
      ,s.[ActiveThruDT]
into #snapshot
from cms.CMS_SnapshotTracker s
where 1=1
and s.DataSetTypeID = 6
and s.LastRunStatus = -1
--and cast(s.ActiveFromDT as date) >=  --'2019-01-25' 
and s.ClientID = @ClientID
and s.ContractYear = @ContractYear
order by SnapshotID  desc



declare @SnapshotID int = ( select SnapshotID from #snapshot )

--select top 2 * from cms.CMS_SnapshotTracker order by snapshotid desc

	--// Update Snapshot Begin
	update s set 
		s.LastRunDate = getdate()
		--, s.LastRunStatus = -1
	from cms.CMS_SnapshotTracker s
	where 1=1
	and s.SnapshotID = @SnapshotID


	insert into cms.CMROfferSupplemental 
	( SourceSystem 
	, PatientID
	, PatientID_All
	, ClientID
	, CMROfferDate
	, CMROfferModality
	, SnapshotID
	, CMROfferRecipient 
	, CMROfferReturnDate )
	
	select 
	c.clientName, 
	p.PatientID ,
	cmros.MEMBER_ID ,  
	cmros.OMTM_CLIENT_ID , 
	cmros.CMR_OFFER_DATE , 
	cmros.CMR_OFFER_MODALITY , 
	@SnapshotID , 
	cmros.CMR_OFFER_RECIPIENT , 
	cmros.CMR_OFFER_RETURN_DATE
	 
	from cmsETL.CMROfferFileLoadStage cmros
	left join dbo.Client c on cmros.OMTM_CLIENT_ID = c.clientID
	left join  OutcomesMTM.dbo.PatientDim p on p.PatientID_All = cmros.MEMBER_ID and p.isCurrent = 1
	where 1=1
	and cmros.FileLoadId = @FileLoadId
	and cmros.PublishTime is null 

	update cmros set 
	     cmros.PublishTime = getdate()
	from cmsETL.CMROfferFileLoadStage cmros
	where 1=1
	and cmros.FileLoadId = @FileLoadId
	and cmros.PublishTime is null 
	

	update s set 
		s.LastRunStatus = 1
	from cms.CMS_SnapshotTracker s
	where 1=1
	and s.SnapshotID = @SnapshotID

	



	--// Add validation logic here
	/*
	IF 
	THROW 51000, 'Error message here.', 1;

	*/

END

COMMIT TRAN

	


END TRY
BEGIN CATCH

		IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

		IF ISNULL(@Return,'') <> ''
			print @Return ;
		ELSE
			THROW;

END CATCH

