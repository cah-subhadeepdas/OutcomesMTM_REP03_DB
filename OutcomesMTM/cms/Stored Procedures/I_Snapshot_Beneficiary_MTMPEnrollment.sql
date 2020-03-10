

CREATE   PROCEDURE [cms].[I_Snapshot_Beneficiary_MTMPEnrollment] 
	@ClientID int
	, @ContractYear int
AS

BEGIN

	DECLARE @Return varchar(8000) = ''
	DECLARE @SnapshotID int

	--// debugging >>  declare @ClientID int = 94, @ContractYear char(4) = '2019'
	drop table if exists #snapshot
	select top 1 s.*
	into #snapshot
	from cms.CMS_SnapshotTracker s
	where 1=1
	and s.ActiveThruDT > getdate()
	and s.LastRunStatus = 0
	and s.DataSetTypeID = 2
	and s.ClientID = @ClientID
	and s.ContractYear = @ContractYear
	order by s.ActiveFromDT desc


	BEGIN TRY


		SET @SnapshotID = ( select SnapshotID from #snapshot )


		--// Update Snapshot Begin
		update s set 
			s.LastRunDate = getdate()
			, s.LastRunStatus = -1
		from cms.CMS_SnapshotTracker s
		where 1=1
		and s.SnapshotID = @SnapshotID


		drop table if exists #Beneficiary__INSERTED
		create table #Beneficiary__INSERTED
		(
			BeneficiaryID int
			, SnapshotID int
		)


		drop table if exists #BeneficiaryPatient__INSERTED
		create table #BeneficiaryPatient__INSERTED
		(
			BeneficiaryPatientID int
			, SnapshotID int
		)


		drop table if exists #MTMPEnrollment__INSERTED
		create table #MTMPEnrollment__INSERTED
		(
			MTMPEnrollmentID int
			, SnapshotID int
		)


		--BEGIN TRANSACTION


			INSERT INTO cms.Beneficiary
			(
				ClientID
				, ContractYear
				, BeneficiaryKey
				, HICN
				, First_Name
				, MI
				, Last_Name
				, DOB
				, CreateDT_Source
				, ChangeDT_Source
				, SnapshotID
			)
			OUTPUT INSERTED.BeneficiaryID, INSERTED.SnapshotID INTO #Beneficiary__INSERTED

			SELECT DISTINCT
				ClientID = cast(stg.ClientID as int)
				, ContractYear = cast(stg.ContractYear as char(4))
				, BeneficiaryKey = cast(stg.PatientID as int)
				, HICN = isnull(cast(stg.HICN as varchar(15)),'')
				, First_Name = cast(stg.First_Name as varchar(30))
				, MI = isnull(cast(stg.MI as varchar(1)),'')
				, Last_Name = cast(stg.Last_Name as varchar(30))
				, DOB = cast(stg.DOB as date)
				, CreateDT_Source = cast(cast(stg.ActiveFromDT as datetime2) as datetime)
				, ChangeDT_Source = cast(cast(stg.ActiveFromDT as datetime2) as datetime)
				, SnapshotID = s.SnapshotID

			FROM OutcomesMTM.cmsETL.Snapshot_Beneficiary_FromConnect stg
			join #snapshot s
				on s.ClientID = stg.ClientID
				and s.ContractYear = stg.ContractYear
			WHERE 1=1
			and s.SnapshotID = @SnapshotID
			and not exists (
				select 1
				from OutcomesMTM.cms.Beneficiary b
				where 1=1
				and b.SnapshotID = s.SnapshotID
				)



			INSERT INTO cms.BeneficiaryPatient
			(
				BeneficiaryID
				, PatientID
				, SnapshotID
			)
			OUTPUT INSERTED.BeneficiaryPatientID, INSERTED.SnapshotID INTO #BeneficiaryPatient__INSERTED

			SELECT DISTINCT
				BeneficiaryID = b.BeneficiaryID
				, PatientID = cast(b.BeneficiaryKey as int)
				, SnapshotID = b.SnapshotID
			FROM OutcomesMTM.cms.Beneficiary b
			JOIN #Beneficiary__INSERTED i
				on i.BeneficiaryID = b.BeneficiaryID
				and i.SnapshotID = b.SnapshotID
			WHERE 1=1
			and b.SnapshotID = @SnapshotID
			and not exists (
				select 1
				from OutcomesMTM.cms.BeneficiaryPatient bp
				where 1=1
				and bp.SnapshotID = b.SnapshotID
				)



			INSERT INTO cms.MTMPEnrollment
			(
				PatientID
				, PatientID_All
				, PolicyID
				, ClientID
				, ContractYear
				, ContractNumber
				, MTMPTargetingDate
				, MTMPEnrollmentFromDate
				, MTMPEnrollmentThruDate
				, OptOutDate
				, OptOutReasonCode
				, CreateDT_Source
				, ChangeDT_Source
				, SnapshotID
			)
			OUTPUT INSERTED.MTMPEnrollmentID, INSERTED.SnapshotID INTO #MTMPEnrollment__INSERTED

			SELECT DISTINCT
				PatientID = cast(stg.PatientID as int)
				, PatientID_All = ''
				, PolicyID = cast(stg.PolicyID as int)
				, ClientID = cast(stg.ClientID as int)
				, ContractYear = cast(stg.ContractYear as char(4))
				, ContractNumber = cast(stg.ContractNumber as varchar(5))
				, MTMPTargetingDate = cast(stg.MTMPTargetingDate as date)
				, MTMPEnrollmentFromDate = cast(stg.MTMPEnrollmentFromDate_Actual as date)
				, MTMPEnrollmentThruDate = cast(stg.MTMPEnrollmentThruDate as date)
				, OptOutDate = case when stg.MTMPEnrollmentThruDate < cast(cast(s.ContractYear as char(4)) + '1231' as date) then stg.MTMPEnrollmentThruDate else NULL end
				, OptOutReasonCode = case when isnull(cast(stg.OptOutReasonCode as varchar(2)),'') not in ('01','02','03','04') then '' else cast(stg.OptOutReasonCode as varchar(2)) end
				, CreateDT_Source = cast(cast(stg.ActiveFromTT as datetime2) as datetime)
				, ChangeDT_Source = cast(cast(stg.ActiveFromTT as datetime2) as datetime)
				, SnapshotID = s.SnapshotID
			FROM OutcomesMTM.cmsETL.Snapshot_MMTPEnrollment_FromConnect stg
			join #snapshot s
				on s.ClientID = stg.ClientID
				and s.ContractYear = stg.ContractYear
			WHERE 1=1
			and s.SnapshotID = @SnapshotID
			and not exists (
				select 1
				from OutcomesMTM.cms.MTMPEnrollment mtmp
				where 1=1
				and  mtmp.SnapshotID = s.SnapshotID
				)

		--IF XACT_STATE() = 1 COMMIT TRANSACTION;


		--// Update Snapshot Finish
		update s set 
			s.LastRunStatus = 1
		from cms.CMS_SnapshotTracker s
		where 1=1
		and s.SnapshotID = @SnapshotID


		--// Clean up staging tables
		TRUNCATE TABLE OutcomesMTM.cmsETL.Snapshot_Beneficiary_FromConnect
		TRUNCATE TABLE OutcomesMTM.cmsETL.Snapshot_MMTPEnrollment_FromConnect


		--// Run Validation
		EXECUTE cms.I_Beneficiary_MTMPEnrollment_Validation
			@ClientID = @ClientID
			, @ContractYear = @ContractYear
		;

		----// Run Validation
		--EXECUTE cms.ValidationEngineRun
		--	@ValidationDataSet = 1
		--	, @BatchKey = 'SnapshotID'
		--	, @BatchValue = @SnapshotID
		--;


		--//  Queue SF Export
		EXECUTE cms.I_SFExportProcess_Queue
			@ClientID = @ClientID
			, @ContractYear = @ContractYear
		;


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
			SET @Return = '[CMS_Process_Exception] I_Snapshot_Beneficiary_MTMPEnrollment: ' + (select * from ( select ContractYear = @ContractYear, ClientID = @ClientID, ErrorProcedure = ERROR_PROCEDURE(), ErrorLine = ERROR_LINE(), ErrorMessage = ERROR_MESSAGE() ) r for json auto );
			EXEC xp_logevent 51000, @Return, informational;
			PRINT @Return;
		END

	END CATCH


END
