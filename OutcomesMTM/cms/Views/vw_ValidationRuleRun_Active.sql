CREATE   VIEW cms.vw_ValidationRuleRun_Active
AS

	select
		vrr.ValidationRuleRunID
		, vrr.ValidationRuleConfigID
		, vrr.BatchKey
		, vrr.BatchValue
		, vrr.ClientID
		, vrr.ContractYear
		, vrr.FileID
		, vrr.ContractNumber
		, vrr.Active
		, vrr.CreateDT
		, vrr.ChangeDT
		, vrr.IsCurrent
		, vrr.ValidationRuleDescription
		, vrr.External_RuleID
		, vrr.External_Error_Description
		, vrr.External_Action_Details
		, vrr.ValidationDataSet
		, vrr.SeverityLevel
	from cms.vw_ValidationRuleRun_History vrr
	where 1=1
	and vrr.IsCurrent = 1

