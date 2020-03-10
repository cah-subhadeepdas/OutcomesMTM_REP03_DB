
CREATE   PROCEDURE cms.ValidationStatusCheck_BatchKey
	@ValidationDataSet int
	, @BatchKey varchar(255)
	, @BatchValue varchar(255)
	, @ReturnSeverityLevelOnly char(1) = 'N'

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @ErrorCondition int = 0
	DECLARE @Return varchar(8000) = ''


	BEGIN TRY


		--// debugging:  declare @ValidationDataSet int = 1, @BatchKey varchar(255) = 'SnapshotID', @BatchValue varchar(255) = '506'
		drop table if exists #validationStatus
		select
			b.ValidationDataSet
			, b.BatchKey
			, b.BatchValue
			, vrr.ContractYear
			, vrr.ClientID
			, ContractNumber = isnull(vrr.ContractNumber,'')
			, FileID = ''
			, vrr.CreateDT
			, RulesChecked = isnull(count(distinct vrr.ValidationRuleConfigID),0)
			--, SeverityLevel = isnull(min( case when vrrr.ValidationRuleRunResultID is not null then vrr.SeverityLevel end ),0)
			, SeverityLevel = min( case when vrr.ValidationRuleRunID is null then 0 when vrrr.ValidationRuleRunResultID is not null then vrr.SeverityLevel else 99 end )
			, RulesMet = isnull(count(distinct vrrr.ValidationRuleRunID),0)
			, TotalResultsFound = isnull(count(distinct vrrr.ValidationRuleRunResultID),0)
			, TotalUIDFound = isnull(count(distinct vrrr.UIDValue),0)
			, ValidationRuleRunID_MIN = min(vrr.ValidationRuleRunID)
			, ValidationRuleRunID_MAX = max(vrr.ValidationRuleRunID)
		into #validationStatus
		from (
			select 
				ValidationDataSet = @ValidationDataSet
				, BatchKey = @BatchKey
				, BatchValue = @BatchValue
		) b
		left join cms.vw_ValidationRuleRun_Active vrr
			on vrr.ValidationDataSet = b.ValidationDataSet
			and vrr.BatchKey = b.BatchKey
			and vrr.BatchValue = b.BatchValue
		left join cms.ValidationRuleRunResult_new vrrr 
			on vrrr.ValidationRuleRunID = vrr.ValidationRuleRunID
			and vrrr.ValidationRuleResultStatus > 0
		where 1=1
		group by
			b.ValidationDataSet
			, b.BatchKey
			, b.BatchValue
			, vrr.ContractYear
			, vrr.ClientID
			, vrr.ContractNumber
			, vrr.CreateDT


		IF @ReturnSeverityLevelOnly = 'Y'
		BEGIN
			select SeverityLevel = cast( isnull(vs.SeverityLevel,0) as int)
			from #validationStatus vs
		END

		IF @ReturnSeverityLevelOnly <> 'Y'
		BEGIN
			select *
			from #validationStatus
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
