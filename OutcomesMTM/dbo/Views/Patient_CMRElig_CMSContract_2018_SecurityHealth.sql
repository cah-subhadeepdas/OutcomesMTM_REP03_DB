



CREATE    VIEW [dbo].[Patient_CMRElig_CMSContract_2018_SecurityHealth]
AS


	select distinct
		  PatientID
		, PolicyID
		, CMSContractNumber
		, CMREligible
		, OutcomesEligibilityDate
		, OutcomesTermDate
		, activeFrom = coalesce( start_edge, LAG(start_edge) over (partition by pt.patientid order by pt.activeasof) )
		, activeThru = coalesce( end_edge, LEAD(end_edge) over (partition by pt.patientid order by pt.activeasof) )		
		--, ranker = ROW_NUMBER() over (partition by pt.patientid order by pt.activeasof)			
	from (

		select
			pt.PatientID
			, pt.activeAsOf
			, pt.activeThru
			, pt.CMSContractNumber
			, CMREligible = isnull(pt.CMREligible,0)
			, PolicyID = pt.PolicyID
			, pt.OutcomesEligibilityDate
			, pt.OutcomesTermDate
			, start_edge = case when ( lag(isnull(pt.CMREligible,0)) over (partition by pt.PatientID order by pt.activeasof) <> isnull(pt.CMREligible,0) or isnull(lag(pt.CMSContractNumber)  over (partition by pt.PatientID order by pt.activeasof),'') <> ISNULL(pt.CMSContractNumber,'') ) then pt.activeAsOf end -- 'Y' else 'N' end
			, end_edge = case when ( lead(isnull(pt.CMREligible,0)) over (partition by pt.PatientID order by pt.activeasof) <> isnull(pt.CMREligible,0) or isnull(lead(pt.CMSContractNumber)  over (partition by pt.PatientID order by pt.activeasof),'') <> ISNULL(pt.CMSContractNumber,'') ) then isnull(pt.activethru,'9999-12-31') end -- 'Y' else 'N' end
		from outcomesMTM.dbo.patientdim pt
		where 1=1
		--and pt.patientID = 22280112
		and ( activethru >= '2018-01-01' or activeThru is null)
		and	activeasof < '2019-01-01'
		and pt.policyid in (253)

	) pt
	where coalesce(start_edge,end_edge) is not null
	--order by 6


