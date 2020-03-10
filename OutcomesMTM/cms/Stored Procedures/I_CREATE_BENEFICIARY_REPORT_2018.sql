


Create     procedure [cms].[I_CREATE_BENEFICIARY_REPORT_2018]
	  @ClientID int
	, @ContractYear char(4)
	, @ContractNumber char(5)
	, @DisplayReport bit = 1
	, @SaveReport bit = 0

AS
BEGIN

SET NOCOUNT ON;
	begin try

--declare 
--@ClientID int = 115
--	, @ContractYear char(4) =''
--	, @ContractNumber char(5) = 'H4152'
--	, @DisplayReport bit = 1
--	, @SaveReport bit = 0
--	, @RptRunDate date = null
--	, @Frequency varchar(50)  = null



--// test failsafe
--set @DisplayReport = 1
--set @SaveReport = 0

		Drop table if exists #cfg
		select  
			   cfg.[EnrollmentConfigID]
			  ,cfg.[ClientID]
			  ,cfg.[ContractYear]
			  ,cfg.[ContractNumber]
			  ,cfg.[PolicyID]
			  ,cfg.[EnrollmentType]
			  ,cfg.[EnrollmentSource]
			  ,cfg.[EnrollmentDateLogic]
			  ,cfg.[TargetingSource]
			  ,cfg.[TargetingDateLogic]
			  ,cfg.[ActiveFromDT]
			  ,cfg.[ActiveThruDT]
			  ,cfg.[Frequency]
			  ,[RptFromDate] = cast(cfg.ContractYear + '01-01' as date) --// should always be the first day of CY
			  ,[RptThruDate] = case 
						when getdate() > cast(cfg.ContractYear + '-12-31' as date) then cast(cfg.ContractYear + '-12-31' as date)  --// should never be > last day of CY
						when cfg.Frequency = 'QUARTERLY' then cast(dateadd(quarter,datediff(quarter,1,cast(getdate() as date)),-1) as date)  --// if QUARTERLY is specified, then last day of previous quarter
						else cast(dateadd(month,datediff(month,1,cast(getdate() as date)),-1) as date) --// defaults to last day of previous month
						end
		into #cfg
		from cms.EnrollmentConfig cfg
		where 1=1
		and cfg.ActiveThruDT > getdate()
		and cfg.ClientID = @ClientID
		and cfg.ContractYear = @ContractYear
		and cfg.ContractNumber = @ContractNumber
		--select * from #cfg


		--// get beneficiary and MTMP enrollment records
		drop table if exists #bene_mtmp
		select distinct
			  bm.BeneficiaryID
			, BeneficiaryKey = NULL  --, bm.BeneficiaryKey
			, bm.ContractYear
			, bm.ClientID
			, bm.HICN
			, bm.First_Name
			, bm.MI
			, bm.Last_Name
			, bm.DOB
			, bm.ContractNumber
			, bm.MTMPTargetingDate
			, bm.MTMPEnrollmentFromDate
			, bm.MTMPEnrollmentThruDate
			, bm.OptOutDate
			, bm.OptOutReasonCode
			, Rank_Contract = NULL
			, ActiveFromTT = NULL
			, ActiveThruTT = NULL
			, bm.MTMPEnrollmentID
			, PolicyID = NULL
			, bp.PatientID
			, cfg.RptFromDate 
			, cfg.RptThruDate
		into #bene_mtmp
		from cms.vw_CMS bm
		join #cfg cfg
			on cfg.ClientID = bm.ClientID
			and cfg.ContractYear = bm.ContractYear
			and cfg.ContractNumber = bm.ContractNumber
		join cms.CMS_BeneficiaryPatient_History bp
			on bp.BeneficiaryID = bm.BeneficiaryID
			and bp.isCurrent = 1
		where 1=1  
		and bm.MTMPEnrollmentFromDate between cfg.RptFromDate and cfg.RptThruDate  -- Added on 07/22 
		--and bm.OptOutDate between cfg.RptFromDate and cfg.RptThruDate  -- Added on 7/22
		--and bm.ClientID = @ClientID
		--and bm.ContractYear = @ContractYear
		--and bm.ContractNumber = @ContractNumber
		;

		--//Test
		--select * from #bene_mtmp
		--where OptOutDate > '06-30-2019'


		--// get raw CMR claim records
		drop table if exists #cmr_raw
		select distinct 
			  bm.BeneficiaryID
			, bm.ContractNumber
			, bm.MTMPEnrollmentFromDate
			, bm.MTMPEnrollmentThruDate
			, cmr.ClaimID
			, cmr.MTMServiceDT
			, cmr.ReasonCode
			, cmr.ActionCode
			, cmr.ResultCode
			, cmr.ClaimStatus
			, cmr.ClaimStatusDT
			, cmr.PatientID
			, cmr.PharmacyID
			, cmr.CMRWithSPT
			, cmr.CMROffer
			, cmr.CMRID
			, cmr.CognitivelyImpairedIndicator
			, cmr.MethodOfDeliveryCode
			, cmr.ProviderCode
			, cmr.RecipientCode
			--, cmr.SnapshotID
		into #cmr_raw
		--select *
		from cms.vw_CMR_Active cmr
		join #bene_mtmp bm
			on bm.PatientID = cmr.PatientID
			and cmr.MTMServiceDT between bm.MTMPEnrollmentFromDate and bm.MTMPEnrollmentThruDate
			and cmr.MTMServiceDT between bm.RptFromDate and bm.RptThruDate   -- Added on 7/22
;

--// test
--Select * from #cmr_raw where MTMServiceDT > = '06-30-2019'

		--// sort top 2 successful CMRs with SPT (Standard Patient Takeaway)
		drop table if exists #cmr
		select 
			cmr.*
			,rankRpt = rankCust
		into #cmr
		from (
			select cmr.*
				,rankCust = row_number() over (partition by cmr.BeneficiaryID, cmr.ContractNumber --// apply custom rank
							order by case
								when cmr.rankasc = 1 then 1  --// 1) first CMR
								when cmr.rankdesc = 1 then 2  --// 2) last CMR
								else 3 end asc
							--,cmr.MAPCount desc  --// 3) most MAP topics
							,cmr.MTMServiceDT desc)  --// 4) most recent
			from (
				select cmr.*
					, CMRCount = count(*) over (partition by cmr.BeneficiaryID, cmr.ContractNumber)
					, rankasc = row_number() over (partition by cmr.BeneficiaryID, cmr.ContractNumber order by cmr.MTMServiceDT asc)
					, rankdesc= row_number() over (partition by cmr.BeneficiaryID, cmr.ContractNumber order by cmr.MTMServiceDT desc)
				from #cmr_raw cmr
				where 1=1
				and cmr.CMRWithSPT = 1  --// CMR with SPT
			) cmr
		) cmr
		;

		--// combine CMR Offer data
		drop table if exists #cmro
		select distinct 
			  bm.BeneficiaryID
			, bm.ContractNumber
			, bm.MTMPEnrollmentFromDate
			, bm.MTMPEnrollmentThruDate
			, cmro.PatientID
			, cmro.CMROfferDate
			, cmro.CMROfferID
			, cmro.ClaimID
			--, cmro.SnapShotID
			, rank = row_number() over (partition by bm.BeneficiaryID, bm.ContractNumber order by cmro.CMROfferDate asc)  --// First CMR Offer within enrollment period
		into #cmro
		from (

			select 
				  cmro.PatientID
				, CMROfferDate = cmro.CMROfferDate
				, CMROfferID = cmro.CMROfferID
				, ClaimID = cmro.ClaimID
				, SnapshotID = cmro.SnapshotID
			--// select top 100 *
			from cms.vw_CMROffer_Active cmro
			where 1=1

		) cmro
		join #bene_mtmp bm
			on bm.PatientID = cmro.PatientID
			and cmro.CMROfferDate between bm.MTMPEnrollmentFromDate and bm.MTMPEnrollmentThruDate
			and cmro.CMROfferDate between bm.RptFromDate and bm.RptThruDate		-- Added on 7/22
		;
		 

		--// get TMR records
		drop table if exists #tmr
		select distinct 
			  bm.BeneficiaryID
			, bm.ContractNumber
			, bm.MTMPEnrollmentFromDate
			, bm.MTMPEnrollmentThruDate
			, tmr.PatientID
			, TMRDate = cast(tmr.TMRDate as date)
			, TMRID = tmr.TMRID
			--, tmr.SnapshotID
		into #tmr
		-- select top 100 *
		from cms.vw_TMR_Active tmr
		join #bene_mtmp bm
			on bm.PatientID = tmr.PatientID
			and cast(tmr.TMRDate as date) between bm.MTMPEnrollmentFromDate and bm.MTMPEnrollmentThruDate
			and cast(tmr.TMRDate as date) between bm.RptFromDate and bm.MTMPEnrollmentThruDate   -- Added on 7/22
		;

		--// get raw DTP claim records
		drop table if exists #dtp_raw
		select distinct 
			  dtp.ClaimID
			, dtp.MTMServiceDT
			, dtp.ReasonCode
			, dtp.ActionCode
			, dtp.ResultCode
			, dtp.ClaimStatus
			, dtp.ClaimStatusDT
			, dtp.PatientID
			, PharmacyNABP = dtp.NCPDP_NABP
			, dtp.DTPRecommendation
			, dtp.GPI
			, dtp.MedName
			, dtp.SuccessfulResult
			, bm.BeneficiaryID
			--, dtp.SnapshotID
		into #dtp_raw
		--select dtp.*
		from cms.vw_DTP_Active dtp
		join #bene_mtmp bm
			on bm.PatientID = dtp.PatientID
			and dtp.MTMServiceDT between bm.MTMPEnrollmentFromDate and bm.MTMPEnrollmentThruDate
			and dtp.MTMServiceDT between bm.RptFromDate and bm.RptThruDate   -- Added on 7/22
		;

		--// unique DTPs
		drop table if exists #dtp
		select distinct
			  BeneficiaryID
			, ContractNumber
			, MTMPEnrollmentFromDate
			, MTMPEnrollmentThruDate
			, ClaimID
			, MTMServiceDT
			, GPI
			, MedName
			, ReasonCode
			, ActionCode
			, ResultCode
			, ClaimStatus
			, ClaimStatusDT
			, PatientID
			, DTPRecommendation
			, DTPResolution = case when DTP.SuccessfulResult = 1 then 1 else 0 end
			--, dtp.SnapshotID
		into #dtp
		from (
			select distinct
				dtp.*
				,rrank = row_number() over (partition by year(dtp.MTMServiceDT), dtp.PatientID, dtp.ReasonCode, dtp.ActionCode, dtp.GPI  --// deduplicate based on Reason, Action, GPI
						order by dtp.SuccessfulResult desc, dtp.MTMServiceDT asc)  --// sort by successful DTPs, then oldest
				,mtmp.ContractNumber
				,mtmp.MTMPEnrollmentFromDate
				,mtmp.MTMPEnrollmentThruDate
			from #dtp_raw dtp
			join #bene_mtmp mtmp
				on mtmp.PatientID = DTP.PatientID
				and DTP.mtmServiceDT > dateadd(year,datediff(year,0,mtmp.MTMPEnrollmentFromDate),0)
				and DTP.mtmServiceDT < dateadd(year,datediff(year,-1,mtmp.MTMPEnrollmentFromDate),0)
			where 1=1
			and dtp.GPI is not null  --// exclude claims that don't have a GPI
			and dtp.mtmServiceDT between mtmp.MTMPEnrollmentFromDate and mtmp.MTMPEnrollmentThruDate
			and  dtp.mtmServiceDT between mtmp.RptFromDate and mtmp.RptThruDate  -- Added on 7/22
		) DTP
		where 1=1
		and dtp.rrank = 1
		;


		--// CTEs to format into reporting elements
		drop table if exists #rpt;
		WITH 
		cteBene as
		(
			select distinct
				  ClientID
				, ContractYear
				, ContractNumber
				, BeneficiaryID
				, BeneficiaryKey
				, First_Name
				, MI
				, Last_Name
				, DOB
				, HICN
				, MTMPCriteriaMet = case when MTMPTargetingDate is not null then 'Y' else 'N' end
				, MTMPTargetingDate
				, MTMPEnrollmentFromDate
				, MTMPEnrollmentThruDate
				, OptOutDate = case when OptOutReasonCode in ('01','02','03','04') then OptOutDate else NULL end
				, OptOutReasonCode = case when OptOutReasonCode in ('01','02','03','04') then OptOutReasonCode else NULL end
				, RptFromDate   -- Added on 7/22
				, RptThruDate	-- Added on 7/22
			from #bene_mtmp m
			where 1=1
		)
		,cteCMROffer as
		(
			select *
			from #cmro
			where rank = 1  --// only 1 per beneficiary/contract
		)
		,cteCMR as
		(
			select 
				  BeneficiaryID
				, ContractNumber
				, CMR_Count = CMRCount
				, CMR_CognitivelyImpairedIndicator = max(case when cmr.rankRpt = 1 then cmr.CognitivelyImpairedIndicator end)
				, CMR_MethodOfDeliveryCode = max(case when cmr.rankRpt = 1 then cmr.MethodOfDeliveryCode end)
				, CMR_ProviderCode = max(case when cmr.rankRpt = 1 then cmr.ProviderCode end)
				, CMR_RecipientCode = max(case when cmr.rankRpt = 1 then cmr.RecipientCode end)
				, CMR_Date1 = max(case when cmr.rankRpt = 1 then cmr.MTMServiceDT end)
				, CMR_Date2 = max(case when cmr.rankRpt = 2 and cmr.CMRCount >= 2 then cmr.MTMServiceDT end)
			from #cmr cmr
			group by BeneficiaryID, ContractNumber, CMRCount
		)
		,cteDTP as 
		(
			select 
				  BeneficiaryID
				, ContractNumber
				, DTPR_Count = sum(cast(DTPRecommendation as int))
				, DTPC_Count = sum(cast(DTPResolution as int))
			from #dtp
			group by BeneficiaryID, ContractNumber
		)
		,cteTMR as
		(
			select 
				  BeneficiaryID
				, ContractNumber
				, TMR_Count = count(distinct TMRDate)
			from #tmr
			group by BeneficiaryID, ContractNumber
		)

		--// bring everything together into the final report
		select
			  ReportID = identity(int,1,1)
			, b.ClientID
			, b.BeneficiaryID
			, b.BeneficiaryKey
			, b.ContractNumber
			, HICN = ltrim(rtrim(b.HICN))
			, FirstName = ltrim(rtrim(b.First_Name))
			, MI = left(ltrim(b.MI),1)
			, LastName = ltrim(rtrim(b.Last_Name))
			, DOB = cast(b.DOB as date)
			, MTMPCriteriaMet = isnull(b.MTMPCriteriaMet,'N')
			, MTMPEnrollmentFromDate = cast(b.MTMPEnrollmentFromDate as date)
			, MTMPEnrollmentThruDate = cast(b.MTMPEnrollmentThruDate as date)
			, MTMPTargetingDate = cast(b.MTMPTargetingDate as date)
			, OptOutDate = cast(b.OptOutDate as date)
			, OptOutReasonCode = isnull(right('00' + b.OptOutReasonCode,2),'')
			, CMROffered = case when cmro.CMROfferDate is null then 'N' else 'Y' end
			, CMROfferDate = cast(cmro.CMROfferDate as date)
			, CMRReceived = case when cmr.CMR_Count > 0 then 'Y' else 'N' end
			, CMR_Count = isnull(cmr.CMR_Count,0)
			, CMR_CognitivelyImpairedIndicator = isnull(cmr.CMR_CognitivelyImpairedIndicator,'U')
			, CMR_MethodOfDeliveryCode = isnull(cmr.CMR_MethodOfDeliveryCode,'')
			, CMR_ProviderCode = isnull(cmr.CMR_ProviderCode,'')
			, CMR_RecipientCode = isnull(cmr.CMR_RecipientCode,'')
			, CMR_Date1 = cast(cmr.CMR_Date1 as date)
			, CMR_Date2 = cast(cmr.CMR_Date2 as date)
			, TMR_Count = isnull(tmr.TMR_Count,0)
			, DTPR_Count = isnull(dtp.DTPR_Count,0)
			, DTPC_Count = isnull(dtp.DTPC_Count,0)
			, RptFromDate = b.RptFromDate   -- Added 7/22
			, RptThruDate =  b.RptThruDate	-- Added 7/22
		into #rpt
		from cteBene b
		left join cteCMROffer cmro
			on cmro.BeneficiaryID = b.BeneficiaryID
			and cmro.ContractNumber = b.ContractNumber
		left join cteCMR cmr
			on cmr.BeneficiaryID = b.BeneficiaryID
			and cmr.ContractNumber = b.ContractNumber
		left join cteTMR tmr
			on tmr.BeneficiaryID = b.BeneficiaryID
			and tmr.ContractNumber = b.ContractNumber
		left join cteDTP dtp
			on dtp.BeneficiaryID = b.BeneficiaryID
			and dtp.ContractNumber = b.ContractNumber
		where 1=1
		order by b.ContractNumber, b.Last_Name, b.First_Name, b.DOB, b.BeneficiaryID
		;



		drop table if exists #rpt_Batch__INSERTED
		create table #rpt_Batch__INSERTED
		(
			BatchID int
			, ClientID int
			, ContractYear char(4)
			, ContractNumber varchar(5)
			, ActiveFromDT datetime
			, ActiveThruDT datetime
			, Notes varchar(8000)
			
			, RptFromDT date		-- Added on 07/22
			, RptThruDt date
		)

		--// save report
		if @SaveReport = 1
		begin
			
			--// insert new Batch record
			insert into cms.CMS_rpt_Batch 
			(
				  ClientID
				, ContractYear
				, ContractNumber
				--, Notes
				, RptFromDT
				, RptThruDT
			)
				output inserted.* into #rpt_Batch__INSERTED
			select distinct
				  ClientID		= cfg.clientID
				, ContractYear	= cfg.ContractYear
				, ContractNumber= cfg.ContractNumber
				, RptFromDT		= cfg.RptFromDate
				, RptThruDate	= cfg.RptThruDate   
			from #cfg cfg
				--, Notes			= @Notes
			;


			--// log report records
			insert into cms.rpt_Report_Log
			(
				  BatchID
				, ReportID
				, ClientID
				, BeneficiaryID
				, BeneficiaryKey
				, ContractNumber
				, HICN
				, FirstName
				, MI
				, LastName
				, DOB
				, MTMPCriteriaMet
				, MTMPEnrollmentFromDate
				, MTMPEnrollmentThruDate
				, MTMPTargetingDate
				, OptOutDate
				, OptOutReasonCode
				, CMROffered
				, CMROfferDate
				, CMRReceived
				, CMR_Count
				, CMR_CognitivelyImpairedIndicator
				, CMR_MethodOfDeliveryCode
				, CMR_ProviderCode
				, CMR_RecipientCode
				, CMR_Date1
				, CMR_Date2
				, TMR_Count
				, DTPR_Count
				, DTPC_Count
				, RptFromDT-- Removed
				, RptThruDT-- Removed
			)
			select
				  BatchID = ( select distinct BatchID from #rpt_Batch__INSERTED )
				, rpt.ReportID
				, rpt.ClientID
				, rpt.BeneficiaryID
				, rpt.BeneficiaryKey
				, rpt.ContractNumber
				, rpt.HICN
				, rpt.FirstName
				, rpt.MI
				, rpt.LastName
				, rpt.DOB
				, rpt.MTMPCriteriaMet
				, rpt.MTMPEnrollmentFromDate
				, rpt.MTMPEnrollmentThruDate
				, rpt.MTMPTargetingDate
				, rpt.OptOutDate
				, rpt.OptOutReasonCode
				, rpt.CMROffered
				, rpt.CMROfferDate
				, rpt.CMRReceived
				, rpt.CMR_Count
				, rpt.CMR_CognitivelyImpairedIndicator
				, rpt.CMR_MethodOfDeliveryCode
				, rpt.CMR_ProviderCode
				, rpt.CMR_RecipientCode
				, rpt.CMR_Date1
				, rpt.CMR_Date2
				, rpt.TMR_Count
				, rpt.DTPR_Count
				, rpt.DTPC_Count
				, rpt.RptFromDate
				, rpt.RptThruDate
			from #rpt rpt
			;



			--// log beneficiary MTMP records
			insert into cms.rpt_BeneMTMP_Log
			(
				BatchID
				,BeneficiaryID
				,BeneficiaryKey
				,ContractYear
				,ClientID
				,HICN
				,FirstName
				,MI
				,LastName
				,DOB
				,ContractNumber
				,MTMPTargetingDate
				,MTMPEnrollmentFromDate
				,MTMPEnrollmentThruDate
				,OptOutDate
				,OptOutReasonCode
				,Rank_Contract
				,ActiveFromTT
				,ActiveThruTT
				,MTMPEnrollmentID
				,PolicyID
				,PatientID
			)
			select
				BatchID = ( select distinct BatchID from #rpt_Batch__INSERTED )
				,BeneficiaryID
				,BeneficiaryKey
				,ContractYear
				,ClientID
				,HICN
				,First_Name
				,MI
				,Last_Name
				,DOB
				,ContractNumber
				,MTMPTargetingDate
				,MTMPEnrollmentFromDate
				,MTMPEnrollmentThruDate
				,OptOutDate
				,OptOutReasonCode
				,Rank_Contract
				,ActiveFromTT
				,ActiveThruTT
				,MTMPEnrollmentID
				,PolicyID
				,PatientID
				--, bm.*
			from #bene_mtmp bm
			;


			--// log CMR records
			insert into cms.rpt_CMR_Log
			(
				 [BatchID]
				,BeneficiaryID
				,[ContractNumber]
				,[MTMPEnrollmentFromDate]
				,[MTMPEnrollmentThruDate]
				,[ClaimID]
				,[MTMServiceDT]
				,[ReasonCode]
				,[ActionCode]
				,[ResultCode]
				,[ClaimStatus]
				,[ClaimStatusDT]
				,[PatientID]
				,[PharmacyID]
				,[CMRWithSPT]
				,[CMROffer]
				,[CMRID]
				,[CognitivelyImpairedIndicator]
				,[MethodOfDelivery]
				,[ProviderCode]
				,[RecipientCode]
				,[CMRCount]
				,[RankAsc]
				,[RankDesc]
				,[RankCust]
				,[RankRpt]
			)
			select 
				BatchID = ( select distinct BatchID from #rpt_Batch__INSERTED )
				,BeneficiaryID
				,[ContractNumber]
				,[MTMPEnrollmentFromDate]
				,[MTMPEnrollmentThruDate]
				,[ClaimID]
				,[MTMServiceDT]
				,[ReasonCode]
				,[ActionCode]
				,[ResultCode]
				,[ClaimStatus]
				,[ClaimStatusDT]
				,[PatientID]
				,[PharmacyID]
				,[CMRWithSPT]
				,[CMROffer]
				,[CMRID]
				,[CognitivelyImpairedIndicator]
				,[MethodOfDelivery] = cmr.MethodOfDeliveryCode
				,[ProviderCode]
				,[RecipientCode]
				,[CMRCount]
				,[RankAsc]
				,[RankDesc]
				,[RankCust]
				,[RankRpt]
			from #cmr cmr
			;

			--// log CMR Offer records
			insert into cms.rpt_CMROffer_Log
			(
				BatchID
				,BeneficiaryID
				,ContractNumber
				,MTMPEnrollmentFromDate
				,MTMPEnrollmentThruDate
				,PatientID
				,CMROfferDate
				,CMROfferID
				,ClaimID
				,RptRank
			)
			select 
				BatchID = ( select distinct BatchID from #rpt_Batch__INSERTED )
				,BeneficiaryID
				,ContractNumber
				,MTMPEnrollmentFromDate
				,MTMPEnrollmentThruDate
				,PatientID
				,CMROfferDate
				,CMROfferID
				,ClaimID
				,RptRank = cmro.rank
			from #cmro cmro
			;

			--// log DTP records
			insert into cms.rpt_DTP_Log
			(
				BatchID
				,BeneficiaryID
				,ContractNumber
				,MTMPEnrollmentFromDate
				,MTMPEnrollmentThruDate
				,ClaimID
				,MTMServiceDT
				,GPI
				,MedName
				,ReasonCode
				,ActionCode
				,ResultCode
				,ClaimStatus
				,ClaimStatusDT
				,PatientID
				,DTPRecommendation
				,DTPResolution			
			)
			select 
				BatchID = ( select distinct BatchID from #rpt_Batch__INSERTED )
				,BeneficiaryID
				,ContractNumber
				,MTMPEnrollmentFromDate
				,MTMPEnrollmentThruDate
				,ClaimID
				,MTMServiceDT
				,GPI
				,MedName
				,ReasonCode
				,ActionCode
				,ResultCode
				,ClaimStatus
				,ClaimStatusDT
				,PatientID
				,DTPRecommendation
				,DTPResolution		
			from #dtp dtp
			;

			--// log TMR records
			insert into cms.rpt_TMR_Log
			(
				BatchID
				,BeneficiaryID
				,ContractNumber
				,MTMPEnrollmentFromDate
				,MTMPEnrollmentThruDate
				,PatientID
				,TMRDate
				,TMRID		
			)
			select 
				BatchID = ( select distinct BatchID from #rpt_Batch__INSERTED )
				,BeneficiaryID
				,ContractNumber
				,MTMPEnrollmentFromDate
				,MTMPEnrollmentThruDate
				,PatientID
				,TMRDate
				,TMRID	
			from #tmr tmr
			;

		end

		--// show report
		if @DisplayReport = 1
		begin
	
			select 
				BatchID = NULL --( select distinct BatchID from #rpt_Batch__INSERTED )
				, rpt.*
			from #rpt rpt
			order by ReportID
			;

		end

		drop table #bene_mtmp;
		drop table #cmr_raw;
		drop table #cmr;
		drop table #cmro;
		drop table #dtp_raw;
		drop table #dtp;
		drop table #tmr;
		drop table #rpt;

	end try

	--// error handling
	begin catch

		PRINT ERROR_MESSAGE();

	end catch

END




