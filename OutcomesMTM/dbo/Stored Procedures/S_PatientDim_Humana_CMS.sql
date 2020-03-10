







CREATE   PROCEDURE [dbo].[S_PatientDim_Humana_CMS]
@rptFromDT date, 
@rptThruDT date

AS
BEGIN

SET NOCOUNT ON;


----For Test Purpose:
--declare @rptFromDT date = cast('1/1/2018' as date)
--declare @rptThruDT date = cast('12/31/2018' as date)



	select pt.PatientID
	, pt.PolicyID
	, pt.PatientID_All
	, pt.MemberGenKey
	, pt.HICN
	, pt.First_Name
	, pt.Last_Name
	, pt.DOB
	, pt.OutcomesEligibilityDate as MTMEligibilityDate
	, pt.OutcomesTermDate as MTMTermDate
	, pt.ActiveFrom
	, pt.ActiveThru
	, pt.ranker
	, PlatformCode
	from (
			select 
				pt.PatientID, pt.PolicyID, pt.PatientID_All, pt.MemberGenKey, pt.HICN, pt.First_Name, pt.Last_Name, pt.DOB, pt.OutcomesEligibilityDate, pt.OutcomesTermDate
				, ActiveFrom = pt.ActiveAsOf
				, ActiveThru = isnull(pt.ActiveThru,'9999-12-31')
				, ranker = ROW_NUMBER() over (partition by pt.PatientID order by case when pt.MemberGenKey is not null then 0 else 1 end, pt.ActiveAsOf desc)
			from outcomesmtm.dbo.patientdim pt			
			where 1=1
			and pt.clientid = 72
			and pt.policyid in (262,602,606,607,635,636,639,642,643,644,645,648,649,650,652,653,655,656,657,659,661
								,866,867,868,869,870,871,872,873,874,875,876,877,878,928,929,930,931,932,933,934,935,936,937,938,939) -- adding/removing policyid's by  TC-2954
			and pt.OutcomesEligibilityDate >= @rptFromDT
			and pt.OutcomesEligibilityDate <= @rptThruDT
		) pt
left join (
			select ptai.PatientID
				  ,ptai.PlatformCode
				  ,ranker = ROW_NUMBER() over (partition by ptai.PatientID order by ptai.ActiveFrom desc)
			from outcomesmtm.dbo.PatientAdditionalInfo_Humana ptai
		 )	ptai on pt.patientid = ptai.patientid
				 and pt.ActiveThru >= @rptFromDT
				 and pt.ActiveFrom <= @rptThruDT
				 and ptai.ranker = 1
	where pt.ranker = 1
	order by pt.PatientID


End


