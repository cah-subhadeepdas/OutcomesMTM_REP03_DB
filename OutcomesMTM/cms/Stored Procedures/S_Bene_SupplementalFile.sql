

CREATE   PROCEDURE [cms].[S_Bene_SupplementalFile]
	@ClientID int
	, @ContractYear char(4) = ''
	, @IncludeQACheck char(1) = 'N'
	, @LogMessage char(1) = 'Y'
	, @ThruDate date = null

AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


		DECLARE @Return varchar(8000) = ''
		DECLARE @ClientName varchar(255) = ''
		DECLARE @ContractNumber varchar(255) = ''
		DECLARE @SeverityLevel_Min_Batch int
		DECLARE @Severity1_Count_Batch int
		DECLARE @Severity2_Count_Batch int
		DECLARE @Severity3_Count_Batch int



	BEGIN TRY

		IF isnull(@ContractYear,'') = ''
			SET @ContractYear = ( select top 1 ContractYear
								from cms.CMS_SnapshotTracker
								where DataSetTypeID = 2
								and ActiveThruDT > getdate()
								order by ContractYear desc )

		IF isnull(@Thrudate,'19000101') not between cast(@ContractYear + '0101' as date) and cast(@ContractYear + '1231' as date)
			SET @Thrudate = cast(@ContractYear + '1231' as date)


		--//  declare @ClientID int = 156, @ContractYear char(4) = '2019';
		DECLARE @SnapshotID int = (
				select st.SnapshotID
				from cms.CMS_SnapshotTracker st
				where 1=1
				and st.DataSetTypeID = 2
				and st.ActiveThruDT > getdate()
				and st.LastRunStatus = 1
				and st.ClientID = @ClientID
				and st.ContractYear = @ContractYear
		)

		--//  declare @ClientID int = 147, @ContractYear char(4) = '2019';
		drop table if exists #benemtmp
		select distinct
			 [ClientName] = c.clientname									
			,[ClientID]	= bm.ClientiD										
			,[PatientID] = bm.patientid									
			,[MemberID]= ptd.PatientID_All								
			,[FirstName] = case when bm.First_Name is not null then bm.First_Name else '' end																	
			,[LastName] = case when bm.Last_Name is not null then bm.Last_Name else '' end									
			,[DOB] = convert(char(8), bm.DOB, 112)											
			,[HICN_MBI] = bm.HICN										
			,[ContractNumber] = bm.ContractNumber							
			,[MTMPEnrollmentStartDate] = convert(char(8), bm.MTMPEnrollmentFromDate, 112)				
			,[MTMPTargetingDate] = convert(char(8), bm.MTMPTargetingDate, 112)							
			,[OptOutDate] = case 
								when bm.OptOutDate is not null then convert(char(8),bm.MTMPEnrollmentThruDate, 112)
								else ''
							end																			
			,[OptOutReasonCode] = case when isnull(right('00' + bm.OptOutReasonCode,2),'') not in ('01','02','03','04', '99') then '' else cast(bm.OptOutReasonCode as varchar(2)) end						
			,[ContractYear] = bm.ContractYear
			,bm.MTMPEnrollmentID
			,bm.SnapshotID
		into #benemtmp
		--from cms.vw_CMS bm
		from cms.tvf_CMS(@SnapshotID) bm
		left join outcomesmtm.dbo.patientdim ptd with (nolock)
			on bm.patientid = ptd.patientid
			and ptd.isCurrent = 1
		left join outcomesmtm.dbo.client c with (nolock)
			 on bm.ClientID = c.ClientID	
		where 1=1
		--and bm.ClientID = @ClientID
		--and bm.ContractYear = @ContractYear
		;


		drop table if exists #vrrr
		select distinct vrr.*, vrrr.ValidationRuleRunResultID, vrrr.UIDKey, vrrr.UIDValue, vrrr.ValidationRuleResultStatus, vrrr.ValidationData
		into #vrrr
		--// select *
		from #benemtmp bm	
		left join cms.vw_ValidationRuleRun_Active vrr
			on vrr.ValidationDataSet = 1
			and vrr.BatchKey = 'SnapshotID'
			and vrr.BatchValue = bm.SnapshotID
		left join cms.ValidationRuleRunResult_new vrrr with (nolock)
			on vrrr.ValidationRuleRunID = vrr.ValidationRuleRunID
			and vrrr.UIDKey = 'MTMPEnrollmentID'
			and vrrr.UIDValue = bm.MTMPEnrollmentID
			and vrrr.ValidationRuleResultStatus > 0
		where 1=1
		;


		drop table if exists #vrp
		select vrp.*
		into #vrp
		from (
			select distinct
				vrrr.ValidationDataSet
				, vrrr.BatchKey
				, vrrr.BatchValue
				, vrrr.CreateDT
				, vrrr.ClientID
				, vrrr.ContractYear
				, vrrr.FileID
				, vrrr.ContractNumber
				, vrrr.UIDKey
				, vrrr.UIDValue
				, Severity1_Count_Batch = sum( case when vrrr.SeverityLevel = 1 then 1 else 0 end ) over (partition by vrrr.ValidationDataSet, vrrr.BatchKey, vrrr.BatchValue)
				, Severity2_Count_Batch = sum( case when vrrr.SeverityLevel = 2 then 1 else 0 end ) over (partition by vrrr.ValidationDataSet, vrrr.BatchKey, vrrr.BatchValue)
				, Severity3_Count_Batch = sum( case when vrrr.SeverityLevel = 3 then 1 else 0 end ) over (partition by vrrr.ValidationDataSet, vrrr.BatchKey, vrrr.BatchValue)
				, ValidationCheck_InternalQA_CSV = stuff((  --// ValidationRuleDescription
							select '|' + vrrr2.ValidationRuleDescription
							from #vrrr vrrr2
							where 1=1
							and vrrr.BatchKey = vrrr2.BatchKey
							and vrrr.BatchValue = vrrr2.BatchValue
							and vrrr.CreateDT = vrrr2.CreateDT
							and vrrr.UIDKey = vrrr2.UIDKey
							and vrrr.UIDValue = vrrr2.UIDValue
							and isnull(vrrr2.ValidationRuleDescription,'') <> ''
							order by vrrr2.ValidationRuleDescription
							for XML PATH('')), 1, 1, '')
				, ValidationCheck_InternalQA_CSV2 = stuff((  --// ValidationRuleDescription
							select '|' + vrrr2.ValidationRuleDescription + ' ' + vrrr2.ValidationData
							from #vrrr vrrr2
							where 1=1
							and vrrr.BatchKey = vrrr2.BatchKey
							and vrrr.BatchValue = vrrr2.BatchValue
							and vrrr.CreateDT = vrrr2.CreateDT
							and vrrr.UIDKey = vrrr2.UIDKey
							and vrrr.UIDValue = vrrr2.UIDValue
							and isnull(vrrr2.ValidationRuleDescription,'') <> ''
							order by vrrr2.ValidationRuleDescription
							for XML PATH('')), 1, 1, '')
				, ValidationCheck_CSV = stuff(( --// External_Error_Description
							select '|' + vrrr2.External_Error_Description
							from #vrrr vrrr2
							where 1=1
							and vrrr.BatchKey = vrrr2.BatchKey
							and vrrr.BatchValue = vrrr2.BatchValue
							and vrrr.CreateDT = vrrr2.CreateDT
							and vrrr.UIDKey = vrrr2.UIDKey
							and vrrr.UIDValue = vrrr2.UIDValue
							and isnull(vrrr2.External_Error_Description,'') <> ''
							order by vrrr2.External_Error_Description
							for XML PATH('')), 1, 1, '')
				, ValidationAction_CSV = stuff(( --// External_Action_Details
							select '|' + vrrr2.External_Action_Details
							from #vrrr vrrr2
							where 1=1
							and vrrr.BatchKey = vrrr2.BatchKey
							and vrrr.BatchValue = vrrr2.BatchValue
							and vrrr.CreateDT = vrrr2.CreateDT
							and vrrr.UIDKey = vrrr2.UIDKey
							and vrrr.UIDValue = vrrr2.UIDValue
							and isnull(vrrr2.External_Action_Details,'') <> ''
							order by vrrr2.External_Action_Details
							for XML PATH('')), 1, 1, '')
			--// select top 100 *
			from #benemtmp bm
			join #vrrr vrrr
				on vrrr.UIDValue = bm.MTMPEnrollmentID
				and vrrr.UIDKey = 'MTMPEnrollmentID'
				and vrrr.ValidationDataSet = 1
				and vrrr.ValidationRuleResultStatus = 1
			where 1=1
		) vrp
		where 1=1
		--and ( vrp.ValidationCheck_CSV is not null or vrp.ValidationCheck_CSV <> '' )
		;


		drop table if exists #benematch
		select bmc.PatientID, bmc.BeneficiaryMatchCheck, bmc.BeneficiaryMatch_OMTM_IDs
		into #benematch
		from #benemtmp bm
		join OutcomesMTM.cms.vw_BeneMatchCheck bmc with (nolock)
			on bmc.PatientID = bm.PatientID
			and bmc.Snapshotid = bm.SnapshotID
		where 1=1
		;



		set @SeverityLevel_Min_Batch = ( select SeverityLevel = min( case when vrrr.ValidationRuleRunID is null then 0 when vrrr.ValidationRuleRunResultID is not null then vrrr.SeverityLevel else 99 end ) from #vrrr vrrr )
		set @Severity1_Count_Batch = ( select isnull(min(Severity1_Count_Batch),0) from #vrp )
		set @Severity2_Count_Batch = ( select isnull(min(Severity2_Count_Batch),0) from #vrp )
		set @Severity3_Count_Batch = ( select isnull(min(Severity3_Count_Batch),0) from #vrp )
		set @ClientName = ( select top 1 ClientName from #benemtmp )
		set @ContractNumber = ( select distinct stuff((
									select ',' + bm3.ContractNumber
									from ( select distinct  bm2.ContractNumber from #benemtmp bm2 where 1=1 ) bm3
									order by bm3.ContractNumber
									for XML PATH('')), 1, 1, '')
								from #benemtmp bm )


		IF @LogMessage = 'Y'
		BEGIN
			IF @SeverityLevel_Min_Batch > 2  --// continue proc and report notification
				SET @Return = '[CMS_Process_Notification] Supplemental file generation for ' + cast(@ClientName as varchar(8000)) + ' (ID ' + cast(@ClientID as varchar(8000)) + ') completed successfully (Sev1: ' + cast(@Severity1_Count_Batch as varchar(8000)) + ', Sev2: ' + cast(@Severity2_Count_Batch as varchar(8000)) + ', Sev3: ' + cast(@Severity3_Count_Batch as varchar(8000)) + ')';

			IF @SeverityLevel_Min_Batch = 2  --// continue proc and report notification
				SET @Return = '[CMS_Process_Notification] [CMS_Process_Exception] Supplemental file generation for ' + cast(@ClientName as varchar(8000)) + ' (ID ' + cast(@ClientID as varchar(8000)) + ') completed with issues (Sev1: ' + cast(@Severity1_Count_Batch as varchar(8000)) + ', Sev2: ' + cast(@Severity2_Count_Batch as varchar(8000)) + ', Sev3: ' + cast(@Severity3_Count_Batch as varchar(8000)) + ')';

			IF @SeverityLevel_Min_Batch < 2  --// continue proc and report exception
				SET @Return = '[CMS_Process_Exception] Supplemental file generation for ' + cast(@ClientName as varchar(8000)) + ' (ID ' + cast(@ClientID as varchar(8000)) + ') stopped (Sev1: ' + cast(@Severity1_Count_Batch as varchar(8000)) + ', Sev2: ' + cast(@Severity2_Count_Batch as varchar(8000)) + ', Sev3: ' + cast(@Severity3_Count_Batch as varchar(8000))+ ')';
		END


		IF @IncludeQACheck <> 'Y'
		BEGIN


			--IF @SeverityLevel_Min_Batch > 2  --// continue proc and report notification
			--	SET @Return = '[CMS_Process_Notification] Supplemental file generation for ' + cast(@ClientName as varchar(8000)) + ' (ID ' + cast(@ClientID as varchar(8000)) + ') completed successfully (Sev1: ' + cast(@Severity1_Count_Batch as varchar(8000)) + ', Sev2: ' + cast(@Severity2_Count_Batch as varchar(8000)) + ', Sev3: ' + cast(@Severity3_Count_Batch as varchar(8000)) + ')';

			--IF @SeverityLevel_Min_Batch = 2  --// continue proc and report notification
			--	SET @Return = '[CMS_Process_Notification] [CMS_Process_Exception] Supplemental file generation for ' + cast(@ClientName as varchar(8000)) + ' (ID ' + cast(@ClientID as varchar(8000)) + ') completed with issues (Sev1: ' + cast(@Severity1_Count_Batch as varchar(8000)) + ', Sev2: ' + cast(@Severity2_Count_Batch as varchar(8000)) + ', Sev3: ' + cast(@Severity3_Count_Batch as varchar(8000)) + ')';

			--IF @SeverityLevel_Min_Batch < 2  --// continue proc and report exception
			--	SET @Return = '[CMS_Process_Exception] Supplemental file generation for ' + cast(@ClientName as varchar(8000)) + ' (ID ' + cast(@ClientID as varchar(8000)) + ') stopped (Sev1: ' + cast(@Severity1_Count_Batch as varchar(8000)) + ', Sev2: ' + cast(@Severity2_Count_Batch as varchar(8000)) + ', Sev3: ' + cast(@Severity3_Count_Batch as varchar(8000))+ ')';


			select distinct
				  [ClientName] = bm.ClientName
				, [OMTM_ID] = bm.PatientID 	  --// OMTM_ID
				, [Member ID] = bm.MemberID 
				, [FirstName] = isnull(bm.FirstName,'') 
				, [LastName] = isnull(bm.LastName,'')
				, [DOB] = isnull(convert(varchar,bm.DOB,112),'')
				, [HICN_MBI] = isnull(bm.HICN_MBI,'')
				, [ContractNumber] = isnull(bm.ContractNumber,'')
				, [MTMPEnrollmentStartDate] = isnull(convert(varchar,bm.MTMPEnrollmentStartDate,112),'')
				, [MTMPTargetingDate] = isnull(convert(varchar,bm.MTMPTargetingDate, 112),'')
				, [OptOutDate] = case when bm.OptOutDate is not null then convert(varchar,bm.OptOutDate, 112) else '' end 
				, [OptOutReasonCode] = case when bm.OptOutReasonCode in ('01','02','03','04') then bm.OptOutReasonCode else '' end
				, [BeneficiaryMatchCheck] = isnull(bmc.BeneficiaryMatchCheck,'')
				, [ValidationCheck] = isnull(vrp.ValidationCheck_CSV,'')
				, [ActionRequiredOnCheck] = case when vrp.ValidationAction_CSV is null and bmc.BeneficiaryMatch_OMTM_IDs is not null then 'Select master OMTM_ID'
												 when vrp.ValidationAction_CSV is not null and bmc.BeneficiaryMatch_OMTM_IDs is not null then concat(cast(vrp.ValidationAction_CSV as varchar), '|Select master OMTM_ID')
												 else isnull(vrp.ValidationAction_CSV,'') end 
				, [BeneficiaryMatch_OMTM_IDs] = isnull(bmc.BeneficiaryMatch_OMTM_IDs, '')
				, [SelectMasterOMTM_ID] = case when bmc.BeneficiaryMatch_OMTM_IDs is not null then '' else 'NA' end
				, [RemoveMember] = 'NO'
			from #benemtmp bm
			left join #vrp vrp
				on vrp.UIDValue = bm.MTMPEnrollmentID
			left join #benematch bmc
				on bmc.PatientID = bm.PatientID 
			;
		END


		IF @IncludeQACheck = 'Y'
		BEGIN

			select distinct
				  [ClientName] = bm.ClientName
				, [OMTM_ID] = bm.PatientID 	  --// OMTM_ID
				, [Member ID] = bm.MemberID 
				, [FirstName] = isnull(bm.FirstName,'') 
				, [LastName] = isnull(bm.LastName,'')
				, [DOB] = isnull(convert(varchar,bm.DOB,112),'')
				, [HICN_MBI] = isnull(bm.HICN_MBI,'')
				, [ContractNumber] = isnull(bm.ContractNumber,'')
				, [MTMPEnrollmentStartDate] = isnull(convert(varchar,bm.MTMPEnrollmentStartDate,112),'')
				, [MTMPTargetingDate] = isnull(convert(varchar,bm.MTMPTargetingDate, 112),'')
				, [OptOutDate] = case when bm.OptOutDate is not null then convert(varchar,bm.OptOutDate, 112) else '' end 
				, [OptOutReasonCode] = case when bm.OptOutReasonCode in ('01','02','03','04') then bm.OptOutReasonCode else '' end
				, [BeneficiaryMatchCheck] = isnull(bmc.BeneficiaryMatchCheck,'')
				, [ValidationCheck] = isnull(vrp.ValidationCheck_CSV,'')
				, [ActionRequiredOnCheck] = case when vrp.ValidationAction_CSV is null and bmc.BeneficiaryMatch_OMTM_IDs is not null then 'Select master OMTM_ID'
												 when vrp.ValidationAction_CSV is not null and bmc.BeneficiaryMatch_OMTM_IDs is not null then concat(cast(vrp.ValidationAction_CSV as varchar), '|Select master OMTM_ID')
												 else isnull(vrp.ValidationAction_CSV,'') end 
				, [BeneficiaryMatch_OMTM_IDs] = isnull(bmc.BeneficiaryMatch_OMTM_IDs, '')
				, [SelectMasterOMTM_ID] = case when bmc.BeneficiaryMatch_OMTM_IDs is not null then '' else 'NA' end
				, [RemoveMember] = 'NO'
				, [QACheck] =  isnull(vrp.ValidationCheck_InternalQA_CSV,'')
			from #benemtmp bm
			left join #vrp vrp
				on vrp.UIDValue = bm.MTMPEnrollmentID
			left join #benematch bmc
				on bmc.PatientID = bm.PatientID
			where 1=1
			;
		END


	IF @Return <> ''
		EXEC xp_logevent 51000, @Return, informational;
		PRINT @Return

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
			SET @Return = '[CMS_Process_Exception] S_Bene_SupplementalFile: ' + (select * from ( select ContractYear = @ContractYear, ClientID = @ClientID, ClientName = @ClientName, ContractNumber = @ContractNumber, ErrorProcedure = ERROR_PROCEDURE(), ErrorLine = ERROR_LINE(), ErrorMessage = ERROR_MESSAGE() ) r for json auto );
			EXEC xp_logevent 51000, @Return, informational;
			PRINT @Return;
		END

	END CATCH


END
