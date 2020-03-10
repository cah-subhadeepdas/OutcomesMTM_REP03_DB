


CREATE    PROCEDURE [cms].[S_BeneficiaryReport_Export_2019]
	@ClientID int null
	, @ContractYear char(4) null
	, @ContractNumber varchar(5) null
	, @BatchID int null
	, @FileType varchar(10)
	, @LogMessage char(1) = 'N'

AS
BEGIN

	SET NOCOUNT ON;


	DECLARE @Return varchar(8000) = ''
	DECLARE @ClientName varchar(255) = ''
	--DECLARE @ContractNumber varchar(255) = ''
	DECLARE @SeverityLevel_Min_Batch int
	DECLARE @Severity1_Count_Batch int
	DECLARE @Severity2_Count_Batch int
	DECLARE @Severity3_Count_Batch int



	IF ( ISNULL(@ClientID,0) <> 0 AND ISNULL(@ContractYear,'') <> '' AND ISNULL(@ContractNumber,'') <> '' )
	BEGIN
		BEGIN TRY
				SELECT @BatchID = bt2.BatchID
				FROM (
					select bt.BatchID, bt.ClientID, cl.clientName, bt.ContractYear, bt.ContractNumber, ranker = ROW_NUMBER() over (partition by bt.ClientID, bt.ContractYear, bt.ContractNumber order by bt.ActiveFromDT desc)
					from cms.CMS_rpt_Batch bt
					left join dbo.Client cl
						on cl.clientID = bt.ClientID
					where 1=1
					and bt.ActiveThruDT > getdate()
					and bt.ClientID = @ClientID
					and bt.ContractYear = @ContractYear
					and bt.ContractNumber = @ContractNumber
				) bt2
				WHERE 1=1
				AND bt2.ranker = 1
		END TRY
		BEGIN CATCH
			THROW;
		END CATCH
	END

	IF ( ISNULL(@BatchID,0) <> 0 )
	BEGIN
		BEGIN TRY
				SELECT @BatchID = bt2.BatchID
				FROM (
					select bt.BatchID, bt.ClientID, cl.clientName, bt.ContractYear, bt.ContractNumber, ranker = ROW_NUMBER() over (partition by bt.ClientID, bt.ContractYear, bt.ContractNumber order by bt.ActiveFromDT desc)
					from cms.CMS_rpt_Batch bt
					left join dbo.Client cl
						on cl.clientID = bt.ClientID
					where 1=1
					and bt.ActiveThruDT > getdate()
					and bt.BatchID = @BatchID
				) bt2
				WHERE 1=1
				AND bt2.ranker = 1
		END TRY
		BEGIN CATCH
			THROW;
		END CATCH
	END


	--// declare @BatchID int = 853
	drop table if exists #rpt
	select *
	into #rpt
	from cms.vw_BeneficiaryReport_Export_2019 rpt
	where 1=1
	and rpt.BatchID = @BatchID


	BEGIN TRY

		IF @FileType = 'FixedWidth'
		BEGIN
			
			SET @LogMessage = 'Y'

			select ALL_ELEMENTS = CONCAT(
				A_ContractNumber
				, B_HICNumber
				, C_FirstName
				, D_LastName
				, E_DOB
				, F_TargetingCriteriaMet
				, G_CognitivelyImpaired
				, H_LTCIndicator  --// added 2019
				, I_MTMPEnrollmentDate
				, J_MTMPTargetedDate
				, K_MTMPOptOutDate
				, L_MTMPOptOutReasonCode
				, M_CMROffered
				, N_CMROfferDate
				, O_CMROfferRecipientCode  --// added 2019
				, P_CMRReceived
				, Q_CMRReceivedDate1
				, R_CMRSPTSentDate  --// added 2019
				, S_CMRDeliveryMethod
				, T_CMRProviderCode
				, U_CMRRecipientCode
				, V_TMRCount
				, W_TMRFirstDate  --// added 2019
				, X_DTPRecommendationsCount
				, Y_DTPChangesCount 
				)
			from #rpt rpt
			where 1=1

		END


		IF @FileType = 'Delimited'
		BEGIN

			select
				A_ContractNumber
				, B_HICNumber
				, C_FirstName
				, D_LastName
				, E_DOB
				, F_TargetingCriteriaMet
				, G_CognitivelyImpaired
				, H_LTCIndicator  --// added 2019
				, I_MTMPEnrollmentDate
				, J_MTMPTargetedDate
				, K_MTMPOptOutDate
				, L_MTMPOptOutReasonCode
				, M_CMROffered
				, N_CMROfferDate
				, O_CMROfferRecipientCode  --// added 2019
				, P_CMRReceived
				, Q_CMRReceivedDate1
				, R_CMRSPTSentDate  --// added 2019
				, S_CMRDeliveryMethod
				, T_CMRProviderCode
				, U_CMRRecipientCode
				, V_TMRCount
				, W_TMRFirstDate  --// added 2019
				, X_DTPRecommendationsCount
				, Y_DTPChangesCount 
				, ValidationCheck_InternalQA_CSV
				, rpt.BatchID
				, rpt.ClientID
				, rpt.ContractYear
				, rpt.ContractNumber
			from #rpt rpt
			where 1=1

		END


		IF @LogMessage = 'Y'
		BEGIN

			SET @SeverityLevel_Min_Batch = ( select isnull(min(SeverityLevel_Min_Batch),0) from #rpt )
			SET @Severity1_Count_Batch = ( select isnull(min(Severity1_Count_Batch),0) from #rpt )
			SET @Severity2_Count_Batch = ( select isnull(min(Severity2_Count_Batch),0) from #rpt )
			SET @Severity3_Count_Batch = ( select isnull(min(Severity3_Count_Batch),0) from #rpt )
			SET @ClientName = ( select top 1 ClientName from #rpt )
			SET @ContractNumber = ( select top 1 ContractNumber from #rpt )

			IF @SeverityLevel_Min_Batch > 2  --// continue proc and report notification
				SET @Return = '[CMS_Process_Notification] Beneficiary Report generation for ' + cast(@ClientName as varchar(8000)) + ' (ID ' + cast(@ClientID as varchar(8000)) + '; Contract ' + cast(@ContractNumber as varchar(8000)) + ') completed successfully (Sev1: ' + cast(@Severity1_Count_Batch as varchar(8000)) + ', Sev2: ' + cast(@Severity2_Count_Batch as varchar(8000)) + ', Sev3: ' + cast(@Severity3_Count_Batch as varchar(8000)) + ')';

			IF @SeverityLevel_Min_Batch = 2  --// continue proc and report notification
				SET @Return = '[CMS_Process_Notification] [CMS_Process_Exception] Beneficiary Report generation for ' + cast(@ClientName as varchar(8000)) + ' (ID ' + cast(@ClientID as varchar(8000)) + '; Contract ' + cast(@ContractNumber as varchar(8000)) + ') completed with issues (Sev1: ' + cast(@Severity1_Count_Batch as varchar(8000)) + ', Sev2: ' + cast(@Severity2_Count_Batch as varchar(8000)) + ', Sev3: ' + cast(@Severity3_Count_Batch as varchar(8000)) + ')';

			IF @SeverityLevel_Min_Batch < 2  --// continue proc and report exception
				SET @Return = '[CMS_Process_Exception] Beneficiary Report generation for ' + cast(@ClientName as varchar(8000)) + ' (ID ' + cast(@ClientID as varchar(8000)) + '; Contract ' + cast(@ContractNumber as varchar(8000)) + ') stopped (Sev1: ' + cast(@Severity1_Count_Batch as varchar(8000)) + ', Sev2: ' + cast(@Severity2_Count_Batch as varchar(8000)) + ', Sev3: ' + cast(@Severity3_Count_Batch as varchar(8000))+ ')';
		END


		IF @Return <> ''
			EXEC xp_logevent 51000, @Return, informational;
			--PRINT @Return


	END TRY
	BEGIN CATCH

		IF ISNULL(@Return,'') <> ''
			PRINT @Return;
		ELSE
			THROW;

	END CATCH

END
