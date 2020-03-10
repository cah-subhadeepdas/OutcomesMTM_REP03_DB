


CREATE    PROCEDURE [cms].[U_Beneficiary_MTMPEnrollment]
	@LogMessage char(1) = 'Y'

AS

SET NOCOUNT ON

BEGIN

	declare @return varchar(8000)
	declare @CYFromDate date =   (cast(year(getdate()) - 1 as varchar(4)) + '-01-01')
	declare @CYThruDate date =  (cast(year(getdate()) - 1 as varchar(4)) + '-12-31')
	declare @LYThruDate date =  (cast(year(getdate()) -2 as varchar(4)) + '-12-31')

	declare @FileID int = 0
	declare @ContractYear char(4)
	declare @ClientID int
	declare @ClientName varchar(255)
	declare @ContractNumber varchar(255)
	declare @SeverityLevel_Min_Batch int
	declare @Severity1_Count_Batch int
	declare @Severity2_Count_Batch int
	declare @Severity3_Count_Batch int

BEGIN TRY

	--// INSERT: FileLoad & BeneficiarySF_IngestLog
	BEGIN TRANSACTION


		drop table if exists #FileLoad_stg
		select distinct 
			FileNM = i.FileName
			, LoadDT = min(i.LoadDate)
		into #FileLoad_stg
		from cmsETL.BeneficiarySF_Ingest i
		group by i.Filename


		drop table if exists #FileLoad__INSERTED
		create table #FileLoad__INSERTED
		(
			FileID int
			, FileNM varchar(255)
			, FilePath varchar(8000)
			, FileTypeID int
			, LoadDT datetime
			, ActiveFromDT datetime
			, AciveThruDT datetime
		)


		insert into cmsETL.FileLoad
		(
			FileNM
			, FilePath
			, FileTypeID
			, LoadDT
		)
			output inserted.* into #FileLoad__INSERTED
		select 
			FileNM = stg.FileNM
			, FilePath = ''
			, FileTypeID = 1  --// 1: Beneficiary SF Ingest
			, LoadDT = stg.LoadDT
		from #FileLoad_stg stg


		set @FileID = ( select FileID from #FileLoad__INSERTED )


		drop table if exists #IngestLog__INSERTED
		create table #IngestLog__INSERTED
		(
			IngestLogID bigint,
			IngestLogDT datetime,
			FileID int NULL,
			[OMTM_ID] [int] NULL,
			[ClientName] [varchar](8000) NULL,
			[MemberID] [varchar](8000) NULL,
			[FirstName] [varchar](8000) NULL,
			[MiddleInitial] [varchar](8000) NULL,
			[LastName] [varchar](8000) NULL,
			[DOB] [varchar](8000) NULL,
			[HICN_MBI] [varchar](8000) NULL,
			[ContractNumber] [varchar](8000) NULL,
			[MTMPEnrollmentStartDate] [varchar](8000) NULL,
			[MTMPTargetingDate] [varchar](8000) NULL,
			[OptOutDate] [varchar](8000) NULL,
			[OptOutReasonCode] [varchar](8000) NULL,
			[BeneficiaryMatchCheck] [varchar](8000) NULL,
			[ValidationCheck] [varchar](8000) NULL,
			[ActionRequiredOnCheck] [varchar](8000) NULL,
			[BeneficiaryMatch_OMTM_IDs] [varchar](8000) NULL,
			[SelectMasterOMTM_ID] [varchar](8000) NULL,
			[RemoveMember] [varchar](8000) NULL,
		)
		
		--// debugging:  insert into #IngestLog__INSERTED select il.* from cmsETL.BeneficiarySF_IngestLog il where il.FileID = 1333
		insert into cmsETL.BeneficiarySF_IngestLog
		(
			FileID
			,OMTM_ID
			,ClientName
			,MemberID
			,FirstName
			,MiddleInitial
			,LastName
			,DOB
			,HICN_MBI
			,ContractNumber
			,MTMPEnrollmentStartDate
			,MTMPTargetingDate
			,OptOutDate
			,OptOutReasonCode
			,BeneficiaryMatchCheck
			,ValidationCheck
			,ActionRequiredOnCheck
			,BeneficiaryMatch_OMTM_IDs
			,SelectMasterOMTM_ID
			,RemoveMember
		)
			output inserted.* into #IngestLog__INSERTED
		select
			FileID = ( select distinct FileID from #FileLoad__INSERTED )
			,OMTM_ID = sf.OMTM_ID
			,ClientName = replace(sf.ClientName,'"','')
			,MemberID = replace(sf.MemberID,'"','')
			,FirstName = replace(sf.FirstName,'"','')
			,MiddleInitial
			,LastName = replace(sf.LastName,'"','')
			,DOB = replace(sf.DOB,'"','')
			,HICN_MBI = replace(sf.HICN_MBI,'"','')
			,ContractNumber = replace(sf.ContractNumber,'"','')
			,MTMPEnrollmentStartDate = replace(sf.MTMPEnrollmentStartDate,'"','')
			,MTMPTargetingDate = replace(sf.MTMPTargetingDate,'"','')
			,OptOutDate = replace(sf.OptOutDate,'"','')
			,OptOutReasonCode = replace(sf.OptOutReasonCode,'"','')
			,BeneficiaryMatchCheck = replace(sf.BeneficiaryMatchCheck,'"','')
			,ValidationCheck = replace(sf.ValidationCheck,'"','')
			,ActionRequiredOnCheck = replace(sf.ActionRequiredOnCheck,'"','')
			,BeneficiaryMatch_OMTM_IDs = replace(sf.BeneficiaryMatch_OMTM_IDs,'"','')
			,SelectMasterOMTM_ID = replace(sf.SelectMasterOMTM_ID,'"','')
			,RemoveMember = replace(sf.RemoveMember,'"','')
		from cmsETL.BeneficiarySF_Ingest sf
		where 1=1


	IF XACT_STATE() = 1 COMMIT TRANSACTION;


	--// get current Snapshot of Ingested SF even if the multiyear snapshot is present
	drop table if exists #snapshot
	select res.*
	into #snapshot 
	from 
	(
		select distinct 
			s.*
			, CYFromDate = cast(cast(s.ContractYear as char(4)) + '-01-01' as date)
			, CYThruDate = cast(cast(s.ContractYear as char(4)) + '-12-31' as date)
			, cl.ClientName
			, ranker = ROW_NUMBER() over(order by s.contractyear desc, s.lastrundate desc)
		from cms.CMS_SnapshotTracker s
		join dbo.Client cl
			on cl.ClientID = s.ClientID
		where 1 = 1 
		and exists (
			select 1
			from #IngestLog__INSERTED i
			join cms.CMS_BeneficiaryPatient_History bp
				on bp.PatientID = i.OMTM_ID
				and bp.isCurrent = 1
			where 1=1
			and bp.SnapshotID = s.SnapshotID 
			)
	) res 
	where res.ranker = 1


	--// Used to create Stage Publish
	drop table if exists #BeneMTMP_stg
	select
		BeneficiaryID = b.BeneficiaryID
		,ClientID = b.ClientID
		,ContractYear = b.ContractYear
		,HICN
		,First_Name
		,MI
		,Last_Name
		,DOB
		,SnapshotID = b.SnapshotID
		,ActiveFromDT = b.ActiveFromDT
		,ActiveThruDT = b.ActiveThruDT
		,IsCurrent = b.IsCurrent
		,MTMPEnrollmentID
		,PatientID_All
		,PatientID = bp.PatientID
		,ContractNumber
		,MTMPTargetingDate
		,MTMPEnrollmentFromDate
		,MTMPEnrollmentThruDate
		,OptOutDate
		,OptOutReasonCode
	into #BeneMTMP_stg
	from #snapshot s
	join cms.CMS_MTMPEnrollment_History m
		on m.SnapshotID = s.SnapshotID
	join cms.CMS_BeneficiaryPatient_History bp
		on bp.PatientID = m.PatientID
		and bp.SnapshotID = m.SnapshotID
	join cms.CMS_Beneficiary_History b
		on b.BeneficiaryID = bp.BeneficiaryID
		and b.SnapshotID = bp.SnapshotID
	where 1=1


	--// Re-add missing/inactive records
	insert into #BeneMTMP_stg
	(
		BeneficiaryID
		,ClientID
		,ContractYear
		,HICN
		,First_Name
		,MI
		,Last_Name
		,dob
		,snapshotID
		,ActiveFromDT
		,ActiveThruDT
		,isCurrent
		,MTMPEnrollmentID
		,PatientID_All
		,PatientID
		,ContractNumber
		,MTMPTargetingDate
		,MTMPEnrollmentFromDate
		,MTMPEnrollmentThruDate
		,OptOutDate
		,OptOutReasonCode	
	)
	select
		BeneficiaryID = bh.BeneficiaryID
		,ClientID = bh.ClientID
		,ContractYear = bh.ContractYear
		,HICN = bh.HICN
		,First_Name = bh.First_Name
		,MI = bh.MI
		,Last_Name = bh.Last_Name
		,DOB = bh.DOB
		,SnapshotID = bh.SnapshotID
		,ActiveFromDT = bh.ActiveFromDT
		,ActiveThruDT = bh.ActiveThruDT
		,IsCurrent = bh.IsCurrent
		,MTMPEnrollmentID = mh.MTMPEnrollmentID
		,PatientID_All = mh.PatientID_All
		,PatientID = mh.PatientID
		,ContractNumber = mh.ContractNumber
		,MTMPTargetingDate = mh.MTMPTargetingDate
		,MTMPEnrollmentFromDate = mh.MTMPEnrollmentFromDate
		,MTMPEnrollmentThruDate = mh.MTMPEnrollmentThruDate
		,OptOutDate = mh.OptOutDate
		,OptOutReasonCode = mh.OptOutReasonCode
	from #IngestLog__INSERTED il
	join cms.CMS_BeneficiaryPatient_History bph
		on bph.PatientID = il.OMTM_ID
		and bph.isCurrent = 1
	join cms.CMS_Beneficiary_History bh
		on bh.BeneficiaryID = bph.BeneficiaryID
		and bh.ContractYear = (select ContractYear from #snapshot)
		and bh.isCurrent = 1
	join cms.CMS_MTMPEnrollment_History mh
		on mh.PatientID = bph.PatientID
		and mh.ContractNumber = il.ContractNumber
		and mh.ContractYear = bh.ContractYear
		and mh.isCurrent = 1
	left join #BeneMTMP_stg bm
		on bm.PatientID = il.OMTM_ID
		and bm.ContractNumber = il.ContractNumber
	where 1=1
	and bm.PatientID is null



	--IF XACT_STATE() = 1 COMMIT TRANSACTION;


	--// PreIngest Validation Rules
	--// debugging:  declare @FileID int = 1365
	EXECUTE cms.ValidationEngineRun
	@ValidationDataSet = 2
	, @BatchKey = 'FileID'
	, @BatchValue = @FileID
	, @ReturnStatusRecord = 'N'
	;
	
	--// debugging:  declare @ValidationDataSet int = 2, @BatchKey varchar(255) = 'FileID', @FileID varchar(255) = '1333'
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
		, SeverityLevel = min( case when vrr.ValidationRuleRunID is null then 0 when vrrr.ValidationRuleRunResultID is not null then vrr.SeverityLevel else 99 end )
		, Severity1_Count_Batch = sum( case when vrrr.ValidationRuleResultStatus = 1 and vrr.SeverityLevel = 1 then 1 else 0 end ) --over (partition by b.ValidationDataSet, b.BatchKey, b.BatchValue)
		, Severity2_Count_Batch = sum( case when vrrr.ValidationRuleResultStatus = 1 and vrr.SeverityLevel = 2 then 1 else 0 end ) --over (partition by b.ValidationDataSet, b.BatchKey, b.BatchValue)
		, Severity3_Count_Batch = sum( case when vrrr.ValidationRuleResultStatus = 1 and vrr.SeverityLevel = 3 then 1 else 0 end ) --over (partition by b.ValidationDataSet, b.BatchKey, b.BatchValue)
		, RulesMet = isnull(count(distinct vrrr.ValidationRuleRunID),0)
		, TotalResultsFound = isnull(count(distinct vrrr.ValidationRuleRunResultID),0)
		, TotalUIDFound = isnull(count(distinct vrrr.UIDValue),0)
		, ValidationRuleRunID_MIN = min(vrr.ValidationRuleRunID)
		, ValidationRuleRunID_MAX = max(vrr.ValidationRuleRunID)
	into #validationStatus
	from (
		select 
			ValidationDataSet = 2
			, BatchKey = 'FileID'
			, BatchValue = @FileID
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


	SET @SeverityLevel_Min_Batch = ( select cast( isnull(SeverityLevel,0) as int) from #validationStatus )
	SET @Severity1_Count_Batch = ( select isnull(min(Severity1_Count_Batch),0) from #validationStatus )
	SET @Severity2_Count_Batch = ( select isnull(min(Severity2_Count_Batch),0) from #validationStatus )
	SET @Severity3_Count_Batch = ( select isnull(min(Severity3_Count_Batch),0) from #validationStatus )
	SET @ClientName = ( select top 1 ClientName from #snapshot )
	SET @ContractNumber = ( select distinct stuff((
								select ',' + bm3.ContractNumber
								from ( select distinct  bm2.ContractNumber from #BeneMTMP_stg bm2 where 1=1 ) bm3
								order by bm3.ContractNumber
								for XML PATH('')), 1, 1, '')
							from #BeneMTMP_stg bm )
    SET @ClientID = ( select top 1  Clientid from #snapshot )
	SET @ContractYear = ( select top 1 ContractYear from #snapshot )


	IF @SeverityLevel_Min_Batch > 2  --// continue proc and report notification
		SET @Return = '[CMS_Process_Notification] Supplemental file ingestion for ' + cast(@ClientName as varchar(8000)) + ' (ID ' + cast(@ClientID as varchar(8000)) + ') completed successfully (Sev1: ' + cast(@Severity1_Count_Batch as varchar(8000)) + ', Sev2: ' + cast(@Severity2_Count_Batch as varchar(8000)) + ', Sev3: ' + cast(@Severity3_Count_Batch as varchar(8000)) + ')';

	IF @SeverityLevel_Min_Batch = 2  --// continue proc and report notification & exception
		SET @Return = '[CMS_Process_Notification] [CMS_Process_Exception] Supplemental file ingestion for ' + cast(@ClientName as varchar(8000)) + ' (ID ' + cast(@ClientID as varchar(8000)) + ') completed with issues (Sev1: ' + cast(@Severity1_Count_Batch as varchar(8000)) + ', Sev2: ' + cast(@Severity2_Count_Batch as varchar(8000)) + ', Sev3: ' + cast(@Severity3_Count_Batch as varchar(8000)) + ')';

	IF @SeverityLevel_Min_Batch < 2  --// stop proc and report exception
		SET @Return = '[CMS_Process_Exception] Supplemental file ingestion for ' + cast(@ClientName as varchar(8000)) + ' (ID ' + cast(@ClientID as varchar(8000)) + ') stopped (Sev1: ' + cast(@Severity1_Count_Batch as varchar(8000)) + ', Sev2: ' + cast(@Severity2_Count_Batch as varchar(8000)) + ', Sev3: ' + cast(@Severity3_Count_Batch as varchar(8000))+ ')';
	

	IF @SeverityLevel_Min_Batch > 1
	BEGIN

		--// MTMPEnrollment
		drop table if exists #MTMPEnrollment_stg
		select distinct
			bm.MTMPEnrollmentID
			, bm.PatientID
			, bm.PatientID_All
			, bm.ContractNumber
			, bm.MTMPTargetingDate
			, bm.MTMPEnrollmentFromDate
			, bm.MTMPEnrollmentThruDate
			, bm.OptOutDate
			, bm.OptOutReasonCode
		into #MTMPEnrollment_stg
		from #BeneMTMP_stg bm


		drop table if exists #MTMPEnrollment_stg__UPDATED
		create table #MTMPEnrollment_stg__UPDATED
		(
			PatientID int
			, PatientID_All varchar(50)
			, ContractNumber varchar(5)
			, MTMPEnrollmentID int
			, MTMPTargetingDate date
			, MTMPEnrollmentFromDate date
			, MTMPEnrollmentThruDate date
			, OptOutDate date
			, OptOutReasonCode varchar(2)
			, MTMPTargetingDate__OLD date
			, MTMPEnrollmentFromDate__OLD date
			, MTMPEnrollmentThruDate__OLD date
			, OptOutDate__OLD date
			, OptOutReasonCode__OLD varchar(2)
		)
	


		update m 
		set
			m.PatientID_All = m.PatientID_All  -- cast( ltrim(rtrim(il.MemberID)) as varchar())  --// need to alter to correct data type
			, m.MTMPTargetingDate = case when cast(il.MTMPTargetingDate as date) between @CYFromDate and @CYThruDate then cast(il.MTMPTargetingDate as date) else null end  --// need CYFromDate and CYThruDate
			, m.MTMPEnrollmentFromDate = case when cast(il.MTMPEnrollmentStartDate as date) between @CYFromDate and @CYThruDate then cast(il.MTMPEnrollmentStartDate as date) else null end
			, m.MTMPEnrollmentThruDate = case when il.RemoveMember like 'Y%' then @LYThruDate when cast(il.OptOutDate as date) between @CYFromDate and @CYThruDate then cast(il.OptOutDate as date) else @CYThruDate end
			, m.OptOutDate = case when cast(il.OptOutDate as date) between @CYFromDate and @CYThruDate then cast(il.OptOutDate as date) else null end
			, m.OptOutReasonCode = case when right(('00' + ltrim(rtrim(il.OptOutReasonCode))),2) in ('01','02','03','04') then right(('00' + ltrim(rtrim(il.OptOutReasonCode))),2) else '' end
		output 
			inserted.PatientID
			, inserted.PatientID_All
			, inserted.ContractNumber
			, inserted.MTMPEnrollmentID
			, inserted.MTMPTargetingDate
			, inserted.MTMPEnrollmentFromDate
			, inserted.MTMPEnrollmentThruDate
			, inserted.OptOutDate
			, inserted.OptOutReasonCode
			, deleted.MTMPTargetingDate
			, deleted.MTMPEnrollmentFromDate
			, deleted.MTMPEnrollmentThruDate
			, deleted.OptOutDate
			, deleted.OptOutReasonCode
		into #MTMPEnrollment_stg__UPDATED
		from #MTMPEnrollment_stg m
		join #IngestLog__INSERTED il
			on il.OMTM_ID = m.PatientID
			and il.ContractNumber = m.ContractNumber
		where 1=1


		drop table if exists #MTMPEnrollment_stg__REMOVED
		create table #MTMPEnrollment_stg__REMOVED
		(
			PatientID int
			, PatientID_All varchar(50)
			, ContractNumber varchar(5)
			, MTMPEnrollmentID int
			, OptOutDate date
			, OptOutReasonCode varchar(2)
		)

		update m set
			m.MTMPEnrollmentThruDate = @LYThruDate
			, m.OptOutDate = @LYThruDate
			, m.OptOutReasonCode = '02'
		output 
			inserted.PatientID
			, inserted.PatientID_All
			, inserted.ContractNumber
			, inserted.MTMPEnrollmentID
			, inserted.OptOutDate
			, inserted.OptOutReasonCode
		into #MTMPEnrollment_stg__REMOVED
		--// select *
		from #MTMPEnrollment_stg m
		join #IngestLog__INSERTED il
			on il.OMTM_ID = m.PatientID
			and il.ContractNumber = m.ContractNumber
		where 1=1
		and il.RemoveMember = 'YES'


		--// BeneficiaryPatient
		drop table if exists #BeneficiaryPatient_stg
		select distinct
			bm.BeneficiaryID
			, bm.PatientID
			, bm.SnapshotID
			, MasterPatientID = case when isnull(nullif(il.SelectMasterOMTM_ID,'NA'),'') = '' then NULL else il.SelectMasterOMTM_ID end
			, BeneficiaryID_UPDATE = bm.BeneficiaryID
		into #BeneficiaryPatient_stg
		from #BeneMTMP_stg bm
		join #IngestLog__INSERTED il
			on il.OMTM_ID = bm.PatientID
			and il.ContractNumber = bm.ContractNumber


		drop table if exists #BeneficiaryPatient_stg__UPDATED
		create table #BeneficiaryPatient_stg__UPDATED
		(
			BeneficiaryID_UPDATE bigint
			, BeneficiaryID bigint
			, PatientID int
			, MasterPatientID int
		)

		create nonclustered index NC_BenePat_Snapshotid_Pat_BeneID 
		on #BeneficiaryPatient_stg (SnapshotID desc , MasterPatientID  , BeneficiaryID_UPDATE desc) --//added by Subha

		update bp set bp.BeneficiaryID_UPDATE = bh.BeneficiaryID
		output
			inserted.BeneficiaryID
			, inserted.BeneficiaryID_UPDATE
			, inserted.PatientID
			, inserted.MasterPatientID
		into #BeneficiaryPatient_stg__UPDATED
		--// select top 100 *
		from #BeneficiaryPatient_stg bp
		join cms.CMS_Beneficiary_History bh
			on bh.BeneficiaryKey = bp.MasterPatientID
			and bh.SnapshotID = bp.SnapshotID  --// added by Steve; 2019
			and bh.isCurrent = 1
		where 1=1
		and bp.BeneficiaryID_UPDATE <> bh.BeneficiaryID


		--// Beneficiary
		drop table if exists #Beneficiary_stg
		select distinct
			bm.BeneficiaryID
			, b.BeneficiaryKey
			, bm.HICN
			, bm.First_Name
			, /* bm.MI */ NULL as MI --updated by Subha
			, bm.Last_Name
			, bm.DOB
			, bm.PatientID
		into #Beneficiary_stg
		from #BeneMTMP_stg bm
		join cms.Beneficiary b
			on b.BeneficiaryID = bm.BeneficiaryID


		drop table if exists #Beneficiary_stg__UPDATED
		create table #Beneficiary_stg__UPDATED
		(
			PatientID int
			, BeneficiaryID bigint
			, First_Name varchar(30)
			, MI varchar(1) NULL --updated by Subha.. made MI allow nulls
			, Last_Name varchar(30)
			, DOB date
			, HICN varchar(15)
			, First_Name__OLD varchar(30) NULL --updated by Subha.. made MI allow nulls
			, MI__OLD varchar(1)
			, Last_Name__OLD varchar(30)
			, DOB__OLD date
			, HICN__OLD varchar(15)
		)


		update b set
			b.First_Name = cast( ltrim(rtrim(il2.FirstName)) as varchar(30))
			, b.MI = cast( ltrim(rtrim(il2.MiddleInitial)) as varchar(1)) 
			, b.Last_Name = cast( ltrim(rtrim(il2.LastName)) as varchar(30))
			, b.DOB = cast(il2.DOB as date)
			, b.HICN = cast( ltrim(rtrim(il2.HICN_MBI)) as varchar(15))
			, b.BeneficiaryKey = b.BeneficiaryKey  --// need to add logic to concat: PatientID~PatientID
		output
			inserted.PatientID
			, inserted.BeneficiaryID
			, inserted.First_Name
			, inserted.MI 
			, inserted.Last_Name
			, inserted.DOB
			, inserted.HICN
			, deleted.First_Name
			, deleted.MI 
			, deleted.Last_Name
			, deleted.DOB
			, deleted.HICN
		into #Beneficiary_stg__UPDATED
		from #Beneficiary_stg b
		join (
			select il.IngestLogID, il.OMTM_ID, il.FirstName, il.MiddleInitial, il.LastName, il.DOB, il.HICN_MBI, ranker = row_number() over (partition by il.OMTM_ID order by il.SelectMasterOMTM_ID)
			from #IngestLog__INSERTED il
		) il2
			on il2.OMTM_ID = b.PatientID
			and il2.ranker = 1


		--// Used to capture audit for change file
		drop table if exists #audit
		create table #audit
		(
			ContractNumber varchar(5) not null
			, PatientID int not null
			, PatientID_All varchar(50) null
			, AuditActivityTypeID int not null
			, AuditDetailAttributeName varchar(50) null
			, AuditDetailAttributeNameExternal varchar(50) null
			, AuditDetailValue_OLD varchar(8000)
			, AuditDetailValue_NEW varchar(8000)
		)


		--// UPDATED (1)
		insert into #audit
		select
			ContractNumber = mu.ContractNumber
			, PatientID = mu.PatientID
			, PatientID_All = mu.PatientID_All
			, AuditActivityTypeID = 1
			, AuditDetailAttributeName = 'MTMPTargetingDate'
			, AuditDetailAttributeNameExternal = 'MTMPTargetingDate'
			, AuditDetailValue_OLD = convert(varchar,mu.MTMPTargetingDate__OLD,112)
			, AuditDetailValue_NEW = convert(varchar,mu.MTMPTargetingDate,112)
		from #MTMPEnrollment_stg__UPDATED mu
		where 1=1
		and mu.MTMPTargetingDate <> mu.MTMPTargetingDate__OLD


		insert into #audit
		select
			ContractNumber = mu.ContractNumber
			, PatientID = mu.PatientID
			, PatientID_All = mu.PatientID_All
			, AuditActivityTypeID = 1
			, AuditDetailAttributeName = 'MTMPEnrollmentFromDate'
			, AuditDetailAttributeNameExternal = 'MTMPEnrollmentStartDate'
			, AuditDetailValue_OLD = convert(varchar,mu.MTMPEnrollmentFromDate__OLD,112)
			, AuditDetailValue_NEW = convert(varchar,mu.MTMPEnrollmentFromDate,112)
		from #MTMPEnrollment_stg__UPDATED mu
		where 1=1
		and mu.MTMPEnrollmentFromDate <> mu.MTMPEnrollmentFromDate__OLD


		insert into #audit
		select
			ContractNumber = mu.ContractNumber
			, PatientID = mu.PatientID
			, PatientID_All = mu.PatientID_All
			, AuditActivityTypeID = 1
			, AuditDetailAttributeName = 'OptOutDate'
			, AuditDetailAttributeNameExternal = 'OptOutDate'
			, AuditDetailValue_OLD = isnull(convert(varchar,mu.OptOutDate__OLD,112),'')
			, AuditDetailValue_NEW = isnull(convert(varchar,mu.OptOutDate,112),'')
		from #MTMPEnrollment_stg__UPDATED mu
		where 1=1
		and isnull(mu.OptOutDate,'99991231') <> isnull(mu.OptOutDate__OLD,'99991231')
		and not exists (
			select 1
			from #MTMPEnrollment_stg__REMOVED mr
			where 1=1
			and mr.PatientID = mu.PatientID
			and mr.ContractNumber = mu.ContractNumber
			)


		insert into #audit
		select
			ContractNumber = mu.ContractNumber
			, PatientID = mu.PatientID
			, PatientID_All = mu.PatientID_All
			, AuditActivityTypeID = 1
			, AuditDetailAttributeName = 'OptOutReasonCode'
			, AuditDetailAttributeNameExternal = 'OptOutReasonCode'
			, AuditDetailValue_OLD = mu.OptOutReasonCode__OLD
			, AuditDetailValue_NEW = mu.OptOutReasonCode
		from #MTMPEnrollment_stg__UPDATED mu
		where 1=1
		and mu.OptOutReasonCode <> mu.OptOutReasonCode__OLD
		and not exists (
			select 1
			from #MTMPEnrollment_stg__REMOVED mr
			where 1=1
			and mr.PatientID = mu.PatientID
			and mr.ContractNumber = mu.ContractNumber
			)


		insert into #audit
		select
			ContractNumber = m.ContractNumber
			, PatientID = bu.PatientID
			, PatientID_All = m.PatientID_All
			, AuditActivityTypeID = 1
			, AuditDetailAttributeName = 'First_Name'
			, AuditDetailAttributeNameExternal = 'First_Name'
			, AuditDetailValue_OLD = bu.First_Name__OLD
			, AuditDetailValue_NEW = bu.First_Name
		from #Beneficiary_stg__UPDATED bu
		join #MTMPEnrollment_stg m
			on m.PatientID = bu.PatientID
		where 1=1
		and isnull(bu.First_Name,'') <> isnull(bu.First_Name__OLD,'')


		insert into #audit
		select
			ContractNumber = m.ContractNumber
			, PatientID = bu.PatientID
			, PatientID_All = m.PatientID_All
			, AuditActivityTypeID = 1
			, AuditDetailAttributeName = 'Last_Name'
			, AuditDetailAttributeNameExternal = 'Last_Name'
			, AuditDetailValue_OLD = bu.Last_Name__OLD
			, AuditDetailValue_NEW = bu.Last_Name
		from #Beneficiary_stg__UPDATED bu
		join #MTMPEnrollment_stg m
			on m.PatientID = bu.PatientID
		where 1=1
		and isnull(bu.Last_Name,'') <> isnull(bu.Last_Name__OLD,'')


		insert into #audit
		select
			ContractNumber = m.ContractNumber
			, PatientID = bu.PatientID
			, PatientID_All = m.PatientID_All
			, AuditActivityTypeID = 1
			, AuditDetailAttributeName = 'DOB'
			, AuditDetailAttributeNameExternal = 'DOB'
			, AuditDetailValue_OLD = isnull(convert(varchar,bu.DOB__OLD,112),'')
			, AuditDetailValue_NEW = isnull(convert(varchar,bu.DOB,112),'')
		from #Beneficiary_stg__UPDATED bu
		join #MTMPEnrollment_stg m
			on m.PatientID = bu.PatientID
		where 1=1
		and isnull(bu.DOB,'99991231') <> isnull(bu.DOB__OLD,'99991231')


		insert into #audit
		select
			ContractNumber = m.ContractNumber
			, PatientID = bu.PatientID
			, PatientID_All = m.PatientID_All
			, AuditActivityTypeID = 1
			, AuditDetailAttributeName = 'HICN'
			, AuditDetailAttributeNameExternal = 'HICN_MBI'
			, AuditDetailValue_OLD = bu.HICN__OLD
			, AuditDetailValue_NEW = bu.HICN
		from #Beneficiary_stg__UPDATED bu
		join #MTMPEnrollment_stg m
			on m.PatientID = bu.PatientID
		where 1=1
		and isnull(bu.HICN,'') <> isnull(bu.HICN__OLD,'')


		--// REMOVED (2)
		insert into #audit
		select
			ContractNumber = mr.ContractNumber
			, PatientID = mr.PatientID
			, PatientID_All = mr.PatientID_All
			, AuditActivityTypeID = 2  --// REMOVED
			, AuditDetailAttributeName = 'OptOutDate'
			, AuditDetailAttributeNameExternal = 'OptOutDate'
			, AuditDetailValue_OLD = ''
			, AuditDetailValue_NEW = isnull(convert(varchar,mr.OptOutDate,112),'')
		from #MTMPEnrollment_stg__REMOVED mr


		--// MERGED (3)
		drop table if exists #audit_merged
		select m.PatientID, m.PatientID_All, m.ContractNumber, bpu.MasterPatientID
		into #audit_merged
		from #BeneficiaryPatient_stg__UPDATED bpu
		join #MTMPEnrollment_stg m
			on m.PatientID = bpu.PatientID
			or m.PatientID = bpu.MasterPatientID
		where 1=1
		and bpu.PatientID <> bpu.MasterPatientID

		insert into #audit
		select
			ContractNumber = am.ContractNumber
			, PatientID = am.PatientID
			, PatientID_All = am.PatientID_All
			, AuditActivityTypeID = 3  --// MERGED
			, AuditDetailAttributeName = ''
			, AuditDetailAttributeNameExternal = ''
			, AuditDetailValue_OLD = ''
			, AuditDetailValue_NEW = stuff((  --// concat all PatientIDs together
					select '~' + cast(am2.PatientID as varchar(50))
					from #audit_merged am2
					where 1=1
					and am2.MasterPatientID = am.MasterPatientID
					group by am2.PatientID
					order by am2.PatientID
					for XML PATH('')), 1, 1, '')
		from #audit_merged am

	
		--// UN-MERGED (4)
		drop table if exists #audit_unmerged
		select m.PatientID, m.PatientID_All, m.ContractNumber, bpu.MasterPatientID
		into #audit_unmerged
		from #BeneficiaryPatient_stg__UPDATED bpu
		join #Beneficiary_stg b
			on b.BeneficiaryID = bpu.BeneficiaryID
			or b.BeneficiaryID = bpu.BeneficiaryID_UPDATE
		join #MTMPEnrollment_stg m
			on m.PatientID = b.PatientID
		where 1=1
		and bpu.PatientID = bpu.MasterPatientID

		insert into #audit
		select
			ContractNumber = am.ContractNumber
			, PatientID = am.PatientID
			, PatientID_All = am.PatientID_All
			, AuditActivityTypeID = 4  --// UNMERGED
			, AuditDetailAttributeName = ''
			, AuditDetailAttributeNameExternal = ''
			, AuditDetailValue_OLD = ''
			, AuditDetailValue_NEW = stuff((  --// concat all PatientIDs together
					select '~' + cast(am2.PatientID as varchar(50))
					from #audit_unmerged am2
					where 1=1
					and am2.MasterPatientID = am.MasterPatientID
					group by am2.PatientID
					order by am2.PatientID
					for XML PATH('')), 1, 1, '')
			--// select *
		from #audit_unmerged am


		update a set a.PatientID_All = ptd.PatientID_All
		from #audit a
		join dbo.patientDim ptd
			on ptd.PatientID = a.PatientID
			and ptd.isCurrent = 1
		where 1=1
		and a.PatientID_All = '0'


		--// Get Configs to Add to the Final report Queue
		drop table if exists #ec
		select 
			ec.EnrollmentConfigID, ec.ClientID, ec.ContractYear, ec.ContractNumber
			, SnapshotID_Beneficiary = max(case when s2.SnapshotID is not null then s2.SnapshotID end)
			, SnapshotID_CMR = max(case when s1.SnapshotID is not null then s1.SnapshotID end)
			, SnapshotID_TMR = max(case when s3.SnapshotID is not null then s3.SnapshotID end)
			, SnapshotID_DTP = max(case when s4.SnapshotID is not null then s4.SnapshotID end)
		into #ec
		from OutcomesMTM.cms.EnrollmentConfig ec
		join #snapshot s
			on s.ClientID = ec.ClientID
			and s.ContractYear = ec.ContractYear
		left join cms.CMS_SnapshotTracker s2
			on s2.ClientID = ec.ClientID
			and s2.ContractYear = ec.ContractYear
			and s2.DataSetTypeID = 2
			and s2.LastRunStatus = 1
			and s2.ActiveThruDT > getdate()
		left join cms.CMS_SnapshotTracker s1
			on s1.ClientID = ec.ClientID
			and s1.ContractYear = ec.ContractYear
			and s1.DataSetTypeID = 1
			and s1.LastRunStatus = 1
			and s1.ActiveThruDT > getdate()
		left join cms.CMS_SnapshotTracker s3
			on s3.ClientID = ec.ClientID
			and s3.ContractYear = ec.ContractYear
			and s3.DataSetTypeID = 3
			and s3.LastRunStatus = 1
			and s3.ActiveThruDT > getdate()
		left join cms.CMS_SnapshotTracker s4
			on s4.ClientID = ec.ClientID
			and s4.ContractYear = ec.ContractYear
			and s4.DataSetTypeID = 4
			and s4.LastRunStatus = 1
			and s4.ActiveThruDT > getdate()
		where 1=1
		group by
			ec.EnrollmentConfigID, ec.ClientID, ec.ContractYear, ec.ContractNumber


		drop table if exists #rpt_Queue
		select distinct
			ClientID = ec.ClientID
			, ContractYear = ec.ContractYear
			, ContractNumber = ec.ContractNumber 
			, ProcessStatusID = 0
		into #rpt_Queue
		from #ec ec
		join (
			select distinct il.ContractNumber
			from #IngestLog__INSERTED il
		) cf
			on cf.ContractNumber = ec.ContractNumber
		left join cms.rpt_Queue q
			on q.ClientID = ec.ClientID
			and q.ContractYear = ec.ContractYear
			and q.ContractNumber = ec.ContractNumber
			and q.ProcessStatusID = 0
		where 1=1
		and q.QueueID is null
		and ec.SnapshotID_Beneficiary is not null
		and ec.SnapshotID_CMR is not null
		and ec.SnapshotID_DTP is not null



		--// UPDATE MTMPEnrollment, Beneficiary, BeneficiaryPatient; INSERT AuditDetail
		BEGIN TRANSACTION

			--// MTMPEnrollment
			update m set
				m.MTMPTargetingDate = stg.MTMPTargetingDate
				, m.MTMPEnrollmentFromDate = stg.MTMPEnrollmentFromDate
				, m.MTMPEnrollmentThruDate = stg.MTMPEnrollmentThruDate
				, m.OptOutDate = stg.OptOutDate
				, m.OptOutReasonCode = stg.OptOutReasonCode
				, m.ChangeDT = getdate()
			from cms.MTMPEnrollment m
			join #MTMPEnrollment_stg stg
				on stg.MTMPEnrollmentID = m.MTMPEnrollmentID	

			--// BeneficiaryPatient
			update bp set
				bp.BeneficiaryID = stg.BeneficiaryID_UPDATE
				, bp.ChangeDT = getdate()
			from cms.BeneficiaryPatient bp
			join #BeneficiaryPatient_stg stg
				on stg.BeneficiaryID = bp.BeneficiaryID
				and stg.PatientID = bp.PatientID


			--// Beneficiary
			update b set
				b.BeneficiaryKey = stg.BeneficiaryKey
				, b.First_Name = stg.First_Name
				, b.MI = /* stg.MI */ '' --updated by Subha
				, b.Last_Name = stg.Last_Name
				, b.DOB = stg.dob
				, b.HICN = stg.HICN
				, b.ChangeDT = getdate()
			from cms.Beneficiary b
			join #Beneficiary_stg stg
				on stg.BeneficiaryID = b.BeneficiaryID


			--// AuditDetail
			insert into cms.AuditDetail
			(
				ContractNumber
				, SnapshotID
				, PatientID
				, PatientID_All
				, AuditActivityTypeID
				, AuditDetailAttributeName
				, AuditDetailAttributeNameExternal
				, AuditDetailValue_OLD
				, AuditDetailValue_NEW		
			)
			select distinct
				ContractNumber
				, SnapshotID = ( select SnapshotID from #snapshot )
				, PatientID
				, PatientID_All
				, AuditActivityTypeID
				, AuditDetailAttributeName
				, AuditDetailAttributeNameExternal
				, AuditDetailValue_OLD
				, AuditDetailValue_NEW
			from #audit
			order by PatientID, ContractNumber, AuditActivityTypeID, AuditDetailAttributeName


			--// Insert rpt_Queue
			insert into cms.rpt_Queue
			(
				ClientID
				, ContractYear
				, ContractNumber
				, ProcessStatusID
			)
			select distinct
				ClientID
				, ContractYear
				, ContractNumber 
				, ProcessStatusID
			from #rpt_Queue q


		IF XACT_STATE() = 1 COMMIT TRANSACTION;




--below inserts to ##BeneMatchCheckResults added by Subha..
	drop table if exists #BeneMatchCheckResults
	create table #BeneMatchCheckResults
		(    ValidationDataSet int null
			, BatchKey varchar(100) null
			, BatchValue varchar(100) null
			, ContractYear varchar(100) null
			, CYFromDate date null
			, CYThruDate date null
			, CurrentDate date null
			, ClientID int null
			, SeverityLevel int null
			, RulesChecked int null
			, RulesMet int null
			, TotalResultsFound int null
			, TotalUIDFound int null
			, ValidationRuleRunID_MIN int null
			, ValidationRuleRunID_MAX int null 
		)
   
   Insert into #BeneMatchCheckResults
   (		ValidationDataSet
			, BatchKey
			, BatchValue
			, ContractYear
			, CYFromDate
			, CYThruDate
			, CurrentDate
			, ClientID
			, SeverityLevel
			, RulesChecked
			, RulesMet
			, vrrr.TotalResultsFound
			, vrrr.TotalUIDFound
			, vrrr.ValidationRuleRunID_MIN
			, vrrr.ValidationRuleRunID_MAX
	)
		--// Run Validation & Bene Match
		--// debugging:  declare @ClientID int = 115, @ContractYear char(4) = 2019
		EXECUTE cms.I_Beneficiary_MTMPEnrollment_Validation
			@ClientID = @ClientID
			, @ContractYear = @ContractYear
		;


		--//  Queue SF Export
		--// debugging:  declare @ClientID int = 115, @ContractYear char(4) = 2019
		EXECUTE cms.I_SFExportProcess_Queue
			@ClientID = @ClientID
			, @ContractYear = @ContractYear
		;


	END


	SELECT 
		SeverityLevel = @SeverityLevel_Min_Batch 
		, ClientID = @ClientID
		, CY = @ContractYear
		, ClientName = @ClientName
		, IngestRuntime = convert(varchar,getdate(),112) + replace(convert(varchar,getdate(),108),':','')
	--FROM #validationStatus vs


	IF @LogMessage = 'Y'
	BEGIN
		IF ISNULL(@Return,'') <> ''
			EXEC xp_logevent 51000, @Return, informational;
	END


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
			SET @Return = '[CMS_Process_Exception] U_Beneficiary_MTMPEnrollment: ' + (select * from ( select ContractYear = @ContractYear, ClientID = @ClientID, ErrorProcedure = ERROR_PROCEDURE(), ErrorLine = ERROR_LINE(), ErrorMessage = ERROR_MESSAGE() ) r for json auto );
			EXEC xp_logevent 51000, @Return, informational;
			PRINT @Return;
		END

	END CATCH



END


