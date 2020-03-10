

CREATE     PROCEDURE [cms].[I_Beneficiary_MTMPEnrollment_Validation]
	@ClientID int
	, @ContractYear char(4) = NULL
	
AS


BEGIN

SET NOCOUNT ON;

	--// debugging-->> declare @ClientID int = 147, @ContractYear char(4) = '2019'
	drop table if exists #st
	select top 1 st.ClientID, st.ContractYear, st.SnapshotID
	into #st
	from cms.CMS_SnapshotTracker st
	where 1=1
	and st.ClientID = @ClientID
	and st.DataSetTypeID = 2  --// Beneficiary
	and st.ActiveThruDT > getdate()
	and (st.ContractYear = @ContractYear or isnull(@ContractYear,'') = '' )
	order by st.ContractYear desc

	declare @SnapshotID int = (select SnapshotID from #st)


--// *****************************************
--//   Validation Rules
--// *****************************************

exec cms.ValidationEngineRun
	@ValidationDataSet = 1  --// cms.vw_CMS
	, @BatchKey = 'SnapshotID'
	, @BatchValue = @SnapshotID



--// *****************************************
--//   Beneficiary Match
--// *****************************************

drop table if exists #benemtmp
create table #benemtmp
(
	BeneficiaryID int
	,ClientID int
	,ContractYear char(4)
	,HICN varchar(50)
	,First_Name varchar(30)
	,MI varchar(1)
	,Last_Name varchar(30)
	,DOB date
	,snapshotID int
	,MTMPEnrollmentID int
	,PatientID_All varchar(50)
	,PatientID int
	,ContractNumber varchar(5)
	,MTMPTargetingDate date
	,MTMPEnrollmentFromDate date
	,MTMPEnrollmentThruDate date
	,OptOutReasonCode varchar(2)
	,OptOutDate date
)

insert into #benemtmp
(
	BeneficiaryID
	,ClientID
	,ContractYear
	,HICN
	,First_Name 
	,MI
	,Last_Name
	,DOB
	,snapshotID
	,MTMPEnrollmentID
	,PatientID_All
	,PatientID
	,ContractNumber
	,MTMPTargetingDate
	,MTMPEnrollmentFromDate
	,MTMPEnrollmentThruDate 
	,OptOutReasonCode
	,OptOutDate 
)
select
	BeneficiaryID
	,ClientID
	,ContractYear
	,HICN
	,First_Name 
	,MI
	,Last_Name
	,DOB
	,snapshotID
	,MTMPEnrollmentID
	,PatientID_All
	,PatientID
	,ContractNumber
	,MTMPTargetingDate
	,MTMPEnrollmentFromDate
	,MTMPEnrollmentThruDate 
	,OptOutReasonCode
	,OptOutDate
--from outcomesMTM.cms.vw_CMS bm
from cms.tvf_CMS(@SnapshotID) bm
where 1=1
--and bm.SnapshotID = (select SnapshotID from #st)


--// BEGIN TABLE create config
drop table if exists #benematchrule
create table #benematchrule
(
	BeneMatchRuleID int
	, BeneMatchKeyDesc varchar(8000)
)
insert into #benematchrule values (1, 'First_Name~Last_Name~DOB')
insert into #benematchrule values (2, 'HICN_MBI')



drop table if exists #Beneficiary
select distinct
	b.ClientID
	, b.ContractYear
	, b.BeneficiaryID
	, b.PatientID
	, b.HICN
	, b.First_Name
	, b.Last_Name
	, b.DOB
into #Beneficiary
from #benemtmp b
where 1=1

--// get all the BeneMatchValue's for each BeneMatchRuleID
drop table if exists #HashRules
select 
	h.BeneficiaryID
	, h.PatientID
	, h.BeneMatchRuleID
	, h.BeneMatchValue
into #HashRules
from (
		--// 'First_Name~Last_Name~DOB'
		select distinct
			BeneMatchRuleID = 1
			, b.BeneficiaryID
			, b.PatientID
			, BeneMatchValue = convert( varchar(1000), upper(ltrim(rtrim(b.First_Name))) + '~' + upper(ltrim(rtrim(b.Last_Name))) + '~' + convert(varchar(8), b.DOB, 112) )  --// concat match string
		from #Beneficiary b

		UNION ALL

		--// 'HICN_MBI'
		select distinct
			BeneMatchRuleID = 2
			, b.BeneficiaryID
			, b.PatientID
			, BeneMatchValue = convert( varchar(1000), upper(ltrim(rtrim(isnull(NULLIF(b.HICN,''), NULL))))) 
		from #Beneficiary b
) h

create nonclustered index IX__Hash ON #HashRules(BeneMatchValue, PatientID) include (BeneMatchRuleID, BeneficiaryID)

drop table if exists #BeneficiaryMatch_stg
create table #BeneficiaryMatch_stg
(
	SnapshotID int
	, PatientID int
	, BeneficiaryMatchCheck varchar(8000)
	, BeneficiaryMatch_PatientIDs varchar(255)
)

--// debugging:  declare @SnapshotID int = (select SnapshotID from #st)
drop table if exists #Matches
; with Matches as (
		select hr.*
		from #HashRules hr
		join #HashRules hr2
			on hr2.PatientID <> hr.PatientID
			and hr2.BeneMatchValue = hr.BeneMatchValue  
)
select distinct
	m.*
	, CompositePatientID = stuff((  --// concat all PatientIDs together
			select '~' + cast(m2.PatientID as varchar(50))
			from Matches m2
			where 1=1
			and m2.PatientID =m.PatientID --Added on 01/09/2018
			and m2.BeneMatchValue = m.BeneMatchValue
			group by m2.PatientID
			order by m2.PatientID
			for XML PATH('')), 1, 1, '')
into #Matches
from Matches m


; with matches as (
		select distinct
			m.PatientID
			, bmr.BeneMatchRuleID
			, BeneficiaryMatchCheck = bmr.BeneMatchKeyDesc + ':' + m.BeneMatchValue		
			, m.CompositePatientID
		from #matches m
		join #benematchrule bmr
			on bmr.BeneMatchRuleID = m.BeneMatchRuleID
)

, matches2 as (
select distinct
	m.PatientID
	, m.BeneficiaryMatchCheck
	, CompositePatientID2 = stuff((
			select distinct '~' + m2.CompositePatientID  --// this will concat all CompositePatientID's if there are any cross-patient matches
			from matches m2
			where m2.BeneficiaryMatchCheck = m.BeneficiaryMatchCheck --Added on 01/09/2019
			order by 1
			for XML PATH('')), 1, 1, '')
from matches m  --// PLACEHOLDER for the actual table
)
insert into #BeneficiaryMatch_stg
select distinct
	SnapshotID = @SnapshotID
	, PatientID = m.PatientID
	, BeneficiaryMatchCheck = stuff((  --// this will concat BeneficiaryMatchCheck using the newly concatenated CompositePatientID
			select distinct ' | ' + m2.BeneficiaryMatchCheck
			from matches2 m2
			where m2.PatientID =m.PatientID
			--m2.CompositePatientID2 = m.CompositePatientID2
			order by 1
			for XML PATH('')), 1, 3, '')
	, BeneficiaryMatch_OMTM_IDs = m.CompositePatientID2
from matches2 m



BEGIN TRY

	--// UPDATE
	update bma set
		bma.BeneficiaryMatchCheck = stg.BeneficiaryMatchCheck
		, bma.BeneficiaryMatch_PatientIDs = stg.BeneficiaryMatch_PatientIDs
		, bma.ChangeDT = getdate()
	--// select *
	from cms.BeneficiaryMatch bma
	join #BeneficiaryMatch_stg stg
		on stg.SnapshotID = bma.SnapshotID
		and stg.PatientID = bma.PatientID
	where 1=1
	and (
			bma.BeneficiaryMatchCheck <> stg.BeneficiaryMatchCheck
		or	bma.BeneficiaryMatch_PatientIDs <> stg.BeneficiaryMatch_PatientIDs
		)



	--// INSERT
	insert into cms.BeneficiaryMatch
	(
		SnapshotID
		, PatientID
		, BeneficiaryMatchCheck
		, BeneficiaryMatch_PatientIDs
	)
	select distinct
		stg.SnapshotID
		, stg.PatientID
		, stg.BeneficiaryMatchCheck
		, stg.BeneficiaryMatch_PatientIDs
	from #BeneficiaryMatch_stg stg
	left join cms.BeneficiaryMatch bma
		on bma.SnapshotID = stg.SnapshotID
		and bma.PatientID = stg.PatientID
	where 1=1
	and bma.BeneficiaryMatchID is null


	--// DELETE
	delete bma
	from cms.BeneficiaryMatch bma
	left join #BeneficiaryMatch_stg stg
		on stg.SnapshotID = bma.SnapshotID
		and stg.PatientID = bma.PatientID
	where 1=1
	and bma.SnapshotID in (select SnapshotID from #st)
	and stg.PatientID is null


END TRY
BEGIN CATCH
	THROW;
END CATCH

END

