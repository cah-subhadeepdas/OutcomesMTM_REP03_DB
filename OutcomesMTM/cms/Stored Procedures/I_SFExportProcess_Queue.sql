
CREATE   PROCEDURE cms.I_SFExportProcess_Queue
	@ClientID int
	, @ContractYear char(4)

AS
BEGIN

	SET NOCOUNT ON;


	--// declare local variables
	DECLARE @ErrorCondition int = 0
	DECLARE @Return varchar(8000) = ''


	BEGIN TRY

		--//  declare @ClientID int = 94, @ContractYear char(4) = '2019'
		drop table if exists #snapshot
		select top 1 s.*
		into #snapshot
		from cms.CMS_SnapshotTracker s
		where 1=1
		and s.DataSetTypeID = 2
		and s.ActiveThruDT > getdate()
		and s.LastRunStatus = 1
		and s.ClientID = @ClientID
		and s.ContractYear = @ContractYear
		order by s.LastRunDate desc

		IF ( select count(*) from #snapshot ) <> 1
		BEGIN
			SET @Return = '[CMS_Process_Exception] I_SFExportProcess_Queue: No active SnapshotID for parameters ' + ( select * from ( select ContractYear = @ContractYear, ClientID = @ClientID ) r for json auto );
			THROW 51000, @Return, 1;
		END


		BEGIN TRANSACTION
		

			insert into cms.SFExportProcess_Queue
			(
				s.ClientID
				, s.ContractYear
				, s.SnapshotID
			)
			select
				ClientID
				, ContractYear
				, SnapshotID
			from #snapshot s
			where 1=1
			and s.SnapshotID is not null


		IF XACT_STATE() = 1 COMMIT TRANSACTION;


	END TRY
	BEGIN CATCH

		IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

		IF ISNULL(@Return,'') <> ''
		BEGIN
			EXEC xp_logevent 51000, @Return, informational;
			PRINT @Return;
		END
		ELSE
		BEGIN
			SET @Return = '[CMS_Process_Exception] I_SFExportProcess_Queue: ' + (select * from ( select ContractYear = @ContractYear, ClientID = @ClientID, ErrorProcedure = ERROR_PROCEDURE(), ErrorLine = ERROR_LINE(), ErrorMessage = ERROR_MESSAGE() ) r for json auto );
			EXEC xp_logevent 51000, @Return, informational;
			PRINT @Return;
			--THROW;
		END

	END CATCH

END
