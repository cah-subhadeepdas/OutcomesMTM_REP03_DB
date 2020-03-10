




CREATE      PROCEDURE [cms].[CMS_CREATE_SUPPLEMENTAL_QTR_REPORT]
	@ClientID int
	, @ContractYear char(4) = ''
	, @Thrudate date = null

AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

--declare 
--	  @ClientID int = 115
--	, @ContractYear char(4) = null
--	, @ContractNumber char(5) = 'H4152'
--	, @ThruDate date = null --'03-31-2019'--null


IF isnull(@ContractYear,'') = ''
	SET @ContractYear = datepart(yyyy, getdate())  -- CY

IF isnull(@Thrudate,'') =''
	Begin		
		declare @rundate date = getdate(), @fromdate date, @thrudate1 date, @Qtr_CY  int
		--set @Qtr_CY =  DATEPART(QUARTER, @rundate)
		--print @qtr_cy

		set @Fromdate =  cast(dateadd(yy, datediff(yy, 0,getdate()),0) as date)  -- First day of the CY
		set @ThruDate =  cast(dateadd(dd,-1, dateadd(qq,datediff(qq,0,@rundate),0)) as date)  -- last day of the previous quarter
		--print @fromdate
		--print @thrudate
	End
	--print @Thrudate

	--set @fromdate = cast(dateadd(yy, datediff(yy, 0,getdate()),0) as date)
	--set @ThruDate = '03-31-2019'


		--print @fromdate
		--print @thrudate




		drop table if exists #benemtmp
		select distinct
			  [ClientName] = ba.ClientName
			, PatientID 	  --// OMTM_ID
			, [MemberID] = ba.MemberID 
			, [FirstName] = case when ba.FirstName is not null then ba.FirstName else '' end  
			--, [MiddleInitial] = case when ba.MiddleInitial is not null then MiddleInitial else '' end
			, [LastName] = case when ba.LastName is not null then ba.LastName else '' end 
			, [DOB] = convert(char(8),ba.DOB,112) 
			, [HICN_MBI] = ba.HICN_MBI
			, [ContractNumber] = ba.ContractNumber
			, [MTMPEnrollmentStartDate] = ba.MTMPEnrollmentStartDate
			, [MTMPTargetingDate] = convert(char(8),ba.MTMPTargetingDate, 112)
			, [OptOutDate] = case 
								when (ba.OptOutDate is not null and ba.optoutdate between @Fromdate and @Thrudate) then convert(char(8),ba.OptOutDate, 112) 
								else '' end 
			, [OptOutReasonCode] = case when ba.OptOutReasonCode is not null then ba.OptOutReasonCode else '' end
			, [ClientID] = ba.ClientID
			, [ContractYear] = ba.ContractYear
		into #benemtmp
		from outcomesmtm.[cms].[vw_Bene_MTMPEnrollment_Active] ba  --// To Do: this looks like the supplemental file format??; need seperate views
		where 1=1
		and ba.ClientID = @ClientID
		and ba.ContractYear = @ContractYear -- Added on 04/04/2019, Sam
		and ba.MTMPEnrollmentStartDate between @Fromdate and @Thrudate
		and ba.MTMPTargetingDate  between @Fromdate and @Thrudate
		;


		drop table if exists #vrp
		select vrp.*
		into #vrp
		from #benemtmp bm
		join OutcomesMTM.cms.vw_ValidationRunResult_Active_PivotPatient vrp
			on vrp.PatientID = bm.PatientID
		where 1=1
		and ( vrp.ValidationCheck_CSV is not null or vrp.ValidationCheck_CSV <> '' )
		;


		drop table if exists #benematch
		select bmc.*
		into #benematch
		from #benemtmp bm
		join OutcomesMTM.cms.vw_BeneMatchCheck bmc
			on bmc.PatientID = bm.PatientID
		where 1=1
		;

		--select
		--r.[ClientName],
		--r.[OMTM_ID], 
		--r.[Member ID], 
		--r.[FirstName], 
		--r.[MiddleInitial], 
		--r.[LastName], 
		--r.[DOB], 
		--r.[HICN_MBI], 
		--r.[ContractNumber], 
		--r.[MTMPEnrollmentStartDate], 
		--r.[MTMPTargetingDate],
		--r.[OptOutDate], 
		--r.[OptOutReasonCode], 
		--r.[BeneficiaryMatchCheck], 
		--r.[ValidationCheck], 
		--r.[ActionRequiredOnCheck],
		--r.[BeneficiaryMatch_OMTM_IDs], 
		--[SelectMasterOMTM_ID] = case when r.[BeneficiaryMatch_OMTM_IDs] is not null then '' else 'NA' end, 
		--r.[RemoveMember]


		--from  
		--(
		select distinct
			  [ClientName] = bm.ClientName
			, [OMTM_ID] = bm.PatientID 	  --// OMTM_ID
			, [Member ID] = bm.MemberID 
			, [FirstName] = isnull(bm.FirstName,'') 
			--, [MiddleInitial] = isnull(bm.MiddleInitial,'')
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
			on vrp.PatientID = bm.PatientID
		left join #benematch bmc
			on bmc.PatientID = bm.PatientID
		--)  r 
		;

END


