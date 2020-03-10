

-- =====================================================================================================
-- Author:	Ram Ravi
-- Create date: 07/30/2018
-- JIRA Card: TC-2063
-- Description:	PET team has requested for Client Level Current TIPs Report with specific requirements
-- =====================================================================================================
-- Change Log
-- ==========================================================================================
--   #		Date		Author			Description
--   --		--------	----------		----------------
--   1		07/30/2018	Ram Ravi    	TC-2063
--	 2		08/24/2018	Ram Ravi		TC-2171

-- ==========================================================================================


CREATE view [dbo].[vw_Reporting_ClientAccess_CurrentTIPs]
as 


with trained as (						--Getting the list of centers and their respective trained pharmacists
select ph.[NCPDP_NABP]
, ph.[centerid]
, ph.[centername]
, count(ucr.completedTraining) as [Number of Trained Pharmacists]
from OutcomesMTM.[dbo].[pharmacy] ph
join (
		select u.userID
				, r.roleID
				, r.roleTypeID
				, uc.centerID
				, u.completedTraining
		from OutcomesMTM.staging.[users] u
		join OutcomesMTM.staging.[role] r on r.userID = u.userID
		join OutcomesMTM.staging.[userCenter] uc on uc.userID = u.userID
		where 1=1
		and  U.active = 1
		and r.approved = 1
		and uc.approved = 1 
		and uc.active = 1
) ucr on ucr.centerID = ph.centerID
where 1=1
and ucr.roleTypeID = 1
and ucr.completedTraining = 1
group by ph.[NCPDP_NABP]
, ph.[centerid]
, ph.[centername]
)

, patient as (
select 
		pd.PatientID
		, pd.PatientID_All
		, pd.PolicyID
		, pd.PrimaryLanguage
		, pd.Phone
from outcomesmtm.dbo.patientdim pd
join OutcomesMTM.dbo.patientPrimaryPharmacyDim pph
	on pph.patientid = pd.PatientID and pph.primaryPharmacy = 1 and pph.activeThru is null
join OutcomesMTM.dbo.pharmacy ph
	on ph.centerid = pph.centerid
left join trained tr
	on tr.centerid = ph.centerid
where 1=1
and pd.isCurrent = 1
and pd.OutcomesTermDate >= getdate()
and pd.Phone is not null
and (ph.contracted = 0 or isnull(tr.[Number of Trained Pharmacists], 0) = 0)		--Select centers which are either uncontracted or contracted with none trained pharmacists
and pd.policyid in (761, 583, 667, 616, 733, 582, 763, 413,							--Include the policies given in the card
					414, 415, 501, 416, 262, 527, 602, 603, 
					604, 605, 606, 607, 635, 636, 637, 638, 
					639, 640, 641, 642, 643, 644, 645, 646, 
					647, 648, 649, 650, 651, 652, 653, 654, 
					655, 656, 657, 658, 659, 660, 661, 662, 
					651, 654, 658, 660, 662, 866, 867, 868, 
					869, 870, 871, 872, 873, 874, 875, 876, 
					877, 878, 735, 396, 397, 665, 589, 224)								--Included the policy 224 by TC-2171
)


select 
		cast(tdr.TipGenerationDT as date)			as [TIP Generation Date]
	  , tdr.tiptitle								as [TIP Title]
	  , tdr.NPI										as [Pharmacy NPI]
	  , tdr.tiptype									as [TIP Type]
	  , tdr.reasoncode								as [Reason Code]
	  , tdr.reasonTypeDesc							as [Reason Type Desc]
	  , tdr.actionCode								as [Action Code]
	  , tdr.actionNM								as [Action Name]
	  , tdr.patientid_all							as [Member ID]
	  , tdr.First_Name								as [First Name]
	  , tdr.last_name								as [Last Name]
	  , convert(varchar, tdr.DOB, 101)				as [DOB]
	  , tdr.phone									as [Phone]
	  , tdr.Address1								as [Address1]
	  , tdr.Address2								as [Address2]
	  , tdr.City									as [City]
	  , tdr.state									as [State]
	  , tdr.ZipCode									as [ZipCode]
	  , tdr.policyname								as [Policy Name]
	  , tdr.policyid								as [Policy ID]
	  , pt.PatientID								as [PatientID]
	  , tdr.pharmacyCnt								as [Pharmacy cnt]
	  , tdr.PRIMARY_NCPDP_NABP						as [Primary NCPDP]
	  , tdr.Primary_PharmacyName					as [Primary Pharmacy Name]
	  , tdr.TipExpirationDT							as [TIP Expiration Date]
	  , isnull(pt.PrimaryLanguage, '')				as [Patient Language]

from patient pt
join [OutcomesMTM].[dbo].[vw_patientTipDetailReport] tdr
	on tdr.patientid_all = pt.PatientID_All
where 1=1
and tdr.reasoncode in (173, 120)			--Include Reason codes 173, 120 only in the report
and len(tdr.phone) >= 10					--Include only patients with valid phone numbers




