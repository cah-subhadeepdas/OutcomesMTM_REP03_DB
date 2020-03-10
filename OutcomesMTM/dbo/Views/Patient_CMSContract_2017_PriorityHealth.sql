



CREATE VIEW [dbo].[Patient_CMSContract_2017_PriorityHealth]
AS


select distinct
	  PatientID
	, CMSContractNumber
	, activeFrom = coalesce( start_edge, LAG(start_edge) over (partition by pt.patientid order by pt.activeasof) )
	, activeThru = coalesce( end_edge, LEAD(end_edge) over (partition by pt.patientid order by pt.activeasof) )
						
from (
    select
		pt.PatientID
        , pt.activeAsOf
        , pt.activeThru
        , pt.CMSContractNumber
        , PolicyID = pt.PolicyID
		, start_edge = case when ( isnull(lag(pt.CMSContractNumber)  over (partition by pt.PatientID order by pt.activeasof),'') <> ISNULL(pt.CMSContractNumber,'') ) then pt.activeAsOf end -- 'Y' else 'N' end
		, end_edge = case when ( isnull(lead(pt.CMSContractNumber)  over (partition by pt.PatientID order by pt.activeasof),'') <> ISNULL(pt.CMSContractNumber,'') ) then isnull(pt.activethru,'9999-12-31') end -- 'Y' else 'N' end


	from outcomesMTM.dbo.patientdim pt
	where 1=1
	and ( activethru >= '2017-01-01' or activeThru is null)
	and	activeasof < '2018-01-01'
	and pt.policyid in (318)

) pt
where coalesce(start_edge,end_edge) is not null


