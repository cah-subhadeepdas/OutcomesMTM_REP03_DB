
--drop function [CenterQAZone]
CREATE FUNCTION [dbo].[ITVF over TVF](@centerid int)
RETURNS TABLE
AS RETURN
(

--declare @centerid int = 51015

with [qazone] as (

	select ph.centerid
	,isnull(sum(cast(t.denominator as int)),0) as finaltotalclaims
	,isnull(sum(cast(t.numerator as int)),0) as finaltpclaims
	, case when isnull(sum(cast(t.denominator as int)),0) = 0 then 0 
			else convert(float,isnull(sum(cast(t.numerator as int)),0))/convert(float,isnull(sum(cast(t.denominator as int)),0)) 
			end as dtp
	from pharmacy ph with (nolock) 
	left join (

			select 
          e.centerID
			,e.claimID
			,sum(case when qt.qatype='denominator' then 1 else 0 end) as denominator
			,sum(case when qt.qatype='numerator' then 1 else 0 end) as numerator 
			from claim e with (nolock)  
         join staging.status s on e.statusID = s.statusID
			join patientDim pt with (nolock) on pt.patientid = e.patientid 
			join ClientContractPolicyView p with (nolock) on p.policyid = pt.policyid 
			join staging.QAResultType qa with (nolock) on qa.resulttypeid = e.resulttypeid 
			join staging.qaType qt with (nolock) on qt.qatypeid = qa.QAtypeID						
			where 1=1 
			and s.statusnm in ('pending approval', 'approved')
			and p.qa = 1 
			and e.mtmserviceDT >= dateadd(MONTH,-6,getdate())
			and e.centerid = @centerid
			group by e.centerID, e.claimid
	
	) T on t.centerid = ph.centerid 
	where 1=1 
	and ph.centerid = @centerid 
	and ph.roledesc is not null 
	group by ph.centerid

)
select t.centerid 
, t.dtptype
, t.dtp
from (
	select ph1.centerid
	, ph1.dtptype
	, ph1.dtp    
	from (
		select ph.centerid
		, ph.finaltotalclaims
		, ph.finaltpclaims
		, ph.dtp
		, r.dtprangeid
		, r.claimstartnumber
		, r.claimendnumber
		, r.dtplow
		, r.dtphigh
		, r.dtptypeid 
		, t.DTPType
		from qazone ph 
		left join staging.DTPrange r on (ph.finaltotalclaims between r.claimstartnumber and r.claimendnumber)
											and (ph.dtp >= r.dtplow and ph.dtp < r.dtphigh)
											and r.active = 1 
		left join staging.DTPtype t on r.DTPTypeID = t.DTPTypeID
		where 1=1 
		
	) ph1
	where 1=1 
	and ph1.centerid is not null 
	and ph1.DTPType is not null 
	--and not exists (
	--	select 1 
	--	from pharmacy.dbo.pharmacyaction ph with (nolock)
	--	where 1=1 
	--	and ph.actiontypeid = 1
	--	and ph1.centerid = ph.centerid 
	--) 	
) T
where 1=1 
group by t.centerid 
, t.dtptype
, t.dtp


)


