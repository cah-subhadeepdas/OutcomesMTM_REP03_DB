


CREATE   procedure [reporting].[SP_TC_AdHoc_Scripts]
as 

Begin

select 0



----// TC-3679 - CareSourceGenericpatientList
----Start TC-3679 -- SQL02
----========================================================================
----    Initial script created details
----		Card Number:	TC-2635
----		Create Date:	01/25/2018
----		Created By:		Santhosh K. T.
----		Description:	Caresource Generic Patient List Broken Out For COC and Q1 Identification
----		Modified by:    Pranay R (TC-3568)
----                      Pranay R (TC-3679)
----		Modified Date:  01/24/2020
----                      03/05/2020
----     Store proc created details
----     create Date: 03/05/2020 
----       Created By : Pranay R
----      Modified By : 
----========================================================================





---- Loading Data into Temp table for provided identification run

--drop TABLE IF EXISTS #result
-- select * into #result from (

--	select t.runRank  
--	, t.identificationRunid 
--	, t.identificationConfigID 
--	, t.runRxDataThru
--	, t.patientid 
--	, t.total
--	, t.hitcriteria
--	, t.active 
--	from (
--		select row_number() over (partition by t.identificationConfigID, r.patientid 
--								  order by t.runRxDataThru, r.identificationRunResultID) as runRank 
--		, t.identificationRunid 
--		, t.identificationConfigID 
--		, t.runRxDataThru
--		, r.patientid 
--		, 1 as total
--		, cast(r.hitcriteria as int) as hitcriteria
--		, t.active 
--		from identificationRun t with (nolock)
--		join identificationRunResult r with (nolock) on t.identificationRunid = r.identificationRunid
--		where 1=1 
--		and t.IdentificationRunID IN (7906,7907)
--		----and t.identificationConfigid = 748 
--	)t ) t12
	
-------------------------------

--drop TABLE IF exists #mhspt
-- select * 
-- into #mhspt 
-- from 
-- (
--			select c.identificationConfigID  
--			--, c.identificationConfigName 
--			, r.identificationrunid 
--			, r.policyid 
--			, p.policyName
--			--, hc.TotalPtsRun
--			--, hc.TotalPtsHitCriteria
--			, hc.NewPtsHitCriteria
--			, hc.patientid
--			--, c.contractyear
--			--, i.IdentificationType
--			--, s.serviceType
--			--, r.approvedDate
--			--, r.policyRxDataFrom 
--			--, r.policyRxDataThru 
--			--, r.runRxDataThru  
--			, r.runDate
--			--, r.active  
--			--, r.runInactivationDate  
--			from identificationRun r with (nolock) 
--			join IdentificationConfig c with (nolock) on c.identificationConfigid = r.identificationConfigID
--			join IdentificationType i on i.IdentificationTypeID = c.identificationTypeID
--			join serviceType s on s.serviceTypeID = c.serviceTypeID
--			left join policy p with (nolock) on p.policyid = r.policyid 
--			left join (
--				select r.identificationrunid 
--				--, isnull(TotalPtsRun,0) as TotalPtsRun
--				--, isnull(TotalPtsHitCriteria, 0) as TotalPtsHitCriteria
--				, isnull(NewPtsHitCriteria,0) as NewPtsHitCriteria
--				, patientid
--				from identificationRun r
--				--left join (
--				--	select identificationRunid, SUM(total) as TotalPtsRun, SUM(hitcriteria) as TotalPtsHitCriteria
--				--	from #Result r
--				--	group by identificationRunid
--				--) t1 on t1.identificationrunid = r.identificationrunid 
--				left join (
--					select r.identificationRunID 
--					, 1 as NewPtsHitCriteria
--					, t.patientid
--					from #Result r 
--					join (
--						select row_number() over (partition by identificationConfigID, patientid 
--												  order by runRxDataThru) as newRank
--						, identificationConfigID
--						, runRxDataThru
--						, patientid 
--						, runRank
--						from #Result r
--						where 1=1 
--						and hitcriteria = 1
--						and r.active = 1
--					) t on t.identificationConfigID = r.identificationConfigID
--						   and t.patientid = r.patientid 
--						   and t.runRank = r.runRank 
--						   and t.newRank = 1
--					--group by r.identificationRunID 
--				) t2 on t2.identificationrunid = r.identificationrunid 
--				where 1=1 
--			) hc on hc.identificationrunid = r.identificationrunid 
--			where 1=1 
--			and r.IdentificationRunID IN (7906,7907)
--) mp

----------------------- Selecting COC patients if they are categorized into two of them


----**************************************************************************************************************************************************************

----CREATE TABLE #tblPolicyIDs
----	(
----		policyID INT
----	)
----	INSERT INTO #tblPolicyIDs
----	SELECT Item
----	FROM Outcomes.dbo.DelimitedSplit8K(498,',')

----Select * From #tblPolicyIDs

	
--	-- Convert the comma separated list to a table.
--	--CREATE TABLE #tblChainCodesExclude
--	--(
--	--	chainCode VARCHAR(50)
--	--)
--	--INSERT INTO #tblChainCodesExclude
--	--SELECT Item
--	--FROM Outcomes.dbo.DelimitedSplit8K(@chainCodesExclude, ',')

--	-- Identify the patientids used in the report.
--	--Drop table #tblPatientIDs
--	--CREATE TABLE #tblPatientIDs
--	--(
--	--	patientID BIGINT PRIMARY KEY
--	--)
--	--INSERT INTO #tblPatientIDs
--	DROP TABLE IF EXISTS #tblPatientIDs
--	SELECT pt.PatientID
--	INTO #tblPatientIDs
--	FROM outcomes.dbo.patient AS pt

--	WHERE 1=1
--	and pt.PolicyID = 758
--	and pt.OutcomesEligibilityDate >= '2020-01-01'

--	-- Identify the patient's last CMR result description.
--	--Drop table #tblPatientLastCMR
--	--CREATE TABLE #tblPatientLastCMR
--	--(
--	--	patientID BIGINT PRIMARY KEY
--	--	,resultDesc VARCHAR(100)
--	--	,mtmServiceDT DATETIME
--	--)
--	--INSERT INTO #tblPatientLastCMR
--	DROP TABLE IF EXISTS #tblPatientLastCMR
--	SELECT patientid
--	,resultDesc
--	,mtmServiceDT
--	INTO #tblPatientLastCMR
--	FROM
--	(
--		SELECT c.patientid
--		,rt.resultDesc
--		,c.mtmServiceDT
--		,ROW_NUMBER() OVER (PARTITION BY c.patientid ORDER BY c.mtmservicedt DESC) AS ranker
--		FROM #tblPatientIDs AS pt
--		JOIN outcomes.dbo.claim AS c ON pt.patientID=c.patientid
--		JOIN outcomes.dbo.resulttype AS rt on rt.resultTypeID = c.resultTypeID
--		WHERE 1=1
--		AND c.statusID in (2, 6) -- Pending approval (2), Approved (6)
--		AND c.actionTypeID = 1 -- Comprehensive Medication Review (1)
--		AND c.reasonTypeID = 11 -- CMR - Complex drug therapy (11)
--	) AS aa
--	WHERE aa.ranker=1




--	-- Identify and rank the patients' pharmacies.
--Drop TABLE IF EXISTS #tblPharmacies
--SELECT ptids.patientid
--	,ROW_NUMBER() OVER (PARTITION BY ptids.patientid ORDER BY ppp.primarypharmacy DESC, pppfp.pctfillatcenter DESC) AS ranker
--	,ph.NCPDP_NABP
--	,ph.centername
--	,ph.centerid
--	,ph.Address1
--	,ph.Address2
--	,ph.AddressCity
--	,ph.AddressState
--	,ph.AddressPostalCode
--	,ph.PHONE
--	INTO #tblPharmacies
--	FROM #tblPatientIDs AS ptids
--	JOIN outcomes.dbo.patientPrimaryPharmacy AS ppp on ptids.PatientID = ppp.patientid
--	JOIN outcomes.dbo.patientPrimaryPharmacyFillPct pppfp on ppp.patientid = pppfp.patientid 
--		AND ppp.centerid = pppfp.centerid 
--	JOIN outcomes.dbo.pharmacy AS ph ON ppp.centerid = ph.centerid
--	JOIN maintenance.dbo.Pharmacy_Trained AS ptr ON ph.centerid = ptr.centerid
--	WHERE 1=1
--	--and ppp.centerid NOT IN (SELECT centerid 
--	--						   FROM outcomes.dbo.centerChain pc
--	--						   JOIN outcomes.dbo.chain ch on pc.chainid = ch.chainid
--	--						   JOIN #tblChainCodesExclude AS cce ON ch.chaincode=cce.chainCode
--	--						   WHERE 1 = 1
--	--						   AND pc.active = 1)
--	and ph.active = 1


--	-- Identify and rank the patients' pharmacies.
--	Drop TABLE IF exists #tblConsultantPharmacy
--	SELECT ptids.patientid
--	,ROW_NUMBER() OVER (PARTITION BY ptids.patientid ORDER BY pmc.patientmtmcenterid DESC) AS ranker
--	,ph.NCPDP_NABP
--	,ph.centername
--	,ph.centerid
--	,ph.Address1
--	,ph.Address2
--	,ph.AddressCity
--	,ph.AddressState
--	,ph.AddressPostalCode
--	,ph.PHONE
--	INTO #tblConsultantPharmacy
--	FROM #tblPatientIDs AS ptids
--	JOIN outcomes.dbo.tblpatientmtmcenter pmc on pmc.patientid = ptids.patientid 
--	JOIN outcomes.dbo.pharmacy AS ph ON pmc.centerid = ph.centerid
--	JOIN maintenance.dbo.Pharmacy_Trained AS ptr ON ph.centerid = ptr.centerid
--	WHERE ph.active = 1
--	and ph.roledesc = 'CONSULTANT PHARMACIST';









----Drop table #GenericPat
--with MTMPEnroll
--as
--	(
--select mtmp.PatientID, 
--       MTMPEnrollmentFromDate, 
--	   MTMPEnrollmentThruDate = MTMPEnrollmentThruDate_GPL, 
--	   row_number() over(partition by mtmp.patientid order by mtmpenrollmentfromdate desc) ranked
----into #MTMPEnroll
--from  outcomes.reporting.MTMPEnrollment_active_all(default) mtmp
--join #tblPatientIDs pt
--	on pt.patientid = mtmp.PatientID
--where mtmp.ContractYear=YEAR(GETDATE())
--	),



--CAG as
--(
-- select 
-- cag.patientid
-- ,Carrier = coalesce(p.value('(./CARRIERID)[1]','VARCHAR(50)'), p.value('(./CARRIER)[1]','VARCHAR(50)'),  p.value('(./clob)[1]','VARCHAR(50)')) 
-- ,Account = coalesce(p.value('(./ACCOUNTID)[1]','VARCHAR(50)'), p.value('(./ACCOUNT)[1]','VARCHAR(50)'), p.value('(./groupid)[1]','VARCHAR(50)'))  
-- ,[Group] =  coalesce(p.value('(./GROUPID)[1]','VARCHAR(50)'), p.value('(./GROUP)[1]','VARCHAR(50)'), p.value('(./subgroupid)[1]','VARCHAR(50)'))   
--  --into #CAG
--  from outcomes.dbo.patientAdditionalInfo cag with (nolock)
--  join #tblPatientIDs pt
--	on pt.patientID = cag.patientid
--  cross apply additionalinfoxml.nodes('/') t(p)  
--),


--PatOpt
--as
-- (
--select a.patientid, b.termReason
----into #PatOpt
--from [outcomes].[dbo].[patientOptOut] a 
--join #tblPatientIDs pt
--	on pt.patientid = a.PatientID
--left join [outcomes].[dbo].[patientOptOutTermReason] b
--on a.patientOptOutTermReasonID = b.patientOptOutTermReasonID
--where contractYear = year(getdate())
-- )



--	SELECT pt.PatientID
--	,pt.displayID as PatientID_All
--	,pt.PolicyID
--    ,pt.HICN
--	,pt.PlanTermDate
--	,cag.Carrier
--	,cag.Account
--	,cag.[Group]
--	,patopt.termReason 
--	,p.policyName
--	,pt.Last_Name
--	,pt.First_Name
--	,pt.MI
--	,pt.CMSContractNumber
--	,pt.pbp
--	,pt.Gender
--	,pt.DOB
--	,pt.PrimaryLanguage
--	,pt.Address1
--	,pt.Address2
--	,pt.City
--	,pt.State
--	,pt.ZipCode
--	,pt.Phone
--	,pt.OutcomesEligibilityDate AS OutcomesEffectiveDate
--	,pt.OutcomesTermDate AS OutcomesTermDate
--	,mtmp.MTMPEnrollmentFromDate
--	,mtmp.MTMPEnrollmentThruDate
--	,cast(pce.createDT AS DATE) AS cmrEnrollmentDate
--	,ISNULL(tipcount.tipcnt, 0) AS [Current TIP Opportunities]
--	,pt.CMReligible
--	,CASE WHEN pt.CMReligible = 1 AND needscmr.PatientID IS NOT NULL
--		  THEN 'Y'
--		  ELSE 'N'
--	 END AS [Currently Targeted for a CMR]
--	,lastcmr.mtmServiceDT AS [Last CMR - Date]
--	,lastcmr.resultDesc as [Last CMR - Result Name]
--	,ph1.NCPDP_NABP AS Pharmacy1NABP
--	,ph1.centername AS Pharmacy1Name
--	,ph1.Address1 AS Pharmacy1Address1
--	,ph1.Address2 AS Pharmacy1Address2
--	,ph1.AddressCity AS Pharmacy1City
--	,ph1.AddressState AS Pharmacy1State
--	,ph1.AddressPostalCode AS Pharmacy1ZipCode
--	,ph1.phone AS Pharmacy1Phone
--	,ph2.NCPDP_NABP AS Pharmacy2NABP
--	,ph2.centername AS Pharmacy2Name
--	,ph2.Address1 AS Pharmacy2Address1
--	,ph2.Address2 AS Pharmacy2Address2
--	,ph2.AddressCity AS Pharmacy2City
--	,ph2.AddressState AS Pharmacy2State
--	,ph2.AddressPostalCode AS Pharmacy2ZipCode
--	,ph2.phone AS Pharmacy2Phone
--	,ph3.NCPDP_NABP AS Pharmacy3NABP
--	,ph3.centername AS Pharmacy3Name
--	,ph3.Address1 AS Pharmacy3Address1
--	,ph3.Address2 AS Pharmacy3Address2
--	,ph3.AddressCity AS Pharmacy3City
--	,ph3.AddressState AS Pharmacy3State
--	,ph3.AddressPostalCode AS Pharmacy3ZipCode
--	,ph3.phone AS Pharmacy3Phone
--	,cph.NCPDP_NABP AS ConsultantPharmacyNABP
--	,cph.centername AS ConsultantPharmacyName
--	,cph.Address1 AS ConsultantPharmacyAddress1
--	,cph.Address2 AS ConsultantPharmacyAddress2
--	,cph.AddressCity AS ConsultantPharmacyCity
--	,cph.AddressState AS ConsultantPharmacyState
--	,cph.AddressPostalCode AS ConsultantPharmacyZipCode
--	,cph.phone AS ConsultantPharmacyPhone
--	Into #GenericPat
--	FROM #tblPatientIDs AS ptids
--	JOIN outcomes.dbo.patient AS pt ON ptids.patientID=pt.PatientID
--	left join CAG cag on cag.patientID = ptids.patientid
--	left join PatOpt patopt on pt.patientID = patopt.patientid  
--	LEFT JOIN outcomes.dbo.policy AS p ON pt.policyID=p.policyID
--	LEFT JOIN maintenance.dbo.PatientCurrentTipCount AS tipcount ON pt.PatientID = tipcount.patientid
--	LEFT JOIN maintenance.dbo.vw_NeedsCMR AS needscmr on pt.PatientID = needscmr.PatientID
--	LEFT JOIN #tblPatientLastCMR AS lastcmr on pt.PatientID=lastcmr.patientid
--	LEFT JOIN MTMPEnroll AS mtmp ON pt.PatientID=mtmp.PatientID and ranked = 1 
--	--LEFT JOIN outcomes.reporting.MTMPEnrollment_active_targeted(default) AS mtmp ON pt.PatientID=mtmp.PatientID
--	--AND mtmp.ContractYear=YEAR(GETDATE())
--	LEFT JOIN outcomes.dbo.patientCMREnrollment AS pce ON pt.PatientID=pce.patientid
--	AND pt.PolicyID=pce.policyid
--	AND YEAR(pce.createDT) = YEAR(GETDATE())
--	LEFT JOIN #tblPharmacies AS ph1 ON pt.PatientID=ph1.PatientID
--	AND ph1.ranker=1
--	LEFT JOIN #tblPharmacies AS ph2 ON pt.PatientID=ph2.PatientID
--	AND ph2.ranker=2
--	LEFT JOIN #tblPharmacies AS ph3 ON pt.PatientID=ph3.PatientID
--	AND ph3.ranker=3
--	LEFT JOIN #tblConsultantPharmacy AS cph ON pt.PatientID = cph.patientid
--	AND cph.ranker=1








----******************************************************************************************************************************************************************
--DROP TABLE IF EXISTS #Final
--SELECT * INTO #Final FROM (
--select row_number() over(partition by x.[MemberID] order by x.[Category] asc) as rank, X.* from (
--select mpt.PolicyID
--	, mpt.policyName
--	, P.PatientID_All  As [MemberID]
--	, P.First_Name
--	, P.MI
--	, P.Last_Name
--	, P.CMSContractNumber
--	, P.pbp
--	, P.Gender
--	, cast(P.DOB as date) as [DOB]
--	, P.PrimaryLanguage
--	, P.Address1
--	, P.Address2
--	, P.City
--	, P.[State]
--	, substring(P.ZipCode, 1, 5) as [Zip Code]
	
--	, cast(P.OutcomesEligibilityDate as date) as [Outcomes Effective Date]
--	, cast(P.OutcomesTermDate as date) as [Outcomes Term Date]
--	, cast(MTM.MTMPEnrollmentFromDate as date) as [MTMP Target From Date]
--	, cast(MTM.MTMPEnrollmentThruDate as date) as [MTMP Target Thru Date]
--	, cast(IR.RunDate as date) as [Run Date]
--	, IRR.HitCriteria
--	, IRR.IdentificationRunID
--	, case when IRR.IdentificationRunID in (7906) then 'COC'
--			when IRR.IdentificationRunID in (7907) then 'QA' end as [Category]

--	from #mhspt mpt 
--	join #Genericpat gp on mpt.patientid=gp.PatientID 
--	left join [outcomes].[dbo].[patient] P With(Nolock) on p.patientid = mpt.patientid
--	left join [outcomes].[dbo].[IdentificationRunResult] IRR With(Nolock) on P.PatientID = IRR.patientid
--	left join [outcomes].[dbo].[IdentificationRun] IR With(Nolock) on IR.identificationRunid = IRR.IdentificationRunID
--	left join [outcomes].[reporting].[MTMPEnrollment_active_targeted](default) MTM on MTM.PatientID = P.PatientID and mtm.ContractYear=YEAR(GETDATE())

--	where 1=1 and
--	IRR.IdentificationRunID IN (7906,7907) and
--	IRR.HitCriteria = 1 --and 
--	) X ) y where y.rank = 1




--	select PolicyID
--	, policyName
--	, [MemberID]
--	, First_Name
--	, MI
--	, Last_Name
--	, CMSContractNumber
--	, pbp
--	, Gender
--	, [DOB]
--	, PrimaryLanguage
--	, Address1
--	, Address2
--	, City
--	, [State]
--	, [Zip Code]	
--	, [Outcomes Effective Date]
--	, [Outcomes Term Date]
--	, [MTMP Target From Date]
--	, [MTMP Target Thru Date]
--	, [Run Date]
--	, HitCriteria
--	, IdentificationRunID
--	, [Category]
--	FROM #Final

----END TC-3679



End 


