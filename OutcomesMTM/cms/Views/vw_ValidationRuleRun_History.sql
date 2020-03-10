
CREATE     VIEW [cms].[vw_ValidationRuleRun_History]
AS


	select
		vrr2.ValidationRuleRunID
		, vrr2.ValidationRuleConfigID
		, vrr2.BatchKey
		, vrr2.BatchValue
		, vrr2.ClientID
		, vrr2.ContractYear
		, FileID = NULL
		, vrr2.ContractNumber
		, vrr2.Active
		, vrr2.CreateDT
		, vrr2.ChangeDT
		, IsCurrent = case when vrr2.ranker = 1 then 1 else 0 end
		, vrc.ValidationRuleDescription
		, vrc.External_RuleID
		, vrc.External_Error_Description
		, vrc.External_Action_Details
		, vrc.ValidationDataSet
		, vrc.SeverityLevel
	from (
		select 
			vrr.*
			, ranker = DENSE_RANK() over (partition by vrr.BatchKey, vrr.BatchValue order by vrr.CreateDT desc)
		from cms.ValidationRuleRun_new vrr with (nolock)
		where 1=1
		and vrr.Active = 1
	) vrr2
	left join cms.ValidationRuleConfig vrc
		on vrc.ValidationRuleConfigID = vrr2.ValidationRuleConfigID


