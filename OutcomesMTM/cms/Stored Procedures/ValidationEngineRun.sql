

CREATE   PROCEDURE [cms].[ValidationEngineRun]
	@ValidationDataSet int
	, @BatchKey varchar(255)
	, @BatchValue varchar(255)
	, @ReturnStatusRecord char(1) = 'Y'

AS
BEGIN

	SET NOCOUNT ON;


	DECLARE @ErrorCondition int = 0
	DECLARE @Return varchar(8000) = ''
	DECLARE @ValidationRuleConfigID varchar(max)
	DECLARE @ValidationFields varchar(max)
	DECLARE @ValidationSQL varchar(max)
	DECLARE @SQLStatement varchar(max)


	BEGIN TRY


		drop table if exists #ValidateThisBatchInfo
		create table #ValidateThisBatchInfo
		(
			ValidationDataSet int
			, BatchKey varchar(255)
			, BatchValue varchar(255)
			, ContractYear char(4)
			, CYFromDate date
			, CYThruDate date
			, CurrentDate date
			, ClientID int
		)


		--//  put any pre-CRUD work in this section; not writing to prod tables
		IF ( @ValidationDataSet not in (1,2,3) )	
		BEGIN
			SET @Return = 'Parameter value invalid: @ValidationDataSet. Accepted values include: 1,2,3';
			THROW 51000, @Return, 1;
		END
		

		--// Beneficiary Snapshot - cms.vw_CMS
		IF (@ValidationDataSet = 1)
		BEGIN

			IF ( @BatchKey <> 'SnapshotID' )
			BEGIN
				SET @Return = 'Parameter value invalid: @BatchKey. Accepted values (while @ValidationDataSet = 1) include: SnapshotID';
				THROW 51000, @Return, 1;
			END

			IF ( ISNUMERIC(@BatchValue) <> 1 )
			BEGIN
				SET @Return = 'Parameter value invalid: @BatchValue. Value must be an integer';
				THROW 51000, @Return, 1;
			END
			
			--//  debugging: declare @ValidationDataSet int = 1, @BatchKey varchar(255) = 'SnapshotID', @BatchValue varchar(255) = '556'
			drop table if exists #ValidateThis_1
			select 
				BatchKey = @BatchKey
				, BatchValue = @BatchValue
				, UIDKey = 'MTMPEnrollmentID'
				, UIDValue = bm.MTMPEnrollmentID
				, CYFromDate = cast( dateadd(year,datediff(year,0,bm.ContractYear),0) as date)
				, CYThruDate = cast( dateadd(year,datediff(year,-1,bm.ContractYear),-1) as date)
				, CurrentDate = cast(getdate() as date)
				, bm.BeneficiaryID
				, bm.ClientID
				, bm.ContractYear
				, bm.HICN
				, bm.First_Name
				, bm.MI
				, bm.Last_Name
				, bm.DOB
				, bm.SnapshotID
				, bm.ActiveFromDT
				, bm.ActiveThruDT
				, bm.IsCurrent
				, bm.MTMPEnrollmentID
				, bm.PatientID_All
				, bm.PatientID
				, bm.ContractNumber
				, bm.MTMPTargetingDate
				, bm.MTMPEnrollmentFromDate
				, bm.MTMPEnrollmentThruDate
				, bm.OptOutDate
				, bm.OptOutReasonCode
				, bm.MTMPEnrollmentThruDate_INFERRED
				, bm.OptOutDate_INFERRED
				, bm.OptOutReasonCode_INFERRED
			into #ValidateThis_1
			from cms.tvf_CMS(@BatchValue) bm
			where 1=1
			--and bm.SnapshotID = @BatchValue


			insert into #ValidateThisBatchInfo
			select distinct
				ValidationDataSet = @ValidationDataSet
				, BatchKey = @BatchKey
				, BatchValue = @BatchValue
				, ContractYear = vt.ContractYear
				, CYFromDate = vt.CYFromDate
				, CYThruDate = vt.CYThruDate
				, CurrentDate = vt.CurrentDate
				, ClientID = vt.ClientID
			from #ValidateThis_1 vt

		END


		--// Beneficiary Supplemental File Ingest - cmsETL.BeneficiarySF_IngestLog
		IF (@ValidationDataSet = 2)
		BEGIN

			IF ( @BatchKey <> 'FileID' )
			BEGIN
				SET @Return = 'Parameter value invalid: @BatchKey. Accepted values (while @ValidationDataSet = 2) include: FileID';
				THROW 51000, @Return, 1;
			END

			IF ( ISNUMERIC(@BatchValue) <> 1 )
			BEGIN
				SET @Return = 'Parameter value invalid: @BatchValue. Value must be an integer';
				THROW 51000, @Return, 1;
			END
			
			IF ( (select distinct FileID from cmsETL.BeneficiarySF_IngestLog sfil where 1=1 and sfil.FileID = @BatchValue) IS NULL )
			BEGIN
				SET @Return = 'Parameter value invalid: @BatchValue. FileID does not exist';
				THROW 51000, @Return, 1;
			END


			--// debugging:  declare @BatchKey varchar(255) = 'FileID', @BatchValue varchar(255) = '1324', @ValidationDataSet int = 2
			drop table if exists #ValidateThis_2
			select distinct
				BatchKey = @BatchKey
				, BatchValue = @BatchValue
				, UIDKey = 'IngestLogID'
				, UIDValue = sfil.IngestLogID
				, ContractYear = cast( year(dateadd(quarter,-1, sfil.IngestLogDT)) as char(4))
				, CYFromDate = cast( dateadd(year,datediff(year,0, dateadd(quarter,-1, sfil.IngestLogDT) ),0) as date)
				, CYThruDate = cast( dateadd(year,datediff(year,-1, dateadd(quarter,-1, sfil.IngestLogDT) ),-1) as date)
				, CurrentDate = cast(getdate() as date)
				, ClientID = ( select top 1 cl.ClientID from OutcomesMTM.dbo.Client cl with (nolock) where cl.ClientName = sfil.ClientName )
				, Patient_ClientID = ( select top 1 m.ClientID from cms.CMS_MTMPEnrollment_History m with (nolock) where m.PatientID = sfil.OMTM_ID and m.LastRunStatus = 1 order by m.ActiveFromDT desc )
				, MTMPEnrollmentThruDate_Inferred = case 
						when sfil.OptOutDate = '' then cast( dateadd(year,datediff(year,-1, dateadd(quarter,-1, sfil.IngestLogDT) ),-1) as date)
						when sfil.OptOutDate <> '' and isdate(sfil.OptOutDate) = 1 then cast(sfil.OptOutDate as date)
						end			
				, sfil.IngestLogID
				, sfil.IngestLogDT
				, sfil.FileID
				, sfil.OMTM_ID
				, sfil.ClientName
				, sfil.MemberID
				, sfil.FirstName
				, sfil.MiddleInitial
				, sfil.LastName
				, sfil.DOB
				, sfil.HICN_MBI
				, sfil.ContractNumber
				, sfil.MTMPEnrollmentStartDate
				, sfil.MTMPTargetingDate
				, sfil.OptOutDate
				, sfil.OptOutReasonCode
				, sfil.BeneficiaryMatchCheck
				, sfil.ValidationCheck
				, sfil.ActionRequiredOnCheck
				, sfil.BeneficiaryMatch_OMTM_IDs
				, sfil.SelectMasterOMTM_ID
				, sfil.RemoveMember
			into #ValidateThis_2
			from cmsETL.BeneficiarySF_IngestLog sfil
			where 1=1
			and sfil.FileID = @BatchValue

			insert into #ValidateThisBatchInfo
			select top 1
				ValidationDataSet = @ValidationDataSet
				, BatchKey = @BatchKey
				, BatchValue = @BatchValue
				, ContractYear = vt.ContractYear
				, CYFromDate = vt.CYFromDate
				, CYThruDate = vt.CYThruDate
				, CurrentDate = vt.CurrentDate
				, ClientID = vt.ClientID
			from #ValidateThis_2 vt
			where ClientID is not null

		END


		--// CMS Beneficiary Report - cms.rpt_Report_Log
		IF (@ValidationDataSet = 3)
		BEGIN
	
			IF ( @BatchKey <> 'BatchID' )
			BEGIN
				SET @Return = 'Parameter value invalid: @BatchKey. Accepted values (while @ValidationDataSet = 3) include: BatchID';
				THROW 51000, @Return, 1;
			END

			IF ( ISNUMERIC(@BatchValue) <> 1 )
			BEGIN
				SET @Return = 'Parameter value invalid: @BatchValue. Value must be an integer';
				THROW 51000, @Return, 1;
			END	

			--// declare @BatchKey varchar(8000) = 'BatchID', @BatchValue varchar(8000) = '393'
			drop table if exists #ValidateThis_3
			select
				BatchKey = @BatchKey
				, BatchValue = @BatchValue
				, UIDKey = 'ReportLogID'
				, UIDValue = rptl.ReportLogID
				, ContractYear = bt.ContractYear
				, CYFromDate = cast( dateadd(year,datediff(year,0,bt.ContractYear),0) as date)
				, CYThruDate = cast( dateadd(year,datediff(year,-1,bt.ContractYear),-1) as date)
				, CurrentDate = cast(getdate() as date)
				, rptl.ReportLogID
				, rptl.BatchID
				, rptl.ReportID
				, rptl.ClientID
				, rptl.BeneficiaryID
				, rptl.BeneficiaryKey
				, rptl.ContractNumber
				, rptl.HICN
				, rptl.FirstName
				, rptl.MI
				, rptl.LastName
				, rptl.DOB
				, rptl.MTMPCriteriaMet
				, rptl.MTMPEnrollmentFromDate
				, rptl.MTMPEnrollmentThruDate
				, rptl.MTMPTargetingDate
				, rptl.OptOutDate
				, rptl.OptOutReasonCode
				, rptl.CMROffered
				, rptl.CMROfferDate
				, rptl.CMRReceived
				, rptl.CMR_Count
				, rptl.CMR_CognitivelyImpairedIndicator
				, rptl.CMR_MethodOfDeliveryCode
				, rptl.CMR_ProviderCode
				, rptl.CMR_RecipientCode
				, rptl.CMR_Date1
				, rptl.CMR_Date2
				, rptl.CMR_Date3
				, rptl.CMR_Date4
				, rptl.CMR_Date5
				, rptl.CMR_Topic1
				, rptl.CMR_Topic2
				, rptl.CMR_Topic3
				, rptl.CMR_Topic4
				, rptl.CMR_Topic5
				, rptl.TMR_Count
				, rptl.DTPR_Count
				, rptl.DTPC_Count
				, rptl.CMROfferRecipientCode
				, rptl.LTCIndicator
				, rptl.CMR_SPTSentDate
				, rptl.TMR_Date1
			into #ValidateThis_3
			--// select top 100 *
			from cms.rpt_Report_Log rptl
			join cms.CMS_rpt_Batch bt
				on bt.BatchID = rptl.BatchID
			where 1=1
			and rptl.BatchID = @BatchValue


			insert into #ValidateThisBatchInfo
			select distinct
				ValidationDataSet = @ValidationDataSet
				, BatchKey = @BatchKey
				, BatchValue = @BatchValue
				, ContractYear = vt.ContractYear
				, CYFromDate = vt.CYFromDate
				, CYThruDate = vt.CYThruDate
				, CurrentDate = vt.CurrentDate
				, ClientID = vt.ClientID
			from #ValidateThis_3 vt

		END		
		
		
		--//  debugging:  declare @ValidationDataSet int = 2
		drop table if exists #ValidationRules
		select 
			vr.*
			, ProcessFlag = 0
			, SQLStatement = replace( replace( vr.ValidationSQL,'/*{@ValidationRuleID},*/','ValidationRuleConfigID = '+cast(vr.ValidationRuleConfigID as nvarchar(max))+', ' ), '#ValidateThis', '#ValidateThis_'+cast(vr.ValidationDataSet as nvarchar(max))+' ' )
		into #ValidationRules
		--// select *
		from cms.ValidationRuleConfig vr
		where 1=1
		and vr.Active = 1
		and vr.ValidationDataset = @ValidationDataSet


		drop table if exists #ValidationResult
		create table #ValidationResult
		(
			BatchKey varchar(255)
			, BatchValue varchar(255)
			, UIDKey varchar(255)
			, UIDValue varchar(255)
			, ValidationRuleConfigID int
			, ValidationCriteriaMet tinyint
			, ValidationData nvarchar(max)
		)


		--// loop through each ValidationRule, build dynamic SQL and execute
		--// debugging:  declare @ValidationDataSet int = 2, @ValidationRuleConfigID int, @ValidationFields nvarchar(max), @ValidationSQL nvarchar(max), @SQLStatement nvarchar(max)
		WHILE ( (select Cnt = count(*) from #ValidationRules where ProcessFlag = 0) ) > 0
		BEGIN
			
			set @ValidationRuleConfigID = ( select top 1 ValidationRuleConfigID from #ValidationRules where ProcessFlag = 0 order by ValidationRuleConfigID )


			update vr set vr.ProcessFlag = -1
			from #ValidationRules vr
			where 1=1
			and vr.ValidationRuleConfigID = @ValidationRuleConfigID

			--// debugging: declare @ValidationFields nvarchar(max), @ValidationSQLPredicate nvarchar(max), @ValidationRuleConfigID int
			select @ValidationSQL = vr.SQLStatement
			from #ValidationRules vr
			where 1=1
			and vr.ValidationRuleConfigID = @ValidationRuleConfigID


			set @SQLStatement  = '
				insert into #ValidationResult '+cast(@ValidationSQL as nvarchar(max))

			exec (@SQLStatement)
			--print @SQLStatement

			update vr set
				vr.ProcessFlag = 1
				, vr.SQLStatement = @SQLStatement
			from #ValidationRules vr
			where 1=1
			and vr.ValidationRuleConfigID = @ValidationRuleConfigID

		END



		--// debugging: @ErrorCondition int = 0, @Return varchar(8000) = ''
		BEGIN TRANSACTION

			drop table if exists #ValidationRuleRun__INSERTED
			create table #ValidationRuleRun__INSERTED
			(
				ValidationRuleRunID int
				, ValidationRuleConfigID int
				, BatchKey varchar(255)
				, BatchValue varchar(255)
				, ClientID int
				, ContractYear char(4)
				, ContractNumber varchar(5)
				, Active bit
				, CreateDT datetime
				, ChangeDT datetime
			)

			drop table if exists #ValidationRuleRunResult__INSERTED
			create table #ValidationRuleRunResult__INSERTED
			(
				VallidationRuleRunResultID bigint
				, ValidationRuleRunID int
				, ValidationRuleResultStatus int
				, ValidationData nvarchar(max)
				, UIDKey varchar(255)
				, UIDValue varchar(255)
			)

			insert into cms.ValidationRuleRun_new
			(
				ValidationRuleConfigID
				, BatchKey
				, BatchValue
				, ClientID
				, ContractYear
			)
				output inserted.* into #ValidationRuleRun__INSERTED
			select 
				ValidationRuleConfigID = vr.ValidationRuleConfigID
				, BatchKey = vtbi.BatchKey
				, BatchValue = vtbi.BatchValue
				, ClientID = isnull((select distinct ClientID from #ValidateThisBatchInfo),0)
				, ContractYear = isnull((select distinct ContractYear from #ValidateThisBatchInfo),0)
			from #ValidationRules vr
			, #ValidateThisBatchInfo vtbi


			insert into cms.ValidationRuleRunResult_new
			(
				ValidationRuleRunID
				, ValidationRuleResultStatus
				, ValidationData
				, UIDKey
				, UIDValue
			)
				output inserted.ValidationRuleRunResultID, inserted.ValidationRuleRunID, inserted.ValidationRuleResultStatus, inserted.ValidationData, inserted.UIDKey, inserted.UIDValue into #ValidationRuleRunResult__INSERTED
			select
				ValidationRuleRunID = rr.ValidationRuleRunID
				, ValidationRuleResultStatus = vr.ValidationCriteriaMet
				, ValidationData = vr.ValidationData
				, UIDKey = vr.UIDKey
				, UIDValue = vr.UIDValue
			from #ValidationResult vr
			join #ValidationRuleRun__INSERTED rr
				on rr.ValidationRuleConfigID = vr.ValidationRuleConfigID


		--//  use this to check for error conditions to exit the proc (if used inside begin/commit transaction, the tran will be rolled back when the condition is met; otherwise, the tran will be committed)
		IF @ErrorCondition <> 0
		BEGIN
			SET @Return = 'Error Condition Met; Transaction Rolled Back.';  --// can customize return message
			THROW 51000, @Return, 1;
		END

		IF XACT_STATE() = 1 COMMIT TRANSACTION;


		IF @ReturnStatusRecord = 'Y'
		BEGIN

			--// return 1 record back to show results/status	
			select distinct
				vtbi.ValidationDataSet
				, vtbi.BatchKey
				, vtbi.BatchValue
				, vtbi.ContractYear
				, vtbi.CYFromDate
				, vtbi.CYThruDate
				, vtbi.CurrentDate
				, vtbi.ClientID
				, vrrr.SeverityLevel
				, vrrr.RulesChecked
				, vrrr.RulesMet
				, vrrr.TotalResultsFound
				, vrrr.TotalUIDFound
				, vrrr.ValidationRuleRunID_MIN
				, vrrr.ValidationRuleRunID_MAX
			from #ValidateThisBatchInfo vtbi
			outer apply (
				select 
					RulesChecked = isnull(count(distinct vrr.ValidationRuleConfigID),0)
					, SeverityLevel = isnull(min(vrg.SeverityLevel),99)
					, RulesMet = isnull(count(distinct vrrr.ValidationRuleRunID),0)
					, TotalResultsFound = isnull(count(distinct vrrr.VallidationRuleRunResultID),0)
					, TotalUIDFound = isnull(count(distinct vrrr.UIDValue),0)
					, ValidationRuleRunID_MIN = min(vrr.ValidationRuleRunID)
					, ValidationRuleRunID_MAX = max(vrr.ValidationRuleRunID)
				from #ValidationRuleRun__INSERTED vrr
				join cms.ValidationRuleConfig vrg
					on vrg.ValidationRuleConfigID = vrr.ValidationRuleConfigID
				left join #ValidationRuleRunResult__INSERTED vrrr
					on vrrr.ValidationRuleRunID = vrr.ValidationRuleRunID
					and vrrr.ValidationRuleResultStatus > 0
				where 1=1
			) vrrr

		END

	END TRY
	BEGIN CATCH

		IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

		IF ISNULL(@Return,'') <> ''
			PRINT @Return;
		ELSE
			THROW;

	END CATCH


END
